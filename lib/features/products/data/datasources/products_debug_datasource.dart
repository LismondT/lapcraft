// import 'dart:math';
//
// import 'package:lapcraft/features/features.dart';
//
// class ProductsDebugDatasourceImpl implements ProductsDatasource {
//   final List<ProductResponse> _catalog = [];
//   final List<String> _images = [
//     'https://cdn.myanimelist.net/s/common/uploaded_files/1457954629-8e5311661dd9410b98e2971ffdc21df6.jpeg',
//     'https://cdn.myanimelist.net/s/common/uploaded_files/1457954650-04a7655ca93df4b49e837c65f5aa6646.jpeg',
//     'https://cdn.myanimelist.net/s/common/uploaded_files/1457954646-328e0b58faa5c5b8888f6f9be0533dd5.jpeg',
//     'https://cdn.myanimelist.net/s/common/uploaded_files/1457954643-dd4c29919a682cff1b975046c29e4d6c.jpeg'
//   ];
//
//   ProductsDebugDatasourceImpl(int itemsCount) {
//     final random = Random();
//
//     for (int i = 0; i < itemsCount; i++) {
//       final product = ProductResponse(
//           id: i.toString(),
//           article: i,
//           title: 'Предмет $i',
//           description: 'Описание крутое вообще ладно да давай пока',
//           price: random.nextInt(20000).toDouble(),
//           imageUrls: _images,
//           stockQuantity: random.nextInt(10));
//       _catalog.add(product);
//     }
//   }
//
//   @override
//   Future<ProductResponse> product(String id) async {
//     final product = _catalog.firstWhere((x) => x.id == id);
//     return product;
//   }
//
//   @override
//   Future<ProductsResponse> products(int page, int pageSize,
//       {String? categoryId, double? priceStart, double? priceEnd}) async {
//     final start = page * pageSize - pageSize;
//     final end = (start + pageSize).clamp(0, _catalog.length);
//     final products = _catalog.getRange(start, end);
//     final response = ProductsResponse(
//         data: products.toList(),
//         currentPage: page,
//         totalPages: (_catalog.length / pageSize).toInt());
//
//     await Future.delayed(Duration(milliseconds: 500));
//
//     return response;
//   }
// }
