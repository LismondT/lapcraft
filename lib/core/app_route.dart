import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lapcraft/core/widgets/scaffold_with_bottom_navbar.dart';
import 'package:lapcraft/features/favorites/presentation/pages/favorites_page.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_cubit.dart';
import 'package:lapcraft/features/products/presentation/pages/categories_page.dart';
import 'package:lapcraft/features/products/presentation/pages/products_page.dart';
import 'package:lapcraft/features/products/presentation/pages/subcategories_page.dart';

import '../features/cart/presentation/pages/cart_page.dart';

enum Routes {
  root("/"),
  categories("/categories"),
  subcategories("/subcategories"),
  products("/products"),
  favorites("/favorites"),
  cart("/cart"),
  profile("/profile");

  const Routes(this.path);

  final String path;

  String withParameter(String parameter) => "$path/$parameter";

  String withQuery(String key, {String? value}) {
    String result = '$path?$key';

    if (value != null) {
      result += '=$value';
    }

    return result;
  }
}

class AppRouter {
  static final _rootNavigationKey = GlobalKey<NavigatorState>();
  static final _shellNavigationKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
      navigatorKey: _rootNavigationKey,
      initialLocation: Routes.categories.path,
      routes: [
        ShellRoute(
            navigatorKey: _shellNavigationKey,
            builder: (context, state, child) {
              return ScaffoldWithBottomNavBar(child: child);
            },
            routes: [
              GoRoute(
                  path: Routes.categories.path,
                  builder: (context, state) => const CategoriesPage()),
              GoRoute(
                path: Routes.favorites.path,
                builder: (context, state) => const FavoritesPage(),
              ),
              GoRoute(
                path: Routes.cart.path,
                builder: (context, state) => const CartPage(),
              ),
              GoRoute(
                path: Routes.profile.path,
                pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const Center(child: Text('Страница профиля'))),
              ),
              GoRoute(
                  path: Routes.subcategories.withParameter(':parentId'),
                  builder: (context, state) {
                    final parentId = state.pathParameters['parentId']!;
                    return BlocProvider.value(
                      value: context.read<CategoryCubit>()
                        ..loadSubcategories(parentId),
                      child: SubcategoriesPage(parentId: parentId),
                    );
                  }),
              GoRoute(
                  path: Routes.products.path,
                  builder: (context, state) {
                    //ToDo Добавить обработку параметров
                    return const ProductsPage();
                  }),
            ]),
        GoRoute(path: '/', redirect: (context, state) => Routes.categories.path)
      ]);
}
