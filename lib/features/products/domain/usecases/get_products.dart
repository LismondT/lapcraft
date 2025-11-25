import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/products/products.dart';

class GetProducts {
  final ProductsRepository _repo;

  GetProducts(this._repo);

  Future<Either<Failure, Products>> call(
          {required int page,
          required int count,
          required String category,
          required Map<String, dynamic> filters}) =>
      _repo.products(
          page: page, count: count, category: category, filters: filters);
}
