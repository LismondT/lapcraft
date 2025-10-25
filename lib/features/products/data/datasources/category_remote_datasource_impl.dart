import 'dart:convert';

import 'package:lapcraft/core/api/api_client.dart';
import 'package:lapcraft/features/products/data/datasources/category_remote_datasource.dart';
import 'package:lapcraft/features/products/data/models/category_model.dart';

import '../../../../core/api/api.dart';

class CategoryRemoteDatasourceImpl extends CategoryRemoteDatasource {
  final ApiClient client;

  CategoryRemoteDatasourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.get(Api.category.withItem('root'));

    if (response.statusCode == 200) {
      final categories = (response.data as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  @override
  Future<CategoryModel> getCategory(String id) async {
    final response = await client.get(Api.category.withItem(id));

    if (response.statusCode == 200) {
      final category = CategoryModel.fromJson(response.data);
      return category;
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoryTree() async {
    final response = await client.get(Api.category.withItem('tree'));

    if (response.statusCode == 200) {
      final categories = (response.data as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  @override
  Future<List<CategoryModel>> getSubcategories(String parentId) async {
    final response =
        await client.get('${Api.category.withItem(parentId)}/children');

    if (response.statusCode == 200) {
      final categories = (response.data as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }
}
