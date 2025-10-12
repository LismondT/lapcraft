
import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';

import '../repositories/cart_repository.dart';

class AddCartItem extends UseCase<void, String> {
  final CartRepository _repository;

  AddCartItem(this._repository);

  @override
  Future<Either<Failure, void>> call(String productId) async {
    return await _repository.addToCart(productId);
  }
}