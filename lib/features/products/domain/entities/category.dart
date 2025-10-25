// ignore: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
sealed class Category with _$Category {
  const factory Category(
      {required String id,
      required String name,
      String? description,
      String? parentId,
      String? icon,
      String? color,
      @Default(0) int productCount,
      @Default(0) int childrenCount,
      @Default(null) List<Category>? children}) = _Category;
}

extension CategoryExtension on Category {
  bool get hasChildren => childrenCount > 0;

  String get displayName => name;

  bool get hasParent => parentId != null;
}
