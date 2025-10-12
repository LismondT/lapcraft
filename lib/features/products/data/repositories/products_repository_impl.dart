import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsDatasource _productsRemoteDatasource;

  const ProductsRepositoryImpl(this._productsRemoteDatasource);

  @override
  Future<Either<Failure, Product>> product(String id) async {
    final response = await _productsRemoteDatasource.product(id);

    return response.fold((failure) => Left(failure),
        (productResponse) => Right(productResponse.toEntity()));
  }

  @override
  Future<Either<Failure, Products>> products(int start, int size,
      {int? petId,
      int? categoryId,
      double? priceStart,
      double? priceEnd}) async {
    final response = await _productsRemoteDatasource.products(start, size);

    return response.fold((failure) => Left(failure), (productsResponse) {
      if (productsResponse.data?.isEmpty ?? true) {
        return Left(NoDataFailure());
      }
      return Right(productsResponse.toEntity());
    });
  }
}
