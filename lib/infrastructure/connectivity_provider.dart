import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_water_quality/domain/models/connectivity_state_model.dart';
import 'package:frontend_water_quality/infrastructure/connectivity_interceptor.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityState _state = ConnectivityState(
    isOnline: true,
    lastChecked: DateTime.now(),
  );

  ConnectivityState get state => _state;
  bool get isOnline => _state.isOnline;
  bool get isOffline => !_state.isOnline;

  final Dio _dio;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Se recibe la instancia de Dio desde el exterior.
  ConnectivityProvider(this._dio) {
    _initDio();
    _initConnectivityListener();
    _checkInitialConnectivity();
  }

  void _initDio() {
    // El interceptor se agrega aquí para asegurar que siempre esté en la instancia de Dio
    // que este provider maneja, sin importar dónde se cree el Dio.
    _dio.interceptors.add(ConnectivityInterceptor(this));
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .handleError((err) => print(err))
        .listen(
      (results) {
        final bool hasConnection =
            results.any((result) => result != ConnectivityResult.none);

        // Dispara la verificación real solo si hay un cambio de estado de bajo nivel.
        if (hasConnection != _state.isOnline) {
          _performRealConnectivityCheck();
        }
      },
      // El `onError` del stream captura errores de la plataforma en web.
      onError: (error) {
        _updateConnectionState(false);
      },
      cancelOnError: true,
    );
  }

  Future<void> _checkInitialConnectivity() async {
    await _performRealConnectivityCheck();
  }

  Future<void> _performRealConnectivityCheck() async {
    try {
      // Se utiliza la instancia de Dio que fue inyectada, con su URL ya configurada.
      // Se hace una llamada a un endpoint simple como '/'.
      final response = await _dio.get('/');

      if (response.statusCode == 200) {
        _updateConnectionState(true);
      } else {
        _updateConnectionState(false);
      }
    } on DioException catch (e) {
      // Se capturan los errores específicos de Dio.
      setOfflineWithError(e.message ?? 'Error de conexión');
    } catch (e) {
      // Se captura cualquier otro tipo de error.
      setOfflineWithError('Error inesperado');
    }
  }

  void _updateConnectionState(bool isOnline) {
    if (_state.isOnline != isOnline) {
      _state = _state.copyWith(
        isOnline: isOnline,
        hasError: false,
        errorMessage: null,
        lastChecked: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void setOfflineWithError(String errorMessage) {
    _state = _state.copyWith(
      isOnline: false,
      hasError: true,
      errorMessage: errorMessage,
      lastChecked: DateTime.now(),
    );
    notifyListeners();
  }

  void clearError() {
    _state = _state.copyWith(
      hasError: false,
      errorMessage: null,
    );
    notifyListeners();
  }

  Future<void> retryConnection() async {
    clearError();
    await _performRealConnectivityCheck();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
