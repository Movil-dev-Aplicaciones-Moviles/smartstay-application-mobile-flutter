import 'package:smart_stay/features/room/domain/room_control.dart';

class RoomControlDto {
  final String roomNumber;
  final double temperature;
  final double brightness;
  final double blinds;
  final bool mainLight;
  final bool airConditioning;

  RoomControlDto({
    required this.roomNumber,
    required this.temperature,
    required this.brightness,
    required this.blinds,
    required this.mainLight,
    required this.airConditioning,
  });

  factory RoomControlDto.fromJson(Map<String, dynamic> json) {
    return RoomControlDto(
      roomNumber: json['roomNumber'],
      temperature: json['temperature'],
      brightness: json['brightness'],
      blinds: json['blinds'],
      mainLight: json['mainLight'],
      airConditioning: json['airConditioning'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomNumber': roomNumber,
      'temperature': temperature,
      'brightness': brightness,
      'blinds': blinds,
      'mainLight': mainLight,
      'airConditioning': airConditioning,
    };
  }

  RoomControl toDomain() {
    return RoomControl(
      roomNumber: roomNumber,
      temperature: temperature,
      brightness: brightness,
      blinds: blinds,
      mainLight: mainLight,
      airConditioning: airConditioning,
    );
  }

  factory RoomControlDto.fromDomain(RoomControl roomControl) {
    return RoomControlDto(
      roomNumber: roomControl.roomNumber,
      temperature: roomControl.temperature,
      brightness: roomControl.brightness,
      blinds: roomControl.blinds,
      mainLight: roomControl.mainLight,
      airConditioning: roomControl.airConditioning,
    );
  }
}
