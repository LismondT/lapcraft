import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/profile/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);

  Future<Either<Failure, User>> register(
      {required String login, required String email, required String password, String? phone});

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> refreshToken();

  Future<Either<Failure, void>> logout();

  Future<bool> isLoggedIn();
}
