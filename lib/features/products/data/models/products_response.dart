import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/domain/entities/entities.dart';

part 'products_response.freezed.dart';
part 'products_response.g.dart';

@freezed
sealed class ProductsResponse with _$ProductsResponse {
  const factory ProductsResponse(
      {
        List<ProductResponse>? products,
      int? page,
      int? count,
      int? total}) = _ProductsResponse;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);
}

extension ProductsResponseToEntity on ProductsResponse {
  Products toEntity() => Products(
      products: products
          ?.map((data) => data.toEntity())
          .toList() ?? [],
      page: page ?? 1,
      count: count ?? 0,
      total: total ?? 0
  );
}
