import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8000',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8000',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  final storage = FlutterSecureStorage();

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await storage.read(key: 'access_token');

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshTokenSt = await storage.read(key: 'refresh_token');

            if (refreshTokenSt != null) {
              final newTokens = await refreshToken(refreshTokenSt);

              if (newTokens != null) {
                await storage.write(
                  key: 'access_token',
                  value: newTokens['access'],
                );
                await storage.write(
                  key: 'refresh_token',
                  value: newTokens['refresh'],
                );

                e.requestOptions.headers['Authorization'] =
                    "Bearer ${newTokens['access']}";

                final response = await _dio.fetch(e.requestOptions);
                return handler.resolve(response);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/api/v1/users/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        await storage.write(
          key: 'access_token',
          value: response.data['access'],
        );
        await storage.write(
          key: 'refresh_token',
          value: response.data['refresh'],
        );
        return response.data;
      }
    } on DioException catch (e) {
      print("LogIn Error: ${e.message}");
    }
    return null;
  }

  Future<List<dynamic>?> getData() async {
    try {
      final response = await _dio.get('/api/v1/vault/get-entries', data: {});

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      print("Error while try to get data: ${e.message}");
    }
    return null;
  }

  Future<Map<String, dynamic>?> refreshToken(String token) async {
    try {
      final response = await _refreshDio.post(
        '/api/v1/users/refresh',
        data: {'refresh': token},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException {
      //catch (e) {
      signOut();

      print("session is outdated, code should return to welcome screen");
    }
    return null;
  }

  Future<void> signOut() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    _dio.options.headers.remove('Authorization');
  }
}
