// lib/core/di/service_locator.dart
import 'package:e_commerce_store_with_bloc/core/api/api_client.dart';
import 'package:e_commerce_store_with_bloc/core/utils/secure_storage.dart';
import 'package:e_commerce_store_with_bloc/products/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:e_commerce_store_with_bloc/auth/bloc/auth_bloc.dart';
import 'package:e_commerce_store_with_bloc/auth/data/repositories/auth_repository.dart';

import 'package:e_commerce_store_with_bloc/products/bloc/product_bloc.dart';
import 'package:e_commerce_store_with_bloc/products/data/repositories/product_repository.dart';

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

  getIt.registerLazySingleton<ProductDetailBloc>(
      () => ProductDetailBloc(productRepository: getIt<ProductRepository>()));
}
