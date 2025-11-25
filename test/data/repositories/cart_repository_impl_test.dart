import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/error/failure.dart';
import 'package:lapcraft/features/cart/data/datasources/cart_datasource.dart';
import 'package:lapcraft/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';
import 'package:mocktail/mocktail.dart';

class MockCartDatasource extends Mock implements CartDatasource {}

void main() {
  late CartRepositoryImpl repository;
  late MockCartDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockCartDatasource();
    repository = CartRepositoryImpl(mockDatasource);
  });

  group('Репозиторий корзины', () {
    final testCartItems = [
      CartItem(
        productId: '1',
        title: 'Товар 1',
        description: 'Описание 1',
        price: 1000.0,
        count: 2,
      ),
      CartItem(
        productId: '2',
        title: 'Товар 2',
        description: 'Описание 2',
        price: 2000.0,
        count: 1,
      ),
    ];

    test('должен получать все элементы корзины', () async {
      // Arrange
      when(() => mockDatasource.getAll())
          .thenAnswer((_) async => Right(testCartItems));

      // Act
      final result = await repository.getAll();

      // Assert
      expect(result, isA<Right<Failure, List<CartItem>>>());
      result.fold(
        (failure) => fail('Не должно возвращать ошибку'),
        (items) {
          expect(items.length, 2);
          expect(items[0].productId, '1');
          expect(items[1].productId, '2');
        },
      );
      verify(() => mockDatasource.getAll()).called(1);
    });

    test('должен добавлять товар в корзину', () async {
      // Arrange
      when(() => mockDatasource.add('test-product-id'))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await repository.addToCart('test-product-id');

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockDatasource.add('test-product-id')).called(1);
    });

    test('должен удалять товар из корзины', () async {
      // Arrange
      when(() => mockDatasource.remove('test-product-id'))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await repository.removeFromCart('test-product-id');

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockDatasource.remove('test-product-id')).called(1);
    });

    test('должен обновлять количество товара', () async {
      // Arrange
      when(() => mockDatasource.setCount('test-product-id', 3))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await repository.updateQuantity('test-product-id', 3);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockDatasource.setCount('test-product-id', 3)).called(1);
    });

    test('должен очищать корзину', () async {
      // Arrange
      when(() => mockDatasource.clear()).thenAnswer((_) async => Right(null));

      // Act
      final result = await repository.clearCart();

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockDatasource.clear()).called(1);
    });
  });
}
