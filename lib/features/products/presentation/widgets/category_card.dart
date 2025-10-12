import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lapcraft/core/app_route.dart';

import '../../domain/entities/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (category.hasChildren) {
            context.push(Routes.subcategories.withPathParameter(category.id),
                extra: {
                  'parentName': category.name,
                  'parentCategory': category
                });
          } else {
            context.go(Routes.products.path);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.icon ?? '🐾',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              '${category.productCount} товаров',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
