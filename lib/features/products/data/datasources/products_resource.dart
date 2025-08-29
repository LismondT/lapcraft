import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

abstract class ProductsDatasource {
  Future<Either<Failure, ProductsResponse>> products(int page, int pageSize);

  Future<Either<Failure, ProductResponse>> product(String id);
}
