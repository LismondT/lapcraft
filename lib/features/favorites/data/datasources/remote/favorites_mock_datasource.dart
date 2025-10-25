import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/favorites/data/datasources/remote/favorites_remote_datasource.dart';
import 'package:lapcraft/features/features.dart';

class FavoritesMockDatasource extends FavoritesRemoteDatasource {
  final ProductsDatasource productsDatasource;
  final List<ProductResponse> _favorites = [];

  FavoritesMockDatasource({required this.productsDatasource});

  @override
  Future<Either<Failure, void>> addToFavorites(String productId) async {
    try {
      final response = await productsDatasource.product(productId);
      _favorites.add(response);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductResponse>>> getFavorites() async {
    return Right(_favorites);
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String productId) async {
    _favorites.removeWhere((x) => x.id == productId);
    return Right(null);
  }
}
