import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/add_cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/get_cart_items.dart';
import 'package:lapcraft/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/update_cart_item_quantity.dart';

import '../../domain/usecases/clear_cart.dart';
import 'cart_cubit_states.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._getCartItems, this._addCartItem, this._removeCartItem,
      this._updateCartItemQuantity, this._clearCart)
      : super(CartStateInitial());

  final GetCartItems _getCartItems;
  final AddCartItem _addCartItem;
  final RemoveCartItem _removeCartItem;
  final UpdateCartItemQuantity _updateCartItemQuantity;
  final ClearCart _clearCart;

  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  double get totalAmount {
    return _cartItems.fold<double>(0, (sum, product) {
      final quantity = product.count ?? 1;
      return sum + (product.price ?? 0) * quantity;
    });
  }

  int get totalItems {
    return _cartItems.fold<int>(0, (sum, product) {
      return sum + (product.count ?? 1);
    });
  }

  Future<void> loadCart() async {
    emit(CartStateLoading());
    try {
      final response = await _getCartItems(NoParams());

      response.fold((failure) {
        emit(CartStateFailure(failure.toString()));
      }, (products) {
        if (products.isEmpty) {
          emit(CartStateEmpty());
        } else {
          _cartItems = products;
          emit(CartStateSuccess(_cartItems));
        }
      });
    } catch (e) {
      emit(CartStateFailure(e.toString()));
    }
  }

  Future<void> addToCart(String productId) async {
    try {
      final response = await _addCartItem(productId);

      response.fold((failure) {
        emit(CartStateFailure(failure.toString()));
      }, (_) {
        loadCart();
      });
    } catch (e) {
      emit(CartStateFailure(e.toString()));
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final response = await _removeCartItem(productId);

      response.fold((failure) {
        emit(CartStateFailure(failure.toString()));
      }, (_) {
        loadCart();
      });
    } catch (e) {
      emit(CartStateFailure(e.toString()));
    }
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity < 0) return;

    try {
      final response = await _updateCartItemQuantity(productId, newQuantity);

      response.fold((failure) {
        emit(CartStateFailure(failure.toString()));
      }, (_) {
        // Обновляем локальное состояние без полной перезагрузки
        _updateLocalQuantity(productId, newQuantity);
        emit(CartStateSuccess(_cartItems));
      });
    } catch (e) {
      emit(CartStateFailure(e.toString()));
    }
  }

  // Увеличить количество товара на 1
  Future<void> incrementQuantity(String productId) async {
    final product = _cartItems.firstWhere(
      (p) => p.productId == productId,
      orElse: () => throw Exception('Product not found in cart'),
    );

    final currentQuantity = product.count ?? 1;
    await updateQuantity(productId, currentQuantity + 1);
  }

  // Уменьшить количество товара на 1
  Future<void> decrementQuantity(String productId) async {
    final product = _cartItems.firstWhere(
      (p) => p.productId == productId,
      orElse: () => throw Exception('Product not found in cart'),
    );

    final currentQuantity = product.count ?? 1;

    if (currentQuantity > 1) {
      await updateQuantity(productId, currentQuantity - 1);
    } else {
      await removeFromCart(productId);
    }
  }

  // Очистить всю корзину
  Future<void> clearCart() async {
    try {
      final response = await _clearCart();

      response.fold((failure) {
        emit(CartStateFailure(failure.toString()));
      }, (_) {
        _cartItems.clear();
        emit(CartStateEmpty());
      });
    } catch (e) {
      emit(CartStateFailure(e.toString()));
    }
  }

  // Получить количество конкретного товара
  int getProductQuantity(String productId) {
    try {
      final product = _cartItems.firstWhere((p) => p.productId == productId);
      return product.count ?? 1;
    } catch (e) {
      return 0;
    }
  }

  // Проверить, есть ли товар в корзине
  bool isProductInCart(String productId) {
    return _cartItems.any((product) => product.productId == productId);
  }

  // Получить общую стоимость конкретного товара
  double getProductTotal(String productId) {
    try {
      final product = _cartItems.firstWhere((p) => p.productId == productId);
      final quantity = product.count ?? 1;
      return (product.price ?? 0) * quantity;
    } catch (e) {
      return 0;
    }
  }

  // Обновить локальное состояние количества (без вызова API)
  void _updateLocalQuantity(String productId, int newQuantity) {
    final index = _cartItems.indexWhere((p) => p.productId == productId);
    if (index != -1) {
      final updatedProduct = _cartItems[index].copyWith(count: newQuantity);
      _cartItems[index] = updatedProduct;
    }
  }

  // Сбросить состояние корзины
  void reset() {
    _cartItems.clear();
    emit(CartStateInitial());
  }
}
