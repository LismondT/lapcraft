import 'package:lapcraft/features/profile/data/models/login_response.dart';

import '../../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponse> login(
      {required String email, required String password});

  Future<UserModel> getCurrentUser({String? accessToken});

  Future<LoginResponse> refreshToken(String refreshToken);

  Future<void> logout({String? refreshToken});

  Future<bool> isLoggedIn({String? token});

  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
}
