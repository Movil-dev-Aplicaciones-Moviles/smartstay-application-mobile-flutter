import 'package:smart_stay/features/auth/domain/user.dart';

abstract class AuthRepository {
  Future<User?> login({required String email, required String password});
  Future<User?> register({required String email, required String password});
}
