import 'package:dartz/dartz.dart';
import 'package:lapcraft/features/products/domain/entities/category.dart';
import 'package:lapcraft/features/products/domain/repositories/category_repository.dart';

import '../../../../core/error/failure.dart';

class GetCategoryTree {
  final CategoryRepository repository;

  GetCategoryTree(this.repository);

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategoryTree();
  }
}
