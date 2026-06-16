import 'package:smart_stay/features/services/data/hotel_service_dto.dart';
import 'package:smart_stay/features/services/data/hotel_service_service.dart';
import 'package:smart_stay/features/services/domain/hotel_service.dart';
import 'package:smart_stay/features/services/domain/hotel_service_repository.dart';
import 'package:smart_stay/features/services/domain/service_request.dart';

class HotelServiceRepositoryImpl implements HotelServiceRepository {
  final HotelServiceService service;

  HotelServiceRepositoryImpl({required this.service});

  @override
  Future<List<HotelService>> getServices() async {
    final response = await service.getServices();
    return response.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<ServiceRequest>> getRequests() async {
    final response = await service.getRequests();
    return response.map((e) => e.toDomain()).toList();
  }

  @override
  Future<ServiceRequest?> requestService(HotelService hotelService) async {
    final dto = HotelServiceDto(
      id: hotelService.id,
      title: hotelService.title,
      description: hotelService.description,
      estimatedTime: hotelService.estimatedTime,
      status: hotelService.status,
    );

    final response = await service.requestService(dto);
    return response?.toDomain();
  }
}
