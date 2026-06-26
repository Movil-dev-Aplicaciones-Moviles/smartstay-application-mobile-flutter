import 'package:flutter/material.dart';
import 'package:smart_stay/features/check_in/domain/check_in_repository.dart';
import 'package:smart_stay/features/check_in/presentation/check_in_state.dart';

class CheckInViewModel extends ChangeNotifier {
  final CheckInRepository repository;

  CheckInViewModel({required this.repository}) {
    loadCheckIn();
  }

  CheckInState state = CheckInState();

  Future<void> loadCheckIn() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final checkIn = await repository.getPendingCheckIn();
      state = state.copyWith(isLoading: false, checkIn: checkIn);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo cargar el check-in: $e',
      );
    }

    notifyListeners();
  }

  void toggleDocumentAccepted(bool value) {
    state = state.copyWith(documentAccepted: value);
    notifyListeners();
  }

  void togglePoliciesAccepted(bool value) {
    state = state.copyWith(policiesAccepted: value);
    notifyListeners();
  }

  Future<void> confirmCheckIn() async {
    final currentCheckIn = state.checkIn;
    if (currentCheckIn == null || !state.canConfirm) return;

    state = state.copyWith(isConfirming: true, errorMessage: null);
    notifyListeners();

    try {
      final confirmed = await repository.confirmCheckIn(currentCheckIn);
      state = state.copyWith(isConfirming: false, checkIn: confirmed);
    } catch (e) {
      state = state.copyWith(
        isConfirming: false,
        errorMessage: 'No se pudo confirmar el check-in: $e',
      );
    }

    notifyListeners();
  }
}
