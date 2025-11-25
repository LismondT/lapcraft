import 'package:dio/dio.dart';
import 'package:lapcraft/core/api/api_client.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/profile/data/datasource/remote/auth_remote_datasource.dart';
import 'package:lapcraft/features/profile/data/models/login_response.dart';
import 'package:lapcraft/features/profile/data/models/user_model.dart';
import 'package:lapcraft/features/profile/domain/repositories/token_repository.dart';

class AuthRemoteDatasourceImpl extends AuthRemoteDatasource {
  final ApiClient client;
  final TokenRepository tokenRepository;

  AuthRemoteDatasourceImpl(
      {required this.client, required this.tokenRepository});

  @override
  Future<UserModel> getCurrentUser({required String accessToken}) async {
    try {
      final response = await client.get(Api.me.url);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        await refreshToken(await tokenRepository.getRefreshToken() ?? '');
        throw AccessTokenExpiredFailure();
      }
      rethrow;
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<bool> isLoggedIn({String? token}) {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<void> logout({String? refreshToken}) async {
    try {
      await client.post(Api.logout.url, data: {'refresh_token': refreshToken});
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<void> refreshToken(String refreshToken) async {
    try {
      final response = await client
          .post(Api.refresh.url, data: {'refresh_token': refreshToken});
      final tokens = LoginResponse.fromJson(
          response.data as Map<String, dynamic>);
      await tokenRepository.saveTokens(
          accessToken: tokens.accessToken, refreshToken: tokens.refreshToken);
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<LoginResponse> register({required String name,
    required String email,
    required String password,
    String? phone}) async {
    try {
      final response = await client.post(Api.register.url, data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password
      });

      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw EmailAlreadyExistsFailure();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<LoginResponse> login(
      {required String email, required String password}) async {
    try {
      final response = await client
          .post(Api.login.url, data: {'email': email, 'password': password});

      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw InvalidCredentialsFailure();
      }
      throw ServerFailure();
    } catch (e) {
      throw ServerFailure();
    }
  }
}
