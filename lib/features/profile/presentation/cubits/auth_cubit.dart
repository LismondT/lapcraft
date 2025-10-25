import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_state.dart';

import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login loginUseCase;
  final Register registerUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final Logout logoutUseCase;

  AuthCubit(
      {required this.loginUseCase,
      required this.registerUseCase,
      required this.getCurrentUserUseCase,
      required this.logoutUseCase})
      : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final result = await loginUseCase(email, password);

    result.fold(
      (failure) => emit(AuthState.error(failure.toString())),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> checkAuth() async {
    final result = await getCurrentUserUseCase();
    result.fold(
      (failure) => emit(AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> logout() async {
    emit(AuthState.loading());
    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthState.error(failure.toString())),
      (_) => emit(AuthState.unauthenticated()),
    );
  }

  Future<void> register(
      {required String login,
      required String email,
      required String password,
      String? phone}) async {
    emit(AuthState.loading());

    final response = await registerUseCase(
        login: login, email: email, password: password, phone: phone);
    response.fold((failure) => emit(AuthState.error(failure.toString())),
        (user) => emit(AuthState.authenticated(user: user)));
  }
}
