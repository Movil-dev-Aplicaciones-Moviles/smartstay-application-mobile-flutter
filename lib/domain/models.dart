part of '../main.dart';

class AppUser {
  final int id;
  final String username;
  final String role;
  final String status;
  final int? hotelId;
  final int? chainId;
  final String createdAt;
  final String updatedAt;

  AppUser({required this.id, required this.username, required this.role, required this.status, this.hotelId, this.chainId, required this.createdAt, required this.updatedAt});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: readInt(json, 'id') ?? readInt(json, 'Id') ?? 0,
      username: readString(json, 'username') ?? readString(json, 'Username') ?? '',
      role: readString(json, 'role') ?? readString(json, 'Role') ?? 'guest',
      status: readString(json, 'status') ?? readString(json, 'Status') ?? 'Active',
      hotelId: readInt(json, 'hotelId') ?? readInt(json, 'HotelId'),
      chainId: readInt(json, 'chainId') ?? readInt(json, 'ChainId'),
      createdAt: readString(json, 'createdAt') ?? readString(json, 'CreatedAt') ?? 'Desconocido',
      updatedAt: readString(json, 'updatedAt') ?? readString(json, 'UpdatedAt') ?? 'Desconocido',
    );
  }
}

class AppProfile {
  final int id;
  final String fullName;
  final String email;
  final String streetAddress;

  AppProfile({required this.id, required this.fullName, required this.email, required this.streetAddress});

  factory AppProfile.fromJson(Map<String, dynamic> json) {
    return AppProfile(
      id: readInt(json, 'id') ?? readInt(json, 'Id') ?? 0,
      fullName: readString(json, 'fullName') ?? readString(json, 'FullName') ?? '',
      email: readString(json, 'email') ?? readString(json, 'Email') ?? '',
      streetAddress: readString(json, 'streetAddress') ?? readString(json, 'StreetAddress') ?? '',
    );
  }
}

class AppHotel {
  final int id;
  final String name;
  final String location;
  final String type;
  final double basePrice;

  AppHotel({required this.id, required this.name, required this.location, required this.type, required this.basePrice});

  factory AppHotel.fromJson(Map<String, dynamic> json) {
    return AppHotel(
      id: readInt(json, 'id') ?? readInt(json, 'Id') ?? 0,
      name: readString(json, 'name') ?? readString(json, 'Name') ?? '',
      location: readString(json, 'location') ?? readString(json, 'Location') ?? '',
      type: readString(json, 'type') ?? readString(json, 'Type') ?? 'Hotel',
      basePrice: readDouble(json, 'basePrice') ?? readDouble(json, 'BasePrice') ?? 0,
    );
  }
}

String? readString(Map<String, dynamic> json, String key) => json[key]?.toString();
int? readInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? readDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
