import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../domain/entities/category.dart';
import '../cubits/category_cubit.dart';
import '../cubits/category_state.dart';
import '../widgets/category_card.dart';

class SubcategoriesPage extends StatefulWidget {
  final String parentId;
  final String? parentName;
  final Category? parentCategory;

  const SubcategoriesPage({
    super.key,
    required this.parentId,
    this.parentName,
    this.parentCategory,
  });

  @override
  State<SubcategoriesPage> createState() => _SubcategoriesPageState();
}

class _SubcategoriesPageState extends State<SubcategoriesPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSubcategories();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadSubcategories() {
    final currentState = context.read<CategoryCubit>().state;
    if (currentState is! SubcategoriesLoaded ||
        currentState.parentId != widget.parentId) {
      context.read<CategoryCubit>().loadSubcategories(widget.parentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, __) {
        if (didPop) {
          context.read<CategoryCubit>().clearSubcategoriesCache();
          context.read<CategoryCubit>().returnToMainCategories();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.parentName ?? 'Подкатегории',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: innerBoxIsScrolled ? 16 : 20,
                    ),
                  ),
                  background: _buildHeader(context),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.arrow_left_2,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.search_normal,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () {
                      // TODO: Implement search
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ];
          },
          body: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildContent(state, context),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.9),
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.parentCategory?.icon != null)
                  Text(
                    widget.parentCategory!.icon!,
                    style: const TextStyle(fontSize: 40),
                  ),
                const SizedBox(height: 12),
                if (widget.parentCategory?.description != null)
                  Text(
                    widget.parentCategory!.description!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CategoryState state, BuildContext context) {
    return switch (state) {
      Initial() => _buildLoadingState(),
      Loading() => _buildLoadingState(),
      SubcategoriesLoaded(:final categories, :final parentId)
          when parentId == widget.parentId =>
        _buildSubcategoriesGrid(categories),
      Error(:final message) => _buildErrorState(message),
      _ => _buildEmptyState(),
    };
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Загрузка подкатегорий...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesGrid(List<Category> categories) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CategoryCubit>().clearCache();
        await context.read<CategoryCubit>().loadSubcategories(widget.parentId);
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  Text(
                    '${categories.length} подкатегорий',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  _buildViewAllProductsButton(context),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categories[index];
                  return AnimatedCategoryCard(
                    category: category,
                    index: index,
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildViewAllProductsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(
          '/products?category=${widget.parentId}',
          extra: {'categoryName': widget.parentName},
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Все товары',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Iconsax.arrow_right_3,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.folder_open,
                size: 60,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Нет подкатегорий',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'В категории "${widget.parentName ?? ''}" нет подкатегорий',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildViewAllProductsButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.close_circle,
                size: 60,
                color: Theme.of(context).colorScheme.error,
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Iconsax.refresh),
              label: const Text('Попробовать снова'),
              onPressed: _loadSubcategories,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
