import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

import '../../../../core/api/api_client.dart';

class ProductsRemoteDatasourceImpl implements ProductsDatasource {
  final ApiClient _client;

  ProductsRemoteDatasourceImpl(this._client);

  @override
  Future<ProductResponse> product(String id) async {
    final response = await _client.get(Api.products.withItem(id));
    final product =
        ProductResponse.fromJson(response.data as Map<String, dynamic>);
    return product;
  }

  @override
  Future<ProductsResponse> products(
      {required int page,
      required int count,
      required String category,
      required Map<String, dynamic> filters}) async {
    final queryParams = <String, dynamic>{
      "page": page,
      "count": count,
      "category": category,
    };

    if (filters.containsKey('min_price')) {
      queryParams['min_price'] = filters['min_price'];
    }
    if (filters.containsKey('max_price')) {
      queryParams['max_price'] = filters['max_price'];
    }
    if (filters.containsKey('sort')) {
      queryParams['sort'] = filters['sort'];
    }
    if (filters.containsKey('order')) {
      queryParams['order'] = filters['order'];
    }

    if (filters.containsKey('name')) {
      queryParams['name'] = filters['name'];
    }

    final response = await _client.get(
      Api.products.url,
      queryParameters: queryParams,
    );

    final products =
        ProductsResponse.fromJson(response.data as Map<String, dynamic>);

    return products;
  }
}
