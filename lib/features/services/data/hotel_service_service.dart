import 'dart:async';

import 'package:smart_stay/features/services/data/hotel_service_dto.dart';
import 'package:smart_stay/features/services/data/service_request_dto.dart';

class HotelServiceService {
  final List<Map<String, dynamic>> _requests = [
    {
      'id': 1001,
      'serviceId': 2,
      'title': 'Limpieza adicional',
      'description': 'Cambio de toallas y orden de habitación.',
      'requestedAt': 'Hoy, 09:20 a.m.',
      'estimatedTime': '15 min',
      'status': 'En proceso',
      'room': 'A-204',
    },
    {
      'id': 1002,
      'serviceId': 3,
      'title': 'Soporte técnico',
      'description': 'Revisión de conexión WiFi y Smart TV.',
      'requestedAt': 'Ayer, 08:40 p.m.',
      'estimatedTime': '10 min',
      'status': 'Completado',
      'room': 'A-204',
    },
  ];

  Future<List<HotelServiceDto>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 450));

    final jsons = [
      {
        'id': 1,
        'title': 'Room service',
        'description': 'Solicita comida o bebidas a tu habitación.',
        'estimatedTime': '25 min',
        'status': 'Available',
      },
      {
        'id': 2,
        'title': 'Limpieza adicional',
        'description': 'Pide limpieza, orden o cambio de toallas.',
        'estimatedTime': '15 min',
        'status': 'Available',
      },
      {
        'id': 3,
        'title': 'Soporte técnico',
        'description': 'Reporta problemas con WiFi, TV o aire acondicionado.',
        'estimatedTime': '10 min',
        'status': 'Available',
      },
      {
        'id': 4,
        'title': 'Transporte',
        'description': 'Coordina movilidad al aeropuerto o zonas cercanas.',
        'estimatedTime': '30 min',
        'status': 'Available',
      },
    ];

    return jsons.map((e) => HotelServiceDto.fromJson(e)).toList();
  }

  Future<List<ServiceRequestDto>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _requests.map((e) => ServiceRequestDto.fromJson(e)).toList();
  }

  Future<ServiceRequestDto?> requestService(HotelServiceDto service) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (service.id <= 0) return null;

    final newRequest = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'serviceId': service.id,
      'title': service.title,
      'description': _descriptionByService(service.id),
      'requestedAt': 'Ahora',
      'estimatedTime': service.estimatedTime,
      'status': 'Pendiente',
      'room': 'A-204',
    };

    _requests.insert(0, newRequest);
    return ServiceRequestDto.fromJson(newRequest);
  }

  String _descriptionByService(int id) {
    switch (id) {
      case 1:
        return 'Pedido enviado a cocina para habitación A-204.';
      case 2:
        return 'Housekeeping recibió la solicitud de limpieza.';
      case 3:
        return 'Mantenimiento fue notificado para revisar el problema.';
      case 4:
        return 'Recepción coordinará la movilidad solicitada.';
      default:
        return 'El staff del hotel recibió tu solicitud.';
    }
  }
}
