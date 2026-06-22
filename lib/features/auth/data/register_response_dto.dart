import 'package:smart_stay/features/auth/domain/user.dart';

class RegisterResponseDto {
  final int id;
  final String username;
  final String role;
  final int? hotelId;
  final int? chainId;

  RegisterResponseDto({
    required this.id,
    required this.username,
    required this.role,
    this.hotelId,
    this.chainId,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      hotelId: json['hotelId'],
      chainId: json['chainId'],
    );
  }

  // Método toDomain idéntico al del login
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