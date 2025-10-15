import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/features/favorites/domain/usecases/add_to_favorites.dart';
import 'package:lapcraft/features/favorites/domain/usecases/get_favorites.dart';
import 'package:lapcraft/features/favorites/domain/usecases/is_favorite.dart';
import 'package:lapcraft/features/favorites/domain/usecases/remove_from_favorites.dart';
import 'package:lapcraft/features/favorites/presentation/cubits/favorites_states.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavorites;
  final AddToFavorites addToFavorites;
  final RemoveFromFavorites removeFromFavorites;
  final IsFavorite isFavorite;

  FavoritesCubit({
    required this.getFavorites,
    required this.addToFavorites,
    required this.removeFromFavorites,
    required this.isFavorite,
  }) : super(const FavoritesState.initial());

  Future<void> loadFavorites() async {
    emit(const FavoritesState.loading());

    final result = await getFavorites();
    result.fold((failure) => emit(FavoritesState.error(failure.toString())),
        (favorites) => emit(FavoritesState.loaded(favorites)));
  }

  Future<void> toggleFavorite(String productId) async {
    final currentState = state;
    if (currentState is FavoritesStateLoaded) {
      final isCurrentlyFavorite =
          currentState.products.any((product) => product.id == productId);

      if (isCurrentlyFavorite) {
        await removeFromFavorites(productId);
      } else {
        await addToFavorites(productId);
      }

      await loadFavorites();
    }
  }
}
