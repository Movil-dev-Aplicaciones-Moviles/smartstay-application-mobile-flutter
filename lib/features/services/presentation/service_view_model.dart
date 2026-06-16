import 'package:flutter/material.dart';
import 'package:smart_stay/features/services/domain/hotel_service.dart';
import 'package:smart_stay/features/services/domain/hotel_service_repository.dart';
import 'package:smart_stay/features/services/domain/service_request.dart';
import 'package:smart_stay/features/services/presentation/service_state.dart';

class ServiceViewModel extends ChangeNotifier {
  final HotelServiceRepository repository;

  ServiceViewModel({required this.repository}) {
    loadServices();
  }

  ServiceState state = ServiceState();

  Future<void> loadServices() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearMessage: true,
    );
    notifyListeners();

    try {
      final services = await repository.getServices();
      final requests = await repository.getRequests();

      state = state.copyWith(
        isLoading: false,
        services: services,
        requests: requests,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudieron cargar los servicios.',
      );
    }

    notifyListeners();
  }

  Future<String> requestService(HotelService hotelService) async {
    state = state.copyWith(
      isRequesting: true,
      clearMessage: true,
      clearError: true,
    );
    notifyListeners();

    try {
      final request = await repository.requestService(hotelService);

      if (request == null) {
        state = state.copyWith(
          isRequesting: false,
          message: 'No se pudo registrar la solicitud',
        );
        notifyListeners();
        return 'No se pudo registrar la solicitud';
      }

      final updatedRequests = <ServiceRequest>[request, ...state.requests];

      state = state.copyWith(
        isRequesting: false,
        requests: updatedRequests,
        message: '${hotelService.title} registrado correctamente',
      );

      notifyListeners();
      return '${hotelService.title} registrado correctamente';
    } catch (e) {
      state = state.copyWith(
        isRequesting: false,
        message: 'Ocurrió un problema al registrar la solicitud',
      );
      notifyListeners();
      return 'Ocurrió un problema al registrar la solicitud';
    }
  }

  void clearMessage() {
    state = state.copyWith(clearMessage: true);
    notifyListeners();
  }
}
