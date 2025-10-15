import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

abstract class FavoritesRemoteDatasource {
  Future<Either<Failure, List<ProductResponse>>> getFavorites();

  Future<Either<Failure, void>> addToFavorites(String productId);

  Future<Either<Failure, void>> removeFromFavorites(String productId);

  Future<Either<Failure, bool>> isFavorite(String productId);
}
