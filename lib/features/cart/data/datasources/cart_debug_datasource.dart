import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';
import 'package:lapcraft/features/features.dart';

import 'cart_datasource.dart';

class CartDebugDatasourceImpl extends CartDatasource {
  final ProductsRepository _productsRepository;
  final List<CartItem> _cartItems = [];

  CartDebugDatasourceImpl(this._productsRepository);

  @override
  Future<Either<Failure, void>> add(String productId) async {
    final response = await _productsRepository.product(productId);
    response.fold((failure) {
      return Left(ServerFailure(''));
    }, (data) {
      _cartItems.add(CartItem(
        productId: data.id ?? '',
        title: data.title ?? '',
        description: data.description ?? '',
        imageUrl: data.imageUrls?.first,
        price: data.price ?? 0,
        count: 1
      ));
      return Right(null);
    });

    return Right(null);
  }

  @override
  Future<Either<Failure, List<CartItem>>> getAll() async {
    return Right(_cartItems);
  }

  @override
  Future<Either<Failure, void>> remove(String productId) async {
    _cartItems.removeWhere((x) => x.productId == productId);
    return Right(null);
  }
  @override
  Future<Either<Failure, void>> setCount(String productId, int count) async {
    try {
      // Находим индекс элемента в корзине
      final index = _cartItems.indexWhere((item) => item.productId == productId);

      if (index != -1) {
        if (count <= 0) {
          // Если количество <= 0, удаляем товар из корзины
          _cartItems.removeAt(index);
        } else {
          // Обновляем количество товара
          final updatedItem = _cartItems[index].copyWith(count: count);
          _cartItems[index] = updatedItem;
        }
        return Right(null);
      } else {
        // Товар не найден в корзине
        return Left(NotFoundFailure('Product with id $productId not found in cart'));
      }
    } catch (e) {
      // Обработка ошибок
      return Left(ServerFailure('Failed to update product count: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clear() async {
    _cartItems.clear();
    return Right(null);
  }
}
