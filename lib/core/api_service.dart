part of '../main.dart';

class AppApi {
  static Uri uri(String path) {
    final base = apiBaseUrl.endsWith('/') ? apiBaseUrl.substring(0, apiBaseUrl.length - 1) : apiBaseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$cleanPath');
  }

  static Map<String, String> headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (Session.token != null) 'Authorization': 'Bearer ${Session.token}',
    };
  }

  static Future<dynamic> get(String path) async {
    final response = await http.get(uri(path), headers: headers());
    return decode(response);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(uri(path), headers: headers(), body: jsonEncode(body));
    return decode(response);
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(uri(path), headers: headers(), body: jsonEncode(body));
    return decode(response);
  }

  static Future<dynamic> delete(String path) async {
    final response = await http.delete(uri(path), headers: headers());
    return decode(response);
  }

  static dynamic decode(http.Response response) {
    final status = response.statusCode;
    final body = response.body.trim();

    if (status >= 200 && status < 300) {
      if (body.isEmpty) return null;
      return jsonDecode(body);
    }

    String message = body.isEmpty ? 'Error de conexión con backend' : body;
    try {
      final data = jsonDecode(body);
      if (data is Map && data['message'] != null) message = data['message'].toString();
    } catch (_) {}
    throw Exception('HTTP $status: $message');
  }

  static Future<AppUser> signIn(String username, String password) async {
    final data = await post('/authentication/sign-in', {
      'username': username,
      'password': password,
    }) as Map<String, dynamic>;
    Session.token = readString(data, 'token') ?? readString(data, 'Token');
    final user = AppUser.fromJson(data);
    Session.user = user;
    return user;
  }

  static Future<void> signUp(String username, String password) async {
    await post('/authentication/sign-up', {
      'username': username,
      'password': password,
      'role': 'guest',
    });
  }

  static Future<List<AppUser>> getUsers() async {
    final data = await get('/users') as List;
    return data.whereType<Map<String, dynamic>>().map(AppUser.fromJson).toList();
  }

  static Future<AppUser> getUserById(int id) async {
    final data = await get('/users/$id') as Map<String, dynamic>;
    return AppUser.fromJson(data);
  }

  static Future<void> createUser({required String username, required String password, required String role, int? hotelId, int? chainId}) async {
    await post('/users', {
      'username': username,
      'password': password,
      'role': role,
      'hotelId': hotelId,
      'chainId': chainId,
    });
  }

  static Future<void> updateUser({required int id, String? username, int? hotelId, int? chainId}) async {
    await put('/users/$id', {
      'newUsername': username,
      'newHotelId': hotelId,
      'newChainId': chainId,
    });
  }

  static Future<void> assignRole(int userId, String role) async {
    await post('/users/$userId/assign-role', {
      'targetUserId': userId,
      'newRole': role,
    });
  }

  static Future<void> deactivateUser(int userId) async {
    await delete('/users/$userId');
  }

  static Future<void> activateUser(int userId) async {
    await post('/users/$userId/activate', {});
  }

  static Future<void> changePassword(String currentPassword, String newPassword) async {
    await post('/users/change-password', {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  static Future<List<AppProfile>> getProfiles() async {
    final data = await get('/profiles') as List;
    return data.whereType<Map<String, dynamic>>().map(AppProfile.fromJson).toList();
  }

  static Future<AppProfile> getProfileById(int id) async {
    final data = await get('/profiles/$id') as Map<String, dynamic>;
    return AppProfile.fromJson(data);
  }

  static Future<void> createProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String street,
    required String number,
    required String city,
    required String postalCode,
    required String country,
  }) async {
    await post('/profiles', {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'street': street,
      'number': number,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    });
  }

  static Future<List<AppHotel>> getHotels() async {
    final data = await get('/hotels') as List;
    return data.whereType<Map<String, dynamic>>().map(AppHotel.fromJson).toList();
  }
}
