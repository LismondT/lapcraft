
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lapcraft/features/products/domain/entities/entities.dart';

part 'products.freezed.dart';

@freezed
sealed class Products with _$Products {
  const factory Products({
    List<Product>? products,
    int? currentPage,
    int? totalPages
  }) = _Products;
}

