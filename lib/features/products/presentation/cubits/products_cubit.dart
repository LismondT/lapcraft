import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/features/products/presentation/cubits/products_cubit_states.dart';
import 'package:lapcraft/features/products/products.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._getProducts) : super(ProductsStateInitial());

  final int pageSize = 10;

  int _currentPage = 0;
  int _totalProducts = 0;
  final List<Product> _products = [];
  bool _isLoading = false;
  Map<String, dynamic> _filters = {};

  final GetProducts _getProducts;

  bool get hasReachedMax => _products.length >= _totalProducts;

  Future<void> loadInitialProducts(String category) async {
    if (_isLoading) return;

    _isLoading = true;
    _currentPage = 0;
    _totalProducts = 0;
    _products.clear();

    emit(ProductsStateLoading());
    await _fetchProducts(page: 1, category: category);
  }

  Future<void> loadNextPage(String category) async {
    if (_isLoading || hasReachedMax) return;

    _isLoading = true;
    _currentPage++;

    await _fetchProducts(page: _currentPage + 1, category: category);
  }

  Future<void> refreshProducts(String category) async {
    if (_isLoading) return;

    _isLoading = true;

    // Сохраняем текущие продукты для состояния обновления
    final currentProducts = Products(
      products: List<Product>.from(_products),
      page: _currentPage,
      count: pageSize,
      total: _totalProducts,
    );

    emit(ProductsStateRefreshing(currentProducts));

    _currentPage = 0;
    _totalProducts = 0;
    _products.clear();

    await _fetchProducts(page: 1, category: category);
  }

  Future<void> _fetchProducts(
      {required int page, required String category}) async {
    try {
      final data = await _getProducts(
          page: page, count: pageSize, category: category, filters: _filters);

      data.fold((failure) {
        _isLoading = false;
        if (failure is NoDataFailure && _products.isEmpty) {
          emit(ProductsStateEmpty());
        } else if (failure is ServerFailure) {
          emit(ProductsStateFailure(failure.toString()));
        } else if (_products.isNotEmpty) {
          // При ошибке, но с существующими данными - показываем успех
          emit(ProductsStateSuccess(_createProductsObject()));
        } else {
          emit(ProductsStateFailure("Неизвестная ошибка"));
        }
      }, (response) {
        _isLoading = false;

        // Обновляем данные на основе ответа
        _products.addAll(response.products);
        _currentPage = response.page - 1; // Приводим к 0-based индексу
        _totalProducts = response.total;

        final updatedProducts = _createProductsObject();

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

  Products _createProductsObject() {
    return Products(
      products: List<Product>.from(_products),
      page: _currentPage,
      count: pageSize,
      total: _totalProducts,
    );
  }

  void applyFiltersAndSort({
    required Map<String, dynamic> filters,
    required String category
  }) {
    // При применении фильтров сбрасываем пагинацию
    _currentPage = 0;
    _totalProducts = 0;
    _products.clear();
    _isLoading = false;

    _filters = filters;

    loadInitialProducts(category);
  }

  void applySearch(String query, String category) {
    if (query.isNotEmpty) {
      _filters['name'] = query;
    } else {
      _filters.remove('name');
    }
    applyFiltersAndSort(filters: _filters, category: category);
  }

  void clearFilters(String category) {
    _filters.clear();
    applyFiltersAndSort(filters: _filters, category: category);
  }

  void reset() {
    _currentPage = 0;
    _totalProducts = 0;
    _products.clear();
    _isLoading = false;
    _filters = {};
    emit(ProductsStateInitial());
  }
}
