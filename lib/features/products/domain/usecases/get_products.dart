
import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/products/products.dart';

class GetProducts extends UseCase<Products, (int page, int size)> {
  final ProductsRepository _repo;

  GetProducts(this._repo);

  @override
  Future<Either<Failure, Products>> call((int, int) params) =>
      _repo.products(params.$1, params.$2);
}