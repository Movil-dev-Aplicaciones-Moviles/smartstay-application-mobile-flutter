import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_stay/features/auth/domain/auth_repository.dart';
import 'package:smart_stay/features/auth/presentation/login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginViewModel({required this.repository}) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      final user = await repository.login(email: email, password: password);

      if (user == null) {
        emit(LoginFailure(error: 'Complete email and password'));
        return;
      }

      emit(LoginSuccess(user: user));
    } catch (e) {
      emit(LoginFailure(error: 'Login error: $e'));
    }
  }
}
