import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/category.dart';

class CategoryTreeView extends StatelessWidget {
  final List<Category> categories;
  final int level;

  const CategoryTreeView({
    super.key,
    required this.categories,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: categories
            .map((category) => CategoryTreeItem(
                  category: category,
                  level: level,
                ))
            .toList(),
      ),
    );
  }
}

class CategoryTreeItem extends StatefulWidget {
  final Category category;
  final int level;

  const CategoryTreeItem({
    super.key,
    required this.category,
    required this.level,
  });

  @override
  State<CategoryTreeItem> createState() => _CategoryTreeItemState();
}

class _CategoryTreeItemState extends State<CategoryTreeItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.category.hasChildren;
    final paddingLeft = 16.0 + (widget.level * 24.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: EdgeInsets.only(
            left: paddingLeft,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: ListTile(
            leading: Text(
              widget.category.icon ?? '🐾',
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(
              widget.category.name,
              style: TextStyle(
                fontWeight:
                    widget.level == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text('${widget.category.productCount} товаров'),
            trailing: hasChildren
                ? IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  )
                : null,
            onTap: () {
              if (hasChildren) {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              } else {
                context.go(
                  '/products?category=${widget.category.id}',
                  extra: {'categoryName': widget.category.name},
                );
              }
            },
          ),
        ),

        // Анимированное появление подкатегорий
        if (hasChildren && _isExpanded && widget.category.children != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: CategoryTreeView(
              categories: widget.category.children!,
              level: widget.level + 1,
            ),
          ),
      ],
    );
  }
}
