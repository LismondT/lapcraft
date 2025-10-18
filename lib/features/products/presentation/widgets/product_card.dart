import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_state.dart';

import '../../../cart/presentation/cubits/cart_cubit.dart';

class ProductCard extends StatelessWidget {
  final Product _product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard(
    this._product, {
    super.key,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDesktop = screenWidth >= 900;

    return isMobile
        ? _buildMobileCard(context)
        : _buildDesktopCard(context, isTablet, isDesktop);
  }

  // Мобильная версия - горизонтальная компактная
  Widget _buildMobileCard(BuildContext context) {
    final isInStock = (_product.stockQuantity) > 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;

    return SizedBox(
      height: 140,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ??
              () {
                context.push(Routes.product.withParameter(_product.id));
              },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                _buildMobileImageSection(isSmallScreen),

                // Content section
                Expanded(
                  child: _buildMobileContentSection(
                      context, isSmallScreen, isInStock),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Десктоп/планшет версия - вертикальная с рейтингом
  Widget _buildDesktopCard(
      BuildContext context, bool isTablet, bool isDesktop) {
    final isInStock = (_product.stockQuantity) > 0;

    return Container(
      constraints: BoxConstraints(
        minHeight: isTablet ? 280 : 320,
        maxHeight: isTablet ? 320 : 360,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap ??
              () {
                context.push(Routes.product.withParameter(_product.id));
              },
          child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image section
                    _buildDesktopImageSection(isTablet),

                    // Content section
                    Expanded(
                      child: _buildDesktopContentSection(
                          context, isTablet, isDesktop, isInStock),
                    ),

                    // Footer section
                    _buildDesktopFooterSection(context, isInStock),
                  ],
                ),

                // Badges
                if (!isInStock) _buildOutOfStockBadge(isTablet),
                _buildFavoriteButton(isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== MOBILE VERSION ==========

  Widget _buildMobileImageSection(bool isSmallScreen) {
    return SizedBox(
      width: isSmallScreen ? 100 : 120,
      height: 140,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        child: _product.imageUrls.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: _product.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildPlaceholderImage(),
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildMobileContentSection(
      BuildContext context, bool isSmallScreen, bool isInStock) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  _product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 12 : 13,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Description
                Text(
                  _product.description,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 11,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Rating - добавляем рейтинг в мобильную версию
                _buildRatingSection(true, isSmallScreen),

                // Stock status
                if (!isInStock) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Нет в наличии',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bottom section
          Row(
            children: [
              // Price
              Expanded(
                child: Text(
                  '${_formatPrice(_product.price)} ₽',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 13 : 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

              // Add to cart button
              _buildAddToCartButton(context, true, isSmallScreen, isInStock),
            ],
          ),
        ],
      ),
    );
  }

  // ========== DESKTOP VERSION ==========

  Widget _buildDesktopImageSection(bool isTablet) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: SizedBox(
        height: isTablet ? 140 : 160,
        child: _product.imageUrls.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: _product.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildPlaceholderImage(),
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildDesktopContentSection(
      BuildContext context, bool isTablet, bool isDesktop, bool isInStock) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                _product.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 14 : 16,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Description - больше строк на широких экранах
              Container(
                constraints: BoxConstraints(
                  maxHeight: isDesktop ? 60 : 48, // Больше места для описания
                ),
                child: Text(
                  _product.description,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: isDesktop ? 3 : 2, // 3 строки на десктопе
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 12),

              // Rating - полноценный рейтинг
              _buildRatingSection(false, isTablet),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooterSection(BuildContext context, bool isInStock) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Price
          Expanded(
            child: Text(
              '${_formatPrice(_product.price)} ₽',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 12),

          // Add to cart button
          _buildAddToCartButton(context, false, false, isInStock),
        ],
      ),
    );
  }

  // ========== SHARED COMPONENTS ==========

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Icon(
          Iconsax.gallery,
          size: 32,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildRatingSection(bool isMobile, bool isSmallScreen) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Iconsax.star1,
            size: isMobile ? (isSmallScreen ? 10 : 12) : 14,
            color: Colors.amber),
        const SizedBox(width: 2),
        Text(
          '4.8',
          style: TextStyle(
            fontSize: isMobile ? (isSmallScreen ? 9 : 10) : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(124)',
          style: TextStyle(
            fontSize: isMobile ? (isSmallScreen ? 9 : 10) : 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(
      BuildContext context, bool isMobile, bool isSmallScreen, bool isInStock) {
    final buttonSize = isMobile ? (isSmallScreen ? 28.0 : 32.0) : 40.0;
    final iconSize = isMobile ? (isSmallScreen ? 14.0 : 16.0) : 20.0;

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        color: isInStock
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[300],
        child: InkWell(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
          onTap: isInStock ? onAddToCart ?? () => _addToCart(context) : null,
          child: Icon(
            isInStock ? Iconsax.add : Iconsax.close_circle,
            size: iconSize,
            color: isInStock ? Colors.white : Colors.grey[500],
          ),
        ),
      ),
    );
  }

  Widget _buildOutOfStockBadge(bool isTablet) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Нет в наличии',
          style: TextStyle(
            fontSize: isTablet ? 10 : 11,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(bool isTablet) {
    return Positioned(
      top: 8,
      right: 8,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Add to favorites
          },
          child: Container(
            width: isTablet ? 28 : 32,
            height: isTablet ? 28 : 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Iconsax.heart,
              size: isTablet ? 14 : 16,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final isAuthed = context.read<AuthCubit>().state is AuthAuthenticated;

    if (isAuthed) {
      context.read<CartCubit>().addToCart(_product.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Iconsax.tick_circle, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_product.title} добавлен в корзину',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Iconsax.login, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () => context.go(Routes.login
                      .withQuery('returnUrl', value: Routes.categories.path)),
                  child: Text('Войдите, чтобы добавить товар в корзину!',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }
}
