import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/features.dart';

import 'cart_datasource.dart';

class CartDebugDatasourceImpl extends CartDatasource {
  final ProductsRepository _productsRepository;
  final List<Product> _products = [];

  CartDebugDatasourceImpl(this._productsRepository);

  @override
  Future<Either<Failure, void>> add(String product_id) async {
    final response = await _productsRepository.product(product_id);
    response.fold((failure) {
      return Left(ServerFailure(''));
    }, (data) {
      _products.add(data);
      return Right(null);
    });

    return Right(null);
  }

  @override
  Future<Either<Failure, List<Product>>> get_all() async {
    return Right(_products);
  }

  @override
  Future<Either<Failure, void>> remove(String product_id) async {
    _products.removeWhere((x) => x.id == product_id);
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> set_count(String product_id, int count) {
    // TODO: implement set_count
    throw UnimplementedError();
  }
}
