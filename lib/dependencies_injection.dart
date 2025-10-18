import 'package:get_it/get_it.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/cart/data/datasources/cart_datasource.dart';
import 'package:lapcraft/features/cart/data/datasources/cart_debug_datasource.dart';
import 'package:lapcraft/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:lapcraft/features/cart/domain/repositories/cart_repository.dart';
import 'package:lapcraft/features/cart/domain/usecases/clear_cart.dart';
import 'package:lapcraft/features/cart/domain/usecases/get_cart_items.dart';
import 'package:lapcraft/features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'package:lapcraft/features/favorites/data/datasources/remote/favorites_mock_datasource.dart';
import 'package:lapcraft/features/favorites/data/datasources/remote/favorites_remote_datasource.dart';
import 'package:lapcraft/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:lapcraft/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lapcraft/features/favorites/domain/usecases/add_to_favorites.dart';
import 'package:lapcraft/features/favorites/domain/usecases/get_favorites.dart';
import 'package:lapcraft/features/favorites/domain/usecases/is_favorite.dart';
import 'package:lapcraft/features/favorites/domain/usecases/remove_from_favorites.dart';
import 'package:lapcraft/features/favorites/presentation/cubits/favorites_cubit.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/data/datasources/category_debug_datasource.dart';
import 'package:lapcraft/features/products/data/datasources/category_remote_datasource.dart';
import 'package:lapcraft/features/products/data/repositories/category_repository_impl.dart';
import 'package:lapcraft/features/products/domain/usecases/get_categories.dart';
import 'package:lapcraft/features/products/domain/usecases/get_category_tree.dart';
import 'package:lapcraft/features/products/domain/usecases/get_subcategories.dart';
import 'package:lapcraft/features/products/presentation/cubits/category_cubit.dart';
import 'package:lapcraft/features/products/presentation/cubits/product_cubit.dart';
import 'package:lapcraft/features/profile/data/datasource/remote/auth_mock_datasource.dart';
import 'package:lapcraft/features/profile/data/datasource/remote/auth_remote_datasource.dart';
import 'package:lapcraft/features/profile/data/repositories/auth_repository_impl.dart';
import 'package:lapcraft/features/profile/domain/repositories/auth_repository.dart';
import 'package:lapcraft/features/profile/domain/usecases/check_auth.dart';
import 'package:lapcraft/features/profile/domain/usecases/get_current_user.dart';
import 'package:lapcraft/features/profile/domain/usecases/login.dart';
import 'package:lapcraft/features/profile/domain/usecases/logout.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';

import 'features/cart/domain/usecases/add_cart_item.dart';
import 'features/cart/domain/usecases/remove_cart_item.dart';
import 'features/cart/presentation/cubits/cart_cubit.dart';
import 'features/products/presentation/cubits/products_cubit.dart';
import 'features/profile/domain/usecases/register.dart';

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
  sl.registerLazySingleton<FavoritesRemoteDatasource>(
      () => FavoritesMockDatasource(productsDatasource: sl()));
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthMockDatasource());
}

void _repositories() {
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(remoteDatasource: sl()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(dataSource: sl()));
}

void _useCases() {
  // Products
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetCategoryTree(sl()));
  sl.registerLazySingleton(() => GetSubcategories(sl()));
  sl.registerLazySingleton(() => GetProduct(repository: sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));

  // Cart
  sl.registerLazySingleton(() => GetCartItems(sl()));
  sl.registerLazySingleton(() => AddCartItem(sl()));
  sl.registerLazySingleton(() => RemoveCartItem(sl()));
  sl.registerLazySingleton(() => UpdateCartItemQuantity(sl()));
  sl.registerLazySingleton(() => ClearCart(sl()));

  // Favorites
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddToFavorites(sl()));
  sl.registerLazySingleton(() => RemoveFromFavorites(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));

  // Auth
  sl.registerLazySingleton(() => CheckAuth(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
}

void _cubits() {
  // Products
  sl.registerFactory(() => CategoryCubit(
      getCategories: sl(), getCategoryTree: sl(), getSubcategories: sl()));
  sl.registerFactory(() => ProductsCubit(sl()));
  sl.registerFactory(() => ProductCubit(getProduct: sl()));

  //Favorites
  sl.registerFactory(() => FavoritesCubit(
      getFavorites: sl(),
      addToFavorites: sl(),
      removeFromFavorites: sl(),
      isFavorite: sl()));

  // Cart
  sl.registerFactory(() => CartCubit(sl(), sl(), sl(), sl(), sl()));

  // Profile
  sl.registerFactory(() => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      checkAuthUseCase: sl(),
      logoutUseCase: sl()));
}
