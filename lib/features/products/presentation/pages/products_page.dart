import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/presentation/widgets/product_card.dart';

import '../cubits/products_cubit.dart';
import '../cubits/products_cubit_states.dart';

class ProductsPage extends StatefulWidget {
  final String category;

  const ProductsPage({super.key, required this.category});

  @override
  State<StatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  bool _isLoadingNextPage = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _previousSearchText = '';
  Timer? _debounceTimer;

  final Map<String, dynamic> _filters = {};
  String _currentSort = 'title';
  String _currentOrder = 'asc';
  RangeValues _priceRange = const RangeValues(0, 100000);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().loadInitialProducts(widget.category);
    });

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();

    final currentText = _searchController.text.trim();

    if (currentText == _previousSearchText) {
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted && currentText != _previousSearchText) {
        _previousSearchText = currentText;
        context.read<ProductsCubit>().applySearch(
              currentText,
              widget.category,
            );
      }
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
      context.read<ProductsCubit>().loadNextPage(widget.category).then((_) {
        if (mounted) {
          setState(() {
            _isLoadingNextPage = false;
          });
        }
      });
    }
  }

  void _applyFiltersAndSort() {
    context.read<ProductsCubit>().applyFiltersAndSort(
          filters: _filters,
          category: widget.category,
        );
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _searchController.clear();
      _currentSort = 'title';
      _currentOrder = 'asc';
      _priceRange = const RangeValues(0, 100000);
    });
    context.read<ProductsCubit>().clearFilters(widget.category);
  }

  bool get _hasActiveFilters {
    return _filters.isNotEmpty ||
        _searchController.text.isNotEmpty ||
        _currentSort != 'title' ||
        _currentOrder != 'asc' ||
        _priceRange.start > 0 ||
        _priceRange.end < 100000;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductsStateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                action: SnackBarAction(
                  label: 'Повторить',
                  textColor: colorScheme.onError,
                  onPressed: () {
                    context
                        .read<ProductsCubit>()
                        .loadInitialProducts(widget.category);
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
              _buildAppBar(colorScheme),

              // Content based on state
              ..._buildContent(state, colorScheme),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(ColorScheme colorScheme) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Container(
        height: 52,
        decoration: BoxDecoration(
          color: colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.search_normal,
                      size: 20, color: colorScheme.onSurface.withOpacity(0.6)),
                  hintText: 'Поиск товаров...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  isDense: true,
                ),
                style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
              ),
            ),
            if (_hasActiveFilters) ...[
              Container(
                width: 1,
                height: 24,
                color: colorScheme.outline.withOpacity(0.3),
              ),
              SizedBox(
                width: 52,
                child: IconButton(
                  icon: Badge(
                    smallSize: 8,
                    backgroundColor: colorScheme.primary,
                    child: Icon(
                      Iconsax.filter,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
              ),
            ] else ...[
              Container(
                width: 1,
                height: 24,
                color: colorScheme.outline.withOpacity(0.3),
              ),
              SizedBox(
                width: 52,
                child: IconButton(
                  icon: Icon(Iconsax.filter,
                      size: 20, color: colorScheme.onSurface.withOpacity(0.7)),
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        'Фильтры и сортировка',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (_hasActiveFilters)
                        IconButton(
                            onPressed: () {
                              _clearAllFilters();
                              Navigator.pop(context);
                            },
                            icon: Icon(Iconsax.refresh)),
                      if (!_hasActiveFilters)
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Iconsax.close_circle,
                              color: colorScheme.onSurface.withOpacity(0.6)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sort Section
                  Text(
                    'Сортировка',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sort Options
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSortChip(
                        'По названию',
                        'title',
                        setModalState,
                        colorScheme,
                      ),
                      _buildSortChip(
                        'По цене',
                        'price',
                        setModalState,
                        colorScheme,
                      ),
                      _buildSortChip(
                        'По артикулу',
                        'article',
                        setModalState,
                        colorScheme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Order Toggle
                  Row(
                    children: [
                      Expanded(
                        child: _buildOrderButton(
                          'По возрастанию',
                          'asc',
                          setModalState,
                          colorScheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOrderButton(
                          'По убыванию',
                          'desc',
                          setModalState,
                          colorScheme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Price Filter
                  Text(
                    'Цена',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price Range Slider
                  Column(
                    children: [
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 100000,
                        divisions: 100,
                        labels: RangeLabels(
                          '${_priceRange.start.round()}₽',
                          '${_priceRange.end.round()}₽',
                        ),
                        onChanged: (RangeValues values) {
                          setModalState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${_priceRange.start.round()}₽',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${_priceRange.end.round()}₽',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply price filter
                        _filters['min_price'] = _priceRange.start;
                        _filters['max_price'] = _priceRange.end;

                        // Apply sort
                        _filters['sort'] = _currentSort;
                        _filters['order'] = _currentOrder;

                        _applyFiltersAndSort();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: const Text('Применить фильтры'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Остальные методы остаются без изменений...
  List<Widget> _buildContent(ProductsState state, ColorScheme colorScheme) {
    if (state is ProductsStateInitial) {
      return [_buildInitialState(colorScheme)];
    } else if (state is ProductsStateLoading) {
      return [_buildLoadingState(colorScheme)];
    } else if (state is ProductsStateRefreshing) {
      return _buildProductsGrid(state.products,
          isLoadingMore: true, colorScheme: colorScheme);
    } else if (state is ProductsStateEmpty) {
      return [_buildEmptyState(colorScheme)];
    } else if (state is ProductsStateFailure) {
      return [_buildErrorState(state.message, colorScheme)];
    } else if (state is ProductsStateSuccess) {
      return _buildProductsGrid(state.data, colorScheme: colorScheme);
    }
    return [_buildErrorState('Unknown state', colorScheme)];
  }

  SliverFillRemaining _buildInitialState(ColorScheme colorScheme) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surface,
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
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Начните покупки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Найдите нужные товары для ваших питомцев',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Iconsax.shopping_bag),
              label: const Text('Загрузить товары'),
              onPressed: () {
                context
                    .read<ProductsCubit>()
                    .loadInitialProducts(widget.category);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverFillRemaining _buildLoadingState(ColorScheme colorScheme) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Загрузка товаров...',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverFillRemaining _buildEmptyState(ColorScheme colorScheme) {
    return SliverFillRemaining(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductsCubit>().refreshProducts(widget.category);
        },
        color: colorScheme.primary,
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
                      color: colorScheme.surface,
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
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Товары не найдены',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
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
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Iconsax.refresh),
                    label: const Text('Обновить'),
                    onPressed: () {
                      context
                          .read<ProductsCubit>()
                          .refreshProducts(widget.category);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
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

  SliverFillRemaining _buildErrorState(
      String message, ColorScheme colorScheme) {
    return SliverFillRemaining(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductsCubit>().refreshProducts(widget.category);
        },
        color: colorScheme.primary,
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
                      color: colorScheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.close_circle,
                      size: 48,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ошибка загрузки',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
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
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Iconsax.refresh),
                    label: const Text('Попробовать снова'),
                    onPressed: () {
                      context
                          .read<ProductsCubit>()
                          .loadInitialProducts(widget.category);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
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

  List<Widget> _buildProductsGrid(Products data,
      {bool isLoadingMore = false, required ColorScheme colorScheme}) {
    final products = data.products ?? [];
    final hasReachedMax = context.read<ProductsCubit>().hasReachedMax;

    return [
      // Header with product count
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Text(
                'Найдено ${data.total ?? 0} товаров',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Sort button
              GestureDetector(
                onTap: () {
                  _showFilterBottomSheet(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: colorScheme.outline.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.sort,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(
                        'Сортировка',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
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
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < products.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductCard(products[index]),
                    );
                  } else if (!hasReachedMax) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(
                          child: CupertinoActivityIndicator(
                              color: colorScheme.primary)),
                    );
                  }
                  return null;
                },
                childCount:
                    hasReachedMax ? products.length : products.length + 1,
              ),
            )),

      // Bottom padding
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  Widget _buildSortChip(
    String label,
    String value,
    StateSetter setModalState,
    ColorScheme colorScheme,
  ) {
    final isSelected = _currentSort == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setModalState(() {
          _currentSort = value;
        });
      },
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primary.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildOrderButton(
    String label,
    String value,
    StateSetter setModalState,
    ColorScheme colorScheme,
  ) {
    final isSelected = _currentOrder == value;
    return OutlinedButton(
      onPressed: () {
        setModalState(() {
          _currentOrder = value;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline.withOpacity(0.3),
        ),
        backgroundColor: isSelected
            ? colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
