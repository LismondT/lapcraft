import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/favorites/data/datasources/remote/favorites_remote_datasource.dart';
import 'package:lapcraft/features/features.dart';

import '../../domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl extends FavoritesRepository {
  final FavoritesRemoteDatasource remoteDatasource;

  FavoritesRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, void>> addToFavorites(String productId) async {
    try {
      final response = await remoteDatasource.addToFavorites(productId);
      return response.fold((failure) {
        return Left(failure);
      }, (isFavorite) {
        return Right(null);
      });
    } on Exception catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getFavorites() async {
    try {
      final response = await remoteDatasource.getFavorites();
      return response.fold((failure) {
        return Left(failure);
      }, (favoritesData) {
        final products = favoritesData.map((data) => data.toEntity()).toList();
        return Right(products);
      });
    } on Exception catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String productId) async {
    try {
      final response = await remoteDatasource.removeFromFavorites(productId);
      return response.fold((failure) {
        return Left(failure);
      }, (isFavorite) {
        return Right(null);
      });
    } on Exception catch (e) {
      return Left(ServerFailure());
    }
  }
}
