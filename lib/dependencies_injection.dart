import 'package:get_it/get_it.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/cart/data/datasources/cart_datasource.dart';
import 'package:lapcraft/features/cart/data/datasources/cart_debug_datasource.dart';
import 'package:lapcraft/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:lapcraft/features/cart/domain/repositories/cart_repository.dart';
import 'package:lapcraft/features/cart/domain/usecases/get_cart_items.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/data/datasources/category_debug_datasource.dart';
import 'package:lapcraft/features/products/data/datasources/category_remote_datasource.dart';
import 'package:lapcraft/features/products/data/repositories/category_repository_impl.dart';
import 'package:lapcraft/features/products/domain/usecases/get_categories.dart';
import 'package:lapcraft/features/products/domain/usecases/get_category_tree.dart';
import 'package:lapcraft/features/products/domain/usecases/get_subcategories.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_cubit.dart';

import 'features/cart/domain/usecases/add_cart_item.dart';
import 'features/cart/domain/usecases/remove_cart_item.dart';
import 'features/cart/presentation/cubits/cart_cubit.dart';
import 'features/products/presentation/cubits/products_cubit.dart';

GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  sl.registerSingleton<DioClient>(DioClient());
  _dataSources();
  _repositories();
  _useCases();
  _cubits();
}

void _dataSources() {
  sl.registerLazySingleton<CategoryRemoteDatasource>(
      () => CategoryDebugDatasource());
  sl.registerLazySingleton<ProductsDatasource>(
      () => ProductsDebugDatasourceImpl(20));
  sl.registerLazySingleton<CartDatasource>(() => CartDebugDatasourceImpl(sl()));
}

void _repositories() {
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
}

void _useCases() {
  // Products
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetCategoryTree(sl()));
  sl.registerLazySingleton(() => GetSubcategories(sl()));
  sl.registerLazySingleton(() => GetProduct(sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));

  // Cart
  sl.registerLazySingleton(() => GetCartItems(sl()));
  sl.registerLazySingleton(() => AddCartItem(sl()));
  sl.registerLazySingleton(() => RemoveCartItem(sl()));
}

void _cubits() {
  sl.registerFactory(() => CategoryCubit(
      getCategories: sl(), getCategoryTree: sl(), getSubcategories: sl()));
  sl.registerFactory(() => ProductsCubit(sl()));
  sl.registerFactory(() => CartCubit(sl(), sl(), sl()));
}
