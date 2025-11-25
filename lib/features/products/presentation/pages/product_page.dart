// product_page.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lapcraft/features/cart/presentation/cubits/cart_cubit_states.dart';
import 'package:lapcraft/features/favorites/presentation/cubits/favorites_cubit.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/presentation/cubits/product_cubit.dart';
import 'package:lapcraft/features/products/presentation/cubits/product_state.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_state.dart';

import '../../../../core/app_route.dart';
import '../../../cart/presentation/cubits/cart_cubit.dart';
import '../../../favorites/presentation/cubits/favorites_states.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductCubit>().load(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildBody(state, context),
          );
        },
      ),
    );
  }

  Widget _buildBody(ProductState state, BuildContext context) {
    return switch (state) {
      ProductInitial() => _buildLoadingState(),
      ProductLoading() => _buildLoadingState(),
      ProductError(message: final message) =>
        _buildErrorState(message, context),
      ProductLoaded(product: final product) =>
        _buildProductContent(product, context),
    };
  }

  Widget _buildLoadingState() {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          floating: false,
          pinned: true,
          backgroundColor: Colors.white,
          leading: BackButton(),
          flexibleSpace: FlexibleSpaceBar(
            background: _ProductImageShimmer(),
          ),
        ),
        SliverToBoxAdapter(
          child: _ProductContentShimmer(),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductCubit>().load(widget.productId);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.close_circle,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ошибка загрузки',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Iconsax.refresh),
                  label: const Text('Попробовать снова'),
                  onPressed: () {
                    context.read<ProductCubit>().load(widget.productId);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductContent(Product product, BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _buildImageAppBar(product, context),
            _buildProductContentDetails(product, context),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _ProductBottomBar(product: product),
        ),
      ],
    );
  }

  SliverAppBar _buildImageAppBar(Product product, BuildContext context) {
    final images = product.imageUrls;

    return SliverAppBar(
      expandedHeight: 400,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favoritesState) {
            final isFavorite = favoritesState is FavoritesStateLoaded &&
                favoritesState.products.any((p) => p.id == product.id);

            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Iconsax.heart5 : Iconsax.heart,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  final isAuthed =
                      context.read<AuthCubit>().state is AuthAuthenticated;

                  if (isAuthed) {
                    context.read<FavoritesCubit>().toggleFavorite(product.id);
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
                                    .withQuery('returnUrl',
                                        value: Routes.product
                                            .withParameter(widget.productId))),
                                child: Text(
                                    'Войдите, чтобы добавить товар в избранное!',
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
                },
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: images.isEmpty
            ? _buildPlaceholderImage()
            : PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        _buildPlaceholderImage(),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Icon(
          Iconsax.gallery,
          size: 64,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildProductContentDetails(
      Product product, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product header
            _buildProductHeader(product, context),

            const SizedBox(height: 24),

            // Rating and details
            _buildProductDetails(product),

            const SizedBox(height: 24),

            // Description
            _buildDescriptionSection(product),

            const SizedBox(height: 24),

            // Specifications
            _buildSpecificationsSection(product),

            const SizedBox(height: 80), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader(Product product, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            product.categoryName,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Title
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // Price
        Text(
          '${_formatPrice(product.price)} ₽',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        const SizedBox(height: 12),

        // Stock status
        _buildStockStatus(product),
      ],
    );
  }

  Widget _buildStockStatus(Product product) {
    final isInStock = product.stockQuantity > 0;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isInStock
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isInStock ? Iconsax.tick_circle : Iconsax.close_circle,
            size: 16,
            color: isInStock ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isInStock
              ? 'В наличии (${product.stockQuantity} шт.)'
              : 'Нет в наличии',
          style: TextStyle(
            color: isInStock ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(Product product) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Арт: ${product.article}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Описание',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description.isNotEmpty
              ? product.description
              : 'Описание отсутствует',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificationsSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Характеристики',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildSpecificationItem('Категория', product.categoryName),
        _buildSpecificationItem(
            'Количество на складе', product.stockQuantity.toString()),
        _buildSpecificationItem('Артикул', product.article.toString()),
      ],
    );
  }

  Widget _buildSpecificationItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
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

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }
}

class _ProductBottomBar extends StatelessWidget {
  final Product product;

  const _ProductBottomBar({required this.product});

  @override
  Widget build(BuildContext context) {
    final isInStock = product.stockQuantity > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Итого',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${_formatPrice(product.price)} ₽',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            flex: 2,
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                final isInCart =
                    context.read<CartCubit>().isProductInCart(product.id);

                return ElevatedButton.icon(
                  icon: isInCart
                      ? const Icon(Iconsax.box_remove)
                      : const Icon(Iconsax.shopping_cart),
                  label: Text(isInStock
                      ? (isInCart ? 'Убрать из корзины' : 'Добавить в корзину')
                      : 'Нет в наличии'),
                  onPressed: isInStock
                      ? (isInCart
                          ? () => _removeFromCart(context, product)
                          : () => _addToCart(context, product))
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: isInCart
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, Product product) {
    final isAuthed = context.read<AuthCubit>().state is AuthAuthenticated;

    if (isAuthed) {
      context.read<CartCubit>().addToCart(product.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Iconsax.tick_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${product.title} добавлен в корзину',
                  style: const TextStyle(color: Colors.white),
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

  void _removeFromCart(BuildContext context, Product product) {
    final isAuthed = context.read<AuthCubit>().state is AuthAuthenticated;
    context.read<CartCubit>().removeFromCart(product.id);

    if (isAuthed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Iconsax.tick_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${product.title} убран из корзины',
                  style: const TextStyle(color: Colors.white),
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
                  child: Text('Войдите в аккаунт!',
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
}

// Shimmer widgets for loading state
class _ProductImageShimmer extends StatelessWidget {
  const _ProductImageShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
    );
  }
}

class _ProductContentShimmer extends StatelessWidget {
  const _ProductContentShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 120,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 100,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
