import 'package:smart_stay/features/home/data/stay_service.dart';
import 'package:smart_stay/features/home/domain/current_stay.dart';
import 'package:smart_stay/features/home/domain/stay_repository.dart';

class StayRepositoryImpl implements StayRepository {
  final StayService service;

  StayRepositoryImpl({required this.service});

  @override
  Future<CurrentStay> getCurrentStay() async {
    final response = await service.getCurrentStay();
    return response.toDomain();
  }
}
