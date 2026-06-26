import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/models.dart';
import 'session.dart';

class ApiClient {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://application-mobile-backend.onrender.com/api/v1',
  );

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers({bool auth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = SessionStore.currentUser?.token;
    if (auth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<dynamic> _decode(http.Response response) async {
    final body = response.body.trim();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body.isEmpty) return null;
      return jsonDecode(body);
    }

    String message = body;
    try {
      final parsed = jsonDecode(body);
      if (parsed is Map) {
        message = parsed['message']?.toString() ?? parsed['title']?.toString() ?? body;
      }
    } catch (_) {}

    throw Exception('HTTP ${response.statusCode}: $message');
  }

  Future<AppUser> signIn(String username, String password) async {
    final response = await _client.post(
      _uri('/authentication/sign-in'),
      headers: _headers(auth: false),
      body: jsonEncode({'username': username, 'password': password}),
    );
    final data = await _decode(response) as Map<String, dynamic>;
    final user = AppUser.fromJson(data);
    await SessionStore.save(user);
    return user;
  }

  Future<AppUser> signUp(String username, String password) async {
    final response = await _client.post(
      _uri('/authentication/sign-up'),
      headers: _headers(auth: false),
      body: jsonEncode({'username': username, 'password': password, 'role': 'guest'}),
    );
    final data = await _decode(response) as Map<String, dynamic>;
    final user = AppUser.fromJson(data);
    await SessionStore.save(user);
    return user;
  }

  Future<List<Hotel>> getHotels() async {
    final response = await _client.get(_uri('/hotels'), headers: _headers());
    final data = await _decode(response);
    if (data is List) {
      return data.map((e) => Hotel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return const [];
  }

  Future<List<Room>> getRooms() async {
    final response = await _client.get(_uri('/rooms'), headers: _headers());
    final data = await _decode(response);
    if (data is List) {
      return data.map((e) => Room.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return const [];
  }

  Future<Booking> createBooking({
    required int roomId,
    required String guestName,
    required String guestEmail,
    required String checkInDate,
    required String checkOutDate,
  }) async {
    final response = await _client.post(
      _uri('/bookings'),
      headers: _headers(),
      body: jsonEncode({
        'roomId': roomId,
        'guestName': guestName,
        'guestEmail': guestEmail,
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
      }),
    );
    final data = await _decode(response) as Map<String, dynamic>;
    return Booking.fromJson(data);
  }

  Future<Payment> processPayment({
    required int bookingId,
    required double amount,
    required String paymentMethod,
    required String cardNumber,
    required String cardHolderName,
    required String expirationDate,
    required String cvv,
  }) async {
    final response = await _client.post(
      _uri('/payments'),
      headers: _headers(),
      body: jsonEncode({
        'bookingId': bookingId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'cardNumber': cardNumber,
        'cardHolderName': cardHolderName,
        'expirationDate': expirationDate,
        'cvv': cvv,
      }),
    );
    final data = await _decode(response) as Map<String, dynamic>;
    return Payment.fromJson(data);
  }

  Future<void> createProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String street,
    required String number,
    required String city,
    required String postalCode,
    required String country,
  }) async {
    final response = await _client.post(
      _uri('/profiles'),
      headers: _headers(),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'street': street,
        'number': number,
        'city': city,
        'postalCode': postalCode,
        'country': country,
      }),
    );
    await _decode(response);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final response = await _client.post(
      _uri('/users/change-password'),
      headers: _headers(),
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    await _decode(response);
  }
}
