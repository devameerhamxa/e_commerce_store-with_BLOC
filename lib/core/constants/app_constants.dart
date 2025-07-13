class AppConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String loginEndpoint = '/auth/login';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/products/categories';
  static const String productsByCategoryEndpoint = '/products/category/';
  static const String cartsByUserEndpoint = '/carts/user/';
  static const String usersEndpoint = '/users/';

  // Secure Storage Keys
  static const String authTokenKey = 'authToken';
  static const String userIdKey = 'userId';
}
