
import 'package:lapcraft/features/products/products.dart';

sealed class ProductsState {}

class ProductsStateInitial extends ProductsState {}

class ProductsStateLoading extends ProductsState {}

class ProductsStateSuccess extends ProductsState {
  final Products data;
  ProductsStateSuccess(this.data);
}

class ProductsStateFailure extends ProductsState {
  final String message;
  ProductsStateFailure(this.message);
}

class ProductsStateEmpty extends ProductsState {}

class ProductsStateRefreshing extends ProductsState {
  final Products products;

  ProductsStateRefreshing(this.products);
}