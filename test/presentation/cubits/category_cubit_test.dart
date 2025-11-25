import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/products/domain/entities/category.dart';
import 'package:lapcraft/features/products/domain/usecases/get_categories.dart';
import 'package:lapcraft/features/products/domain/usecases/get_category_tree.dart';
import 'package:lapcraft/features/products/domain/usecases/get_subcategories.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_cubit.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCategories extends Mock implements GetCategories {}

class MockGetCategoryTree extends Mock implements GetCategoryTree {}

class MockGetSubcategories extends Mock implements GetSubcategories {}

void main() {
  late CategoryCubit cubit;
  late MockGetCategories mockGetCategories;
  late MockGetCategoryTree mockGetCategoryTree;
  late MockGetSubcategories mockGetSubcategories;

  final categories = [
    Category(id: '1', name: 'Категория 1'),
    Category(id: '2', name: 'Категория 2'),
  ];

  setUp(() {
    mockGetCategories = MockGetCategories();
    mockGetCategoryTree = MockGetCategoryTree();
    mockGetSubcategories = MockGetSubcategories();

    cubit = CategoryCubit(
      getCategories: mockGetCategories,
      getCategoryTree: mockGetCategoryTree,
      getSubcategories: mockGetSubcategories,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('Загрузка категорий', () {
    test('должен emit состояние загрузки затем загруженные категории при успехе', () async {
      // Arrange
      when(() => mockGetCategories())
          .thenAnswer((_) async => Right(categories));

      // Act
      final expectedStates = [
        CategoryState.loading(),
        CategoryState.categoriesLoaded(categories),
      ];

      // Assert
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      cubit.loadCategories();
    });

    test('должен emit состояние загрузки затем ошибку при неудаче', () async {
      // Arrange
      when(() => mockGetCategories())
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final expectedStates = [
        CategoryState.loading(),
        isA<CategoryError>(),
      ];

      // Assert
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      cubit.loadCategories();
    });

    test('должен использовать кэшированные категории когда они доступны', () async {
      // Arrange - первая загрузка
      when(() => mockGetCategories())
          .thenAnswer((_) async => Right(categories));
      await cubit.loadCategories();

      // Act & Assert - вторая загрузка должна использовать кэш
      cubit.loadCategories();

      // Не должен вызывать usecase снова
      verify(() => mockGetCategories()).called(1);
    });
  });

  group('Загрузка подкатегорий', () {
    final subcategories = [
      Category(id: '1-1', name: 'Подкатегория 1', parentId: '1'),
      Category(id: '1-2', name: 'Подкатегория 2', parentId: '1'),
    ];

    test('должен emit состояние загрузки затем загруженные подкатегории при успехе', () async {
      // Arrange
      when(() => mockGetSubcategories('1'))
          .thenAnswer((_) async => Right(subcategories));

      // Act
      final expectedStates = [
        CategoryState.loading(),
        CategoryState.subcategoriesLoaded(subcategories, '1'),
      ];

      // Assert
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      cubit.loadSubcategories('1');
    });

    test('должен использовать кэшированные подкатегории при одинаковом parentId', () async {
      // Arrange - первая загрузка
      when(() => mockGetSubcategories('1'))
          .thenAnswer((_) async => Right(subcategories));
      await cubit.loadSubcategories('1');

      // Act & Assert - вторая загрузка с тем же parentId должна использовать кэш
      cubit.loadSubcategories('1');

      verify(() => mockGetSubcategories('1')).called(1);
    });
  });

  test('очистка кэша должна очищать все кэшированные данные', () async {
    // Arrange
    when(() => mockGetCategories()).thenAnswer((_) async => Right(categories));
    await cubit.loadCategories();

    // Act
    cubit.clearCache();

    // Assert - следующая загрузка должна снова вызвать usecase
    await cubit.loadCategories();
    verify(() => mockGetCategories()).called(2);
  });
}