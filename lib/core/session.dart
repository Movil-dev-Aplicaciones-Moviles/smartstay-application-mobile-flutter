import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/models.dart';

class SessionStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _localBookingsKey = 'local_bookings';
  static AppUser? currentUser;

  static Future<void> save(AppUser user) async {
    currentUser = user;
    await _storage.write(key: 'token', value: user.token);
    await _storage.write(key: 'id', value: user.id.toString());
    await _storage.write(key: 'username', value: user.username);
    await _storage.write(key: 'role', value: user.role);
    if (user.hotelId != null) {
      await _storage.write(key: 'hotelId', value: user.hotelId.toString());
    }
    if (user.chainId != null) {
      await _storage.write(key: 'chainId', value: user.chainId.toString());
    }
  }

  static Future<AppUser?> restore() async {
    final token = await _storage.read(key: 'token');
    final id = await _storage.read(key: 'id');
    final username = await _storage.read(key: 'username');
    final role = await _storage.read(key: 'role');

    if (token == null || id == null || username == null || role == null) {
      return null;
    }

    currentUser = AppUser(
      id: int.tryParse(id) ?? 0,
      username: username,
      token: token,
      role: role,
      hotelId: int.tryParse(await _storage.read(key: 'hotelId') ?? ''),
      chainId: int.tryParse(await _storage.read(key: 'chainId') ?? ''),
    );
    return currentUser;
  }

  static Future<void> saveLocalBooking(Booking booking) async {
    final bookings = await readLocalBookings();
    final filtered = bookings.where((item) => item.id != booking.id).toList();
    filtered.insert(0, booking);
    await _storage.write(
      key: _localBookingsKey,
      value: jsonEncode(filtered.map((item) => item.toJson()).toList()),
    );
  }

  static Future<List<Booking>> readLocalBookings() async {
    final raw = await _storage.read(key: _localBookingsKey);
    if (raw == null || raw.trim().isEmpty) return const [];
    try {
      final parsed = jsonDecode(raw);
      if (parsed is List) {
        return parsed
            .whereType<Map>()
            .map((item) => Booking.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  static Future<void> updateLocalBookingStatus(int bookingId, String status) async {
    final bookings = await readLocalBookings();
    final updated = bookings.map((item) => item.id == bookingId ? item.copyWith(status: status) : item).toList();
    await _storage.write(
      key: _localBookingsKey,
      value: jsonEncode(updated.map((item) => item.toJson()).toList()),
    );
  }

  static Future<void> clear() async {
    currentUser = null;
    await _storage.deleteAll();
  }
}
