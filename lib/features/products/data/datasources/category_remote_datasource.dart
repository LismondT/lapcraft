import '../models/category_model.dart';

abstract class CategoryRemoteDatasource {
  Future<List<CategoryModel>> getCategories();
  Future<List<CategoryModel>> getCategoryTree();
  Future<CategoryModel> getCategory(String id);
  Future<List<CategoryModel>> getSubcategories(String parentId);
}