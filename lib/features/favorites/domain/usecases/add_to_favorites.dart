import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/favorites/domain/repositories/favorites_repository.dart';

class AddToFavorites {
  final FavoritesRepository _repository;

  AddToFavorites(this._repository);

  Future<Either<Failure, void>> call(String productId) async {
    return await _repository.addToFavorites(productId);
  }
}
