import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_category_tree.dart';
import '../../domain/usecases/get_subcategories.dart';
import '../pages/categories_page.dart';
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

  List<Category>? _lastCategories;
  List<Category>? _lastCategoryTree;
  String? _lastParentId;
  List<Category>? _lastSubcategories;
  ViewMode _currentViewMode = ViewMode.grid;

  ViewMode get currentViewMode => _currentViewMode;

  Future<void> loadCategories() async {
    _currentViewMode = ViewMode.grid;

    if (_lastCategories != null) {
      emit(CategoryState.categoriesLoaded(_lastCategories!));
      return;
    }

    emit(CategoryState.loading());

    final result = await getCategories();

    result.fold(
      (failure) => emit(CategoryState.error(failure.toString())),
      (categories) => emit(CategoryState.categoriesLoaded(categories)),
    );
  }

  // Загрузка дерева категорий
  Future<void> loadCategoryTree() async {
    _currentViewMode = ViewMode.tree;

    if (_lastCategoryTree != null) {
      emit(CategoryState.categoryTreeLoaded(_lastCategoryTree!));
      return;
    }

    emit(CategoryState.loading());

    final result = await getCategoryTree();

    result.fold(
      (failure) => emit(CategoryState.error(failure.toString())),
      (categories) => emit(CategoryState.categoryTreeLoaded(categories)),
    );
  }

  // Загрузка подкатегорий
  Future<void> loadSubcategories(String parentId) async {
    if (_lastParentId == parentId && _lastSubcategories != null) {
      emit(CategoryState.subcategoriesLoaded(_lastSubcategories!, parentId));
      return;
    }

    emit(CategoryState.loading());

    final result = await getSubcategories(parentId);

    result.fold(
      (failure) => emit(CategoryState.error(failure.toString())),
      (categories) =>
          emit(CategoryState.subcategoriesLoaded(categories, parentId)),
    );
  }

  void returnToMainCategories() {
    if (_currentViewMode == ViewMode.grid) {
      if (_lastCategories != null) {
        emit(CategoryState.categoriesLoaded(_lastCategories!));
      } else {
        loadCategories();
      }
    } else {
      if (_lastCategoryTree != null) {
        emit(CategoryState.categoryTreeLoaded(_lastCategoryTree!));
      } else {
        loadCategoryTree();
      }
    }
  }

  void clearSubcategoriesCache() {
    _lastParentId = null;
    _lastSubcategories = null;
  }

  void clearCache() {
    _lastCategories = null;
    _lastCategoryTree = null;
    _lastParentId = null;
    _lastSubcategories = null;
  }
}
