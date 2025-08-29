import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lapcraft/features/products/domain/entities/entities.dart';

part 'products_response.freezed.dart';
part 'products_response.g.dart';

@freezed
sealed class ProductsResponse with _$ProductsResponse {
  const factory ProductsResponse({
    List<ProductData>? data,
    int? currentPage,
    int? totalPages
  }) = _ProductsResponse;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => _$ProductsResponseFromJson(json);
}

@freezed
sealed class ProductData with _$ProductData {
  const factory ProductData({
    String? id,
    int? article,
    String? title,
    String? description,
    double? price,
    int? category,
    int? petCategory,
    List<String>? imageUrls,
    int? stockQuantity,
  }) = _ProductData;

  factory ProductData.fromJson(Map<String, dynamic> json) => _$ProductDataFromJson(json);
}

extension ProductsResponseToEntity on ProductsResponse {
  Products toEntity() => Products(
      products: data?.map(
              (data) => Product(
              id: data.id,
              article: data.article,
              title: data.title,
              description: data.description,
              price: data.price,
              category: data.category,
              petCategory: data.petCategory,
              imageUrls: data.imageUrls,
              stockQuantity: data.stockQuantity
          )
      ).toList(),
      currentPage: currentPage,
      totalPages: totalPages
  );
}