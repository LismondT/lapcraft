import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lapcraft/core/widgets/scaffold_with_bottom_navbar.dart';
import 'package:lapcraft/features/cart/pages/cart_page/cart_page.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_cubit.dart';
import 'package:lapcraft/features/products/presentation/pages/categories_page.dart';
import 'package:lapcraft/features/products/presentation/pages/subcategories_page.dart';

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

  String withPathParameter(String parameter) => "$path/$parameter";
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
                pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const Center(child: Text('Страница избранного'))),
              ),
              GoRoute(
                path: Routes.cart.path,
                builder: (_, __) => const CartPage(),
              ),
              GoRoute(
                path: Routes.profile.path,
                pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const Center(child: Text('Страница профиля'))),
              )
            ]),
        GoRoute(
            path: Routes.subcategories.withPathParameter(':parentId'),
            builder: (context, state) {
              final parentId = state.pathParameters['parentId']!;
              return BlocProvider.value(
                value: context.read<CategoryCubit>()
                  ..loadSubcategories(parentId),
                child: SubcategoriesPage(parentId: parentId),
              );
            }),
        GoRoute(path: '/', redirect: (context, state) => Routes.categories.path)
      ]);
}
