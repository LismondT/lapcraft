import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category.dart';
part 'category_state.freezed.dart';

@freezed
sealed class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = CategoryInitial;

  const factory CategoryState.loading() = CategoryLoading;

  const factory CategoryState.categoriesLoaded(List<Category> categories) =
      CategoriesLoaded;

  const factory CategoryState.categoryTreeLoaded(List<Category> categories) =
      CategoryTreeLoaded;

  const factory CategoryState.subcategoriesLoaded(
      List<Category> categories, String parentId) = SubcategoriesLoaded;

  const factory CategoryState.error(String message) = CategoryError;
}
