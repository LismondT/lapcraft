import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/profile/data/models/login_response.dart';

import '../../models/login_request.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);

  Future<Either<Failure, UserModel>> getCurrentUser({String? token});

  Future<Either<Failure, LoginResponse>> refreshToken(String refreshToken);

  Future<Either<Failure, void>> logout({String? token});

  Future<bool> isLoggedIn({String? token});

  Future<Either<Failure, LoginResponse>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
}
