import 'package:dio/dio.dart';
import 'package:e_commerce_store_with_bloc/core/api/api_client.dart';
import 'package:e_commerce_store_with_bloc/core/constants/app_constants.dart';
import 'package:e_commerce_store_with_bloc/user_profile/data/models/user_model.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<UserModel> getUserDetails(int userId) async {
    try {
      final response =
          await _apiClient.dio.get('${AppConstants.usersEndpoint}$userId');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load user details: ${e.message}');
    }
  }
}
