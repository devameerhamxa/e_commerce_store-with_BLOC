import 'package:dio/dio.dart';
import 'package:e_commerce_store_with_bloc/core/api/api_client.dart';
import 'package:e_commerce_store_with_bloc/auth/data/models/auth_response_model.dart';
import 'package:e_commerce_store_with_bloc/core/constants/app_constants.dart';
import 'package:e_commerce_store_with_bloc/core/utils/secure_storage.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  AuthRepository(this._apiClient, this._secureStorage);

  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );
      final authResponse = AuthResponseModel.fromJson(response.data);
      await _secureStorage.saveAuthToken(authResponse.token);
      // FakeStoreAPI doesn't return user ID on login, so we'll simulate a fixed one for cart/profile
      // In a real app, the login response would include user details.
      await _secureStorage
          .saveUserId(1); // Assuming user ID 1 for demonstration
      return authResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getAuthToken();
    return token != null;
  }

  Future<int?> getLoggedInUserId() async {
    return await _secureStorage.getUserId();
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.getAuthToken();
  }
}
