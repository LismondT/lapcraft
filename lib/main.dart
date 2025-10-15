import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/dependencies_injection.dart';
import 'package:lapcraft/features/favorites/presentation/cubits/favorites_cubit.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_cubit.dart';
import 'package:lapcraft/features/products/presentation/cubits/products_cubit.dart';

import 'features/cart/presentation/cubits/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<CategoryCubit>()..loadCategories()),
        BlocProvider(create: (context) => sl<CartCubit>()..loadCart()),
        BlocProvider(
            create: (context) => sl<FavoritesCubit>()..loadFavorites()),
        BlocProvider(create: (context) => sl<ProductsCubit>()),
      ],
      child: MaterialApp.router(
          title: 'Lapcraft',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepOrange, brightness: Brightness.light),
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router),
    );
  }
}
