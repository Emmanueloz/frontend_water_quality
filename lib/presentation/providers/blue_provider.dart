import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:frontend_water_quality/infrastructure/ble_service.dart';

class BlueProvider with ChangeNotifier {
  final BLEService? _bleService;
  bool _isScanning = false;
  bool _isConnected = false;
  List<BluetoothDevice> _devices = [];
  List<String> _messages = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  BluetoothDevice? _connectedDevice;

  BlueProvider(this._bleService);

  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  List<BluetoothDevice> get devices => List.unmodifiable(_devices);
  List<String> get messages => List.unmodifiable(_messages);
  BluetoothDevice? get connectedDevice => _connectedDevice;

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
      _isConnected = true;
      _addMessage('Connected to ${device.advName}');

      // Setup message listener
      await _bleService?.setupConnection(device, (data) {
        _addMessage('Received: ${String.fromCharCodes(data)}');
      });

      notifyListeners();
    } catch (e) {
      _addMessage('Connection failed: $e');
      rethrow;
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      await _bleService?.send(message);
      _addMessage('Sent: $message');
    } catch (e) {
      print(e);
      _addMessage('Failed to send: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
      }
      _addMessage('Disconnected');
    } catch (e) {
      _addMessage('Error disconnecting: $e');
    } finally {
      _connectedDevice = null;
      _isConnected = false;
      _messages.clear();
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    await _bleService?.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  void _addMessage(String message) {
    _messages = [..._messages, message];
    notifyListeners();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _bleService?.disconnect();
    super.dispose();
  }
}
