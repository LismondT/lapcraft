import 'package:dartz/dartz.dart';
import 'package:lapcraft/features/products/domain/repositories/category_repository.dart';

import '../../../../core/error/failure.dart';
import '../entities/category.dart';

class GetSubcategories {
  final CategoryRepository repository;

  GetSubcategories(this.repository);

  Future<Either<Failure, List<Category>>> call(String parentId) async {
    return await repository.getSubcategories(parentId);
  }
}
