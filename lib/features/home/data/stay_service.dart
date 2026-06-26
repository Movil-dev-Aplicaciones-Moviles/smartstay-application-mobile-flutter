import 'dart:async';

import 'package:smart_stay/features/home/data/current_stay_dto.dart';

class StayService {
  Future<CurrentStayDto> getCurrentStay() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final map = {
      'guestName': 'Jaredt Montes',
      'hotelName': 'SmartStay Boutique Lima',
      'roomNumber': '305',
      'checkInDate': '12 Jun 2026',
      'checkOutDate': '15 Jun 2026',
      'accessCode': 'A9-305',
      'nights': 3,
    };

    return CurrentStayDto.fromJson(map);
  }
}
