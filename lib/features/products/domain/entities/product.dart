import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
sealed class Product with _$Product {
  const factory Product({
    required String id,
    required int article,
    required String title,
    required double price,
    required String category,
    required List<String> imageUrls,
    required int stockQuantity,
    @Default('') String description,
    @Default(false) bool isFavorite
  }) = _Product;
}