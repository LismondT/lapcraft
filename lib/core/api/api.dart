enum Api {
  // Products
  products('/products'),
  category('/categories'),

  // Favorites
  favorites('favorites'),

  // Cart
  cart('cart'),

  // Profile
  refresh('/auth/refresh'),
  login('/auth/login'),
  register('/auth/register'),
  me('/auth/me'),
  logout('/auth/logout');

  static const String baseUrl = String.fromEnvironment('LAPCRAFT_URL_API');
  final String path;

  const Api(this.path);

  String get url => baseUrl + path;

  String withItem(String item) => '$url/$item';
}
