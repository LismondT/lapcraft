import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

class ProductsRemoteDatasourceImpl implements ProductsDatasource {
  final DioClient _client;

  ProductsRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, ProductResponse>> product(String id) async {
    final response = await _client.get(ListApi.products + id,
        converter: (response) =>
            ProductResponse.fromJson(response as Map<String, dynamic>));

    return response;
  }

  @override
  Future<Either<Failure, ProductsResponse>> products(int page, int pageSize,
      {int? petId,
      int? categoryId,
      double? priceStart,
      double? priceEnd}) async {
    final response = await _client.get(ListApi.products,
        queryParameters: {
          "page": page,
          "size": pageSize,
          "pet": petId ?? 0,
          "category": categoryId ?? 0
        },
        converter: (response) =>
            ProductsResponse.fromJson(response as Map<String, dynamic>));

    return response;
  }
}
