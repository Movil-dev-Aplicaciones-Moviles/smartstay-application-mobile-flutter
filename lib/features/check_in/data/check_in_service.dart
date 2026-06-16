import 'package:smart_stay/features/check_in/data/check_in_dto.dart';
import 'package:smart_stay/features/check_in/domain/check_in.dart';

class CheckInService {
  Future<CheckInDto> getPendingCheckIn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final json = {
      'guestName': 'Jaredt Montes',
      'hotelName': 'SmartStay Boutique Lima',
      'roomNumber': '804',
      'bookingCode': 'SS-2026-804',
      'accessCode': 'A8-42',
      'checkInDate': '12 Jun 2026',
      'checkOutDate': '15 Jun 2026',
      'documentValidated': false,
      'termsAccepted': false,
      'checkInCompleted': false,
    };

    return CheckInDto.fromJson(json);
  }

  Future<CheckIn> confirmCheckIn(CheckIn checkIn) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return checkIn.copyWith(
      documentValidated: true,
      termsAccepted: true,
      checkInCompleted: true,
    );
  }
}
