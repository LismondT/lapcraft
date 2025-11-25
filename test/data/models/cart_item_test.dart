import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/features/cart/domain/entities/cart_item.dart';

void main() {
  group('Элемент корзины (CartItem)', () {
    test('должен создавать элемент корзины с правильными значениями', () {
      // Arrange & Act
      final cartItem = CartItem(
        productId: 'test-id',
        title: 'Тестовый товар',
        description: 'Тестовое описание',
        price: 1000.0,
        count: 2,
        imageUrl: 'https://example.com/image.jpg',
      );

      // Assert
      expect(cartItem.productId, 'test-id');
      expect(cartItem.title, 'Тестовый товар');
      expect(cartItem.description, 'Тестовое описание');
      expect(cartItem.price, 1000.0);
      expect(cartItem.count, 2);
      expect(cartItem.imageUrl, 'https://example.com/image.jpg');
    });

    test('должен создавать копию элемента корзины с обновленными значениями',
        () {
      // Arrange
      final original = CartItem(
        productId: 'test-id',
        title: 'Оригинальный товар',
        description: 'Оригинальное описание',
        price: 1000.0,
        count: 1,
      );

      // Act
      final copy = original.copyWith(
        title: 'Обновленный товар',
        count: 3,
      );

      // Assert
      expect(copy.productId, 'test-id');
      expect(copy.title, 'Обновленный товар');
      expect(copy.description, 'Оригинальное описание');
      expect(copy.price, 1000.0);
      expect(copy.count, 3);
    });
  });
}
