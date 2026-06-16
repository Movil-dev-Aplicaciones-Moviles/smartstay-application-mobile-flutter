import 'package:flutter/material.dart';
import 'package:smart_stay/features/notifications/domain/notification_repository.dart';
import 'package:smart_stay/features/notifications/presentation/notification_state.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository repository;

  NotificationViewModel({required this.repository}) {
    loadNotifications();
  }

  NotificationState state = NotificationState();

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final notifications = await repository.getNotifications();
      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load notifications: $e',
      );
    }

    notifyListeners();
  }
}
