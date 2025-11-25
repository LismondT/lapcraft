import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/features/products/data/datasources/category_debug_datasource.dart';
import 'package:lapcraft/features/products/data/repositories/category_repository_impl.dart';
import 'package:lapcraft/features/products/domain/usecases/get_categories.dart';
import 'package:lapcraft/features/products/domain/usecases/get_category_tree.dart';
import 'package:lapcraft/features/products/domain/usecases/get_subcategories.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_cubit.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_state.dart';

void main() {
  group('Интеграционный тест потока работы с категориями', () {
    late CategoryCubit cubit;

    setUp(() {
      final datasource = CategoryDebugDatasource(simulateLoading: false);
      final repository = CategoryRepositoryImpl(datasource);

      cubit = CategoryCubit(
        getCategories: GetCategories(repository),
        getCategoryTree: GetCategoryTree(repository),
        getSubcategories: GetSubcategories(repository),
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('полный поток навигации по категориям', () async {
      // Загрузка основных категорий
      await cubit.loadCategories();

      expect(cubit.state, isA<CategoriesLoaded>());
      final mainState = cubit.state as CategoriesLoaded;
      expect(mainState.categories.isNotEmpty, true);

      // Загрузка подкатегорий для первой категории
      final firstCategory = mainState.categories.first;
      await cubit.loadSubcategories(firstCategory.id);

      expect(cubit.state, isA<SubcategoriesLoaded>());
      final subState = cubit.state as SubcategoriesLoaded;
      expect(subState.categories.isNotEmpty, true);
      expect(subState.parentId, firstCategory.id);

      // Возврат к основным категориям
      cubit.returnToMainCategories();

      expect(cubit.state, isA<CategoriesLoaded>());
    });
  });
}
