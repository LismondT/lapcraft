import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    String? description,
    String? parentId,
    String? icon,
    String? color,
    @JsonKey(name: 'product_count') @Default(0) int productCount,
    @JsonKey(name: 'children_count') @Default(0) int childrenCount,
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
      description: description,
      parentId: parentId,
      icon: icon,
      color: color,
      productCount: productCount,
      childrenCount: childrenCount,
      children: children?.map((child) => child.toEntity()).toList(),
    );
  }
}

extension CategoryExtension on Category {
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      description: description,
      parentId: parentId,
      icon: icon,
      color: color,
      productCount: productCount,
      children: children?.map((child) => child.toModel()).toList(),
    );
  }
}
