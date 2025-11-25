import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/profile/domain/entities/user.dart';
import 'package:lapcraft/features/profile/domain/usecases/get_current_user.dart';
import 'package:lapcraft/features/profile/domain/usecases/login.dart';
import 'package:lapcraft/features/profile/domain/usecases/logout.dart';
import 'package:lapcraft/features/profile/domain/usecases/register.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLogin extends Mock implements Login {}
class MockRegister extends Mock implements Register {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockLogout extends Mock implements Logout {}

void main() {
  late AuthCubit cubit;
  late MockLogin mockLogin;
  late MockRegister mockRegister;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockLogout mockLogout;

  final testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    phone: '+79999999999',
  );

  setUp(() {
    mockLogin = MockLogin();
    mockRegister = MockRegister();
    mockGetCurrentUser = MockGetCurrentUser();
    mockLogout = MockLogout();

    cubit = AuthCubit(
      loginUseCase: mockLogin,
      registerUseCase: mockRegister,
      getCurrentUserUseCase: mockGetCurrentUser,
      logoutUseCase: mockLogout,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthCubit', () {
    test('начальное состояние должно быть AuthState.initial', () {
      expect(cubit.state, isA<AuthInitial>());
    });

    blocTest<AuthCubit, AuthState>(
      'должен эмитить loading и authenticated при успешном входе',
      build: () {
        when(() => mockLogin(any(), any()))
            .thenAnswer((_) async => Right(testUser));
        return cubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'password'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
      verify: (_) {
        verify(() => mockLogin('test@example.com', 'password')).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'должен эмитить loading и error при ошибке входа',
      build: () {
        when(() => mockLogin(any(), any()))
            .thenAnswer((_) async => Left(InvalidCredentialsFailure()));
        return cubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'wrongpassword'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'должен эмитить authenticated при успешной проверке аутентификации',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => Right(testUser));
        return cubit;
      },
      act: (cubit) => cubit.checkAuth(),
      expect: () => [
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'должен эмитить unauthenticated при отсутствии аутентификации',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => Left(UnauthorizedFailure()));
        return cubit;
      },
      act: (cubit) => cubit.checkAuth(),
      expect: () => [
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'должен эмитить loading и unauthenticated при успешном выходе',
      build: () {
        when(() => mockLogout())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'должен успешно регистрировать пользователя',
      build: () {
        when(() => mockRegister(
          login: any(named: 'login'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          phone: any(named: 'phone'),
        )).thenAnswer((_) async => Right(testUser));
        return cubit;
      },
      act: (cubit) => cubit.register(
        login: 'Test User',
        email: 'test@example.com',
        password: 'password',
        phone: '+79999999999',
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );
  });
}