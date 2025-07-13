import 'package:e_commerce_store_with_bloc/products/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_store_with_bloc/auth/ui/login_screen.dart';
import 'package:e_commerce_store_with_bloc/user_profile/ui/user_profile_screen.dart';
import 'package:e_commerce_store_with_bloc/products/ui/product_list_screen.dart';
import 'package:e_commerce_store_with_bloc/products/ui/product_detail_screen.dart';
import 'package:e_commerce_store_with_bloc/cart/ui/cart_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        // ProductListScreen uses the ProductBloc provided higher up in the widget tree (MyApp)
        return MaterialPageRoute(
          builder: (context) => ProductListScreen(
            onThemeToggle: (bool isDarkMode) {},
          ),
          settings: settings,
        );

      case productDetail:
        // Extract product data from arguments
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'];

        if (productId == null) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Product ID is required'),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            // CORRECTED: Provide the ProductDetailBloc here
            value: context.read<ProductDetailBloc>(),
            child: ProductDetailScreen(
              productId: productId is int
                  ? productId
                  : int.tryParse(productId.toString()) ?? 0,
            ),
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
