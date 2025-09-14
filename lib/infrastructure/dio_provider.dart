import 'package:dio/dio.dart';

class DioProvider {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:8000',
        validateStatus: (status) {
          return true;
        },
      ),
    );
    return dio;
  }
}
