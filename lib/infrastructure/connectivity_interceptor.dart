import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/connectivity_provider.dart';

class ConnectivityInterceptor extends Interceptor {
  final ConnectivityProvider connectivityProvider;

  ConnectivityInterceptor(this.connectivityProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Agregar headers para indicar capacidades offline
    options.headers['X-Client-Offline-Capable'] = 'true';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("on Error");
    print(err.type);
    print(err.requestOptions.path);
    print(err.message);
    // Detectar errores de conexión
    if (_isConnectionError(err)) {
      connectivityProvider.setOfflineWithError(
        _getConnectionErrorMessage(err),
      );
    }
    super.onError(err, handler);
  }

  bool _isConnectionError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.unknown && err.error is SocketException);
  }

  String _getConnectionErrorMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de respuesta agotado';
      case DioExceptionType.connectionError:
        return 'Error de conexión a internet';
      default:
        return 'Sin conexión a internet';
    }
  }
}
