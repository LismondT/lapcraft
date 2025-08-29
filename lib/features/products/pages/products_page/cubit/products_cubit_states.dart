
import 'package:lapcraft/features/products/products.dart';

sealed class ProductsState {}

class ProductsStateLoading extends ProductsState {}

class ProductsStateInitial extends ProductsState {}

class ProductsStateSuccess extends ProductsState {
  final Products data;
  ProductsStateSuccess(this.data);
}

class ProductsStateFailure extends ProductsState {
  final String message;
  ProductsStateFailure(this.message);
}

class ProductsStateEmpty extends ProductsState {}