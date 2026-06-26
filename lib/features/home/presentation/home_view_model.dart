import 'package:flutter/material.dart';
import 'package:smart_stay/features/home/domain/stay_repository.dart';
import 'package:smart_stay/features/home/presentation/home_state.dart';

class HomeViewModel extends ChangeNotifier {
  final StayRepository repository;

  HomeViewModel({required this.repository}) {
    loadCurrentStay();
  }

  HomeState state = HomeState();

  Future<void> loadCurrentStay() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final stay = await repository.getCurrentStay();
      state = state.copyWith(isLoading: false, stay: stay);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load stay: $e',
      );
    }

    notifyListeners();
  }
}
