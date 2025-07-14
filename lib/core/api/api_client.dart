import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce_store_with_bloc/core/constants/app_constants.dart';
import 'package:e_commerce_store_with_bloc/core/utils/secure_storage.dart';

class ApiClient {
  late Dio _dio;
  final SecureStorage _secureStorage = SecureStorage();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add an interceptor for logging and token attachment
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          log('REQUEST[${options.method}] => PATH: ${options.path}');
          log('HEADERS: ${options.headers}');
          log('DATA: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          log('DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          log('ERROR MESSAGE: ${e.message}');
          log('ERROR RESPONSE: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
