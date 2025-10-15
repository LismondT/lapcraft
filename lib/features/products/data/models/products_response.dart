import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lapcraft/features/products/domain/entities/entities.dart';

part 'products_response.freezed.dart';
part 'products_response.g.dart';

@freezed
sealed class ProductsResponse with _$ProductsResponse {
  const factory ProductsResponse(
      {List<ProductData>? data,
      int? currentPage,
      int? totalPages}) = _ProductsResponse;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);
}

@freezed
sealed class ProductData with _$ProductData {
  const factory ProductData(
      {String? id,
      int? article,
      String? title,
      String? description,
      double? price,
      String? categoryId,
      String? categoryName,
      List<String>? imageUrls,
      int? stockQuantity,
      bool? isFavorite}) = _ProductData;

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);
}

extension ProductsResponseToEntity on ProductsResponse {
  Products toEntity() => Products(
      products: data
          ?.map((data) => Product(
              id: data.id ?? '',
              article: data.article ?? 0,
              title: data.title ?? 'Без названия',
              description: data.description ?? '',
              price: data.price ?? 0,
              categoryId: data.categoryId ?? '',
              categoryName: data.categoryName ?? 'Без категории',
              imageUrls: data.imageUrls ?? [],
              stockQuantity: data.stockQuantity ?? 0,
              isFavorite: data.isFavorite ?? false))
          .toList(),
      currentPage: currentPage,
      totalPages: totalPages);
}
