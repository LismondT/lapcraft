// import 'package:flutter/material.dart';
//
// import '../../domain/entities/category.dart';
// import 'category_card.dart';
//
// class CategoriesGrid extends StatelessWidget {
//   final List<Category> categories;
//
//   const CategoriesGrid({super.key, required this.categories});
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.9,
//       ),
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         return CategoryCard(category: category);
//       },
//     );
//   }
// }
