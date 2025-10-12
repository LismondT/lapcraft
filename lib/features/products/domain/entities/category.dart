import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
sealed class Category with _$Category {
  const factory Category(
      {required String id,
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
      @Default(null) List<Category>? children}) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

extension CategoryExtension on Category {
  bool get hasChildren => children != null && children!.isNotEmpty;

  String get displayName => name;

  bool get hasParent => parentId != null;
}
