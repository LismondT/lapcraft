import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/features/products/data/models/category_model.dart';

void main() {
  group('CategoryModel', () {
    test('должна создавать CategoryModel из json', () {
      final json = {
        'id': 'test-id',
        'name': 'Test Category',
        'description': 'Test Description',
        'parent_id': 'parent-id',
        'icon': '🐱',
        'color': '#FF6B6B',
        'product_count': 10,
        'children_count': 2,
      };

      final category = CategoryModel.fromJson(json);

      expect(category.id, 'test-id');
      expect(category.name, 'Test Category');
      expect(category.description, 'Test Description');
      expect(category.parentId, 'parent-id');
      expect(category.icon, '🐱');
      expect(category.color, '#FF6B6B');
      expect(category.productCount, 10);
      expect(category.childrenCount, 2);
    });

    test('должна преобразовываться CategoryModel в entity', () {
      final model = CategoryModel(
        id: 'test-id',
        name: 'Test Category',
        description: 'Test Description',
        parentId: 'parent-id',
        icon: '🐱',
        color: '#FF6B6B',
        productCount: 10,
        childrenCount: 2,
        children: [
          CategoryModel(id: 'child-1', name: 'Child 1'),
        ],
      );

      final entity = model.toEntity();

      expect(entity.id, 'test-id');
      expect(entity.name, 'Test Category');
      expect(entity.description, 'Test Description');
      expect(entity.parentId, 'parent-id');
      expect(entity.icon, '🐱');
      expect(entity.color, '#FF6B6B');
      expect(entity.productCount, 10);
      expect(entity.childrenCount, 2);
      expect(entity.children?.first.name, 'Child 1');
    });
  });
}
