import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/features/favorites/data/datasources/remote/favorites_mock_datasource.dart';
import 'package:lapcraft/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:lapcraft/features/favorites/domain/usecases/add_to_favorites.dart';
import 'package:lapcraft/features/favorites/domain/usecases/get_favorites.dart';
import 'package:lapcraft/features/favorites/domain/usecases/remove_from_favorites.dart';
import 'package:lapcraft/features/favorites/presentation/cubits/favorites_cubit.dart';
import 'package:lapcraft/features/favorites/presentation/cubits/favorites_states.dart';
import 'package:lapcraft/features/products/products.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRemoteDatasource extends Mock implements ProductsDatasource {}

void main() {
  group('Favorites Feature Integration Test', () {
    test('полная интеграция: от datasource до cubit', () async {
      // Arrange
      final productsDatasource = MockProductsRemoteDatasource();
      final favoritesDatasource =
          FavoritesMockDatasource(productsDatasource: productsDatasource);
      final repository =
          FavoritesRepositoryImpl(remoteDatasource: favoritesDatasource);

      final getFavorites = GetFavorites(repository);
      final addToFavorites = AddToFavorites(repository);
      final removeFromFavorites = RemoveFromFavorites(repository);

      final cubit = FavoritesCubit(
        getFavorites: getFavorites,
        addToFavorites: addToFavorites,
        removeFromFavorites: removeFromFavorites,
      );

      // Act & Assert
      // Проверяем начальное состояние
      expect(cubit.state, const FavoritesState.initial());

      // Добавляем товар в избранное
      await addToFavorites('1');

      // Загружаем избранное
      cubit.loadFavorites();
      await Future.delayed(const Duration(milliseconds: 100));

      // Проверяем, что товар добавлен
      expect(cubit.state, isA<FavoritesStateLoaded>());
      if (cubit.state is FavoritesStateLoaded) {
        final loadedState = cubit.state as FavoritesStateLoaded;
        expect(loadedState.products.length, 1);
        expect(loadedState.products.first.id, '1');
      }

      // Удаляем товар из избранного
      await removeFromFavorites('1');

      // Снова загружаем избранное
      cubit.loadFavorites();
      await Future.delayed(const Duration(milliseconds: 100));

      // Проверяем, что список пуст
      expect(cubit.state, const FavoritesState.empty());
    });
  });
}
