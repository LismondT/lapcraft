import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? parentId,
    String? imageUrl,
    String? icon,
    String? color,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    @Default(0) int productCount,
    @Default(null) List<CategoryModel>? children,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

// Конвертация между Entity и Model
extension CategoryModelExtension on CategoryModel {
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      slug: slug,
      description: description,
      parentId: parentId,
      imageUrl: imageUrl,
      icon: icon,
      color: color,
      sortOrder: sortOrder,
      isActive: isActive,
      productCount: productCount,
      children: children?.map((child) => child.toEntity()).toList(),
    );
  }
}

extension CategoryExtension on Category {
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      slug: slug,
      description: description,
      parentId: parentId,
      imageUrl: imageUrl,
      icon: icon,
      color: color,
      sortOrder: sortOrder,
      isActive: isActive,
      productCount: productCount,
      children: children?.map((child) => child.toModel()).toList(),
    );
  }
}