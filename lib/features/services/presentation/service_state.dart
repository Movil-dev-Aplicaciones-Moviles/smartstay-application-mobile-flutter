import 'package:smart_stay/features/services/domain/hotel_service.dart';
import 'package:smart_stay/features/services/domain/service_request.dart';

class ServiceState {
  final bool isLoading;
  final bool isRequesting;
  final List<HotelService> services;
  final List<ServiceRequest> requests;
  final String? message;
  final String? errorMessage;

  ServiceState({
    this.isLoading = false,
    this.isRequesting = false,
    this.services = const [],
    this.requests = const [],
    this.message,
    this.errorMessage,
  });

  ServiceState copyWith({
    bool? isLoading,
    bool? isRequesting,
    List<HotelService>? services,
    List<ServiceRequest>? requests,
    String? message,
    String? errorMessage,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return ServiceState(
      isLoading: isLoading ?? this.isLoading,
      isRequesting: isRequesting ?? this.isRequesting,
      services: services ?? this.services,
      requests: requests ?? this.requests,
      message: clearMessage ? null : message ?? this.message,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
