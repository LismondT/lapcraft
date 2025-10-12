import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/presentation/widgets/product_card.dart';

import '../cubits/products_cubit.dart';
import '../cubits/products_cubit_states.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ScrollController _scrollController;
  bool _isLoadingNextPage = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    //Load initial products when the page is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().loadInitialProducts();
    });
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Load next page when we're within 200 pixels of the bottom
    // and not currently loading
    if (maxScroll - currentScroll <= 200 &&
        !_isLoadingNextPage &&
        context.read<ProductsCubit>().hasReachedMax == false) {
      setState(() {
        _isLoadingNextPage = true;
      });
      context.read<ProductsCubit>().loadNextPage().then((_) {
        setState(() {
          _isLoadingNextPage = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductsStateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                action: SnackBarAction(
                  label: 'Повторить',
                  onPressed: () {
                    context.read<ProductsCubit>().loadInitialProducts();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductsStateInitial) {
            return _buildInitialState();
          } else if (state is ProductsStateLoading) {
            return _buildLoadingState();
          } else if (state is ProductsStateRefreshing) {
            return _buildProductsGrid(state.products, isLoadingMore: true);
          } else if (state is ProductsStateEmpty) {
            return _buildEmptyState();
          } else if (state is ProductsStateFailure) {
            return _buildErrorState(state.message);
          } else if (state is ProductsStateSuccess) {
            return _buildProductsGrid(state.data);
          }
          return _buildErrorState('Unknown state');
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Browse Products',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.read<ProductsCubit>().loadInitialProducts();
            },
            child: const Text('Load Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductsCubit>().refreshProducts();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  'Товары не найдены',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Попробуйте изменить параметры поиска и фильтров',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProductsCubit>().refreshProducts();
                  },
                  child: const Text('Попробовать снова'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductsCubit>().refreshProducts();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                const Text(
                  'Что-то пошло не так',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProductsCubit>().loadInitialProducts();
                  },
                  child: const Text('Попробовать снова'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(Products data, {bool isLoadingMore = false}) {
    final products = data.products ?? [];
    final hasReachedMax = context.read<ProductsCubit>().hasReachedMax;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductsCubit>().refreshProducts();
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, size: 20),
                        hintText: 'Поиск товаров...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: (value) {
                        // Implement search functionality
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, size: 20),
                    onPressed: () {
                      // Implement filter functionality
                    },
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            pinned: true,
            floating: true,
            snap: true,
            elevation: 2,
          ),
          if (products.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.crossAxisExtent > 600
                      ? (constraints.crossAxisExtent > 900 ? 4 : 3)
                      : 2;
                  final childAspectRatio =
                      constraints.crossAxisExtent > 600 ? 0.65 : 0.6;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < products.length) {
                          return ProductCard(products[index]);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: hasReachedMax
                                  ? const Text('No more products')
                                  : const CupertinoActivityIndicator(),
                            ),
                          );
                        }
                      },
                      childCount:
                          hasReachedMax ? products.length : products.length + 1,
                    ),
                  );
                },
              ),
            )
          else if (isLoadingMore)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }
}
