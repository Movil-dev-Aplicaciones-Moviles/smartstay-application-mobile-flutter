import 'package:smart_stay/features/room/data/room_control_dto.dart';
import 'package:smart_stay/features/room/data/room_service.dart';
import 'package:smart_stay/features/room/domain/room_control.dart';
import 'package:smart_stay/features/room/domain/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomService service;

  RoomRepositoryImpl({required this.service});

  @override
  Future<RoomControl> getRoomControl() async {
    final response = await service.getRoomControl();
    return response.toDomain();
  }

  @override
  Future<RoomControl> updateRoomControl(RoomControl roomControl) async {
    final request = RoomControlDto.fromDomain(roomControl);
    final response = await service.updateRoomControl(request);
    return response.toDomain();
  }
}
