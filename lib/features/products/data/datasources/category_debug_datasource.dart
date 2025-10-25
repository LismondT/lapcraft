import 'package:lapcraft/features/products/data/datasources/category_remote_datasource.dart';
import 'package:lapcraft/features/products/data/models/category_model.dart';

class CategoryDebugDatasource implements CategoryRemoteDatasource {
  final bool simulateLoading;
  final Duration loadingDelay;

  CategoryDebugDatasource({
    this.simulateLoading = true,
    this.loadingDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<List<CategoryModel>> getCategories() async {
    if (simulateLoading) {
      await Future.delayed(loadingDelay);
    }

    return _mockCategories;
  }

  @override
  Future<CategoryModel> getCategory(String id) async {
    if (simulateLoading) {
      await Future.delayed(loadingDelay);
    }

    final category = _mockCategories.firstWhere(
      (category) => category.id == id,
      orElse: () => throw Exception('Category with id $id not found'),
    );

    return category;
  }

  @override
  Future<List<CategoryModel>> getCategoryTree() async {
    if (simulateLoading) {
      await Future.delayed(loadingDelay);
    }

    return _mockCategoryTree;
  }

  @override
  Future<List<CategoryModel>> getSubcategories(String parentId) async {
    if (simulateLoading) {
      await Future.delayed(loadingDelay);
    }

    return switch (parentId) {
      'cat-uuid-1' => _mockCatSubcategories,
      'cat-food-uuid-11' => _mockCatFoodSubcategories,
      'cat-dry-food-uuid-111' => _mockCatDryFoodSubcategories,
      // 'cat-toys-uuid-12' => _mockCatToysSubcategories,
      'dog-uuid-2' => _mockDogSubcategories,
      //'dog-food-uuid-21' => _mockDogFoodSubcategories,
      // Добавь другие ID по необходимости
      _ => [], // По умолчанию возвращаем пустой список
    };
  }

  // Mock данные для основных категорий
  static final List<CategoryModel> _mockCategories = [
    CategoryModel(
        id: 'cat-uuid-1',
        name: 'Для кошек',
        description: 'Все для ваших пушистых друзей',
        icon: '🐱',
        color: '#FF6B6B',
        productCount: 156,
        children: [CategoryModel(id: 'dada', name: 'test')]),
    CategoryModel(
      id: 'dog-uuid-2',
      name: 'Для собак',
      description: 'Товары для лучших друзей человека',
      icon: '🐶',
      color: '#4ECDC4',
      productCount: 203,
    ),
    CategoryModel(
      id: 'fish-uuid-3',
      name: 'Для рыбок',
      description: 'Аквариумы и все для водных питомцев',
      icon: '🐠',
      color: '#45B7D1',
      productCount: 89,
    ),
    CategoryModel(
      id: 'bird-uuid-4',
      name: 'Для птиц',
      description: 'Клетки, корм и аксессуары для пернатых',
      icon: '🐦',
      color: '#F7DC6F',
      productCount: 67,
    ),
    CategoryModel(
      id: 'small-uuid-5',
      name: 'Для грызунов',
      description: 'Все для хомяков, кроликов и морских свинок',
      icon: '🐹',
      color: '#BB8FCE',
      productCount: 42,
    ),
    CategoryModel(
      id: 'reptile-uuid-6',
      name: 'Для рептилий',
      description: 'Террариумы и корм для экзотических питомцев',
      icon: '🦎',
      color: '#52BE80',
      productCount: 31,
    ),
  ];

  // Подкатегории для кошек
  static final List<CategoryModel> _mockCatSubcategories = [
    CategoryModel(
      id: 'cat-food-uuid-11',
      name: 'Корма для кошек',
      parentId: 'cat-uuid-1',
      icon: '🍖',
      color: '#FF9F1C',
      productCount: 78,
    ),
    CategoryModel(
      id: 'cat-toys-uuid-12',
      name: 'Игрушки для кошек',
      parentId: 'cat-uuid-1',
      icon: '🎮',
      color: '#6A0572',
      productCount: 45,
    ),
    CategoryModel(
      id: 'cat-litter-uuid-13',
      name: 'Наполнители',
      parentId: 'cat-uuid-1',
      icon: '🚽',
      color: '#118AB2',
      productCount: 33,
    ),
  ];

  static final List<CategoryModel> _mockCatFoodSubcategories = [
    CategoryModel(
      id: 'cat-dry-food-uuid-111',
      name: 'Сухие корма',
      parentId: 'cat-food-uuid-11',
      icon: '🥣',
      color: '#FF6B6B',
      productCount: 35,
    ),
    CategoryModel(
      id: 'cat-wet-food-uuid-112',
      name: 'Влажные корма',
      parentId: 'cat-food-uuid-11',
      icon: '🥫',
      color: '#4ECDC4',
      productCount: 28,
    ),
    CategoryModel(
      id: 'cat-premium-food-uuid-113',
      name: 'Премиум корма',
      parentId: 'cat-food-uuid-11',
      icon: '⭐',
      color: '#F7DC6F',
      productCount: 15,
    ),
  ];

  static final List<CategoryModel> _mockCatDryFoodSubcategories = [
    CategoryModel(
      id: 'cat-dry-kitten-uuid-1111',
      name: 'Для котят',
      parentId: 'cat-dry-food-uuid-111',
      icon: '🐱',
      color: '#FF6B6B',
      productCount: 12,
    ),
    CategoryModel(
      id: 'cat-dry-adult-uuid-1112',
      name: 'Для взрослых кошек',
      parentId: 'cat-dry-food-uuid-111',
      icon: '🐈',
      color: '#4ECDC4',
      productCount: 15,
    ),
    CategoryModel(
      id: 'cat-dry-senior-uuid-1113',
      name: 'Для пожилых кошек',
      parentId: 'cat-dry-food-uuid-111',
      icon: '🐈‍⬛',
      color: '#BB8FCE',
      productCount: 8,
    ),
  ];

  // Подкатегории для собак
  static final List<CategoryModel> _mockDogSubcategories = [
    CategoryModel(
      id: 'dog-food-uuid-21',
      name: 'Корма для собак',
      parentId: 'dog-uuid-2',
      icon: '🍖',
      color: '#FF9F1C',
      productCount: 95,
    ),
    CategoryModel(
      id: 'dog-leash-uuid-22',
      name: 'Поводки и ошейники',
      parentId: 'dog-uuid-2',
      icon: '🦮',
      color: '#6A0572',
      productCount: 58,
    ),
    CategoryModel(
      id: 'dog-toys-uuid-23',
      name: 'Игрушки для собак',
      parentId: 'dog-uuid-2',
      icon: '🥏',
      color: '#118AB2',
      productCount: 50,
    ),
  ];

  // Подкатегории для рыбок
  static final List<CategoryModel> _mockFishSubcategories = [
    CategoryModel(
      id: 'fish-food-uuid-31',
      name: 'Корм для рыбок',
      parentId: 'fish-uuid-3',
      icon: '🌿',
      color: '#FF9F1C',
      productCount: 25,
    ),
    CategoryModel(
      id: 'aquarium-uuid-32',
      name: 'Аквариумы',
      parentId: 'fish-uuid-3',
      icon: '🐟',
      color: '#6A0572',
      productCount: 35,
    ),
  ];

  // Подкатегории для птиц
  static final List<CategoryModel> _mockBirdSubcategories = [
    CategoryModel(
      id: 'bird-food-uuid-41',
      name: 'Корм для птиц',
      parentId: 'bird-uuid-4',
      icon: '🌾',
      color: '#FF9F1C',
      productCount: 30,
    ),
    CategoryModel(
      id: 'bird-cage-uuid-42',
      name: 'Клетки',
      parentId: 'bird-uuid-4',
      icon: '🏠',
      color: '#6A0572',
      productCount: 22,
    ),
  ];

  // Дерево категорий с вложенностью
  static final List<CategoryModel> _mockCategoryTree = [
    CategoryModel(
      id: 'cat-uuid-1',
      name: 'Для кошек',
      icon: '🐱',
      color: '#FF6B6B',
      productCount: 156,
      children: [
        CategoryModel(
          id: 'cat-food-uuid-11',
          name: 'Корма для кошек',
          parentId: 'cat-uuid-1',
          icon: '🍖',
          color: '#FF9F1C',
          productCount: 78,
          children: [
            CategoryModel(
              id: 'cat-dry-food-uuid-111',
              name: 'Сухие корма',
              parentId: 'cat-food-uuid-11',
              icon: '🥣',
              color: '#FF6B6B',
              productCount: 35,
              children: [
                CategoryModel(
                  id: 'cat-dry-kitten-uuid-1111',
                  name: 'Для котят',
                  parentId: 'cat-dry-food-uuid-111',
                  icon: '🐱',
                  color: '#FF6B6B',
                  productCount: 12,
                ),
                CategoryModel(
                  id: 'cat-dry-adult-uuid-1112',
                  name: 'Для взрослых кошек',
                  parentId: 'cat-dry-food-uuid-111',
                  icon: '🐈',
                  color: '#4ECDC4',
                  productCount: 15,
                ),
                CategoryModel(
                  id: 'cat-dry-senior-uuid-1113',
                  name: 'Для пожилых кошек',
                  parentId: 'cat-dry-food-uuid-111',
                  icon: '🐈‍⬛',
                  color: '#BB8FCE',
                  productCount: 8,
                ),
              ],
            ),
            CategoryModel(
              id: 'cat-wet-food-uuid-112',
              name: 'Влажные корма',
              parentId: 'cat-food-uuid-11',
              icon: '🥫',
              color: '#4ECDC4',
              productCount: 28,
            ),
            CategoryModel(
              id: 'cat-premium-food-uuid-113',
              name: 'Премиум корма',
              parentId: 'cat-food-uuid-11',
              icon: '⭐',
              color: '#F7DC6F',
              productCount: 15,
            ),
          ],
        ),
        CategoryModel(
          id: 'cat-toys-uuid-12',
          name: 'Игрушки для кошек',
          parentId: 'cat-uuid-1',
          icon: '🎮',
          color: '#6A0572',
          productCount: 45,
          children: [
            CategoryModel(
              id: 'cat-toys-mice-uuid-121',
              name: 'Игрушки-мыши',
              parentId: 'cat-toys-uuid-12',
              icon: '🐭',
              color: '#FF6B6B',
              productCount: 20,
            ),
            CategoryModel(
              id: 'cat-toys-laser-uuid-122',
              name: 'Лазерные указки',
              parentId: 'cat-toys-uuid-12',
              icon: '🔴',
              color: '#45B7D1',
              productCount: 15,
            ),
            CategoryModel(
              id: 'cat-toys-scratcher-uuid-123',
              name: 'Когтеточки',
              parentId: 'cat-toys-uuid-12',
              icon: '🌲',
              color: '#52BE80',
              productCount: 10,
            ),
          ],
        ),
        // ... другие подкатегории для кошек
      ],
    ),
    CategoryModel(
      id: 'dog-uuid-2',
      name: 'Для собак',
      icon: '🐶',
      color: '#4ECDC4',
      productCount: 203,
      children: _mockDogSubcategories,
    ),
    CategoryModel(
      id: 'fish-uuid-3',
      name: 'Для рыбок',
      icon: '🐠',
      color: '#45B7D1',
      productCount: 89,
      children: _mockFishSubcategories,
    ),
    CategoryModel(
      id: 'bird-uuid-4',
      name: 'Для птиц',
      icon: '🐦',
      color: '#F7DC6F',
      productCount: 67,
      children: _mockBirdSubcategories,
    ),
  ];
}
