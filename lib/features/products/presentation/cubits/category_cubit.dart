import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_category_tree.dart';
import '../../domain/usecases/get_subcategories.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories getCategories;
  final GetCategoryTree getCategoryTree;
  final GetSubcategories getSubcategories;

  CategoryCubit({
    required this.getCategories,
    required this.getCategoryTree,
    required this.getSubcategories,
  }) : super(CategoryState.initial());

  Future<void> loadCategories() async {
    emit(CategoryState.loading());

    final result = await getCategories();

    result.fold(
      (failure) => emit(CategoryState.error(failure.toString())),
      (categories) => emit(CategoryState.categoriesLoaded(categories)),
    );
  }

  // Загрузка дерева категорий
  Future<void> loadCategoryTree() async {
    emit(CategoryState.loading());

    final result = await getCategoryTree();

    result.fold(
      (failure) => emit(CategoryState.error(failure.toString())),
      (categories) => emit(CategoryState.categoryTreeLoaded(categories)),
    );
  }

  // Загрузка подкатегорий
  Future<void> loadSubcategories(String parentId) async {
    emit(CategoryState.loading());

    final result = await getSubcategories(parentId);

    result.fold(
      (failure) => emit(CategoryState.error(failure.toString())),
      (categories) =>
          emit(CategoryState.subcategoriesLoaded(categories, parentId)),
    );
  }
}
