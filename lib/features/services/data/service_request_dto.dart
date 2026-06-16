import 'package:smart_stay/features/services/domain/service_request.dart';

class ServiceRequestDto {
  final int id;
  final int serviceId;
  final String title;
  final String description;
  final String requestedAt;
  final String estimatedTime;
  final String status;
  final String room;

  ServiceRequestDto({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.requestedAt,
    required this.estimatedTime,
    required this.status,
    required this.room,
  });

  factory ServiceRequestDto.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDto(
      id: json['id'],
      serviceId: json['serviceId'],
      title: json['title'],
      description: json['description'],
      requestedAt: json['requestedAt'],
      estimatedTime: json['estimatedTime'],
      status: json['status'],
      room: json['room'],
    );
  }

  ServiceRequest toDomain() {
    return ServiceRequest(
      id: id,
      serviceId: serviceId,
      title: title,
      description: description,
      requestedAt: requestedAt,
      estimatedTime: estimatedTime,
      status: status,
      room: room,
    );
  }
}
