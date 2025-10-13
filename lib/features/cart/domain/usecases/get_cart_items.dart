
import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';
import 'package:lapcraft/features/cart/domain/repositories/cart_repository.dart';
import 'package:lapcraft/features/products/domain/entities/product.dart';

class GetCartItems extends UseCase<List<CartItem>, NoParams> {
  final CartRepository _repository;

  GetCartItems(this._repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams param) async {
    return await _repository.getAll();
  }
}