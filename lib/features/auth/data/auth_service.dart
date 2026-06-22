import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_stay/features/auth/data/login_request_dto.dart';
import 'package:smart_stay/features/auth/data/login_response_dto.dart';
// 👇 NUEVOS IMPORTS PARA REGISTER
import 'package:smart_stay/features/auth/data/register_request_dto.dart';
import 'package:smart_stay/features/auth/data/register_response_dto.dart';

class AuthService {
  final String _baseUrl = 'https://application-mobile-backend.onrender.com';

  // ============================================================
  // LOGIN (ya existente)
  // ============================================================
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final Uri uri = Uri.parse('$_baseUrl/api/v1/authentication/sign-in');

    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return LoginResponseDto.fromJson(json);
    } else {
      throw Exception('Error al iniciar sesión: ${response.statusCode}');
    }
  }

  // ============================================================
  // REGISTER (nuevo, con la misma estructura)
  // ============================================================
  Future<RegisterResponseDto> register(RegisterRequestDto request) async {
    final Uri uri = Uri.parse('$_baseUrl/api/v1/authentication/sign-up');

    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return RegisterResponseDto.fromJson(json);
    } else {
      throw Exception('Error al registrarse: ${response.statusCode}');
    }
  }
}