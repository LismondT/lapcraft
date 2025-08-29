import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

class ProductsRemoteDatasourceImpl implements ProductsDatasource {
  final DioClient _client;

  ProductsRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, ProductResponse>> product(String id) async {
    final response = await _client.getRequest(ListApi.products + id,
        converter: (response) =>
            ProductResponse.fromJson(response as Map<String, dynamic>));

    return response;
  }

  @override
  Future<Either<Failure, ProductsResponse>> products(
      int page, int pageSize) async {
    final response = await _client.getRequest(ListApi.products,
        queryParameters: {"page": page, "size": pageSize},
        converter: (response) =>
            ProductsResponse.fromJson(response as Map<String, dynamic>));

    return response;
  }
}
