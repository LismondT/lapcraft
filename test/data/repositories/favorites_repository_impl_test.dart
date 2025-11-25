import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:lapcraft/features/favorites/data/datasources/remote/favorites_remote_datasource.dart';
import 'package:lapcraft/features/features.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesRemoteDatasource extends Mock implements FavoritesRemoteDatasource {}

void main() {
  late FavoritesRepositoryImpl repository;
  late MockFavoritesRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = MockFavoritesRemoteDatasource();
    repository = FavoritesRepositoryImpl(remoteDatasource: mockRemoteDatasource);
  });

  group('FavoritesRepositoryImpl', () {
    const testProductId = '1';
    final testProductResponse = ProductResponse(
      id: testProductId,
      title: 'Test Product',
      price: 100.0,
      categoryName: 'Test Category',
      stockQuantity: 10,
      imageUrls: [],
    );
    final testProduct = testProductResponse.toEntity();

    setUp(() {
      // Регистрируем fallback значения
      registerFallbackValue(testProductId);
    });

    test('должен успешно добавлять товар в избранное', () async {
      // Arrange
      when(() => mockRemoteDatasource.addToFavorites(any()))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await repository.addToFavorites(testProductId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockRemoteDatasource.addToFavorites(testProductId)).called(1);
    });

    test('должен возвращать ошибку при неудачном добавлении в избранное', () async {
      // Arrange
      when(() => mockRemoteDatasource.addToFavorites(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result = await repository.addToFavorites(testProductId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
    });

    test('должен успешно возвращать список избранных товаров', () async {
      // Arrange
      when(() => mockRemoteDatasource.getFavorites())
          .thenAnswer((_) async => Right([testProductResponse]));

      // Act
      final result = await repository.getFavorites();

      // Assert
      result.fold((l) => fail('Не должно быть ошибки'), (r) {
        expect(r.length, 1);
        expect(r.first.id, testProductId);
      });
      verify(() => mockRemoteDatasource.getFavorites()).called(1);
    });

    test('должен возвращать пустой список при отсутствии избранных товаров', () async {
      // Arrange
      when(() => mockRemoteDatasource.getFavorites())
          .thenAnswer((_) async => Right([]));

      // Act
      final result = await repository.getFavorites();

      // Assert
      result.fold((l) => fail('Не должно быть ошибки'), (r) {
        expect(r, isEmpty);
      });
    });

    test('должен успешно удалять товар из избранного', () async {
      // Arrange
      when(() => mockRemoteDatasource.removeFromFavorites(any()))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await repository.removeFromFavorites(testProductId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockRemoteDatasource.removeFromFavorites(testProductId)).called(1);
    });

    test('должен обрабатывать исключения при работе с избранным', () async {
      // Arrange
      when(() => mockRemoteDatasource.getFavorites())
          .thenThrow(Exception('Test exception'));

      // Act
      final result = await repository.getFavorites();

      // Assert
      expect(result, isA<Left<Failure, List<Product>>>());
    });
  });
}