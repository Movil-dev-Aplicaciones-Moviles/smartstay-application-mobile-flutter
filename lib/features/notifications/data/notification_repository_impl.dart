import 'package:smart_stay/features/notifications/data/notification_service.dart';
import 'package:smart_stay/features/notifications/domain/app_notification.dart';
import 'package:smart_stay/features/notifications/domain/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService service;

  NotificationRepositoryImpl({required this.service});

  @override
  Future<List<AppNotification>> getNotifications() async {
    final response = await service.getNotifications();
    return response.map((e) => e.toDomain()).toList();
  }
}
