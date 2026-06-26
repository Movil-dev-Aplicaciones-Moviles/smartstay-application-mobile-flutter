import 'package:smart_stay/features/check_in/domain/check_in.dart';

class CheckInDto {
  final String guestName;
  final String hotelName;
  final String roomNumber;
  final String bookingCode;
  final String accessCode;
  final String checkInDate;
  final String checkOutDate;
  final bool documentValidated;
  final bool termsAccepted;
  final bool checkInCompleted;

  CheckInDto({
    required this.guestName,
    required this.hotelName,
    required this.roomNumber,
    required this.bookingCode,
    required this.accessCode,
    required this.checkInDate,
    required this.checkOutDate,
    required this.documentValidated,
    required this.termsAccepted,
    required this.checkInCompleted,
  });

  factory CheckInDto.fromJson(Map<String, dynamic> json) {
    return CheckInDto(
      guestName: json['guestName'],
      hotelName: json['hotelName'],
      roomNumber: json['roomNumber'],
      bookingCode: json['bookingCode'],
      accessCode: json['accessCode'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      documentValidated: json['documentValidated'],
      termsAccepted: json['termsAccepted'],
      checkInCompleted: json['checkInCompleted'],
    );
  }

  CheckIn toDomain() {
    return CheckIn(
      guestName: guestName,
      hotelName: hotelName,
      roomNumber: roomNumber,
      bookingCode: bookingCode,
      accessCode: accessCode,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      documentValidated: documentValidated,
      termsAccepted: termsAccepted,
      checkInCompleted: checkInCompleted,
    );
  }
}
