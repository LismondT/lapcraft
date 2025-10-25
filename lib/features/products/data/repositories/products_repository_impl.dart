import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsDatasource _productsRemoteDatasource;

  const ProductsRepositoryImpl(this._productsRemoteDatasource);

  @override
  Future<Either<Failure, Product>> product(String id) async {
    try {
      final response = await _productsRemoteDatasource.product(id);
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Products>> products(int start, int size,
      {String? categoryId, double? priceStart, double? priceEnd}) async {
    try {
      final response = await _productsRemoteDatasource.products(start, size,
          categoryId: categoryId, priceStart: priceStart, priceEnd: priceEnd);
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
