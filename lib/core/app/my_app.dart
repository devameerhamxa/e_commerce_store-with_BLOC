import 'package:e_commerce_store_with_bloc/cart/bloc/cart_event.dart';
import 'package:e_commerce_store_with_bloc/core/theme/app_themes.dart';
import 'package:e_commerce_store_with_bloc/core/theme/theme_bloc/theme_bloc.dart';
import 'package:e_commerce_store_with_bloc/core/theme/theme_bloc/theme_state.dart';

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
          BlocProvider<ThemeBloc>(
            create: (context) => getIt<ThemeBloc>(),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
            // NEW: Use BlocBuilder for ThemeBloc
            builder: (context, themeState) {
          return MaterialApp(
            title: 'E-Commerce Store',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeState.themeMode,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) => AppRoutes.generateRoute(settings),
            home: MultiBlocListener(
              listeners: [
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      // Fetch fresh cart data on login
                      BlocProvider.of<CartBloc>(context)
                          .add(FetchUserCarts(state.userId));
                    } else if (state is AuthUnauthenticated) {
                      // Reset cart state immediately on logout
                      BlocProvider.of<CartBloc>(context)
                          .add(const ResetCartState());
                    }
                  },
                ),
              ],
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthInitial || state is AuthLoading) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is AuthAuthenticated) {
                    return ProductListScreenWithThemeToggle();
                  } else {
                    return const LoginScreen();
                  }
                },
              ),
            ),
          );
        }));
  }
}
