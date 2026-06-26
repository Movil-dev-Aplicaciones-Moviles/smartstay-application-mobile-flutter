import 'package:smart_stay/features/room/domain/room_control.dart';

class RoomState {
  final bool isLoading;
  final RoomControl? roomControl;
  final String? errorMessage;

  RoomState({
    this.isLoading = false,
    this.roomControl,
    this.errorMessage,
  });

  RoomState copyWith({
    bool? isLoading,
    RoomControl? roomControl,
    String? errorMessage,
  }) {
    return RoomState(
      isLoading: isLoading ?? this.isLoading,
      roomControl: roomControl ?? this.roomControl,
      errorMessage: errorMessage,
    );
  }
}
