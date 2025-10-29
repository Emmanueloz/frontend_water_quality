import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:frontend_water_quality/core/interface/meter_setup.dart';
import 'package:frontend_water_quality/core/enums/pairing_state.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/infrastructure/ble_service.dart';
import 'package:frontend_water_quality/core/errors/pairing_error.dart';
import 'package:frontend_water_quality/core/utils/retry_mechanism.dart';

class BlueProvider with ChangeNotifier {
  final BLEService? _bleService;
  final MeterRepo? _meterRepo;
  bool _isScanning = false;
  bool _isConnected = false;
  bool _isConnecting = false;
  List<BluetoothDevice> _devices = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  BluetoothDevice? _connectedDevice;

  MeterSetup? _currentMeterSetup;
  PairingState _pairingState = PairingState.unpaired;
  String? _currentUserToken;
  String? _currentWorkspaceId;
  String? _currentMeterId;
  PairingError? _lastError;

  BlueProvider(this._bleService, this._meterRepo);

  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  List<BluetoothDevice> get devices => List.unmodifiable(_devices);
  BluetoothDevice? get connectedDevice => _connectedDevice;
  MeterSetup? get currentMeterSetup => _currentMeterSetup;
  PairingState get pairingState => _pairingState;
  PairingError? get lastError => _lastError;

  bool get isSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  void updatePairingState(PairingState newState, [PairingError? error]) {
    _pairingState = newState;
    _lastError = error;
    notifyListeners();
  }

  void resetPairingState() {
    _pairingState = PairingState.unpaired;
    _lastError = null;
    notifyListeners();
  }

  void setValidationContext({
    required String userToken,
    required String workspaceId,
    required String meterId,
  }) {
   

    _currentUserToken = userToken;
    _currentWorkspaceId = workspaceId;
    _currentMeterId = meterId;


    print(_currentMeterSetup?.token);

    _validateCurrentToken();
  }

  Future<void> initScan() async {
    if (_isScanning) return;

    _isScanning = true;
    _devices.clear();
    _lastError = null;
    notifyListeners();

    try {
      await RetryMechanism.execute(
        () async {
          await _bleService?.startScan(
            onDevicesFound: (devices) {
              _devices = devices;
              notifyListeners();
            },
          );
        },
        config: RetryConfig.bluetooth,
        shouldRetry: (error) => _shouldRetryBluetoothError(error),
        onRetry: (attempt, error) {
          print('Retrying Bluetooth scan (attempt $attempt): $error');
        },
      );
    } catch (e) {
      final pairingError = PairingError.fromException(e);
      _lastError = pairingError;
      print('Bluetooth scan failed: ${pairingError.message}');
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _isConnecting = true;
      _connectedDevice = device;
      _isScanning = false;
      _lastError = null;
      notifyListeners();

      await RetryMechanism.execute(
        () async {
          await device.connect(
            autoConnect: false,
            timeout: const Duration(seconds: 15),
          );

          // Setup message listener
          await _bleService?.setupConnection(device, (data) {
            _callbackMessage(String.fromCharCodes(data));
          });
        },
        config: RetryConfig.bluetooth,
        shouldRetry: (error) => _shouldRetryBluetoothError(error),
        onRetry: (attempt, error) {
          print('Retrying Bluetooth connection (attempt $attempt): $error');
        },
      );

      _isConnected = true;
      _isConnecting = false;
      notifyListeners();

      // Request meter configuration immediately after connection
      await sendMessage("getConfig");

      // If we already have validation context, prepare for validation
      if (_currentUserToken != null &&
          _currentWorkspaceId != null &&
          _currentMeterId != null) {
        // Reset pairing state to prepare for new validation
        resetPairingState();
      }
    } catch (e) {
      final pairingError = PairingError.fromException(e);
      _lastError = pairingError;
      _isConnected = false;
      _isConnecting = false;
      notifyListeners();
      print('Bluetooth connection failed: ${pairingError.message}');
    }
  }

  void cancelConnect() {
    _isConnecting = false;
    _isConnected = false;
    _connectedDevice = null;
    notifyListeners();
  }

  @visibleForTesting
  void callbackMessage(String data) {
    _callbackMessage(data);
  }

