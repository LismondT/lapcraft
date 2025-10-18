import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lapcraft/core/widgets/scaffold_with_bottom_navbar.dart';
import 'package:lapcraft/features/favorites/presentation/pages/favorites_page.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_cubit.dart';
import 'package:lapcraft/features/products/presentation/cubits/product_cubit.dart';
import 'package:lapcraft/features/products/presentation/pages/categories_page.dart';
import 'package:lapcraft/features/products/presentation/pages/product_page.dart';
import 'package:lapcraft/features/products/presentation/pages/products_page.dart';
import 'package:lapcraft/features/products/presentation/pages/subcategories_page.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_state.dart';
import 'package:lapcraft/features/profile/presentation/pages/login_page.dart';
import 'package:lapcraft/features/profile/presentation/pages/profile_page.dart';
import 'package:lapcraft/features/profile/presentation/pages/register_page.dart';

import '../dependencies_injection.dart';
import '../features/cart/presentation/pages/cart_page.dart';

enum Routes {
  root("/"),
  // products
  categories("/categories"),
  subcategories("/subcategories"),
  products("/products"),
  product("/product"),
  // favorites
  favorites("/favorites"),
  // cart
  cart("/cart"),
  // auth
  profile("/profile"),
  register("/register"),
  login("/login");

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
      redirect: (context, state) {
        final authState = context.read<AuthCubit>().state;

        final protectedRoutes = [
          Routes.favorites.path,
          Routes.cart.path,
          Routes.profile.path,
        ];

        final isProtectedRoute = protectedRoutes
            .any((route) => state.matchedLocation.startsWith(route));

        if (isProtectedRoute && authState is! AuthAuthenticated) {
          final returnUrl = state.uri.toString();
          return Routes.login.withQuery('returnUrl', value: returnUrl);
        }

        if ((state.matchedLocation == Routes.login.path ||
                state.matchedLocation == Routes.register.path) &&
            authState is AuthAuthenticated) {
          return Routes.profile.path;
        }

        return null;
      },
      routes: [
        ShellRoute(
            navigatorKey: _shellNavigationKey,
            builder: (context, state, child) {
              return ScaffoldWithBottomNavBar(child: child);
            },
            routes: [
              // Products
              GoRoute(
                  path: Routes.categories.path,
                  builder: (context, state) => const CategoriesPage()),
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
                  path: Routes.product.withParameter(':productId'),
                  builder: (context, state) {
                    final productId = state.pathParameters['productId']!;
                    return BlocProvider(
                      create: (context) => sl<ProductCubit>(),
                      child: ProductPage(productId: productId),
                    );
                  }),
              GoRoute(
                  path: Routes.products.path,
                  builder: (context, state) {
                    //ToDo Добавить обработку параметров
                    return const ProductsPage();
                  }),

              // Favorites
              GoRoute(
                path: Routes.favorites.path,
                builder: (context, state) => const FavoritesPage(),
              ),

              // Cart
              GoRoute(
                path: Routes.cart.path,
                builder: (context, state) => const CartPage(),
              ),

              // Profile
              GoRoute(
                  path: Routes.profile.path,
                  builder: (context, state) {
                    return const ProfilePage();
                  }),
              GoRoute(
                  path: Routes.login.path,
                  builder: (context, state) {
                    final returnUrl = state.uri.queryParameters['returnUrl'];
                    return LoginPage(returnUrl: returnUrl);
                  }),
              GoRoute(
                  path: Routes.register.path,
                  builder: (context, state) {
                    final returnUrl = state.uri.queryParameters['returnUrl'];
                    return RegisterPage(returnUrl: returnUrl);
                  }),
            ]),
        GoRoute(path: '/', redirect: (context, state) => Routes.categories.path)
      ]);
}
