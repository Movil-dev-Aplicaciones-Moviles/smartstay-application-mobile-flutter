import 'package:smart_stay/features/services/domain/hotel_service.dart';
import 'package:smart_stay/features/services/domain/service_request.dart';

abstract class HotelServiceRepository {
  Future<List<HotelService>> getServices();
  Future<List<ServiceRequest>> getRequests();
  Future<ServiceRequest?> requestService(HotelService hotelService);
}
