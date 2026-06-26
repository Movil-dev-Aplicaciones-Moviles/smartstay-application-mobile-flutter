import 'package:smart_stay/features/home/domain/current_stay.dart';

abstract class StayRepository {
  Future<CurrentStay> getCurrentStay();
}
