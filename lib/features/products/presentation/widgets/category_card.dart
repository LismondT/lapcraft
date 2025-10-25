import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../domain/entities/category.dart';

class AnimatedCategoryCard extends StatelessWidget {
  final Category category;
  final int index;

  const AnimatedCategoryCard({
    super.key,
    required this.category,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      child: FadeInCategoryCard(category: category),
    );
  }
}

class FadeInCategoryCard extends StatefulWidget {
  final Category category;

  const FadeInCategoryCard({super.key, required this.category});

  @override
  State<FadeInCategoryCard> createState() => _FadeInCategoryCardState();
}

class _FadeInCategoryCardState extends State<FadeInCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final hasChildren = widget.category.hasChildren;
    final productCount = widget.category.productCount;

    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 200, // Минимальная высота для очень узких экранов
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              // Важно: занимать только нужное место
              children: [
                // Icon/Image section - адаптивная высота
                _buildIconSection(context),

                // Content section - расширяемая часть
                Expanded(
                  child: _buildContentSection(context),
                ),

                // Footer section - фиксированная высота
                _buildFooterSection(context),
              ],
            ),

            // Badge for children indicator
            if (hasChildren) _buildChildrenBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSection(BuildContext context) {
    // Адаптивная высота вместо фиксированной 100
    return AspectRatio(
      aspectRatio: 16 / 9, // Соотношение сторон вместо фиксированной высоты
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ],
          ),
        ),
        child: Center(
          child: Text(
            widget.category.icon ?? '🐾',
            style: TextStyle(
              fontSize:
                  MediaQuery.of(context).size.width * 0.08, // Адаптивный размер
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.03), // Адаптивные отступы
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.category.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width *
                  0.035, // Адаптивный размер
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
          if (widget.category.description != null)
            Expanded(
              // Описание может занимать оставшееся место
              child: Text(
                widget.category.description!,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.028,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
                maxLines: 3, // Увеличил количество строк
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            // Гибкий текст для товаров
            child: Text(
              '${widget.category.productCount} товаров',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.028,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Iconsax.arrow_right_3,
              size: MediaQuery.of(context).size.width * 0.03,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.folder,
              size: 10,
              color: Colors.orange,
            ),
            const SizedBox(width: 2),
            Text(
              '${widget.category.childrenCount}',
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (widget.category.hasChildren) {
      context.push(
        '/subcategories/${widget.category.id}',
        extra: {
          'parentName': widget.category.name,
          'parentCategory': widget.category,
        },
      );
    } else {
      context.push(
        '/products?category=${widget.category.id}',
        extra: {'categoryName': widget.category.name},
      );
    }
  }
}
