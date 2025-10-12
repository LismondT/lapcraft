import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapcraft/features/features.dart';

class ProductDetailPage extends StatelessWidget {
  final Product _product;

  const ProductDetailPage(this._product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title ?? 'Детали товара'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Галерея изображений
            _buildImageGallery(context),

            const SizedBox(height: 24),

            // Основная информация
            _buildProductInfo(context),

            const SizedBox(height: 24),

            // Описание
            _buildDescriptionSection(context),

            const SizedBox(height: 24),

            // Характеристики
            _buildSpecificationsSection(context),

            const SizedBox(height: 32),

            // Кнопка добавления в корзину
            _buildAddToCartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    final images = _product.imageUrls ?? [];

    return SizedBox(
      height: 300,
      child: images.isEmpty
          ? _buildPlaceholderImage(context)
          : PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child:
                            const Center(child: CupertinoActivityIndicator()),
                      ),
                      errorWidget: (context, url, error) =>
                          _buildPlaceholderImage(context),
                    ),
                  ),
                );
              },
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
          size: 64,
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _product.title ?? 'Без названия',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          _product.price != null
              ? '${_formatPrice(_product.price!)} ₽'
              : 'Цена не указана',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (_product.article != null)
          Text(
            'Артикул: ${_product.article}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        const SizedBox(height: 8),
        _buildStockStatus(context),
      ],
    );
  }

  Widget _buildStockStatus(BuildContext context) {
    final stock = _product.stockQuantity ?? 0;
    final isInStock = stock > 0;

    return Row(
      children: [
        Icon(
          isInStock ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: isInStock ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 4),
        Text(
          isInStock ? 'В наличии ($stock шт.)' : 'Нет в наличии',
          style: TextStyle(
            color: isInStock ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Описание',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          _product.description ?? 'Описание отсутствует',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildSpecificationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Характеристики',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildSpecificationItem(
            'Категория', _product.category?.toString() ?? 'Не указана'),
        _buildSpecificationItem('Категория питомца',
            _product.petCategory?.toString() ?? 'Не указана'),
        _buildSpecificationItem(
            'Количество на складе', (_product.stockQuantity ?? 0).toString()),
      ],
    );
  }

  Widget _buildSpecificationItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    final isInStock = (_product.stockQuantity ?? 0) > 0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isInStock
            ? () {
                // Добавление в корзину
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${_product.title ?? "Товар"} добавлен в корзину'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Добавить в корзину',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
