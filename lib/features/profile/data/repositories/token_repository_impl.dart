import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repositories/token_repository.dart';

class TokenRepositoryImpl extends TokenRepository {
  static const String refreshTokenKey = 'refresh_token';
  static const String accessTokenKey = 'access_token';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  TokenRepositoryImpl();

  @override
  Future<String?> getAccessToken() => _secureStorage.read(key: accessTokenKey);

  @override
  Future<String?> getRefreshToken() =>
      _secureStorage.read(key: refreshTokenKey);

  @override
  Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    await _secureStorage.write(key: accessTokenKey, value: accessToken);
    await _secureStorage.write(key: refreshTokenKey, value: refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: accessTokenKey);
    await _secureStorage.delete(key: refreshTokenKey);
  }
}
