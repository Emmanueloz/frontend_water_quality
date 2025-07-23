import 'package:flutter/material.dart';
import 'package:frontend_water_quality/infrastructure/meter_socket_service.dart';

class MeterProvider with ChangeNotifier {
  final MeterSocketService _socketService = MeterSocketService();
  dynamic meterData;

  void subscribeToMeter({
    required String baseUrl,
    required String token,
    required String idWorkspace,
    required String idMeter,
  }) {
    _socketService.connect(
      baseUrl: baseUrl,
      token: token,
      idWorkspace: idWorkspace,
      idMeter: idMeter,
      onData: (data) {
        meterData = data;
        notifyListeners();
      },
    );
  }

  void unsubscribe() {
    _socketService.disconnect();
  }
} 