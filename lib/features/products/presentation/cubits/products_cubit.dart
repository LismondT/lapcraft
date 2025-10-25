import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/products/presentation/cubits/products_cubit_states.dart';
import 'package:lapcraft/features/products/products.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._getProducts) : super(ProductsStateLoading());

  final int pageSize = 10;

  int _currentPage = 1;
  int _lastPage = 1;
  final List<Product> _products = [];
  bool _isLoading = false;

  final GetProducts _getProducts;

  bool get hasReachedMax => _currentPage >= _lastPage;

  Future<void> loadInitialProducts() async {
    if (_isLoading) return;

    _isLoading = true;
    _currentPage = 1;
    _lastPage = 1;
    _products.clear();

    emit(ProductsStateLoading());
    await _fetchProducts((_currentPage, pageSize));
  }

  Future<void> loadNextPage() async {
    if (_isLoading || hasReachedMax) return;

    _isLoading = true;
    _currentPage++;

    await _fetchProducts((_currentPage, pageSize));
  }

  Future<void> refreshProducts() async {
    if (_isLoading) return;

    _isLoading = true;
    emit(ProductsStateRefreshing(Products(
        currentPage: _currentPage,
        totalPages: _lastPage,
        products: _products)));

    _currentPage = 1;
    _lastPage = 1;
    _products.clear();

    await _fetchProducts((_currentPage, pageSize));
  }

  Future<void> _fetchProducts((int page, int size) params) async {
    try {
      final data = await _getProducts(params);

      data.fold((failure) {
        _isLoading = false;
        if (failure is NoDataFailure && _products.isEmpty) {
          emit(ProductsStateEmpty());
        } else if (failure is ServerFailure) {
          emit(ProductsStateFailure(failure.toString()));
        } else if (_products.isNotEmpty) {
          emit(ProductsStateSuccess(Products(
              currentPage: _currentPage - 1,
              totalPages: _lastPage,
              products: _products)));
        } else {
          emit(ProductsStateFailure("Неизвестная ошибка"));
        }
      }, (response) {
        _isLoading = false;
        _products.addAll(response.products ?? []);
        _currentPage = response.currentPage ?? _currentPage;
        _lastPage = response.totalPages ?? _lastPage;

        final updatedProducts = Products(
          currentPage: _currentPage,
          totalPages: _lastPage,
          products: _products,
        );

        if (_products.isEmpty) {
          emit(ProductsStateEmpty());
        } else {
          emit(ProductsStateSuccess(updatedProducts));
        }
      });
    } catch (error) {
      _isLoading = false;
      emit(ProductsStateFailure("Unexpected error: $error"));
    }
  }

  void applyFiltersAndSort({
    required Map<String, dynamic> filters,
    required String sortBy,
    required String sortOrder,
  }) {
    // Здесь реализуйте логику применения фильтров и сортировки
    // к вашим данным
    // Это может включать вызов API с параметрами или локальную фильтрацию
  }

  void reset() {
    _currentPage = 1;
    _lastPage = 1;
    _products.clear();
    _isLoading = false;
    emit(ProductsStateInitial());
  }
}
