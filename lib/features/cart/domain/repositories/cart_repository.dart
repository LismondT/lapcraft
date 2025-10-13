
import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getAll();
  Future<Either<Failure, void>> addToCart(String productId);
  Future<Either<Failure, void>> updateQuantity(String productId, int count);
  Future<Either<Failure, void>> removeFromCart(String productId);
  Future<Either<Failure, void>> clearCart();

  Future<double> calculateTotal();
  Future<int> getCartItemsCount();
}