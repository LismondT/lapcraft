import 'package:get_it/get_it.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/features.dart';

GetIt sl = GetIt.instance;

Future<void> serviceLocator() async {
  sl.registerSingleton<DioClient>(DioClient());
  _dataSources();
  _repositories();
  _useCases();
  _cubits();
}

void _dataSources() {
  sl.registerLazySingleton<ProductsDatasource>(
      // () => ProductsRemoteDatasourceImpl(sl())
      () => ProductsDebugDatasourceImpl(100));
}

void _repositories() {
  sl.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(sl()));
}

void _useCases() {
  sl.registerLazySingleton(() => GetProduct(sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
}

void _cubits() {
  sl.registerFactory(() => ProductsCubit(sl()));
}
