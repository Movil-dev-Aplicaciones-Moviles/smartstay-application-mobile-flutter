import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_stay/core/storage/token_storage.dart';
import 'package:smart_stay/features/auth/data/auth_repository_impl.dart';
import 'package:smart_stay/features/auth/data/auth_service.dart';
import 'package:smart_stay/features/auth/domain/auth_repository.dart';
import 'package:smart_stay/features/auth/presentation/login_view_model.dart';

final getIt = GetIt.instance;

void setup() {
  if (getIt.isRegistered<LoginViewModel>()) return;

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<TokenStorage>(
    () => TokenStorage(storage: getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<AuthService>(() => AuthService());

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      service: getIt<AuthService>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  getIt.registerFactory(
    () => LoginViewModel(repository: getIt<AuthRepository>()),
  );
}
