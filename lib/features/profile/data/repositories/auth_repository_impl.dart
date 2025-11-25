import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/profile/data/datasource/remote/auth_remote_datasource.dart';
import 'package:lapcraft/features/profile/data/models/user_model.dart';
import 'package:lapcraft/features/profile/domain/entities/user.dart';
import 'package:lapcraft/features/profile/domain/repositories/auth_repository.dart';
import 'package:lapcraft/features/profile/domain/repositories/token_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource dataSource;
  final TokenRepository tokenRepository;

  AuthRepositoryImpl({required this.dataSource, required this.tokenRepository});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await dataSource.login(email: email, password: password);

      await tokenRepository.saveTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken);

      final currentUser =
          await dataSource.getCurrentUser(accessToken: response.accessToken);

      return Right(currentUser.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await tokenRepository.getAccessToken() ?? '';
      final result = await dataSource.getCurrentUser(accessToken: token);

      return Right(result.toEntity());
    } on AccessTokenExpiredFailure catch (e) {
      final token = await tokenRepository.getAccessToken() ?? '';
      final result = await dataSource.getCurrentUser(accessToken: token);

      return Right(result.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await tokenRepository.getRefreshToken();
      await dataSource.logout(refreshToken: token);

      await tokenRepository.clearTokens();
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String login,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await dataSource.register(
        name: login,
        email: email,
        password: password,
        phone: phone,
      );

      await tokenRepository.saveTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken);

      final currentUser =
          await dataSource.getCurrentUser(accessToken: response.accessToken);

      return Right(currentUser.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}
