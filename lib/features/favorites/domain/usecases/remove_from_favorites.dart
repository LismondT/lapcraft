import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';

import '../repositories/favorites_repository.dart';

class RemoveFromFavorites {
  final FavoritesRepository _repository;

  RemoveFromFavorites(this._repository);

  Future<Either<Failure, void>> call(String productId) async {
    return await _repository.removeFromFavorites(productId);
  }
}
