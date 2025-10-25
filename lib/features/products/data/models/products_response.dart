import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/domain/entities/entities.dart';

part 'products_response.freezed.dart';
part 'products_response.g.dart';

@freezed
sealed class ProductsResponse with _$ProductsResponse {
  const factory ProductsResponse(
      {List<ProductResponse>? data,
      int? currentPage,
      int? totalPages}) = _ProductsResponse;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);
}

extension ProductsResponseToEntity on ProductsResponse {
  Products toEntity() => Products(
      products: data
          ?.map((data) => data.toEntity())
          .toList(),
      currentPage: currentPage,
      totalPages: totalPages);
}
