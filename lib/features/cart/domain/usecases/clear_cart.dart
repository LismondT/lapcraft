import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/cart_repository.dart';

class ClearCart {
  final CartRepository _repository;

  ClearCart(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.clearCart();
  }
}
