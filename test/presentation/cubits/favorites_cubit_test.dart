import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/favorites/domain/usecases/add_to_favorites.dart';
import 'package:lapcraft/features/favorites/domain/usecases/get_favorites.dart';
import 'package:lapcraft/features/favorites/domain/usecases/remove_from_favorites.dart';
import 'package:lapcraft/features/favorites/presentation/cubits/favorites_cubit.dart';
import 'package:lapcraft/features/favorites/presentation/cubits/favorites_states.dart';
import 'package:lapcraft/features/features.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFavorites extends Mock implements GetFavorites {}
class MockAddToFavorites extends Mock implements AddToFavorites {}
class MockRemoveFromFavorites extends Mock implements RemoveFromFavorites {}

void main() {
  late FavoritesCubit cubit;
  late MockGetFavorites mockGetFavorites;
  late MockAddToFavorites mockAddToFavorites;
  late MockRemoveFromFavorites mockRemoveFromFavorites;

  final testProducts = [
    Product(
      id: '1',
      title: 'Test Product 1',
      price: 100.0,
      categoryName: 'Test Category',
      stockQuantity: 10,
      imageUrls: [], article: 1, categoryId: '',
    ),
    Product(
      id: '2',
      title: 'Test Product 2',
      price: 200.0,
      categoryName: 'Test Category',
      stockQuantity: 5,
      imageUrls: [], article: 2, categoryId: '',
    ),
  ];

  setUp(() {
    mockGetFavorites = MockGetFavorites();
    mockAddToFavorites = MockAddToFavorites();
    mockRemoveFromFavorites = MockRemoveFromFavorites();

    cubit = FavoritesCubit(
      getFavorites: mockGetFavorites,
      addToFavorites: mockAddToFavorites,
      removeFromFavorites: mockRemoveFromFavorites,
    );

    // Регистрируем fallback значения
    registerFallbackValue('test_product_id');
  });

  tearDown(() {
    cubit.close();
  });

  group('FavoritesCubit', () {
    test('начальное состояние должно быть FavoritesState.initial', () {
      // Assert
      expect(cubit.state, const FavoritesState.initial());
    });

    blocTest<FavoritesCubit, FavoritesState>(
      'должен эмитить состояния loading и loaded при успешной загрузке избранного',
      build: () {
        when(() => mockGetFavorites())
            .thenAnswer((_) async => Right(testProducts));
        return cubit;
      },
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [
        const FavoritesState.loading(),
        FavoritesState.loaded(testProducts),
      ],
      verify: (_) {
        verify(() => mockGetFavorites()).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'должен эмитить состояния loading и empty при загрузке пустого списка',
      build: () {
        when(() => mockGetFavorites())
            .thenAnswer((_) async => Right([]));
        return cubit;
      },
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [
        const FavoritesState.loading(),
        const FavoritesState.empty(),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'должен эмитить состояния loading и error при ошибке загрузки',
      build: () {
        when(() => mockGetFavorites())
            .thenAnswer((_) async => Left(ServerFailure()));
        return cubit;
      },
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [
        const FavoritesState.loading(),
        predicate<FavoritesState>((state) =>
        state is FavoritesStateError &&
            state.message.isNotEmpty
        ),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'должен добавлять товар в избранное при toggleFavorite если товара нет в избранном',
      build: () {
        when(() => mockGetFavorites())
            .thenAnswer((_) async => Right(testProducts));
        when(() => mockAddToFavorites(any()))
            .thenAnswer((_) async => Right(null));
        return cubit;
      },
      seed: () => FavoritesState.loaded(testProducts),
      act: (cubit) => cubit.toggleFavorite('3'),
      verify: (_) {
        verify(() => mockAddToFavorites('3')).called(1);
        verify(() => mockGetFavorites()).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'должен удалять товар из избранного при toggleFavorite если товар уже в избранном',
      build: () {
        when(() => mockGetFavorites())
            .thenAnswer((_) async => Right(testProducts));
        when(() => mockRemoveFromFavorites(any()))
            .thenAnswer((_) async => Right(null));
        return cubit;
      },
      seed: () => FavoritesState.loaded(testProducts),
      act: (cubit) => cubit.toggleFavorite('1'),
      verify: (_) {
        verify(() => mockRemoveFromFavorites('1')).called(1);
        verify(() => mockGetFavorites()).called(1);
      },
    );

    test('не должен выполнять toggleFavorite если состояние не loaded', () async {
      // Arrange
      cubit.emit(const FavoritesState.loading());

      // Act
      await cubit.toggleFavorite('1');

      // Assert
      verifyNever(() => mockAddToFavorites(any()));
      verifyNever(() => mockRemoveFromFavorites(any()));
    });
  });
}