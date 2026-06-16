import 'package:smart_stay/features/home/domain/current_stay.dart';

class CurrentStayDto {
  final String guestName;
  final String hotelName;
  final String roomNumber;
  final String checkInDate;
  final String checkOutDate;
  final String accessCode;
  final int nights;

  CurrentStayDto({
    required this.guestName,
    required this.hotelName,
    required this.roomNumber,
    required this.checkInDate,
    required this.checkOutDate,
    required this.accessCode,
    required this.nights,
  });

  factory CurrentStayDto.fromJson(Map<String, dynamic> json) {
    return CurrentStayDto(
      guestName: json['guestName'],
      hotelName: json['hotelName'],
      roomNumber: json['roomNumber'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      accessCode: json['accessCode'],
      nights: json['nights'],
    );
  }

  CurrentStay toDomain() {
    return CurrentStay(
      guestName: guestName,
      hotelName: hotelName,
      roomNumber: roomNumber,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      accessCode: accessCode,
      nights: nights,
    );
  }
}
