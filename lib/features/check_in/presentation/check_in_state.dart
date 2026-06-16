import 'package:smart_stay/features/check_in/domain/check_in.dart';

class CheckInState {
  final bool isLoading;
  final bool isConfirming;
  final String? errorMessage;
  final CheckIn? checkIn;
  final bool documentAccepted;
  final bool policiesAccepted;

  CheckInState({
    this.isLoading = false,
    this.isConfirming = false,
    this.errorMessage,
    this.checkIn,
    this.documentAccepted = false,
    this.policiesAccepted = false,
  });

  bool get canConfirm => documentAccepted && policiesAccepted;

  CheckInState copyWith({
    bool? isLoading,
    bool? isConfirming,
    String? errorMessage,
    CheckIn? checkIn,
    bool? documentAccepted,
    bool? policiesAccepted,
  }) {
    return CheckInState(
      isLoading: isLoading ?? this.isLoading,
      isConfirming: isConfirming ?? this.isConfirming,
      errorMessage: errorMessage,
      checkIn: checkIn ?? this.checkIn,
      documentAccepted: documentAccepted ?? this.documentAccepted,
      policiesAccepted: policiesAccepted ?? this.policiesAccepted,
    );
  }
}
