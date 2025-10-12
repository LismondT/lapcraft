import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    required String productId,
    String? imageUrl,
    required String title,
    required String description,
    required double price,
    required int count,
  }) = _CartItem;
}
