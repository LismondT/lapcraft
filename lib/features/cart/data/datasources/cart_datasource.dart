import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';

abstract class CartDatasource {
  Future<Either<Failure, List<CartItem>>> getAll();

  Future<Either<Failure, void>> add(String productId);

  Future<Either<Failure, void>> setCount(String productId, int count);

  Future<Either<Failure, void>> remove(String productId);

  Future<Either<Failure, void>> clear();
}
