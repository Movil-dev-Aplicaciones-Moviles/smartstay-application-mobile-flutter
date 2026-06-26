import 'package:smart_stay/features/services/domain/hotel_service.dart';

class HotelServiceDto {
  final int id;
  final String title;
  final String description;
  final String estimatedTime;
  final String status;

  HotelServiceDto({
    required this.id,
    required this.title,
    required this.description,
    required this.estimatedTime,
    required this.status,
  });

  factory HotelServiceDto.fromJson(Map<String, dynamic> json) {
    return HotelServiceDto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      estimatedTime: json['estimatedTime'],
      status: json['status'],
    );
  }

  HotelService toDomain() {
    return HotelService(
      id: id,
      title: title,
      description: description,
      estimatedTime: estimatedTime,
      status: status,
    );
  }
}
