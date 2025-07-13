import 'package:e_commerce_store_with_bloc/auth/ui/login_screen.dart';
import 'package:e_commerce_store_with_bloc/cart/ui/cart_screen.dart';
import 'package:e_commerce_store_with_bloc/products/ui/product_detail_screen.dart';
import 'package:e_commerce_store_with_bloc/products/ui/product_list_screen.dart';
import 'package:e_commerce_store_with_bloc/user_profile/ui/user_profile_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String userProfile = '/user-profile';
  static const String productList = '/product-list';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          settings: settings,
        );

      case userProfile:
        return MaterialPageRoute(
          builder: (context) => const UserProfileScreen(),
          settings: settings,
        );

      case productList:
        return MaterialPageRoute(
          builder: (context) => const ProductListScreen(),
          settings: settings,
        );

      case productDetail:
        // Extract product data from arguments if needed
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            productId: args?['productId'] ?? '',
          ),
          settings: settings,
        );

      case cart:
        return MaterialPageRoute(
          builder: (context) => const CartScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}
