import 'package:smart_stay/features/auth/domain/user.dart';

class LoginResponseDto {
  final int id;
  final String username;
  final String token;
  final String role;
  final int? hotelId;
  final int? chainId;

  LoginResponseDto({
    required this.id,
    required this.username,
    required this.token,
    required this.role,
    this.hotelId,
    this.chainId,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      id: json['id'],
      username: json['username'],
      token: json['token'],
      role: json['role'],
      hotelId: json['hotelId'],
      chainId: json['chainId'],
    );
  }

  User toDomain() {
    return User(
      id: id,
      username: username,
      role: role,
      hotelId: hotelId,
      chainId: chainId,
    );
  }
}
