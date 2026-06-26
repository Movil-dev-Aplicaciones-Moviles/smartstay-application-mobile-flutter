import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/models.dart';

class SessionStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
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

  static Future<void> clear() async {
    currentUser = null;
    await _storage.deleteAll();
  }
}
