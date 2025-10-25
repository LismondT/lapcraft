import 'package:lapcraft/features/features.dart';

abstract class ProductsDatasource {
  Future<ProductResponse> product(String id);

  Future<ProductsResponse> products(int page, int pageSize,
      {String? categoryId, double? priceStart, double? priceEnd});
}
