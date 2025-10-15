import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../domain/entities/category.dart';
import '../cubits/category_cubit.dart';
import '../cubits/category_state.dart';
import '../widgets/category_card.dart';
import '../widgets/category_tree_view.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  ViewMode _currentViewMode = ViewMode.grid;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryCubit>().loadCategories();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetSubcategoriesState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final cubit = context.read<CategoryCubit>();
    final state = cubit.state;

    // Загружаем данные только если их нет
    if (state is CategoryInitial || state is Error) {
      cubit.loadCategories();
    } else if (state is SubcategoriesLoaded) {
      // Если пришли с подкатегорий, возвращаем к основным
      cubit.returnToMainCategories();
    }
  }

  void _resetSubcategoriesState() {
    // Сбрасываем кэш подкатегорий при возврате на эту страницу
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryCubit>().clearSubcategoriesCache();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Категории',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              return _buildViewModeSwitch(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildContent(state, context),
          );
        },
      ),
    );
  }

  Widget _buildViewModeSwitch(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewModeButton(
            context,
            icon: Iconsax.grid_5,
            isActive: _currentViewMode == ViewMode.grid,
            onTap: () {
              if (_currentViewMode != ViewMode.grid) {
                setState(() => _currentViewMode = ViewMode.grid);
                context.read<CategoryCubit>().loadCategories();
              }
            },
          ),
          _buildViewModeButton(
            context,
            icon: Iconsax.category,
            isActive: _currentViewMode == ViewMode.tree,
            onTap: () {
              if (_currentViewMode != ViewMode.tree) {
                setState(() => _currentViewMode = ViewMode.tree);
                context.read<CategoryCubit>().loadCategoryTree();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(
      BuildContext context, {
        required IconData icon,
        required bool isActive,
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: isActive
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
        ),
        onPressed: onTap,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  Widget _buildContent(CategoryState state, BuildContext context) {
    return switch (state) {
      CategoryInitial() => _buildLoadingState(),
      CategoryLoading() => _buildLoadingState(),
      CategoriesLoaded(:final categories) => _buildGridState(categories),
      CategoryTreeLoaded(:final categories) => _buildTreeState(categories),
      SubcategoriesLoaded(:final categories, :final parentId) =>
          _buildTreeState(categories),
      CategoryError(:final message) => _buildErrorState(message, context),
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
            'Загрузка категорий...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridState(List<Category> categories) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CategoryCubit>().clearCache();
        await context.read<CategoryCubit>().loadCategories();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                '${categories.length} категорий',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
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

  Widget _buildTreeState(List<Category> categories) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CategoryCubit>().clearCache();
        if (_currentViewMode == ViewMode.tree) {
          await context.read<CategoryCubit>().loadCategoryTree();
        } else {
          await context.read<CategoryCubit>().loadCategories();
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return AnimatedCategoryTreeItem(
            category: category,
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
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
                Icons.error_outline_rounded,
                size: 60,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ошибка загрузки',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  context,
                  icon: Iconsax.refresh,
                  text: 'Обновить',
                  onPressed: () => context.read<CategoryCubit>().loadCategories(),
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  icon: Iconsax.support,
                  text: 'Помощь',
                  onPressed: () {
                    // TODO: Добавить обработку помощи
                  },
                  isSecondary: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onPressed,
        bool isSecondary = false,
      }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary
            ? Colors.grey[200]
            : Theme.of(context).colorScheme.primary,
        foregroundColor: isSecondary
            ? Colors.grey[800]
            : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

enum ViewMode {
  grid,
  tree,
}