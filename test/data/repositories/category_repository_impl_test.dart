import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/data/datasources/category_remote_datasource.dart';
import 'package:lapcraft/features/products/data/models/category_model.dart';
import 'package:lapcraft/features/products/data/repositories/category_repository_impl.dart';
import 'package:lapcraft/features/products/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRemoteDatasource extends Mock
    implements CategoryRemoteDatasource {}

void main() {
  late CategoryRepositoryImpl repository;
  late MockCategoryRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockCategoryRemoteDatasource();
    repository = CategoryRepositoryImpl(mockDatasource);
  });

  group('Получение категорий', () {
    final mockCategories = [
      CategoryModel(id: '1', name: 'Категория 1'),
      CategoryModel(id: '2', name: 'Категория 2'),
    ];

    test('должен возвращать категории при успешном запросе к источнику данных', () async {
      // Arrange
      when(() => mockDatasource.getCategories())
          .thenAnswer((_) async => mockCategories);

      // Act
      final result = await repository.getCategories();

      // Assert
      expect(result, isA<Right<Failure, List<Category>>>());
      result.fold(
            (failure) => fail('Не должен возвращать ошибку'),
            (categories) {
          expect(categories.length, 2);
          expect(categories.first.id, '1');
          expect(categories.first.name, 'Категория 1');
        },
      );
      verify(() => mockDatasource.getCategories()).called(1);
    });

    test('должен возвращать ошибку сервера при исключении в источнике данных', () async {
      // Arrange
      when(() => mockDatasource.getCategories()).thenThrow(Exception());

      // Act
      final result = await repository.getCategories();

      // Assert
      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (categories) => fail('Должен возвращать ошибку'),
      );
    });
  });

  group('Получение категории по ID', () {
    final mockCategory = CategoryModel(id: '1', name: 'Тестовая категория');

    test('должен возвращать категорию при успешном запросе к источнику данных', () async {
      // Arrange
      when(() => mockDatasource.getCategory('1'))
          .thenAnswer((_) async => mockCategory);

      // Act
      final result = await repository.getCategory('1');

      // Assert
      expect(result, isA<Right<Failure, Category>>());
      result.fold(
            (failure) => fail('Не должен возвращать ошибку'),
            (category) {
          expect(category.id, '1');
          expect(category.name, 'Тестовая категория');
        },
      );
      verify(() => mockDatasource.getCategory('1')).called(1);
    });

    test('должен возвращать ошибку парсинга при исключении формата', () async {
      // Arrange
      when(() => mockDatasource.getCategory('1'))
          .thenThrow(FormatException('Неверный JSON'));

      // Act
      final result = await repository.getCategory('1');

      // Assert
      expect(result, isA<Left<Failure, Category>>());
      result.fold(
            (failure) {
          expect(failure, isA<ParsingFailure>());
          expect((failure as ParsingFailure).message, 'Неверный JSON');
        },
            (category) => fail('Должен возвращать ошибку'),
      );
    });
  });
}