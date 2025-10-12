import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/features/products/presentation/widgets/categories_grid.dart';

import '../../domain/entities/category.dart';
import '../cubits/category_cubit.dart';
import '../cubits/category_state.dart';
import '../widgets/category_tree_view.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.swap_vert),
                onPressed: () {
                  final cubit = context.read<CategoryCubit>();
                  switch (state) {
                    case CategoriesLoaded():
                      cubit.loadCategoryTree();
                    case CategoryTreeLoaded():
                      cubit.loadCategories();
                    default:
                      cubit.loadCategories();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          return switch (state) {
            Initial() => _buildInitialState(context),
            Loading() => _buildLoadingState(),
            CategoriesLoaded(:final categories) => _buildGridState(categories),
            CategoryTreeLoaded(:final categories) =>
              _buildTreeState(categories),
            SubcategoriesLoaded(:final categories, :final parentId) =>
              _buildTreeState(categories),
            Error(:final message) => _buildErrorState(message, context),
          };
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Выберите режим отображения'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.read<CategoryCubit>().loadCategories(),
                child: const Text('Сетка'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () =>
                    context.read<CategoryCubit>().loadCategoryTree(),
                child: const Text('Дерево'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildGridState(List<Category> categories) {
    return CategoriesGrid(categories: categories);
  }

  Widget _buildTreeState(List<Category> categories) {
    return CategoryTreeView(categories: categories);
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ошибка: $message'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<CategoryCubit>().loadCategories(),
            child: const Text('Попробовать снова'),
          ),
        ],
      ),
    );
  }
}
