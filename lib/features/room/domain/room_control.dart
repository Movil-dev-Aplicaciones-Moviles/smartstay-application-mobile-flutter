class RoomControl {
  final String roomNumber;
  final double temperature;
  final double brightness;
  final double blinds;
  final bool mainLight;
  final bool airConditioning;

  RoomControl({
    required this.roomNumber,
    required this.temperature,
    required this.brightness,
    required this.blinds,
    required this.mainLight,
    required this.airConditioning,
  });

  RoomControl copyWith({
    String? roomNumber,
    double? temperature,
    double? brightness,
    double? blinds,
    bool? mainLight,
    bool? airConditioning,
  }) {
    return RoomControl(
      roomNumber: roomNumber ?? this.roomNumber,
      temperature: temperature ?? this.temperature,
      brightness: brightness ?? this.brightness,
      blinds: blinds ?? this.blinds,
      mainLight: mainLight ?? this.mainLight,
      airConditioning: airConditioning ?? this.airConditioning,
    );
  }
}
