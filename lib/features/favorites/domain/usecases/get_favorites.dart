import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lapcraft/features/features.dart';

class GetFavorites {
  final FavoritesRepository _repository;

  GetFavorites(this._repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await _repository.getFavorites();
  }
}
