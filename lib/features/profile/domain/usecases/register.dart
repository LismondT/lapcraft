import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/profile/domain/repositories/auth_repository.dart';

import '../entities/user.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, User>> call(
      {required String login,
      required String email,
      required String password,
      String? phone}) {
    return repository.register(
        login: login, email: email, password: password, phone: phone);
  }
}
