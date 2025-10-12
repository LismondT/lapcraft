
import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

abstract class CartRepository {
  Future<Either<Failure, List<Product>>> getAll();
  Future<Either<Failure, void>> addToCart(String productId);
  Future<Either<Failure, void>> updateQuantity(String productId, int count);
  Future<Either<Failure, void>> removeFromCart(String productId);
  Future<Either<Failure, void>> clearCart();

  Future<double> calculateTotal();
  Future<int> getCartItemsCount();
}