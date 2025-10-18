// auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/profile/data/datasource/remote/auth_remote_datasource.dart';
import 'package:lapcraft/features/profile/data/models/user_model.dart';
import 'package:lapcraft/features/profile/domain/entities/user.dart';
import 'package:lapcraft/features/profile/domain/repositories/auth_repository.dart';

import '../models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource dataSource;

  String? _currentToken;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final result = await dataSource.login(request);

      return result.fold(
        (failure) => Left(failure),
        (response) {
          _currentToken = response.accessToken;
          _saveToken(response.accessToken);
          return Right(response.user.toEntity());
        },
      );
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await _getToken();
      final result = await dataSource.getCurrentUser(token: token);

      return result.fold(
        (failure) => Left(failure),
        (userModel) => Right(userModel.toEntity()),
      );
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      final token = await _getToken();
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await _getToken();
      final result = await dataSource.logout(token: token);

      return result.fold(
        (failure) => Left(failure),
        (_) {
          _currentToken = null;
          _clearToken();
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await _getToken();
      return await dataSource.isLoggedIn(token: token);
    } catch (e) {
      return false;
    }
  }

  // Вспомогательные методы для работы с токеном
  Future<void> _saveToken(String token) async {
    _currentToken = token;
    // В реальном приложении сохраняем в secure storage
    // await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> _getToken() async {
    if (_currentToken != null) return _currentToken;

    // В реальном приложении получаем из secure storage
    // _currentToken = await storage.read(key: 'auth_token');
    return _currentToken;
  }

  Future<void> _clearToken() async {
    _currentToken = null;
    // В реальном приложении удаляем из secure storage
    // await storage.delete(key: 'auth_token');
  }

  // Дополнительный метод для регистрации
  @override
  Future<Either<Failure, User>> register({
    required String login,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final result = await dataSource.register(
        name: login,
        email: email,
        password: password,
        phone: phone,
      );

      return result.fold(
        (failure) => Left(failure),
        (response) {
          _currentToken = response.accessToken;
          _saveToken(response.accessToken);
          return Right(response.user.toEntity());
        },
      );
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}
