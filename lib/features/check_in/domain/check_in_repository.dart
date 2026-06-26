import 'package:smart_stay/features/check_in/domain/check_in.dart';

abstract class CheckInRepository {
  Future<CheckIn> getPendingCheckIn();
  Future<CheckIn> confirmCheckIn(CheckIn checkIn);
}
