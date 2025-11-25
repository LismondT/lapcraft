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
  Future<Either<Failure, Products>> products(
      {required int page,
      required int count,
      required String category,
      required Map<String, dynamic> filters}) async {
    try {
      final response = await _productsRemoteDatasource.products(
        page: page,
        count: count,
        category: category,
        filters: filters,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
