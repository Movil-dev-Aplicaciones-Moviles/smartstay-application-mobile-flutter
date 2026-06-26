import 'dart:async';

import 'package:smart_stay/features/room/data/room_control_dto.dart';

class RoomService {
  RoomControlDto _roomControl = RoomControlDto.fromJson({
    'roomNumber': '305',
    'temperature': 22.0,
    'brightness': 65.0,
    'blinds': 40.0,
    'mainLight': true,
    'airConditioning': true,
  });

  Future<RoomControlDto> getRoomControl() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _roomControl;
  }

  Future<RoomControlDto> updateRoomControl(RoomControlDto dto) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _roomControl = dto;
    return _roomControl;
  }
}
