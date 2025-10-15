import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/favorites/domain/repositories/favorites_repository.dart';

class IsFavorite {
  final FavoritesRepository _repository;

  IsFavorite(this._repository);

  Future<Either<Failure, bool>> call(String productId) async {
    return await _repository.isFavorite(productId);
  }
}
