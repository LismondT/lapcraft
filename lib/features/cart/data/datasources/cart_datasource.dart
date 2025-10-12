import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/products/domain/entities/product.dart';

abstract class CartDatasource {
  Future<Either<Failure, List<Product>>> get_all();

  Future<Either<Failure, void>> add(String product_id);

  Future<Either<Failure, void>> set_count(String product_id, int count);

  Future<Either<Failure, void>> remove(String product_id);
}
