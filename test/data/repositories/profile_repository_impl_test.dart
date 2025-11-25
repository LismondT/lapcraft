import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/profile/data/datasource/remote/auth_remote_datasource.dart';
import 'package:lapcraft/features/profile/data/models/login_response.dart';
import 'package:lapcraft/features/profile/data/models/user_model.dart';
import 'package:lapcraft/features/profile/data/repositories/auth_repository_impl.dart';
import 'package:lapcraft/features/profile/domain/entities/user.dart';
import 'package:lapcraft/features/profile/domain/repositories/token_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}
class MockTokenRepository extends Mock implements TokenRepository {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDatasource mockDatasource;
  late MockTokenRepository mockTokenRepository;

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    mockTokenRepository = MockTokenRepository();
    repository = AuthRepositoryImpl(
      dataSource: mockDatasource,
      tokenRepository: mockTokenRepository,
    );
  });

  group('AuthRepositoryImpl', () {
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

    final testUser = testUserModel.toEntity();

    final testLoginResponse = LoginResponse(
      accessToken: testAccessToken,
      refreshToken: testRefreshToken,
    );

    test('должен успешно выполнять вход', () async {
      // Arrange
      when(() => mockDatasource.login(email: testEmail, password: testPassword))
          .thenAnswer((_) async => testLoginResponse);

      when(() => mockTokenRepository.saveTokens(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
      )).thenAnswer((_) async {});

      when(() => mockDatasource.getCurrentUser(accessToken: testAccessToken))
          .thenAnswer((_) async => testUserModel);

      // Act
      final result = await repository.login(testEmail, testPassword);

      // Assert
      expect(result, isA<Right<Failure, User>>());
      result.fold(
            (failure) => fail('Не должно быть ошибки'),
            (user) {
          expect(user.id, '1');
          expect(user.email, testEmail);
        },
      );

      verify(() => mockTokenRepository.saveTokens(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
      )).called(1);
    });

    test('должен возвращать ошибку при неверных учетных данных', () async {
      // Arrange
      when(() => mockDatasource.login(email: testEmail, password: testPassword))
          .thenThrow(InvalidCredentialsFailure());

      // Act
      final result = await repository.login(testEmail, testPassword);

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
            (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
            (user) => fail('Должна быть ошибка'),
      );
    });

    test('должен успешно получать текущего пользователя', () async {
      // Arrange
      when(() => mockTokenRepository.getAccessToken())
          .thenAnswer((_) async => testAccessToken);

      when(() => mockDatasource.getCurrentUser(accessToken: testAccessToken))
          .thenAnswer((_) async => testUserModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isA<Right<Failure, User>>());
      result.fold(
            (failure) => fail('Не должно быть ошибки'),
            (user) => expect(user.id, '1'),
      );
    });

    test('должен возвращать UnauthorizedFailure при отсутствии токена', () async {
      // Arrange
      when(() => mockTokenRepository.getAccessToken())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (user) => fail('Должна быть ошибка'),
      );
    });

    test('должен успешно выходить из системы', () async {
      // Arrange
      when(() => mockTokenRepository.getRefreshToken())
          .thenAnswer((_) async => testRefreshToken);

      when(() => mockDatasource.logout(refreshToken: testRefreshToken))
          .thenAnswer((_) async {});

      when(() => mockTokenRepository.clearTokens())
          .thenAnswer((_) async {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockTokenRepository.clearTokens()).called(1);
    });

    test('должен успешно регистрировать пользователя', () async {
      // Arrange
      when(() => mockDatasource.register(
        name: 'Test User',
        email: testEmail,
        password: testPassword,
        phone: '+79999999999',
      )).thenAnswer((_) async => testLoginResponse);

      when(() => mockTokenRepository.saveTokens(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
      )).thenAnswer((_) async {});

      when(() => mockDatasource.getCurrentUser(accessToken: testAccessToken))
          .thenAnswer((_) async => testUserModel);

      // Act
      final result = await repository.register(
        login: 'Test User',
        email: testEmail,
        password: testPassword,
        phone: '+79999999999',
      );

      // Assert
      expect(result, isA<Right<Failure, User>>());
      result.fold(
            (failure) => fail('Не должно быть ошибки'),
            (user) => expect(user.id, '1'),
      );
    });
  });
}