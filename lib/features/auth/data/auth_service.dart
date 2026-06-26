import 'dart:async';

import 'package:smart_stay/features/auth/data/login_request_dto.dart';
import 'package:smart_stay/features/auth/data/login_response_dto.dart';

class AuthService {
  Future<LoginResponseDto?> login(LoginRequestDto request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (request.email.trim().length < 3 || request.password.length < 6) {
      return null;
    }

    final username = request.email.trim().toLowerCase();
    final role = _roleFromUsername(username);

    final map = {
      'id': _idFromRole(role),
      'username': username,
      'token': 'jwt-demo-token',
      'role': role,
      'hotelId': role == 'chain_admin' ? null : 1,
      'chainId': role == 'chain_admin' ? null : 1,
    };

    return LoginResponseDto.fromJson(map);
  }

  String _roleFromUsername(String username) {
    if (username.contains('chain')) return 'chain_admin';
    if (username.contains('admin')) return 'admin';
    if (username.contains('reception')) return 'reception';
    if (username.contains('housekeeping')) return 'housekeeping';
    if (username.contains('maintenance')) return 'maintenance';
    if (username.contains('staff')) return 'staff';
    return 'guest';
  }

  int _idFromRole(String role) {
    switch (role) {
      case 'chain_admin':
        return 1;
      case 'admin':
        return 2;
      case 'staff':
        return 3;
      case 'reception':
        return 4;
      case 'housekeeping':
        return 5;
      case 'maintenance':
        return 6;
      default:
        return 7;
    }
  }
}
