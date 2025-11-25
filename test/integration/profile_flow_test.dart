import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/features/profile/data/datasource/remote/auth_remote_datasource.dart';
import 'package:lapcraft/features/profile/data/models/login_response.dart';
import 'package:lapcraft/features/profile/data/models/user_model.dart';
import 'package:lapcraft/features/profile/data/repositories/auth_repository_impl.dart';
import 'package:lapcraft/features/profile/data/repositories/token_repository_impl.dart';
import 'package:lapcraft/features/profile/domain/usecases/get_current_user.dart';
import 'package:lapcraft/features/profile/domain/usecases/login.dart';
import 'package:lapcraft/features/profile/domain/usecases/logout.dart';
import 'package:lapcraft/features/profile/domain/usecases/register.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  group('Auth Feature Integration Test', () {
    test('полная интеграция: от datasource до cubit', () async {
      // Arrange
      final mockDatasource = MockAuthRemoteDatasource();
      final tokenRepository = TokenRepositoryImpl();
      final repository = AuthRepositoryImpl(
        dataSource: mockDatasource,
        tokenRepository: tokenRepository,
      );

      final loginUseCase = Login(repository);
      final registerUseCase = Register(repository);

      final cubit = AuthCubit(
        loginUseCase: loginUseCase,
        registerUseCase: registerUseCase,
        getCurrentUserUseCase: GetCurrentUser(repository),
        logoutUseCase: Logout(repository),
      );

      const testEmail = 'test@example.com';
      const testPassword = 'password123';
      const testAccessToken = 'test_access_token';
      const testRefreshToken = 'test_refresh_token';

      final testUserModel = UserModel(
        id: '1',
        name: 'Test User',
        email: testEmail,
        phone: '+79999999999',
      );

      final testLoginResponse = LoginResponse(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
      );

      // Настройка моков
      when(() => mockDatasource.login(email: testEmail, password: testPassword))
          .thenAnswer((_) async => testLoginResponse);

      when(() => mockDatasource.getCurrentUser(accessToken: testAccessToken))
          .thenAnswer((_) async => testUserModel);

      // Act & Assert
      // Проверяем начальное состояние
      expect(cubit.state, isA<AuthInitial>());

      // Выполняем вход
      await cubit.login(testEmail, testPassword);
      await Future.delayed(const Duration(milliseconds: 100));

      // Проверяем, что пользователь аутентифицирован
      expect(cubit.state, isA<AuthAuthenticated>());
      if (cubit.state is AuthAuthenticated) {
        final authenticatedState = cubit.state as AuthAuthenticated;
        expect(authenticatedState.user.email, testEmail);
      }

      // Проверяем, что токены сохранились
      final savedAccessToken = await tokenRepository.getAccessToken();
      expect(savedAccessToken, testAccessToken);
    });
  });
}
