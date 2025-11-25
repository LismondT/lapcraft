import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

abstract class ProductsRepository {
  Future<Either<Failure, Product>> product(String id);

  Future<Either<Failure, Products>> products(
      {required int page,
      required int count,
      required String category,
      required Map<String, dynamic> filters});
}
