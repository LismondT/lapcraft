import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().loadInitialProducts();
    });
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductsStateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                action: SnackBarAction(
                  label: 'Повторить',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<ProductsCubit>().loadInitialProducts();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // App Bar
              _buildAppBar(),

              // Content based on state
              ..._buildContent(state),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.search_normal, size: 20, color: Colors.grey[500]),
                  hintText: 'Поиск товаров...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16), // Исправлено выравнивание
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (value) {
                  // Implement search functionality
                },
              ),
            ),
            Container(
              width: 1,
              height: 24,
              color: Colors.grey[200],
            ),
            SizedBox(
              width: 52,
              child: IconButton(
                icon: Icon(Iconsax.filter, size: 20, color: Colors.grey[600]),
                onPressed: () {
                  _showFilterBottomSheet(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent(ProductsState state) {
    if (state is ProductsStateInitial) {
      return [_buildInitialState()];
    } else if (state is ProductsStateLoading) {
      return [_buildLoadingState()];
    } else if (state is ProductsStateRefreshing) {
      return _buildProductsGrid(state.products, isLoadingMore: true);
    } else if (state is ProductsStateEmpty) {
      return [_buildEmptyState()];
    } else if (state is ProductsStateFailure) {
      return [_buildErrorState(state.message)];
    } else if (state is ProductsStateSuccess) {
      return _buildProductsGrid(state.data);
    }
    return [_buildErrorState('Unknown state')];
  }

  SliverFillRemaining _buildInitialState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Icon(
                Iconsax.shop,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Начните покупки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Найдите нужные товары для ваших питомцев',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Iconsax.shopping_bag),
              label: const Text('Загрузить товары'),
              onPressed: () {
                context.read<ProductsCubit>().loadInitialProducts();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverFillRemaining _buildLoadingState() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Загрузка товаров...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverFillRemaining _buildEmptyState() {
    return SliverFillRemaining(
      child: RefreshIndicator(
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
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Icon(
                      Iconsax.search_status,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Товары не найдены',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'Попробуйте изменить параметры поиска и фильтров',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Iconsax.refresh),
                    label: const Text('Обновить'),
                    onPressed: () {
                      context.read<ProductsCubit>().refreshProducts();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      ),
    );
  }

  SliverFillRemaining _buildErrorState(String message) {
    return SliverFillRemaining(
      child: RefreshIndicator(
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
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
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
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Iconsax.refresh),
                    label: const Text('Попробовать снова'),
                    onPressed: () {
                      context.read<ProductsCubit>().loadInitialProducts();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      ),
    );
  }

  List<Widget> _buildProductsGrid(Products data, {bool isLoadingMore = false}) {
    final products = data.products ?? [];
    final hasReachedMax = context.read<ProductsCubit>().hasReachedMax;
    final screenWidth = MediaQuery.of(context).size.width;

    return [
      // Header with product count
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Text(
                '${products.length} товаров',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Sort button
              GestureDetector(
                onTap: () {
                  _showSortBottomSheet(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.sort, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Сортировка',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Products grid
      if (products.isNotEmpty)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = _calculateCrossAxisCount(screenWidth);
              final isMobile = screenWidth < 600;

              if (isMobile) {
                // Мобильная версия - список
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index < products.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProductCard(products[index]),
                        );
                      } else {
                        return _buildLoadingIndicator(hasReachedMax);
                      }
                    },
                    childCount: hasReachedMax ? products.length : products.length + 1,
                  ),
                );
              } else {
                // Десктоп/планшет версия - сетка
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: _calculateAspectRatio(screenWidth),
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index < products.length) {
                        return ProductCard(products[index]);
                      } else {
                        return _buildLoadingIndicator(hasReachedMax);
                      }
                    },
                    childCount: hasReachedMax ? products.length : products.length + 1,
                  ),
                );
              }
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

      // Bottom padding
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Фильтры',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Iconsax.close_circle),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Filter content would go here
              Expanded(
                child: Center(
                  child: Text(
                    'Фильтры будут здесь',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Сортировка',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Sort options would go here
              Text(
                'Опции сортировки будут здесь',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) return 1;
    if (screenWidth < 900) return 2;
    if (screenWidth < 1200) return 3;
    return 4;
  }

  double _calculateAspectRatio(double screenWidth) {
    if (screenWidth < 900) return 0.75; // Для планшетов
    return 0.7; // Для десктопов
  }

  Widget _buildLoadingIndicator(bool hasReachedMax) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: hasReachedMax
            ? Text(
          'Все товары загружены',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        )
            : const CupertinoActivityIndicator(),
      ),
    );
  }
}