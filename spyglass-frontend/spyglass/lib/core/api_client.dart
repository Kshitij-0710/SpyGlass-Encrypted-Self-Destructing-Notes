import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'logger.dart';

@lazySingleton
class APIClient {
  late final Dio _dio;

  APIClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.0.100:8000', // ← Changed to match your Django backend
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.d('🚀 ${options.method} ${options.path}');
        logger.d('📤 Data: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        logger.d('📥 ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) {
        logger.e('❌ ${error.requestOptions.path}: ${error.message}');
        handler.next(error);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return _dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}