import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapcraft/features/features.dart';
import 'package:lapcraft/features/products/presentation/cubits/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProduct getProduct;

  late final Product? _product;

  ProductCubit({required this.getProduct}) : super(ProductState.initial());

  Future<void> load(String productId) async {
    emit(const ProductState.loading());

    final result = await getProduct(productId);

    result.fold((failure) => emit(ProductState.error(failure.toString())),
        (product) {
      _product = product;
      emit(ProductState.loaded(product));
    });
  }

  void update() {
    if (_product == null) {
      return;
    }
    emit(ProductState.loaded(_product));
  }
}
