
import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/products/products.dart';

class GetProduct extends UseCase<Product, String> {
  final ProductsRepository _repo;

  GetProduct(this._repo);

  @override
  Future<Either<Failure, Product>> call(String params) =>
      _repo.product(params);
}