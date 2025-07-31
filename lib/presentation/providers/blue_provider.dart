import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:frontend_water_quality/core/interface/meter_setup.dart';
import 'package:frontend_water_quality/infrastructure/ble_service.dart';

class BlueProvider with ChangeNotifier {
  final BLEService? _bleService;
  bool _isScanning = false;
  bool _isConnected = false;
  List<BluetoothDevice> _devices = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  BluetoothDevice? _connectedDevice;

  MeterSetup? _currentMeterSetup;

  BlueProvider(this._bleService);

  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  List<BluetoothDevice> get devices => List.unmodifiable(_devices);
  BluetoothDevice? get connectedDevice => _connectedDevice;
  MeterSetup? get currentMeterSetup => _currentMeterSetup;

  bool get isSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> initScan() async {
    if (_isScanning) return;

    _isScanning = true;
    _devices.clear();
    notifyListeners();

    try {
      await _bleService?.startScan(
        onDevicesFound: (devices) {
          _devices = devices;
          notifyListeners();
        },
      );
    } catch (e) {
      _isScanning = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _connectedDevice = device;
      await device.connect(autoConnect: false);
      _isConnected = true;
      _isScanning = false;
      notifyListeners();
      await sendMessage("getConfig");
      _isConnected = true;

      // Setup message listener
      await _bleService?.setupConnection(device, (data) {
        _callbackMessage(String.fromCharCodes(data));
      });

      notifyListeners();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  void _callbackMessage(String data) {
    print(data);
    try {
      _currentMeterSetup = MeterSetup.fromString(data);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      await _bleService?.send(message);
    } catch (e) {
      print(e);
    }
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
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    await _bleService?.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _bleService?.disconnect();
    super.dispose();
  }
}
