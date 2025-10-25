import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lapcraft/features/products/domain/entities/entities.dart';

part 'product_response.freezed.dart';
part 'product_response.g.dart';

@freezed
sealed class ProductResponse with _$ProductResponse {
  const factory ProductResponse({
    String? id,
    int? article,
    String? title,
    String? description,
    double? price,
    String? categoryId,
    String? categoryName,
    List<String>? imageUrls,
    int? stockQuantity,
  }) = _ProductResponse;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
}

extension ProductResponseToEntity on ProductResponse {
  Product toEntity() => Product(
        id: id ?? '',
        article: article ?? 0,
        title: title ?? 'Без названия',
        description: description ?? '',
        price: price ?? 0,
        categoryId: categoryId ?? '',
        categoryName: categoryName ?? 'Без категории',
        imageUrls: imageUrls ?? [],
        stockQuantity: stockQuantity ?? 0,
      );
}
