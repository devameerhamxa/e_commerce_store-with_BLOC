import 'package:e_commerce_store_with_bloc/core/theme/app_themes.dart';
import 'package:e_commerce_store_with_bloc/products/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce_store_with_bloc/core/di/service_locator.dart';
import 'package:e_commerce_store_with_bloc/core/routes/app_routes.dart';
import 'package:e_commerce_store_with_bloc/core/widgets/product_list_screen_with_theme_toggle.dart';

import 'package:e_commerce_store_with_bloc/auth/bloc/auth_bloc.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_event.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_state.dart';
import 'package:e_commerce_store_with_bloc/auth/ui/login_screen.dart';

import 'package:e_commerce_store_with_bloc/products/bloc/product_bloc.dart';
import 'package:e_commerce_store_with_bloc/cart/bloc/cart_bloc.dart';
import 'package:e_commerce_store_with_bloc/user_profile/bloc/user_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

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
        BlocProvider<ProductDetailBloc>(
          create: (context) => getIt<ProductDetailBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce Store',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => AppRoutes.generateRoute(settings),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial || state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              return ProductListScreenWithThemeToggle(
                onThemeToggle: _toggleTheme,
              );
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
