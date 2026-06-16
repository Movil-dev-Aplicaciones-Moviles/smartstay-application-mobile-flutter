import 'package:smart_stay/features/room/domain/room_control.dart';

abstract class RoomRepository {
  Future<RoomControl> getRoomControl();
  Future<RoomControl> updateRoomControl(RoomControl roomControl);
}
