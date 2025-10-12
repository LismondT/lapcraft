import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/category.dart';
import '../cubits/category_cubit.dart';
import '../cubits/category_state.dart';
import '../widgets/categories_grid.dart';

class SubcategoriesPage extends StatefulWidget {
  final String parentId;
  final String? parentName;

  const SubcategoriesPage({
    super.key,
    required this.parentId,
    this.parentName,
  });

  @override
  State<SubcategoriesPage> createState() => _SubcategoriesPageState();
}

class _SubcategoriesPageState extends State<SubcategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().loadSubcategories(widget.parentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parentName ?? 'Подкатегории'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Кнопка для переключения между видами (сетка/дерево)
          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              return PopupMenuButton<SubcategoriesViewMode>(
                onSelected: (mode) => _switchViewMode(context, mode),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: SubcategoriesViewMode.grid,
                    child: Row(
                      children: [
                        Icon(Icons.grid_view),
                        SizedBox(width: 8),
                        Text('Сетка'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: SubcategoriesViewMode.tree,
                    child: Row(
                      children: [
                        Icon(Icons.account_tree),
                        SizedBox(width: 8),
                        Text('Дерево'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          return switch (state) {
            Initial() => _buildInitialState(),
            Loading() => _buildLoadingState(),
            SubcategoriesLoaded(:final categories, :final parentId)
                when parentId == widget.parentId =>
              _buildContent(categories),
            Error(:final message) => _buildErrorState(message),
            _ => _buildEmptyState(),
          };
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Загрузка подкатегорий...'),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildContent(List<Category> categories) {
    if (categories.isEmpty) {
      return _buildEmptyState();
    }

    // Используем вид по умолчанию или сохраненный выбор пользователя
    return _buildSubcategoriesView(categories);
  }

  Widget _buildSubcategoriesView(List<Category> categories) {
    // Можно добавить логику для сохранения выбора вида
    // Пока используем сетку как вид по умолчанию
    return CategoriesGrid(categories: categories);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.category_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Нет подкатегорий',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'В категории "${widget.parentName ?? ''}" нет подкатегорий',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Переход к товарам родительской категории
              context.go(
                '/products?category=${widget.parentId}',
                extra: {'categoryName': widget.parentName},
              );
            },
            child: const Text('Посмотреть товары'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Ошибка загрузки',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CategoryCubit>().loadSubcategories(widget.parentId);
            },
            child: const Text('Попробовать снова'),
          ),
        ],
      ),
    );
  }

  void _switchViewMode(BuildContext context, SubcategoriesViewMode mode) {
    final state = context.read<CategoryCubit>().state;
    if (state is SubcategoriesLoaded && state.parentId == widget.parentId) {
      // Здесь можно добавить логику для смены вида
      // Например, сохранить в локальное состояние или Cubit
    }
  }
}

// Перечисление для видов отображения
enum SubcategoriesViewMode {
  grid,
  tree,
}
