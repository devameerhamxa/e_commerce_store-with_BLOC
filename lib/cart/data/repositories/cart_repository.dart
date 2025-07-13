import 'package:dio/dio.dart';
import 'package:e_commerce_store_with_bloc/core/api/api_client.dart';
import 'package:e_commerce_store_with_bloc/cart/data/models/cart_model.dart';
import 'package:e_commerce_store_with_bloc/core/constants/app_constants.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';
import 'package:e_commerce_store_with_bloc/products/data/repositories/product_repository.dart';

class CartRepository {
  final ApiClient _apiClient;
  final ProductRepository
      productRepository; // To fetch product details for cart items

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

  // In a real app, this would interact with a backend API to add/remove items.
  // For FakeStoreAPI, we'll simulate a local cart for "Add to Cart" functionality
  // and fetch a pre-existing cart from the API for "View Cart".
  // This is a simplified local cart for demonstration.
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
        print('Failed to fetch details for product ${entry.key}: $e');
        // Optionally, handle products that couldn't be fetched (e.g., show a placeholder)
      }
    }
    return detailedCart;
  }
}
