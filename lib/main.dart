import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:e_commerce_store_with_bloc/api/api_client.dart';
import 'package:e_commerce_store_with_bloc/common/utils/secure_storage.dart';
import 'package:e_commerce_store_with_bloc/theme/app_themes.dart';

import 'package:e_commerce_store_with_bloc/auth/bloc/auth_bloc.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_event.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_state.dart';
import 'package:e_commerce_store_with_bloc/auth/data/repositories/auth_repository.dart';
import 'package:e_commerce_store_with_bloc/auth/ui/login_screen.dart';

import 'package:e_commerce_store_with_bloc/products/bloc/product_bloc.dart';
import 'package:e_commerce_store_with_bloc/products/data/repositories/product_repository.dart';
import 'package:e_commerce_store_with_bloc/products/ui/product_list_screen.dart';

import 'package:e_commerce_store_with_bloc/cart/bloc/cart_bloc.dart';
import 'package:e_commerce_store_with_bloc/cart/data/repositories/cart_repository.dart';

import 'package:e_commerce_store_with_bloc/user_profile/bloc/user_bloc.dart';
import 'package:e_commerce_store_with_bloc/user_profile/data/repositories/user_repository.dart';

// Global instance of GetIt for dependency injection
final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Register singletons
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<ApiClient>(), getIt<SecureStorage>()));
  getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepository(getIt<ApiClient>()));
  getIt.registerLazySingleton<CartRepository>(
      () => CartRepository(getIt<ApiClient>(), getIt<ProductRepository>()));
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepository(getIt<ApiClient>()));

  // Register BLoCs
  getIt.registerFactory<AuthBloc>(
      () => AuthBloc(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory<ProductBloc>(
      () => ProductBloc(productRepository: getIt<ProductRepository>()));
  getIt.registerFactory<CartBloc>(
      () => CartBloc(cartRepository: getIt<CartRepository>()));
  getIt.registerFactory<UserBloc>(
      () => UserBloc(userRepository: getIt<UserRepository>()));
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckStatus()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => getIt<ProductBloc>(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => getIt<CartBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => getIt<UserBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce Store',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              return ProductListScreenWithThemeToggle(
                  onThemeToggle: _toggleTheme);
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

// Wrapper for ProductListScreen to include theme toggle
class ProductListScreenWithThemeToggle extends StatelessWidget {
  final Function(bool) onThemeToggle;

  const ProductListScreenWithThemeToggle(
      {Key? key, required this.onThemeToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ProductListScreen(),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                final currentBrightness = Theme.of(context).brightness;
                onThemeToggle(currentBrightness == Brightness.light);
              },
              child: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
