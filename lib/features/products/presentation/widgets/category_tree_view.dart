import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lapcraft/core/app_route.dart';

import '../../domain/entities/category.dart';

class AnimatedCategoryTreeItem extends StatelessWidget {
  final Category category;
  final int index;

  const AnimatedCategoryTreeItem({
    super.key,
    required this.category,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, 0, 0),
      child: FadeInCategoryTreeItem(category: category),
    );
  }
}

class FadeInCategoryTreeItem extends StatefulWidget {
  final Category category;

  const FadeInCategoryTreeItem({super.key, required this.category});

  @override
  State<FadeInCategoryTreeItem> createState() => _FadeInCategoryTreeItemState();
}

class _FadeInCategoryTreeItemState extends State<FadeInCategoryTreeItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: _CategoryTreeItemContent(category: widget.category),
    );
  }
}

class _CategoryTreeItemContent extends StatefulWidget {
  final Category category;

  const _CategoryTreeItemContent({required this.category});

  @override
  State<_CategoryTreeItemContent> createState() =>
      __CategoryTreeItemContentState();
}

class __CategoryTreeItemContentState extends State<_CategoryTreeItemContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.category.hasChildren;
    final productCount = widget.category.productCount;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          // Main category item
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _handleTap(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary.withOpacity(0.8),
                            Theme.of(context).colorScheme.primary.withOpacity(0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          widget.category.icon ?? '🐾',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.category.productCount} товаров',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (widget.category.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.category.description!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Actions
                    if (hasChildren) ...[
                      IconButton(
                        icon: Icon(
                          _isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() => _isExpanded = !_isExpanded);
                        },
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Товары',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Children categories
          if (hasChildren && _isExpanded && widget.category.children != null)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 8),
              child: Column(
                children: widget.category.children!
                    .map((child) => AnimatedCategoryTreeItem(
                  category: child,
                  index: 0,
                ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (widget.category.hasChildren) {
      if (!_isExpanded) {
        setState(() => _isExpanded = true);
      }
    } else {
      context.push(
        Routes.products.withQuery('category', value: widget.category.id),
        extra: {'categoryName': widget.category.name},
      );
    }
  }
}