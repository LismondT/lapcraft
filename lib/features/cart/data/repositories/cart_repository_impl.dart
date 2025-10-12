import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/cart/data/datasources/cart_datasource.dart';
import 'package:lapcraft/features/cart/domain/repositories/cart_repository.dart';
import 'package:lapcraft/features/products/domain/entities/product.dart';

class CartRepositoryImpl extends CartRepository {
  final CartDatasource _datasource;

  CartRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, void>> addToCart(String productId) async {
    await _datasource.add(productId);
    return Right(null);
  }

  @override
  Future<Either<Failure, List<Product>>> getAll() async {
    final cart_items = await _datasource.get_all();
    return cart_items;
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String productId) async {
    await _datasource.remove(productId);
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> updateQuantity(String productId, int count) {
    // TODO: implement set_count
    throw UnimplementedError();
  }

  @override
  Future<double> calculateTotal() {
    // TODO: implement calculateTotal
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<int> getCartItemsCount() {
    // TODO: implement getCartItemsCount
    throw UnimplementedError();
  }
}
