
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lapcraft/core/widgets/scaffold_with_bottom_navbar.dart';
import 'package:lapcraft/dependencies_injection.dart';
import 'package:lapcraft/features/features.dart';

enum Routes {
  root("/"),

  products("/products"),
  favorites("/favorites"),
  cart("/cart"),
  profile("/profile")
  ;


  const Routes(this.path);

  final String path;
}


class AppRouter {
  static final _rootNavigationKey = GlobalKey<NavigatorState>();
  static final _shellNavigationKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigationKey,
    initialLocation: Routes.products.path,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigationKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.products.path,
            builder: (_, __) => BlocProvider(
              create: (context) => sl<ProductsCubit>()..fetchProducts((0, 10)),
              child: const ProductsPage(),
            ),
          ),
          GoRoute(
            path: Routes.favorites.path,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const Center(child: Text('Страница избранного'))
            ),
          ),
          GoRoute(
            path: Routes.cart.path,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const Center(child: Text('Страница корзины'))
            ),
          ),
          GoRoute(
            path: Routes.profile.path,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const Center(child: Text('Страница профиля'))
            ),
          )
        ]
      )
    ]
  );

}