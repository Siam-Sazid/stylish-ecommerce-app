class AppEndpoints {
  // Products
  static const String products = '/api/products';
  static const String featuredProducts = '/api/products/featured';
  static const String searchProducts = '/api/products/search';
  static String productById(String id) => '/api/products/$id';
  static String productsByCategory(String categoryId) => '/api/products/category/$categoryId';

  // Categories
  static const String categories = '/api/categories';

  // Auth
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';

  // Orders
  static const String orders = '/api/orders';
}
