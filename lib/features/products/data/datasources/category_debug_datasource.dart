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
      slug: 'cats',
      description: 'Все для ваших пушистых друзей',
      imageUrl: 'https://via.placeholder.com/300x200/FF6B6B/FFFFFF?text=Cats',
      icon: '🐱',
      color: '#FF6B6B',
      sortOrder: 1,
      isActive: true,
      productCount: 156,
      children: [CategoryModel(id: 'dada', name: 'test', slug: 'test')]
    ),
    CategoryModel(
      id: 'dog-uuid-2',
      name: 'Для собак',
      slug: 'dogs',
      description: 'Товары для лучших друзей человека',
      imageUrl: 'https://via.placeholder.com/300x200/4ECDC4/FFFFFF?text=Dogs',
      icon: '🐶',
      color: '#4ECDC4',
      sortOrder: 2,
      isActive: true,
      productCount: 203,
    ),
    CategoryModel(
      id: 'fish-uuid-3',
      name: 'Для рыбок',
      slug: 'fish',
      description: 'Аквариумы и все для водных питомцев',
      imageUrl: 'https://via.placeholder.com/300x200/45B7D1/FFFFFF?text=Fish',
      icon: '🐠',
      color: '#45B7D1',
      sortOrder: 3,
      isActive: true,
      productCount: 89,
    ),
    CategoryModel(
      id: 'bird-uuid-4',
      name: 'Для птиц',
      slug: 'birds',
      description: 'Клетки, корм и аксессуары для пернатых',
      imageUrl: 'https://via.placeholder.com/300x200/F7DC6F/FFFFFF?text=Birds',
      icon: '🐦',
      color: '#F7DC6F',
      sortOrder: 4,
      isActive: true,
      productCount: 67,
    ),
    CategoryModel(
      id: 'small-uuid-5',
      name: 'Для грызунов',
      slug: 'small-pets',
      description: 'Все для хомяков, кроликов и морских свинок',
      imageUrl:
          'https://via.placeholder.com/300x200/BB8FCE/FFFFFF?text=Small+Pets',
      icon: '🐹',
      color: '#BB8FCE',
      sortOrder: 5,
      isActive: true,
      productCount: 42,
    ),
    CategoryModel(
      id: 'reptile-uuid-6',
      name: 'Для рептилий',
      slug: 'reptiles',
      description: 'Террариумы и корм для экзотических питомцев',
      imageUrl:
          'https://via.placeholder.com/300x200/52BE80/FFFFFF?text=Reptiles',
      icon: '🦎',
      color: '#52BE80',
      sortOrder: 6,
      isActive: true,
      productCount: 31,
    ),
  ];

  // Подкатегории для кошек
  static final List<CategoryModel> _mockCatSubcategories = [
    CategoryModel(
      id: 'cat-food-uuid-11',
      name: 'Корма для кошек',
      slug: 'cat-food',
      parentId: 'cat-uuid-1',
      icon: '🍖',
      color: '#FF9F1C',
      sortOrder: 1,
      isActive: true,
      productCount: 78,
    ),
    CategoryModel(
      id: 'cat-toys-uuid-12',
      name: 'Игрушки для кошек',
      slug: 'cat-toys',
      parentId: 'cat-uuid-1',
      icon: '🎮',
      color: '#6A0572',
      sortOrder: 2,
      isActive: true,
      productCount: 45,
    ),
    CategoryModel(
      id: 'cat-litter-uuid-13',
      name: 'Наполнители',
      slug: 'cat-litter',
      parentId: 'cat-uuid-1',
      icon: '🚽',
      color: '#118AB2',
      sortOrder: 3,
      isActive: true,
      productCount: 33,
    ),
  ];

  static final List<CategoryModel> _mockCatFoodSubcategories = [
    CategoryModel(
      id: 'cat-dry-food-uuid-111',
      name: 'Сухие корма',
      slug: 'cat-dry-food',
      parentId: 'cat-food-uuid-11',
      icon: '🥣',
      color: '#FF6B6B',
      sortOrder: 1,
      isActive: true,
      productCount: 35,
    ),
    CategoryModel(
      id: 'cat-wet-food-uuid-112',
      name: 'Влажные корма',
      slug: 'cat-wet-food',
      parentId: 'cat-food-uuid-11',
      icon: '🥫',
      color: '#4ECDC4',
      sortOrder: 2,
      isActive: true,
      productCount: 28,
    ),
    CategoryModel(
      id: 'cat-premium-food-uuid-113',
      name: 'Премиум корма',
      slug: 'cat-premium-food',
      parentId: 'cat-food-uuid-11',
      icon: '⭐',
      color: '#F7DC6F',
      sortOrder: 3,
      isActive: true,
      productCount: 15,
    ),
  ];

  static final List<CategoryModel> _mockCatDryFoodSubcategories = [
    CategoryModel(
      id: 'cat-dry-kitten-uuid-1111',
      name: 'Для котят',
      slug: 'cat-dry-kitten',
      parentId: 'cat-dry-food-uuid-111',
      icon: '🐱',
      color: '#FF6B6B',
      sortOrder: 1,
      isActive: true,
      productCount: 12,
    ),
    CategoryModel(
      id: 'cat-dry-adult-uuid-1112',
      name: 'Для взрослых кошек',
      slug: 'cat-dry-adult',
      parentId: 'cat-dry-food-uuid-111',
      icon: '🐈',
      color: '#4ECDC4',
      sortOrder: 2,
      isActive: true,
      productCount: 15,
    ),
    CategoryModel(
      id: 'cat-dry-senior-uuid-1113',
      name: 'Для пожилых кошек',
      slug: 'cat-dry-senior',
      parentId: 'cat-dry-food-uuid-111',
      icon: '🐈‍⬛',
      color: '#BB8FCE',
      sortOrder: 3,
      isActive: true,
      productCount: 8,
    ),
  ];

  // Подкатегории для собак
  static final List<CategoryModel> _mockDogSubcategories = [
    CategoryModel(
      id: 'dog-food-uuid-21',
      name: 'Корма для собак',
      slug: 'dog-food',
      parentId: 'dog-uuid-2',
      icon: '🍖',
      color: '#FF9F1C',
      sortOrder: 1,
      isActive: true,
      productCount: 95,
    ),
    CategoryModel(
      id: 'dog-leash-uuid-22',
      name: 'Поводки и ошейники',
      slug: 'dog-leashes',
      parentId: 'dog-uuid-2',
      icon: '🦮',
      color: '#6A0572',
      sortOrder: 2,
      isActive: true,
      productCount: 58,
    ),
    CategoryModel(
      id: 'dog-toys-uuid-23',
      name: 'Игрушки для собак',
      slug: 'dog-toys',
      parentId: 'dog-uuid-2',
      icon: '🥏',
      color: '#118AB2',
      sortOrder: 3,
      isActive: true,
      productCount: 50,
    ),
  ];

  // Подкатегории для рыбок
  static final List<CategoryModel> _mockFishSubcategories = [
    CategoryModel(
      id: 'fish-food-uuid-31',
      name: 'Корм для рыбок',
      slug: 'fish-food',
      parentId: 'fish-uuid-3',
      icon: '🌿',
      color: '#FF9F1C',
      sortOrder: 1,
      isActive: true,
      productCount: 25,
    ),
    CategoryModel(
      id: 'aquarium-uuid-32',
      name: 'Аквариумы',
      slug: 'aquariums',
      parentId: 'fish-uuid-3',
      icon: '🐟',
      color: '#6A0572',
      sortOrder: 2,
      isActive: true,
      productCount: 35,
    ),
  ];

  // Подкатегории для птиц
  static final List<CategoryModel> _mockBirdSubcategories = [
    CategoryModel(
      id: 'bird-food-uuid-41',
      name: 'Корм для птиц',
      slug: 'bird-food',
      parentId: 'bird-uuid-4',
      icon: '🌾',
      color: '#FF9F1C',
      sortOrder: 1,
      isActive: true,
      productCount: 30,
    ),
    CategoryModel(
      id: 'bird-cage-uuid-42',
      name: 'Клетки',
      slug: 'bird-cages',
      parentId: 'bird-uuid-4',
      icon: '🏠',
      color: '#6A0572',
      sortOrder: 2,
      isActive: true,
      productCount: 22,
    ),
  ];

  // Дерево категорий с вложенностью
  static final List<CategoryModel> _mockCategoryTree = [
    CategoryModel(
      id: 'cat-uuid-1',
      name: 'Для кошек',
      slug: 'cats',
      icon: '🐱',
      color: '#FF6B6B',
      sortOrder: 1,
      isActive: true,
      productCount: 156,
      children: [
        CategoryModel(
          id: 'cat-food-uuid-11',
          name: 'Корма для кошек',
          slug: 'cat-food',
          parentId: 'cat-uuid-1',
          icon: '🍖',
          color: '#FF9F1C',
          sortOrder: 1,
          isActive: true,
          productCount: 78,
          children: [
            CategoryModel(
              id: 'cat-dry-food-uuid-111',
              name: 'Сухие корма',
              slug: 'cat-dry-food',
              parentId: 'cat-food-uuid-11',
              icon: '🥣',
              color: '#FF6B6B',
              sortOrder: 1,
              isActive: true,
              productCount: 35,
              children: [
                CategoryModel(
                  id: 'cat-dry-kitten-uuid-1111',
                  name: 'Для котят',
                  slug: 'cat-dry-kitten',
                  parentId: 'cat-dry-food-uuid-111',
                  icon: '🐱',
                  color: '#FF6B6B',
                  sortOrder: 1,
                  isActive: true,
                  productCount: 12,
                ),
                CategoryModel(
                  id: 'cat-dry-adult-uuid-1112',
                  name: 'Для взрослых кошек',
                  slug: 'cat-dry-adult',
                  parentId: 'cat-dry-food-uuid-111',
                  icon: '🐈',
                  color: '#4ECDC4',
                  sortOrder: 2,
                  isActive: true,
                  productCount: 15,
                ),
                CategoryModel(
                  id: 'cat-dry-senior-uuid-1113',
                  name: 'Для пожилых кошек',
                  slug: 'cat-dry-senior',
                  parentId: 'cat-dry-food-uuid-111',
                  icon: '🐈‍⬛',
                  color: '#BB8FCE',
                  sortOrder: 3,
                  isActive: true,
                  productCount: 8,
                ),
              ],
            ),
            CategoryModel(
              id: 'cat-wet-food-uuid-112',
              name: 'Влажные корма',
              slug: 'cat-wet-food',
              parentId: 'cat-food-uuid-11',
              icon: '🥫',
              color: '#4ECDC4',
              sortOrder: 2,
              isActive: true,
              productCount: 28,
            ),
            CategoryModel(
              id: 'cat-premium-food-uuid-113',
              name: 'Премиум корма',
              slug: 'cat-premium-food',
              parentId: 'cat-food-uuid-11',
              icon: '⭐',
              color: '#F7DC6F',
              sortOrder: 3,
              isActive: true,
              productCount: 15,
            ),
          ],
        ),
        CategoryModel(
          id: 'cat-toys-uuid-12',
          name: 'Игрушки для кошек',
          slug: 'cat-toys',
          parentId: 'cat-uuid-1',
          icon: '🎮',
          color: '#6A0572',
          sortOrder: 2,
          isActive: true,
          productCount: 45,
          children: [
            CategoryModel(
              id: 'cat-toys-mice-uuid-121',
              name: 'Игрушки-мыши',
              slug: 'cat-toys-mice',
              parentId: 'cat-toys-uuid-12',
              icon: '🐭',
              color: '#FF6B6B',
              sortOrder: 1,
              isActive: true,
              productCount: 20,
            ),
            CategoryModel(
              id: 'cat-toys-laser-uuid-122',
              name: 'Лазерные указки',
              slug: 'cat-toys-laser',
              parentId: 'cat-toys-uuid-12',
              icon: '🔴',
              color: '#45B7D1',
              sortOrder: 2,
              isActive: true,
              productCount: 15,
            ),
            CategoryModel(
              id: 'cat-toys-scratcher-uuid-123',
              name: 'Когтеточки',
              slug: 'cat-toys-scratcher',
              parentId: 'cat-toys-uuid-12',
              icon: '🌲',
              color: '#52BE80',
              sortOrder: 3,
              isActive: true,
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
      slug: 'dogs',
      icon: '🐶',
      color: '#4ECDC4',
      sortOrder: 2,
      isActive: true,
      productCount: 203,
      children: _mockDogSubcategories,
    ),
    CategoryModel(
      id: 'fish-uuid-3',
      name: 'Для рыбок',
      slug: 'fish',
      icon: '🐠',
      color: '#45B7D1',
      sortOrder: 3,
      isActive: true,
      productCount: 89,
      children: _mockFishSubcategories,
    ),
    CategoryModel(
      id: 'bird-uuid-4',
      name: 'Для птиц',
      slug: 'birds',
      icon: '🐦',
      color: '#F7DC6F',
      sortOrder: 4,
      isActive: true,
      productCount: 67,
      children: _mockBirdSubcategories,
    ),
  ];
}
