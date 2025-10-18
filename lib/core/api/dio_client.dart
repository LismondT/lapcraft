
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lapcraft/core/core.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

class DioClient {
  static const String baseUrl = String.fromEnvironment("LAPCRAFT_API_URL");

  String? _token;
  late Dio _dio;

  DioClient() {
    _dio = _createDio();
  }

  Dio _createDio() =>
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (_token != null) ...{
                'Authorization': _token,
              },
            },
            receiveTimeout: const Duration(minutes: 1),
            connectTimeout: const Duration(minutes: 1),
          )
      );

  Future<Either<Failure, T>> get<T>(String apiPath, {
    Map<String, dynamic>? queryParameters,
    required ResponseConverter<T> converter
  }) async {
    try {
      final response = await _dio.get(
          apiPath, queryParameters: queryParameters);
      if ((response.statusCode ?? 0) < 0 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response
        );
      }

      return Right(converter(response.data));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, T>> postRequest<T>(String apiPath, {
    Map<String, dynamic>? queryParameters,
    required ResponseConverter<T> converter
  }) async {
    try {
      final response = await _dio.post(
          apiPath, queryParameters: queryParameters);
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      return Right(converter(response.data));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}