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

class _ProductsPageState extends State<ProductsPage>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  bool _isLoadingNextPage = false;
  final TextEditingController _searchController = TextEditingController();

  final Map<String, dynamic> _filters = {
    'priceRange': const {'min': 0, 'max': 100000},
    'inStock': false,
    'rating': 0,
  };

  String _sortBy = 'name';
  String _sortOrder = 'asc';

  // Анимации
  late AnimationController _filterAnimationController;
  late AnimationController _sortAnimationController;
  late Animation<double> _filterScaleAnimation;
  late Animation<double> _sortScaleAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    // Инициализация анимаций
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sortAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _filterScaleAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOutBack,
    );

    _sortScaleAnimation = CurvedAnimation(
      parent: _sortAnimationController,
      curve: Curves.easeInOutBack,
    );

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

  void _applyFiltersAndSort() {
    context.read<ProductsCubit>().applyFiltersAndSort(
      filters: _filters,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
      _filters.addAll({
        'category': null,
        'priceRange': const {'min': 0, 'max': 10000},
        'inStock': false,
        'rating': 0,
      });
      _sortBy = 'name';
      _sortOrder = 'asc';
    });
    _applyFiltersAndSort();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _filterAnimationController.dispose();
    _sortAnimationController.dispose();
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
              _buildAppBar(colorScheme),

              // Active filters chips
              _buildActiveFiltersChips(colorScheme),

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
      title: Container(
        height: 52,
        decoration: BoxDecoration(
          color: colorScheme.surface,
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
                onChanged: (value) {
                  // Implement search functionality
                },
              ),
            ),
            Container(
              width: 1,
              height: 24,
              color: colorScheme.outline.withOpacity(0.3),
            ),
            SizedBox(
              width: 52,
              child: IconButton(
                icon: Icon(Iconsax.filter, size: 20, color: colorScheme.onSurface.withOpacity(0.7)),
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

  Widget _buildActiveFiltersChips(ColorScheme colorScheme) {
    final activeFilters = _getActiveFilters(colorScheme);
    if (activeFilters.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...activeFilters.asMap().entries.map((entry) {
              final index = entry.key;
              final filter = entry.value;
              return AnimatedChip(
                label: filter['label'],
                onDeleted: filter['onDelete'],
                delay: Duration(milliseconds: index * 100),
                colorScheme: colorScheme,
              );
            }).toList(),
            if (activeFilters.length > 1)
              AnimatedChip(
                label: 'Очистить все',
                onDeleted: _clearFilters,
                isClearAll: true,
                delay: Duration(milliseconds: activeFilters.length * 100),
                colorScheme: colorScheme,
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getActiveFilters(ColorScheme colorScheme) {
    final List<Map<String, dynamic>> activeFilters = [];

    // Price range filter
    final priceRange = _filters['priceRange'] as Map<String, dynamic>;
    if (priceRange['min'] > 0 || priceRange['max'] < 100000) {
      activeFilters.add({
        'label': 'Цена: ${priceRange['min']} - ${priceRange['max']} ₽',
        'onDelete': () {
          setState(() {
            _filters['priceRange'] = {'min': 0, 'max': 100000};
          });
          _applyFiltersAndSort();
        },
      });
    }

    // In stock filter
    if (_filters['inStock'] == true) {
      activeFilters.add({
        'label': 'В наличии',
        'onDelete': () {
          setState(() {
            _filters['inStock'] = false;
          });
          _applyFiltersAndSort();
        },
      });
    }

    // Rating filter
    if (_filters['rating'] > 0) {
      activeFilters.add({
        'label': 'Рейтинг: ${_filters['rating']}+',
        'onDelete': () {
          setState(() {
            _filters['rating'] = 0;
          });
          _applyFiltersAndSort();
        },
      });
    }

    // Sort
    if (_sortBy != 'name' || _sortOrder != 'asc') {
      final sortLabels = {
        'name': 'Название',
        'price': 'Цена',
        'rating': 'Рейтинг',
        'createdAt': 'Дата добавления',
      };
      activeFilters.add({
        'label':
        'Сортировка: ${sortLabels[_sortBy]} (${_sortOrder == 'asc' ? 'по возрастанию' : 'по убыванию'})',
        'onDelete': () {
          setState(() {
            _sortBy = 'name';
            _sortOrder = 'asc';
          });
          _applyFiltersAndSort();
        },
      });
    }

    return activeFilters;
  }

  List<Widget> _buildContent(ProductsState state, ColorScheme colorScheme) {
    if (state is ProductsStateInitial) {
      return [_buildInitialState(colorScheme)];
    } else if (state is ProductsStateLoading) {
      return [_buildLoadingState(colorScheme)];
    } else if (state is ProductsStateRefreshing) {
      return _buildProductsGrid(state.products, isLoadingMore: true, colorScheme: colorScheme);
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
                context.read<ProductsCubit>().loadInitialProducts();
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
          context.read<ProductsCubit>().refreshProducts();
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
                      context.read<ProductsCubit>().refreshProducts();
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

  SliverFillRemaining _buildErrorState(String message, ColorScheme colorScheme) {
    return SliverFillRemaining(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductsCubit>().refreshProducts();
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
                      context.read<ProductsCubit>().loadInitialProducts();
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

  List<Widget> _buildProductsGrid(Products data, {bool isLoadingMore = false, required ColorScheme colorScheme}) {
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
                  color: colorScheme.onSurface.withOpacity(0.6),
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.sort, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
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
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final isMobile = screenWidth < 600;

                return SliverList(
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
                          child: Center(child: CupertinoActivityIndicator(color: colorScheme.primary)),
                        );
                      }
                      return null;
                    },
                    childCount:
                    hasReachedMax ? products.length : products.length + 1,
                  ),
                );
              },
            )),

      // Bottom padding
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  void _showFilterBottomSheet(BuildContext context) {
    _filterAnimationController.forward();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return AnimatedFilterSheet(
          animation: _filterScaleAnimation,
          filters: _filters,
          onFiltersChanged: (newFilters) {
            setState(() {
              _filters.clear();
              _filters.addAll(newFilters);
            });
          },
          onApply: () {
            _filterAnimationController.reverse();
            _applyFiltersAndSort();
          },
          onClear: _clearFilters,
        );
      },
    ).then((_) {
      _filterAnimationController.reset();
    });
  }

  void _showSortBottomSheet(BuildContext context) {
    _sortAnimationController.forward();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return AnimatedSortSheet(
          animation: _sortScaleAnimation,
          sortBy: _sortBy,
          sortOrder: _sortOrder,
          onSortChanged: (newSortBy, newSortOrder) {
            setState(() {
              _sortBy = newSortBy;
              _sortOrder = newSortOrder;
            });
          },
          onApply: () {
            _sortAnimationController.reverse();
            _applyFiltersAndSort();
          },
        );
      },
    ).then((_) {
      _sortAnimationController.reset();
    });
  }
}

