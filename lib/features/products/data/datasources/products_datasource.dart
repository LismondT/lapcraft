import 'package:lapcraft/features/features.dart';

abstract class ProductsDatasource {
  Future<ProductResponse> product(String id);

  Future<ProductsResponse> products({required int page,
    required int count,
    required String category,
    required Map<String, dynamic> filters});
}
