import 'package:smart_stay/core/storage/token_storage.dart';
import 'package:smart_stay/features/auth/data/auth_service.dart';
import 'package:smart_stay/features/auth/data/login_request_dto.dart';
import 'package:smart_stay/features/auth/domain/auth_repository.dart';
import 'package:smart_stay/features/auth/domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.service, required this.tokenStorage});

  @override
  Future<User?> login({required String email, required String password}) async {
    final request = LoginRequestDto(email: email, password: password);
    final response = await service.login(request);

    if (response == null) {
      return null;
    }

    await tokenStorage.saveToken(response.token);
    return response.toDomain();
  }
}
