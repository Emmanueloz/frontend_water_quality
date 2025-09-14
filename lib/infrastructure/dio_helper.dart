import 'package:dio/dio.dart';

class DioHelper {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://api.aqua-minds.org',
        validateStatus: (status) {
          return true;
        },
      ),
    );
    return dio;
  }
}
