import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:e_commerce_store_with_bloc/common/constants/app_constants.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: AppConstants.authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: AppConstants.authTokenKey);
  }

  Future<void> saveUserId(int userId) async {
    await _storage.write(key: AppConstants.userIdKey, value: userId.toString());
  }

  Future<int?> getUserId() async {
    String? userIdString = await _storage.read(key: AppConstants.userIdKey);
    return userIdString != null ? int.tryParse(userIdString) : null;
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
