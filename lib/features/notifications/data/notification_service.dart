import 'dart:async';

import 'package:smart_stay/features/notifications/data/app_notification_dto.dart';

class NotificationService {
  Future<List<AppNotificationDto>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 350));

    final jsons = [
      {
        'id': 1,
        'title': 'Check-in listo',
        'description': 'Tu habitación 305 ya se encuentra disponible.',
        'time': 'Hace 5 min',
        'read': false,
      },
      {
        'id': 2,
        'title': 'Room service confirmado',
        'description': 'Tu pedido llegará aproximadamente en 25 minutos.',
        'time': 'Hace 20 min',
        'read': false,
      },
      {
        'id': 3,
        'title': 'Recordatorio de check-out',
        'description': 'Tu salida está programada para el 15 de junio.',
        'time': 'Ayer',
        'read': true,
      },
    ];

    return jsons.map((e) => AppNotificationDto.fromJson(e)).toList();
  }
}
