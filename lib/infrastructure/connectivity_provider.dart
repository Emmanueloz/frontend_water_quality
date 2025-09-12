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

  Dio get dio => _dio;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityProvider(this._dio) {
    _initDio();
    _initConnectivityListener();
    _checkInitialConnectivity();
  }

  void _initDio() {
    _dio.interceptors.add(ConnectivityInterceptor(this));
  }

  void _initConnectivityListener() {
    print("Iniciando connectivity listener");

    // SOLUCIÓN: Usar handleError en el stream para evitar crashes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.handleError((error) {
      print("Error manejado en stream: $error");
    }).listen(
      (results) {
        print("Cambio de conectividad: $results");

        // Tu lógica original
        bool hasConnection = results
            .where((result) => result != ConnectivityResult.none)
            .toList()
            .isNotEmpty;

        print("¿Tiene conexión según connectivity_plus?: $hasConnection");

        if (hasConnection) {
          // Solo hacer ping real si connectivity dice que hay conexión
          _performRealConnectivityCheck();
        } else {
          // Si no hay conexión, actualizar inmediatamente
          _updateConnectionState(false);
        }
      },
    );
  }

  Future<void> _checkInitialConnectivity() async {
    print("Verificando conectividad inicial");

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      print("Conectividad inicial: $connectivityResult");

      // Tu lógica original
      bool hasConnection = connectivityResult
          .where((result) => result != ConnectivityResult.none)
          .toList()
          .isNotEmpty;

      _updateConnectionState(hasConnection);

      // Verificación adicional con ping real
      await _performRealConnectivityCheck();
    } catch (e) {
      print("Error en verificación inicial: $e");
      // Si falla, asumir online y hacer ping
      _updateConnectionState(true);
      await _performRealConnectivityCheck();
    }
  }

  Future<void> _performRealConnectivityCheck() async {
    print("Realizando ping real...");

    try {
      final result = await _dio.get(
        "/",
      );

      print("Resultado del ping: ${result.statusCode}");

      if (result.statusCode == 200) {
        _updateConnectionState(true);
      } else {
        _updateConnectionState(false);
      }
    } catch (e) {
      print("Error en ping real: $e");
      _updateConnectionState(false);
    }
  }

  void _updateConnectionState(bool isOnline) {
    print("Actualizando estado: $isOnline");

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
    print("Setting offline con error: $errorMessage");

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
    print("Reintentando conexión...");
    clearError();
    await _performRealConnectivityCheck();
  }

  @override
  void dispose() {
    print("Disposing ConnectivityProvider");
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
