import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/products/data/datasources/category_remote_datasource.dart';
import 'package:lapcraft/features/products/domain/entities/category.dart';
import 'package:lapcraft/features/products/domain/repositories/category_repository.dart';

import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource datasource;

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    return await _execute(() => datasource.getCategories());
  }

  @override
  Future<Either<Failure, Category>> getCategory(String id) async {
    return await _executeSingle(() => datasource.getCategory(id));
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoryTree() async {
    return await _execute(() => datasource.getCategoryTree());
  }

  @override
  Future<Either<Failure, List<Category>>> getSubcategories(
      String parentId) async {
    return await _execute(() => datasource.getSubcategories(parentId));
  }

  // Общий метод для операций возвращающих списки
  Future<Either<Failure, List<Category>>> _execute(
    Future<List<CategoryModel>> Function() operation,
  ) async {
    try {
      final models = await operation();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on FormatException catch (e) {
      return Left(ParsingFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // Общий метод для операций возвращающих единичный объект
  Future<Either<Failure, Category>> _executeSingle(
    Future<CategoryModel> Function() operation,
  ) async {
    try {
      final model = await operation();
      return Right(model.toEntity());
    } on FormatException catch (e) {
      return Left(ParsingFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
