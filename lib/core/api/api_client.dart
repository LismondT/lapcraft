import 'package:dio/dio.dart';

import '../../features/profile/domain/repositories/token_repository.dart';
import 'api.dart';

class ApiClient {
  final Dio _dio = Dio();
  final TokenRepository _tokenRepository;
  final String baseUrl;

  ApiClient({
    required TokenRepository tokenRepository,
    required this.baseUrl
  }) : _tokenRepository = tokenRepository {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Добавляем токен к каждому запросу
          final token = await _tokenRepository.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Обработка 401 ошибки (токен истек)
          if (error.response?.statusCode == 401) {
            try {
              //await _refreshToken();
              // Повторяем оригинальный запрос
              return handler.resolve(await _retry(error.requestOptions));
            } catch (e) {
              // Если refresh не удался - разлогиниваем пользователя
              _tokenRepository.clearTokens();
              // Можно добавить навигацию на экран логина
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _refreshToken() async {
    final refreshToken = await _tokenRepository.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');

    final response = await _dio.post(
      Api.refresh.url,
      data: {'refresh_token': refreshToken},
    );

    await _tokenRepository.saveTokens(
      accessToken: response.data['access_token'],
      refreshToken: response.data['refresh_token'],
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) {
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  // Методы для HTTP запросов
  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) {
    return _dio.get<T>(baseUrl + path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post<T>(baseUrl + path, data: data);
  }
}
