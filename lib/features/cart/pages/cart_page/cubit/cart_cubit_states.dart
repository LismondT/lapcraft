import 'package:lapcraft/features/features.dart';

sealed class CartState {}

class CartStateInitial extends CartState {}

class CartStateLoading extends CartState {}

class CartStateSuccess extends CartState {
  final List<Product> products;

  CartStateSuccess(this.products);
}

class CartStateFailure extends CartState {
  final String message;

  CartStateFailure(this.message);
}

class CartStateEmpty extends CartState {}
