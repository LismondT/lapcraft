import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Product>>> getFavorites();

  Future<Either<Failure, void>> addToFavorites(String productId);

  Future<Either<Failure, void>> removeFromFavorites(String productId);
}
