import 'package:dartz/dartz.dart';
import 'package:lapcraft/features/cart/domain/repositories/cart_repository.dart';

import '../../../../core/error/failure.dart';

class UpdateCartItemQuantity {
  final CartRepository _repository;

  UpdateCartItemQuantity(this._repository);

  Future<Either<Failure, void>> call(String productId, int quantity) async {
    return await _repository.updateQuantity(productId, quantity);
  }
}
