import 'package:flutter/material.dart';
import 'package:smart_stay/features/room/domain/room_control.dart';
import 'package:smart_stay/features/room/domain/room_repository.dart';
import 'package:smart_stay/features/room/presentation/room_state.dart';

class RoomViewModel extends ChangeNotifier {
  final RoomRepository repository;

  RoomViewModel({required this.repository}) {
    loadRoomControl();
  }

  RoomState state = RoomState();

  Future<void> loadRoomControl() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final roomControl = await repository.getRoomControl();
      state = state.copyWith(isLoading: false, roomControl: roomControl);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load room control: $e',
      );
    }

    notifyListeners();
  }

  Future<void> updateRoomControl(RoomControl roomControl) async {
    state = state.copyWith(roomControl: roomControl);
    notifyListeners();

    try {
      final updated = await repository.updateRoomControl(roomControl);
      state = state.copyWith(roomControl: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update room: $e');
    }

    notifyListeners();
  }
}
