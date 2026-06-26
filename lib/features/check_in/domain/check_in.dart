class CheckIn {
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

  CheckIn({
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

  CheckIn copyWith({
    String? guestName,
    String? hotelName,
    String? roomNumber,
    String? bookingCode,
    String? accessCode,
    String? checkInDate,
    String? checkOutDate,
    bool? documentValidated,
    bool? termsAccepted,
    bool? checkInCompleted,
  }) {
    return CheckIn(
      guestName: guestName ?? this.guestName,
      hotelName: hotelName ?? this.hotelName,
      roomNumber: roomNumber ?? this.roomNumber,
      bookingCode: bookingCode ?? this.bookingCode,
      accessCode: accessCode ?? this.accessCode,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      documentValidated: documentValidated ?? this.documentValidated,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      checkInCompleted: checkInCompleted ?? this.checkInCompleted,
    );
  }
}
