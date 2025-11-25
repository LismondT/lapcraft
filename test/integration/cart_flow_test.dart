import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/features/cart/data/datasources/cart_debug_datasource.dart';
import 'package:lapcraft/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:lapcraft/features/cart/domain/usecases/add_cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/clear_cart.dart';
import 'package:lapcraft/features/cart/domain/usecases/get_cart_items.dart';
import 'package:lapcraft/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'package:lapcraft/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:lapcraft/features/cart/presentation/cubits/cart_cubit_states.dart';
import 'package:lapcraft/features/products/data/models/product_response.dart';
import 'package:lapcraft/features/products/domain/repositories/products_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  group('Интеграционный тест потока работы с корзиной', () {
    late CartCubit cubit;
    late MockProductsRepository mockProductsRepository;

    setUp(() {
      mockProductsRepository = MockProductsRepository();

      // Настраиваем mock для успешного получения товара
      final testProduct = ProductResponse(
        id: 'test-product',
        title: 'Тестовый товар',
        description: 'Тестовое описание',
        price: 1000.0,
        imageUrls: ['https://example.com/image.jpg'],
      );

      when(() => mockProductsRepository.product('test-product'))
          .thenAnswer((_) async => Right(testProduct.toEntity()));

      final datasource = CartDebugDatasourceImpl(mockProductsRepository);
      final repository = CartRepositoryImpl(datasource);

      cubit = CartCubit(
        GetCartItems(repository),
        AddCartItem(repository),
        RemoveCartItem(repository),
        UpdateCartItemQuantity(repository),
        ClearCart(repository),
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('полный цикл работы с корзиной: добавление, обновление, удаление',
        () async {
      // 1. Начальное состояние - пустая корзина
      await cubit.loadCart();
      expect(cubit.state, isA<CartStateEmpty>());

      // 2. Добавляем товар в корзину
      await cubit.addToCart('test-product');
      await cubit.loadCart(); // Перезагружаем для обновления состояния

      expect(cubit.state, isA<CartStateSuccess>());
      expect(cubit.cartItems.length, 1);
      expect(cubit.cartItems.first.productId, 'test-product');
      expect(cubit.cartItems.first.count, 1);

      // 3. Увеличиваем количество товара
      await cubit.incrementQuantity('test-product');
      expect(cubit.getProductQuantity('test-product'), 2);

      // 4. Уменьшаем количество товара
      await cubit.decrementQuantity('test-product');
      expect(cubit.getProductQuantity('test-product'), 1);

      // 5. Удаляем товар из корзины
      await cubit.removeFromCart('test-product');
      await cubit.loadCart(); // Перезагружаем для обновления состояния

      expect(cubit.state, isA<CartStateEmpty>());
      expect(cubit.cartItems.length, 0);
    });

    test('вычисление итоговой суммы корзины', () async {
      // Добавляем несколько товаров
      await cubit.addToCart('test-product');
      await cubit
          .addToCart('test-product'); // Дублируем для увеличения количества
      await cubit.loadCart();

      // Проверяем вычисления
      expect(cubit.totalItems, 2);
      expect(cubit.totalAmount, 2000.0); // 1000 * 2
      expect(cubit.isProductInCart('test-product'), true);
    });
  });
}
