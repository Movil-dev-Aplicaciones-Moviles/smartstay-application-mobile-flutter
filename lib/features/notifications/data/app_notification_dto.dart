import 'package:smart_stay/features/notifications/domain/app_notification.dart';

class AppNotificationDto {
  final int id;
  final String title;
  final String description;
  final String time;
  final bool read;

  AppNotificationDto({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.read,
  });

  factory AppNotificationDto.fromJson(Map<String, dynamic> json) {
    return AppNotificationDto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: json['time'],
      read: json['read'],
    );
  }

  AppNotification toDomain() {
    return AppNotification(
      id: id,
      title: title,
      description: description,
      time: time,
      read: read,
    );
  }
}
