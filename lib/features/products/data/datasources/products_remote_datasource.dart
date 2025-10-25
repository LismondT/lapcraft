import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

import '../../../../core/api/api_client.dart';

class ProductsRemoteDatasourceImpl implements ProductsDatasource {
  final ApiClient _client;

  ProductsRemoteDatasourceImpl(this._client);

  @override
  Future<ProductResponse> product(String id) async {
    final response = await _client.get(Api.products.withItem(id));
    final product = ProductResponse.fromJson(response as Map<String, dynamic>);
    return product;
  }

  @override
  Future<ProductsResponse> products(int page, int pageSize,
      {String? categoryId, double? priceStart, double? priceEnd}) async {
    final response = await _client.get(
      Api.products.url,
      queryParameters: {
        "page": page,
        "size": pageSize,
        if (categoryId != null && categoryId.isNotEmpty) ...{
          "category": categoryId
        },
        if (priceStart != null) ...{"priceStart": priceStart},
        if (priceEnd != null) ...{"priceEnd": priceEnd}
      },
    );

    final products =
        ProductsResponse.fromJson(response as Map<String, dynamic>);

    return products;
  }
}
