import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/products/products.dart';

import './products_cubit_states.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._getProducts) : super(ProductsStateLoading());

  final int pageSize = 3;

  int currentPage = 1;
  int lastPage = 1;
  final List<Product> products = [];

  final GetProducts _getProducts;

  Future<void> nextPage() async {
    if (currentPage < lastPage) {
      currentPage++;
      await fetchProducts((currentPage, pageSize));
    }
  }

  Future<void> fetchProducts((int page, int size) params) async {
    if (currentPage == 1) emit(ProductsStateLoading());

    final data = await _getProducts.call(params);

    data.fold((l) {
      if (l is ServerFailure) {
        emit(ProductsStateFailure(l.message ?? ""));
      } else if (l is NoDataFailure) {
        emit(ProductsStateEmpty());
      }
    }, (r) {
      products.addAll(r.products ?? []);
      currentPage = r.currentPage ?? 1;
      lastPage = r.totalPages ?? 1;

      final updatedProducts = Products(
          currentPage: currentPage, totalPages: lastPage, products: products);

      if (currentPage != 1) emit(ProductsStateInitial());
      emit(ProductsStateSuccess(updatedProducts));
    });
  }
}
