import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

enum BleStatus {
  unknown,
  resetting,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
  error,
}

typedef MessageCallback = void Function(List<int> data);
typedef ScanResultCallback = void Function(List<BluetoothDevice> devices);

class BLEService {
  BLEService() {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  }

  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  StreamSubscription<List<int>>? _valueChangedSubscription;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  final List<BluetoothDevice> _discoveredDevices = [];

  final Guid _serviceUuid = Guid("853540ca-6f63-4823-baf8-52dc3781b06a");
  final Guid _charUuid = Guid("1a5c9524-128c-40b9-9b13-bf435190a3a6");

  bool get isConnected => _device?.isConnected ?? false;
  List<BluetoothDevice> get discoveredDevices => List.unmodifiable(_discoveredDevices);
  bool get isScanning => _scanSubscription != null;
  
  Stream<BleStatus> get status async* {
    yield* FlutterBluePlus.adapterState
        .map((state) {
          if (state == BluetoothAdapterState.on) {
            return BleStatus.poweredOn;
          } else if (state == BluetoothAdapterState.off) {
            return BleStatus.poweredOff;
          } else if (state == BluetoothAdapterState.unauthorized) {
            return BleStatus.unauthorized;
          }
          return BleStatus.unknown;
        })
        .handleError((_) => BleStatus.error);
  }

  Future<void> setupConnection(BluetoothDevice device, MessageCallback onMessage) async {
    _device = device;
    
    // Setup connection state listener
    device.connectionState.listen((state) async {
      if (state == BluetoothConnectionState.disconnected) {
        await _cleanup();
      }
    });

    await _discoverServices(device, onMessage);
  }

  Future<void> _discoverServices(BluetoothDevice device, MessageCallback onMessage) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      
      for (var service in services) {
        print(service.uuid);
        if (service.uuid == _serviceUuid) {
          for (var char in service.characteristics) {
            if (char.uuid == _charUuid) {
              _characteristic = char;
              await _setupCharacteristic(char, onMessage);
              return;
            }
          }
        }
      }
      throw Exception('Required service or characteristic not found');
    } catch (e) {
      await _cleanup();
      rethrow;
    }
  }

  Future<void> _setupCharacteristic(
    BluetoothCharacteristic char, 
    MessageCallback onMessage
  ) async {
    await _valueChangedSubscription?.cancel();
    await char.setNotifyValue(true);
    
    _valueChangedSubscription = char.onValueReceived.listen(onMessage);
  }

  Future<void> send(String message) async {
    if (_characteristic == null) {
      throw Exception('Not connected to any device');
    }
    
    try {
      await _characteristic!.write(message.codeUnits);
    } catch (e) {
      await _cleanup();
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _cleanup();
    if (_device != null) {
      try {
        await _device!.disconnect();
      } catch (e) {
        // Ignore errors during disconnection
      }
    }
  }

  Future<void> _cleanup() async {
    await _valueChangedSubscription?.cancel();
    _valueChangedSubscription = null;
    _characteristic = null;
  }

  Future<bool> isBLESupported() async {
    return await FlutterBluePlus.isSupported;
  }

  Future<bool> _checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      // Request location permission
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          return false;
        }
      }
      
      // Check if Bluetooth is on
      final bluetoothStatus = await FlutterBluePlus.adapterState.first;
      if (bluetoothStatus != BluetoothAdapterState.on) {
        return false;
      }
      
      // Check if location is enabled (required for BLE on Android)
      if (!(await FlutterBluePlus.isOn)) {
        return false;
      }
    }
    return true;
  }

  Future<void> startScan({
    required ScanResultCallback onDevicesFound,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (_scanSubscription != null) return;

    // Check and request permissions
    final hasPermission = await _checkAndRequestPermissions();
    if (!hasPermission) {
      throw Exception('Se requieren permisos de ubicación para escanear dispositivos BLE');
    }

    _discoveredDevices.clear();
    
    try {
      // Clear previous scan results
      if (_scanSubscription != null) {
        await _scanSubscription!.cancel();
        _scanSubscription = null;
      }
      
      // Listen for scan results
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        if (results.isEmpty) return;
        
        final newDevices = results
            .where((r) => r.advertisementData.advName.isNotEmpty)
            .map((r) => r.device)
            .toSet()
            .toList();
            
        _discoveredDevices.clear();
        _discoveredDevices.addAll(newDevices);
        onDevicesFound(_discoveredDevices);
      });
      
      // Start a new scan with timeout
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidUsesFineLocation: true,
      );
      
      // Stop scan after timeout if still scanning
      Future.delayed(timeout, () async {
        if (_scanSubscription != null) {
          await stopScan();
        }
      });
      
    } catch (e) {
      await stopScan();
      rethrow;
    }
  }

  Future<void> stopScan() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    await FlutterBluePlus.stopScan();
  }
}
