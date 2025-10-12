import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/core/usecase/usecase.dart';

import '../repositories/cart_repository.dart';

class RemoveCartItem extends UseCase<void, String> {
  final CartRepository _repository;

  RemoveCartItem(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await _repository.removeFromCart(params);
  }
}
