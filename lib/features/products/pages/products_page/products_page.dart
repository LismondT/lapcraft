import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ScrollController _scrollController = ScrollController()
    ..addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductsCubit>().nextPage();
      }
    });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsStateSuccess) {
              return _buildProductsGrid(state.data);
            }
            return Container();
          }
      ),
    );
  }

  Widget _buildProductsGrid(Products data) {
    return LayoutBuilder(builder: (context, constraints) {
      final crossAxisCount =
          constraints.maxWidth > 600 ? (constraints.maxWidth > 900 ? 4 : 3) : 2;
      final childAspectRatio = constraints.maxWidth > 600 ? 0.65 : 0.6;

      return GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12),
          itemCount: data.currentPage == data.totalPages
              ? data.products?.length
              : ((data.products?.length ?? 0) + 1),
          itemBuilder: (_, index) {
            if (index < (data.products?.length ?? 0)) {
              return productItem(data.products![index]);
            } else {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
          });
    });
  }

  Widget productItem(Product product) {
    return Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            //! Product detail page
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: product.imageUrls?.isNotEmpty ?? false
                      ? CachedNetworkImage(
                          imageUrl: product.imageUrls!.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                  child: CupertinoActivityIndicator())),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            child: Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                          ),
                        )
                      : Container(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          child: Center(
                            child: Icon(
                              Icons.image,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                ),
              ),

              // Body section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        product.title ?? 'Без названия',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      Expanded(
                        child: Text(
                          product.description ?? "Описания нет",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 4),

                      if (product.stockQuantity != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.stockQuantity.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Price and action section
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    border: BorderDirectional(
                        top: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                  width: 1,
                ))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Price
                    Text(
                      product.price != null
                          ? '${product.price!} ₽'
                          : "Цена не указана",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    //Buy button
                    IconButton(
                      onPressed: () {
                        // Добавление в корзину
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${product.title} добавлен в корзину'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: Icon(Icons.add_shopping_cart, size: 24),
                      padding: EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
