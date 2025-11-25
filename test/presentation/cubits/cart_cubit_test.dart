import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/add_cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/clear_cart.dart';
import 'package:lapcraft/features/cart/domain/usecases/get_cart_items.dart';
import 'package:lapcraft/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:lapcraft/features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'package:lapcraft/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:lapcraft/features/cart/presentation/cubits/cart_cubit_states.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCartItems extends Mock implements GetCartItems {}

class MockAddCartItem extends Mock implements AddCartItem {}

class MockRemoveCartItem extends Mock implements RemoveCartItem {}

class MockUpdateCartItemQuantity extends Mock
    implements UpdateCartItemQuantity {}

class MockClearCart extends Mock implements ClearCart {}

void main() {
  late CartCubit cubit;
  late MockGetCartItems mockGetCartItems;
  late MockAddCartItem mockAddCartItem;
  late MockRemoveCartItem mockRemoveCartItem;
  late MockUpdateCartItemQuantity mockUpdateCartItemQuantity;
  late MockClearCart mockClearCart;

  final testCartItems = [
    CartItem(
      productId: '1',
      title: 'Корм для кошек',
      description: 'Премиум корм',
      price: 1500.0,
      count: 2,
    ),
    CartItem(
      productId: '2',
      title: 'Игрушка для собак',
      description: 'Прочная игрушка',
      price: 800.0,
      count: 1,
    ),
  ];

  setUp(() {
    mockGetCartItems = MockGetCartItems();
    mockAddCartItem = MockAddCartItem();
    mockRemoveCartItem = MockRemoveCartItem();
    mockUpdateCartItemQuantity = MockUpdateCartItemQuantity();
    mockClearCart = MockClearCart();

    cubit = CartCubit(
      mockGetCartItems,
      mockAddCartItem,
      mockRemoveCartItem,
      mockUpdateCartItemQuantity,
      mockClearCart,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('Cubit корзины', () {
    test('должен инициализироваться с начальным состоянием', () {
      // Assert
      expect(cubit.state, isA<CartStateInitial>());
    });

    test('должен загружать корзину и переходить в состояние успеха', () async {
      // Arrange
      when(() => mockGetCartItems(any()))
          .thenAnswer((_) async => Right(testCartItems));

      // Act
      final expectedStates = [
        CartStateLoading(),
        CartStateSuccess(testCartItems),
      ];

      // Assert
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      cubit.loadCart();
    });

    test('должен показывать пустое состояние при отсутствии товаров', () async {
      // Arrange
      when(() => mockGetCartItems(any())).thenAnswer((_) async => Right([]));

      // Act
      final expectedStates = [
        CartStateLoading(),
        CartStateEmpty(),
      ];

      // Assert
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      cubit.loadCart();
    });

    test('должен переходить в состояние ошибки при неудачной загрузке',
        () async {
      // Arrange
      when(() => mockGetCartItems(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final expectedStates = [
        CartStateLoading(),
        isA<CartStateFailure>(),
      ];

      // Assert
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      cubit.loadCart();
    });

    test('должен добавлять товар в корзину и перезагружать её', () async {
      // Arrange
      when(() => mockAddCartItem('new-product-id'))
          .thenAnswer((_) async => Right(null));
      when(() => mockGetCartItems(any()))
          .thenAnswer((_) async => Right(testCartItems));

      // Act & Assert
      await cubit.addToCart('new-product-id');

      verify(() => mockAddCartItem('new-product-id')).called(1);
      verify(() => mockGetCartItems(any())).called(1);
    });

    test('должен удалять товар из корзины и перезагружать её', () async {
      // Arrange
      when(() => mockRemoveCartItem('product-to-remove'))
          .thenAnswer((_) async => Right(null));
      when(() => mockGetCartItems(any()))
          .thenAnswer((_) async => Right(testCartItems));

      // Act & Assert
      await cubit.removeFromCart('product-to-remove');

      verify(() => mockRemoveCartItem('product-to-remove')).called(1);
      verify(() => mockGetCartItems(any())).called(1);
    });

    test('должен обновлять количество товара в корзине', () async {
      // Arrange
      when(() => mockUpdateCartItemQuantity('product-id', 3))
          .thenAnswer((_) async => Right(null));

      // Предварительно добавляем товар в локальное состояние
      cubit.cartItems.add(CartItem(
        productId: 'product-id',
        title: 'Тестовый товар',
        description: 'Описание',
        price: 1000.0,
        count: 1,
      ));

      // Act
      await cubit.updateQuantity('product-id', 3);

      // Assert
      verify(() => mockUpdateCartItemQuantity('product-id', 3)).called(1);
      expect(cubit.getProductQuantity('product-id'), 3);
    });

    test('должен увеличивать количество товара на 1', () async {
      // Arrange
      when(() => mockUpdateCartItemQuantity('product-id', 2))
          .thenAnswer((_) async => Right(null));

      // Предварительно добавляем товар
      cubit.cartItems.add(CartItem(
        productId: 'product-id',
        title: 'Тестовый товар',
        description: 'Описание',
        price: 1000.0,
        count: 1,
      ));

      // Act
      await cubit.incrementQuantity('product-id');

      // Assert
      verify(() => mockUpdateCartItemQuantity('product-id', 2)).called(1);
    });

    test('должен удалять товар при уменьшении количества до 0', () async {
      // Arrange
      when(() => mockRemoveCartItem('product-id'))
          .thenAnswer((_) async => Right(null));
      when(() => mockGetCartItems(any())).thenAnswer((_) async => Right([]));

      // Предварительно добавляем товар с количеством 1
      cubit.cartItems.add(CartItem(
        productId: 'product-id',
        title: 'Тестовый товар',
        description: 'Описание',
        price: 1000.0,
        count: 1,
      ));

      // Act
      await cubit.decrementQuantity('product-id');

      // Assert
      verify(() => mockRemoveCartItem('product-id')).called(1);
    });

    test('должен очищать корзину', () async {
      // Arrange
      when(() => mockClearCart()).thenAnswer((_) async => Right(null));

      // Act
      final expectedStates = [
        CartStateEmpty(),
      ];

      // Assert
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.clearCart();

      verify(() => mockClearCart()).called(1);
    });

    test('должен правильно вычислять общую сумму', () {
      // Arrange
      cubit.cartItems.addAll(testCartItems);

      // Act
      final total = cubit.totalAmount;

      // Assert
      // 1500 * 2 + 800 * 1 = 3000 + 800 = 3800
      expect(total, 3800.0);
    });

    test('должен правильно вычислять общее количество товаров', () {
      // Arrange
      cubit.cartItems.addAll(testCartItems);

      // Act
      final totalItems = cubit.totalItems;

      // Assert
      // 2 + 1 = 3
      expect(totalItems, 3);
    });

    test('должен проверять наличие товара в корзине', () {
      // Arrange
      cubit.cartItems.add(testCartItems[0]);

      // Act & Assert
      expect(cubit.isProductInCart('1'), true);
      expect(cubit.isProductInCart('non-existent'), false);
    });

    test('должен вычислять общую стоимость конкретного товара', () {
      // Arrange
      cubit.cartItems.add(testCartItems[0]); // цена 1500, количество 2

      // Act
      final productTotal = cubit.getProductTotal('1');

      // Assert
      expect(productTotal, 3000.0); // 1500 * 2
    });
  });
}
