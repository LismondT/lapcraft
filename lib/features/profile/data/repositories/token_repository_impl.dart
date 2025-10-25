import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repositories/token_repository.dart';

class TokenRepositoryImpl extends TokenRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  TokenRepositoryImpl();

  @override
  Future<String?> getAccessToken() => _secureStorage.read(key: 'access_token');

  @override
  Future<String?> getRefreshToken() => _secureStorage.read(key: 'refresh_token');

  @override
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }
}