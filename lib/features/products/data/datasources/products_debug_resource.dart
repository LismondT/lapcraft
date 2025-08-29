import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/features.dart';

class ProductsDebugDatasourceImpl implements ProductsDatasource {
  final List<ProductData> _catalog = [];
  final List<String> _images = [
    'https://cdn.myanimelist.net/s/common/uploaded_files/1457954629-8e5311661dd9410b98e2971ffdc21df6.jpeg',
    'https://cdn.myanimelist.net/s/common/uploaded_files/1457954650-04a7655ca93df4b49e837c65f5aa6646.jpeg',
    'https://cdn.myanimelist.net/s/common/uploaded_files/1457954646-328e0b58faa5c5b8888f6f9be0533dd5.jpeg',
    'https://cdn.myanimelist.net/s/common/uploaded_files/1457954643-dd4c29919a682cff1b975046c29e4d6c.jpeg'
  ];

  ProductsDebugDatasourceImpl(int itemsCount) {
    final random = Random();

    for (int i = 0; i < itemsCount; i++) {
      final coverImage = _images[random.nextInt(_images.length)];

      final product = ProductData(
          id: i.toString(),
          article: i,
          title: 'Предмет $i',
          description: 'Описание крутое вообще ладно да давай пока',
          price: random.nextInt(20000).toDouble(),
          imageUrls: [coverImage],
          stockQuantity: random.nextInt(10));
      _catalog.add(product);
    }
  }

  @override
  Future<Either<Failure, ProductResponse>> product(String id) async {
    final productData = _catalog.firstWhere((x) => x.id == id);
    final response = ProductResponse(
        id: productData.id,
        article: productData.article,
        title: productData.title,
        description: productData.description,
        price: productData.price);
    return Right(response);
  }

  @override
  Future<Either<Failure, ProductsResponse>> products(
      int page, int pageSize) async {
    final start = page * pageSize;
    final end = start + pageSize;
    final products = _catalog.getRange(start, end);
    final response = ProductsResponse(
        data: products.toList(),
        currentPage: page,
        totalPages: (_catalog.length / pageSize).toInt());
    return Right(response);
  }
}
