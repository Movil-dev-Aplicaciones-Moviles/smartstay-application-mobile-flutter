import 'package:smart_stay/features/notifications/domain/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
}
