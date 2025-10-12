import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';

part 'cart.freezed.dart';

@freezed
sealed class Cart with _$Cart {
  const factory Cart({
    required List<CartItem> items,
    required double totalPrice,
    required int totalItems
  }) = _Cart;
}