  void _callbackMessage(String data) {
    print(data);
    try {
      final newMeterSetup = MeterSetup.fromString(data);

      // Check if this is a new meter setup or token has changed
      bool shouldValidate = _currentMeterSetup == null ||
          _currentMeterSetup!.token != newMeterSetup.token;

      _currentMeterSetup = newMeterSetup;
      notifyListeners();

      // Automatically validate token when MeterSetup is received or changed (async)
      if (shouldValidate &&
          _currentMeterSetup?.token != null &&
          _currentMeterSetup!.token!.isNotEmpty &&
          _meterRepo != null &&
          _currentUserToken != null &&
          _currentWorkspaceId != null &&
          _currentMeterId != null) {
        // Schedule validation for next frame to avoid setState during build
        Future.microtask(() => _validateCurrentToken());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _validateCurrentToken() async {
    final token = _currentMeterSetup?.token;
    print(token);
    print(_meterRepo);
    print(_currentUserToken);
    print(_currentWorkspaceId);
    print(_currentMeterId);

    if (token == null ||
        token.isEmpty ||
        _meterRepo == null ||
        _currentUserToken == null ||
        _currentWorkspaceId == null ||
        _currentMeterId == null) {
      updatePairingState(PairingState.unpaired);
      return;
    }

    try {
      updatePairingState(PairingState.checking);

      final result = await RetryMechanism.execute(
        () async {
          final result = await _meterRepo.validateToken(
            _currentUserToken!,
            _currentWorkspaceId!,
            _currentMeterId!,
            token,
          );

          return result;
        },
        config: RetryConfig.validation,
        shouldRetry: (error) => _shouldRetryValidationError(error),
        onRetry: (attempt, error) {
          print('Retrying token validation (attempt $attempt): $error');
        },
      );

      if (result.isSuccess && result.value==true) {
        updatePairingState(PairingState.paired);
      } else {
        final error = PairingError.tokenMismatch();
        updatePairingState(PairingState.unpaired, error);
      }
    } catch (e) {
      final pairingError = PairingError.fromException(e);
      print('Error validating token: ${pairingError.message}');
      updatePairingState(PairingState.error, pairingError);
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      await RetryMechanism.execute(
        () async {
          await _bleService?.send(message);
        },
        config: RetryConfig.bluetooth,
        shouldRetry: (error) => _shouldRetryBluetoothError(error),
        onRetry: (attempt, error) {
          print('Retrying Bluetooth message send (attempt $attempt): $error');
        },
      );
    } catch (e) {
      final pairingError = PairingError.fromException(e);
      _lastError = pairingError;
      print('Failed to send Bluetooth message: ${pairingError.message}');
      notifyListeners();
    }
  }

  Future<bool> setApiKey(String token) async {
    if (token.isEmpty) {
      final error = PairingError.invalidToken();
      updatePairingState(PairingState.error, error);
      return false;
    }

    if (!_isConnected) {
      final error = PairingError.connectionLost();
      updatePairingState(PairingState.error, error);
      return false;
    }

    try {
      updatePairingState(PairingState.pairing);

      await RetryMechanism.execute(
        () async {
          await _bleService?.send("setApiKey=$token");
        },
        config: RetryConfig.bluetooth,
        shouldRetry: (error) => _shouldRetryBluetoothError(error),
        onRetry: (attempt, error) {
          print('Retrying API key transmission (attempt $attempt): $error');
        },
      );

      updatePairingState(PairingState.paired);
      return true;
    } catch (e) {
      final pairingError = PairingError.fromException(e);
      print('Error setting API key: ${pairingError.message}');
      updatePairingState(PairingState.error, pairingError);
      return false;
    }
  }

  Future<void> validateToken() async {
    await _validateCurrentToken();
  }

  /// Forces token validation for the current meter setup
  /// This is useful when entering a meter page to ensure the token is still valid
  Future<void> forceTokenValidation() async {
    if (_currentMeterSetup?.token != null &&
        _currentMeterSetup!.token!.isNotEmpty &&
        _meterRepo != null &&
        _currentUserToken != null &&
        _currentWorkspaceId != null &&
        _currentMeterId != null) {
      await _validateCurrentToken();
    } else {
      // If no token or context, set to unpaired
      updatePairingState(PairingState.unpaired);
    }
  }

  void updateMeterSetupToken(String token) {
    if (_currentMeterSetup != null) {
      _currentMeterSetup = MeterSetup(
        ssidWifi: _currentMeterSetup!.ssidWifi,
        passwordWifi: _currentMeterSetup!.passwordWifi,
        ph4: _currentMeterSetup!.ph4,
        ph6: _currentMeterSetup!.ph6,
        token: token,
      );
      notifyListeners();
    }
  }

  // For testing purposes only
  @visibleForTesting
  set currentMeterSetup(MeterSetup? setup) {
    _currentMeterSetup = setup;
    notifyListeners();
  }

  Future<void> disconnect() async {
    try {
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      _connectedDevice = null;
      _isConnected = false;
      _currentMeterSetup = null;
      // Reset pairing state when disconnecting
      resetPairingState();
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    await _bleService?.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  bool _shouldRetryBluetoothError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Don't retry permission or hardware issues
    if (errorString.contains('permission') ||
        errorString.contains('disabled') ||
        errorString.contains('unavailable')) {
      return false;
    }

    // Retry connection and transmission errors
    if (errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('failed') ||
        errorString.contains('lost')) {
      return true;
    }

    if (error is PairingError) {
      return error.isRetryable;
    }

    return false;
  }

  bool _shouldRetryValidationError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Don't retry authentication or validation errors
    if (errorString.contains('unauthorized') ||
        errorString.contains('invalid') ||
        errorString.contains('not found')) {
      return false;
    }

    // Retry network and server errors
    if (errorString.contains('timeout') ||
        errorString.contains('network') ||
        errorString.contains('server')) {
      return true;
    }

    if (error is PairingError) {
      return error.isRetryable;
    }

    return false;
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _bleService?.disconnect();
    super.dispose();
  }
}
