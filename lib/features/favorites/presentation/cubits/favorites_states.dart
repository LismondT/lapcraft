import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../products/domain/entities/product.dart';

part 'favorites_states.freezed.dart';

@freezed
sealed class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = FavoritesStateInitial;

  const factory FavoritesState.loading() = FavoritesStateLoading;

  const factory FavoritesState.loaded(List<Product> products) =
      FavoritesStateLoaded;

  const factory FavoritesState.error(String message) = FavoritesStateError;

  const factory FavoritesState.empty() = FavoritesStateEmpty;
}
