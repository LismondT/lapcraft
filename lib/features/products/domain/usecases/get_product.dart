import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/products/products.dart';

class GetProduct {
  final ProductsRepository repository;

  GetProduct({required this.repository});

  Future<Either<Failure, Product>> call(String id) async {
    return await repository.product(id);
  }
}