// Анимированный чип для фильтров
class AnimatedChip extends StatefulWidget {
  final String label;
  final VoidCallback onDeleted;
  final bool isClearAll;
  final Duration delay;
  final ColorScheme colorScheme;

  const AnimatedChip({
    super.key,
    required this.label,
    required this.onDeleted,
    this.isClearAll = false,
    this.delay = Duration.zero,
    required this.colorScheme,
  });

  @override
  State<AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<AnimatedChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Chip(
          label: Text(widget.label),
          deleteIcon: widget.isClearAll
              ? const Icon(Icons.clear_all, size: 16)
              : const Icon(Icons.close, size: 16),
          onDeleted: () {
            _controller.reverse().then((_) {
              widget.onDeleted();
            });
          },
          backgroundColor:
          widget.isClearAll ? widget.colorScheme.surface : widget.colorScheme.primaryContainer,
          labelStyle: TextStyle(
            fontSize: 12,
            color: widget.isClearAll ? widget.colorScheme.onSurface.withOpacity(0.6) : widget.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

// Анимированный лист фильтров
class AnimatedFilterSheet extends StatefulWidget {
  final Animation<double> animation;
  final Map<String, dynamic> filters;
  final Function(Map<String, dynamic>) onFiltersChanged;
  final VoidCallback onApply;
  final VoidCallback onClear;

  const AnimatedFilterSheet({
    super.key,
    required this.animation,
    required this.filters,
    required this.onFiltersChanged,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<AnimatedFilterSheet> createState() => _AnimatedFilterSheetState();
}

class _AnimatedFilterSheetState extends State<AnimatedFilterSheet> {
  late Map<String, dynamic> _currentFilters;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final FocusNode _minPriceFocusNode = FocusNode();
  final FocusNode _maxPriceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentFilters = Map<String, dynamic>.from(widget.filters);
    _updatePriceControllers();

    // Слушатели для ручного ввода цен
    _minPriceController.addListener(_onMinPriceChanged);
    _maxPriceController.addListener(_onMaxPriceChanged);
  }

  void _updatePriceControllers() {
    final priceRange = _currentFilters['priceRange'] as Map<String, dynamic>;
    _minPriceController.text = priceRange['min'].toString();
    _maxPriceController.text = priceRange['max'].toString();
  }

  void _onMinPriceChanged() {
    final text = _minPriceController.text;
    if (text.isNotEmpty) {
      final minPrice = int.tryParse(text) ?? 0;
      final currentMax = (_currentFilters['priceRange'] as Map<String, dynamic>)['max'] as int;

      if (minPrice <= currentMax) {
        setState(() {
          _currentFilters['priceRange'] = {
            'min': minPrice,
            'max': currentMax,
          };
        });
        widget.onFiltersChanged(_currentFilters);
      }
    }
  }

  void _onMaxPriceChanged() {
    final text = _maxPriceController.text;
    if (text.isNotEmpty) {
      final maxPrice = int.tryParse(text) ?? 100000;
      final currentMin = (_currentFilters['priceRange'] as Map<String, dynamic>)['min'] as int;

      if (maxPrice >= currentMin) {
        setState(() {
          _currentFilters['priceRange'] = {
            'min': currentMin,
            'max': maxPrice,
          };
        });
        widget.onFiltersChanged(_currentFilters);
      }
    }
  }

  void _updatePriceRange(RangeValues values) {
    setState(() {
      _currentFilters['priceRange'] = {
        'min': values.start.round(),
        'max': values.end.round(),
      };
    });
    _updatePriceControllers();
    widget.onFiltersChanged(_currentFilters);
  }

  void _updateInStock(bool value) {
    setState(() {
      _currentFilters['inStock'] = value;
    });
    widget.onFiltersChanged(_currentFilters);
  }

  void _updateRating(double value) {
    setState(() {
      _currentFilters['rating'] = value.round();
    });
    widget.onFiltersChanged(_currentFilters);
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minPriceFocusNode.dispose();
    _maxPriceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priceRange = _currentFilters['priceRange'] as Map<String, dynamic>;

    return ScaleTransition(
      scale: widget.animation,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
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
                  bottom: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
                ),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.filter, size: 24, color: colorScheme.onSurface),
                  const SizedBox(width: 12),
                  Text(
                    'Фильтры',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onClear,
                    child: Text('Сбросить', style: TextStyle(color: colorScheme.primary)),
                  ),
                  IconButton(
                    icon: Icon(Iconsax.close_circle, color: colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price range filter
                    _buildAnimatedPriceRangeFilter(priceRange, colorScheme),

                    const SizedBox(height: 32),

                    // Availability filter
                    _buildAnimatedAvailabilityFilter(colorScheme),

                    const SizedBox(height: 32),

                    // Rating filter
                    _buildAnimatedRatingFilter(colorScheme),
                  ],
                ),
              ),
            ),
            // Apply button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
                color: colorScheme.surface,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AnimatedApplyButton(
                  onPressed: () {
                    widget.onApply();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedPriceRangeFilter(Map<String, dynamic> priceRange, ColorScheme colorScheme) {
    return AnimatedFilterSection(
      title: 'Цена, ₽',
      icon: Iconsax.tag,
      child: Column(
        children: [
          const SizedBox(height: 16),
          AnimatedRangeSlider(
            values: RangeValues(
              priceRange['min'].toDouble(),
              priceRange['max'].toDouble(),
            ),
            onChanged: _updatePriceRange,
          ),
          const SizedBox(height: 16),

          // Ручной ввод цен
          Row(
            children: [
              Expanded(
                child: _buildPriceInputField(
                  controller: _minPriceController,
                  focusNode: _minPriceFocusNode,
                  hintText: 'Мин. цена',
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPriceInputField(
                  controller: _maxPriceController,
                  focusNode: _maxPriceFocusNode,
                  hintText: 'Макс. цена',
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              AnimatedPriceChip(
                price: priceRange['min'],
                isMin: true,
                colorScheme: colorScheme,
              ),
              const Spacer(),
              AnimatedPriceChip(
                price: priceRange['max'],
                isMin: false,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required ColorScheme colorScheme,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        suffixText: '₽',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: TextStyle(color: colorScheme.onSurface),
    );
  }

  Widget _buildAnimatedAvailabilityFilter(ColorScheme colorScheme) {
    return AnimatedFilterSection(
      title: 'Наличие',
      icon: Iconsax.box,
      child: const SizedBox(height: 8),
      trailing: AnimatedSwitch(
        value: _currentFilters['inStock'] == true,
        onChanged: _updateInStock,
        colorScheme: colorScheme,
      ),
    );
  }

  Widget _buildAnimatedRatingFilter(ColorScheme colorScheme) {
    return AnimatedFilterSection(
      title: 'Минимальный рейтинг',
      icon: Iconsax.star,
      child: Column(
        children: [
          const SizedBox(height: 16),
          AnimatedRatingSlider(
            value: (_currentFilters['rating'] as num).toDouble(),
            onChanged: _updateRating,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          AnimatedRatingStars(
            rating: _currentFilters['rating'],
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class AnimatedSortSheet extends StatefulWidget {
  final Animation<double> animation;
  final String sortBy;
  final String sortOrder;
  final Function(String, String) onSortChanged;
  final VoidCallback onApply;

  const AnimatedSortSheet({
    super.key,
    required this.animation,
    required this.sortBy,
    required this.sortOrder,
    required this.onSortChanged,
    required this.onApply,
  });

  @override
  State<AnimatedSortSheet> createState() => _AnimatedSortSheetState();
}

class _AnimatedSortSheetState extends State<AnimatedSortSheet> {
  late String _currentSortBy;
  late String _currentSortOrder;

  @override
  void initState() {
    super.initState();
    _currentSortBy = widget.sortBy;
    _currentSortOrder = widget.sortOrder;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sortOptions = {
      'name': {'label': 'Название', 'icon': Iconsax.text},
      'price': {'label': 'Цена', 'icon': Iconsax.tag},
      'rating': {'label': 'Рейтинг', 'icon': Iconsax.star},
      'createdAt': {'label': 'Дата добавления', 'icon': Iconsax.calendar},
    };

    // Рассчитываем безопасную высоту с учетом NavigationShell
    final safeHeight = _calculateSafeHeight(context);

    return ScaleTransition(
      scale: widget.animation,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: safeHeight,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок с кнопкой закрытия
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    'Сортировка',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Iconsax.close_circle, color: colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceVariant,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),

            // Опции сортировки
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...sortOptions.entries.map((entry) {
                      return AnimatedSortOption(
                        label: entry.value['label'] as String,
                        icon: entry.value['icon'] as IconData,
                        value: entry.key,
                        groupValue: _currentSortBy,
                        onChanged: (value) {
                          setState(() {
                            _currentSortBy = value;
                          });
                          widget.onSortChanged(
                              _currentSortBy, _currentSortOrder);
                        },
                        delay: Duration(
                            milliseconds:
                            sortOptions.entries.toList().indexOf(entry) *
                                100),
                        colorScheme: colorScheme,
                      );
                    }).toList(),

                    const SizedBox(height: 16),
                    Divider(color: colorScheme.outline.withOpacity(0.3)),
                    const SizedBox(height: 16),

                    // Порядок сортировки
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedSortOrderOption(
                            label: 'По возрастанию',
                            value: 'asc',
                            groupValue: _currentSortOrder,
                            onChanged: (value) {
                              setState(() {
                                _currentSortOrder = value;
                              });
                              widget.onSortChanged(
                                  _currentSortBy, _currentSortOrder);
                            },
                            delay: const Duration(milliseconds: 400),
                            colorScheme: colorScheme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedSortOrderOption(
                            label: 'По убыванию',
                            value: 'desc',
                            groupValue: _currentSortOrder,
                            onChanged: (value) {
                              setState(() {
                                _currentSortOrder = value;
                              });
                              widget.onSortChanged(
                                  _currentSortBy, _currentSortOrder);
                            },
                            delay: const Duration(milliseconds: 500),
                            colorScheme: colorScheme,
                          ),
                        ),
                      ],
                    ),

                    // Добавляем отступ снизу для безопасности
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Кнопка применения
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: AnimatedApplyButton(
                onPressed: () {
                  widget.onApply();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateSafeHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final paddingTop = mediaQuery.padding.top;
    final paddingBottom = mediaQuery.padding.bottom;

    // Предполагаемая высота NavigationShell (обычно 60-80 пикселей)
    const navigationShellHeight = 80.0;

    // Безопасная высота: общая высота минус верхний паддинг, нижний паддинг и навигация
    final safeHeight =
        screenHeight - paddingTop - paddingBottom - navigationShellHeight - 20;

    // Ограничиваем максимальную высоту (не более 80% экрана)
    return safeHeight.clamp(400.0, screenHeight * 0.8);
  }
}

// Анимированные компоненты
class AnimatedFilterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const AnimatedFilterSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (trailing != null) ...[
                const Spacer(),
                trailing!,
              ],
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class AnimatedRangeSlider extends StatefulWidget {
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  const AnimatedRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
  });

  @override
  State<AnimatedRangeSlider> createState() => _AnimatedRangeSliderState();
}

class _AnimatedRangeSliderState extends State<AnimatedRangeSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late RangeValues _animatedValues;

  @override
  void initState() {
    super.initState();
    _animatedValues = widget.values;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(AnimatedRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return RangeSlider(
          values: widget.values,
          min: 0,
          max: 100000,
          divisions: 100,
          activeColor: colorScheme.primary,
          inactiveColor: colorScheme.surfaceVariant,
          onChanged: widget.onChanged,
        );
      },
    );
  }
}

class AnimatedPriceChip extends StatelessWidget {
  final int price;
  final bool isMin;
  final ColorScheme colorScheme;

  const AnimatedPriceChip({
    super.key,
    required this.price,
    required this.isMin,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMin ? Iconsax.arrow_down : Iconsax.arrow_up,
            size: 14,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            '$price ₽',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;

  const AnimatedSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  State<AnimatedSwitch> createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    if (widget.value) _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: Container(
        width: 50,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: widget.value ? widget.colorScheme.primary : widget.colorScheme.surfaceVariant,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment:
          widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedRatingSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final ColorScheme colorScheme;

  const AnimatedRatingSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  }) : super(key: key);

  @override
  State<AnimatedRatingSlider> createState() => _AnimatedRatingSliderState();
}

class _AnimatedRatingSliderState extends State<AnimatedRatingSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Slider(
          value: widget.value,
          min: 0,
          max: 5,
          divisions: 5,
          activeColor: Colors.amber,
          inactiveColor: widget.colorScheme.surfaceVariant,
          label: widget.value == 0 ? 'Любой' : '${widget.value}+',
          onChanged: widget.onChanged,
        );
      },
    );
  }
}

class AnimatedRatingStars extends StatelessWidget {
  final int rating;
  final ColorScheme colorScheme;

  const AnimatedRatingStars({
    Key? key,
    required this.rating,
    required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + index * 100),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            index < rating ? Iconsax.star1 : Iconsax.star,
            size: 20,
            color: index < rating ? Colors.amber : colorScheme.surfaceVariant,
          ),
        );
      }),
    );
  }
}

class AnimatedSortOption extends StatefulWidget {
  final String label;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final Duration delay;
  final ColorScheme colorScheme;

  const AnimatedSortOption({
    Key? key,
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.delay = Duration.zero,
    required this.colorScheme,
  }) : super(key: key);

  @override
  State<AnimatedSortOption> createState() => _AnimatedSortOptionState();
}

class _AnimatedSortOptionState extends State<AnimatedSortOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == widget.groupValue;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected ? widget.colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? widget.colorScheme.primary : widget.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: RadioListTile<String>(
            title: Row(
              children: [
                Icon(widget.icon, size: 18, color: widget.colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 12),
                Text(widget.label, style: TextStyle(color: widget.colorScheme.onSurface)),
              ],
            ),
            value: widget.value,
            groupValue: widget.groupValue,
            onChanged: (value) => widget.onChanged(value!),
            activeColor: widget.colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }
}

class AnimatedSortOrderOption extends StatefulWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final Duration delay;
  final ColorScheme colorScheme;

  const AnimatedSortOrderOption({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.delay = Duration.zero,
    required this.colorScheme,
  });

  @override
  State<AnimatedSortOrderOption> createState() =>
      _AnimatedSortOrderOptionState();
}

class _AnimatedSortOrderOptionState extends State<AnimatedSortOrderOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == widget.groupValue;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () => widget.onChanged(widget.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? widget.colorScheme.primary : widget.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? widget.colorScheme.primary : widget.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: isSelected ? widget.colorScheme.onPrimary : widget.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedApplyButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedApplyButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<AnimatedApplyButton> createState() => _AnimatedApplyButtonState();
}

class _AnimatedApplyButtonState extends State<AnimatedApplyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.tick_circle, size: 20),
            SizedBox(width: 8),
            Text(
              'Применить',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}