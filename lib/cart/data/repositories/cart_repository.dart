import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce_store_with_bloc/core/api/api_client.dart';
import 'package:e_commerce_store_with_bloc/cart/data/models/cart_model.dart';
import 'package:e_commerce_store_with_bloc/core/constants/app_constants.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';
import 'package:e_commerce_store_with_bloc/products/data/repositories/product_repository.dart';

class CartRepository {
  final ApiClient _apiClient;
  final ProductRepository productRepository;

  CartRepository(this._apiClient, this.productRepository);

  Future<List<CartModel>> getUserCarts(int userId) async {
    try {
      final response = await _apiClient.dio
          .get('${AppConstants.cartsByUserEndpoint}$userId');
      return (response.data as List)
          .map((json) => CartModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load user carts: ${e.message}');
    }
  }

  final Map<int, int> _localCartItems = {}; // productId -> quantity

  void addLocalCartItem(int productId, int quantity) {
    _localCartItems.update(productId, (value) => value + quantity,
        ifAbsent: () => quantity);
  }

  void removeLocalCartItem(int productId) {
    _localCartItems.remove(productId);
  }

  Map<int, int> getLocalCartItems() {
    return Map.from(_localCartItems);
  }

  Future<Map<ProductModel, int>> getDetailedLocalCart() async {
    final Map<ProductModel, int> detailedCart = {};
    for (final entry in _localCartItems.entries) {
      try {
        final product = await productRepository.getProductDetails(entry.key);
        detailedCart[product] = entry.value;
      } catch (e) {
        log('Failed to fetch details for product ${entry.key}: $e');
      }
    }
    return detailedCart;
  }
}
