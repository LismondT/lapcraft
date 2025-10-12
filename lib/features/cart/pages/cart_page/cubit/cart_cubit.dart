import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/cart/domain/usecases/add_cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/get_cart_items.dart';
import 'package:lapcraft/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:lapcraft/features/cart/pages/cart_page/cubit/cart_cubit_states.dart';
import 'package:lapcraft/features/products/domain/entities/product.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._getCartItems, this._addCartItem, this._removeCartItem)
      : super(CartStateInitial());

  final GetCartItems _getCartItems;
  final AddCartItem _addCartItem;
  final RemoveCartItem _removeCartItem;

  List<Product> _products = [];

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
          _products = products;
          emit(CartStateSuccess(_products));
        }
      });
    } catch (e) {
      emit(CartStateFailure(e.toString()));
    }
  }

  void addToCart(String productId) async {
    emit(CartStateLoading());
    await _addCartItem(productId);
    loadCart();
  }

  void removeFromCart(String productId) async {
    emit(CartStateLoading());
    await _removeCartItem(productId);
    loadCart();
  }
}
