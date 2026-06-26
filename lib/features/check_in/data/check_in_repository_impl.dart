import 'package:smart_stay/features/check_in/data/check_in_service.dart';
import 'package:smart_stay/features/check_in/domain/check_in.dart';
import 'package:smart_stay/features/check_in/domain/check_in_repository.dart';

class CheckInRepositoryImpl implements CheckInRepository {
  final CheckInService service;

  CheckInRepositoryImpl({required this.service});

  @override
  Future<CheckIn> getPendingCheckIn() async {
    final dto = await service.getPendingCheckIn();
    return dto.toDomain();
  }

  @override
  Future<CheckIn> confirmCheckIn(CheckIn checkIn) async {
    return service.confirmCheckIn(checkIn);
  }
}
