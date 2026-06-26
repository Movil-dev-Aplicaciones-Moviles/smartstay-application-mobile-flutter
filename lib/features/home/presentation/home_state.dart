import 'package:smart_stay/features/home/domain/current_stay.dart';

class HomeState {
  final bool isLoading;
  final CurrentStay? stay;
  final String? errorMessage;

  HomeState({
    this.isLoading = false,
    this.stay,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    CurrentStay? stay,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      stay: stay ?? this.stay,
      errorMessage: errorMessage,
    );
  }
}
