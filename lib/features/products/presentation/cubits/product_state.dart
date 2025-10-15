import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lapcraft/features/features.dart';

part 'product_state.freezed.dart';

@freezed
sealed class ProductState with _$ProductState {
  const factory ProductState.initial() = ProductInitial;

  const factory ProductState.loading() = ProductLoading;

  const factory ProductState.loaded(Product product) = ProductLoaded;

  const factory ProductState.error(String message) = ProductError;
}
