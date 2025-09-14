import 'package:dio/dio.dart';

class DioProvider {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.aqua-minds.org/',
        validateStatus: (status) {
          return true;
        },
      ),
    );
    return dio;
  }
}
