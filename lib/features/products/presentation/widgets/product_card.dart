import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/features/cart/pages/cart_page/cubit/cart_cubit.dart';
import 'package:lapcraft/features/features.dart';

import '../pages/products_detail_page.dart';

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
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ??
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(_product),
                ),
              );
            },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            _buildImageSection(context),

            // Body section
            _buildBodySection(context),

            // Price and action section
            _buildFooterSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: _product.imageUrls?.isNotEmpty ?? false
            ? CachedNetworkImage(
                imageUrl: _product.imageUrls!.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CupertinoActivityIndicator()),
                ),
                errorWidget: (context, url, error) =>
                    _buildPlaceholderImage(context),
              )
            : _buildPlaceholderImage(context),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Center(
        child: Icon(
          Icons.image,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildBodySection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              _product.title ?? 'Без названия',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Description
            Expanded(
              child: Text(
                _product.description ?? "Описания нет",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price
          Expanded(
            child: Text(
              _product.price != null
                  ? '${_formatPrice(_product.price!)} ₽'
                  : "Цена не указана",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 8),

          // Buy button
          _buildAddToCartButton(context),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onAddToCart ??
            () {
              context.read<CartCubit>().addToCart(_product.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${_product.title ?? "Товар"} добавлен в корзину'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.add_shopping_cart,
            size: 20,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    // Format price with thousand separators
    return price
        .toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }
}
