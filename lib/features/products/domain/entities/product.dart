
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
sealed class Product with _$Product {
  const factory Product({
    String? id,
    int? article,
    String? title,
    String? description,
    double? price,
    int? category,
    int? petCategory,
    List<String>? imageUrls,
    int? stockQuantity
  }) = _Product;
}