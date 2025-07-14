import 'package:dio/dio.dart';
import 'package:e_commerce_store_with_bloc/core/api/api_client.dart';
import 'package:e_commerce_store_with_bloc/core/constants/app_constants.dart';
import 'package:e_commerce_store_with_bloc/products/data/models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.productsEndpoint);
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load products: ${e.message}');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response =
          await _apiClient.dio.get(AppConstants.categoriesEndpoint);
      return (response.data as List).map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load categories: ${e.message}');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _apiClient.dio
          .get('${AppConstants.productsByCategoryEndpoint}$category');
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load products by category: ${e.message}');
    }
  }

  Future<ProductModel> getProductDetails(int id) async {
    try {
      final response =
          await _apiClient.dio.get('${AppConstants.productsEndpoint}/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load product details: ${e.message}');
    }
  }
}
