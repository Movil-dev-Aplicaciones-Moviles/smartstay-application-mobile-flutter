import 'package:smart_stay/core/storage/token_storage.dart';
import 'package:smart_stay/features/auth/data/login_request_dto.dart';
import 'package:smart_stay/features/auth/data/login_response_dto.dart';
import 'package:smart_stay/features/auth/data/auth_service.dart';
// 👇 NUEVOS IMPORTS PARA REGISTER
import 'package:smart_stay/features/auth/data/register_request_dto.dart';
import 'package:smart_stay/features/auth/data/register_response_dto.dart';
import 'package:smart_stay/features/auth/domain/auth_repository.dart';
import 'package:smart_stay/features/auth/domain/user.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.service, required this.tokenStorage});

  // ============================================================
  // LOGIN
  // ============================================================
  @override
  Future<User?> login({required String email, required String password}) async {
    final request = LoginRequestDto(email: email, password: password);
    final response = await service.login(request);

    // ❌ ELIMINADA la línea basura: final TokenStorage storage;
    
    if (response == null) {
      return null;
    }

    await tokenStorage.saveToken(response.token);
    return response.toDomain();
  }

  // ============================================================
  // REGISTER
  // ============================================================
  @override
  Future<User?> register({required String email, required String password}) async {
    final request = RegisterRequestDto(email: email, password: password);
    final response = await service.register(request);

    // ✅ Si el backend devuelve token, puedes guardarlo:
    // await tokenStorage.saveToken(response.token);

    return response.toDomain();
  }
}