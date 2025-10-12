import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';

import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Category>>> getCategoryTree();

  Future<Either<Failure, Category>> getCategory(String id);

  Future<Either<Failure, List<Category>>> getSubcategories(String parentId);
}
