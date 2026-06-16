import 'package:smart_stay/features/notifications/domain/app_notification.dart';

class NotificationState {
  final bool isLoading;
  final List<AppNotification> notifications;
  final String? errorMessage;

  NotificationState({
    this.isLoading = false,
    this.notifications = const [],
    this.errorMessage,
  });

  NotificationState copyWith({
    bool? isLoading,
    List<AppNotification>? notifications,
    String? errorMessage,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }
}
