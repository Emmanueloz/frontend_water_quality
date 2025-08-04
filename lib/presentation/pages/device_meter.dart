import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/initial_meter_setup.dart';

class DeviceMeter extends StatelessWidget {
  final String id;
  final String idMeter;
  const DeviceMeter({super.key, required this.id, required this.idMeter});

  @override
  Widget build(BuildContext context) {
    final BlueProvider blueProvider = Provider.of<BlueProvider>(context);

    return Layout(
      title: "Dispositivo",
      builder: (context, screenSize) => BaseContainer(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        child: !blueProvider.isConnected
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: InitialMeterSetup(
                  idWorkspace: id,
                  idMeter: idMeter,
                  nameDevice: blueProvider.connectedDevice!.advName,
                  initialSetup: blueProvider.currentMeterSetup,
                  onSaveWifi: (String ssid, String password) async {
                    blueProvider.sendMessage("setWifiSsid=$ssid");
                    blueProvider.sendMessage("setWifiPassword=$password");
                  },
                  onSaveManualCalibration: (double ph4, double ph6) async {
                    blueProvider.sendMessage("phSetVol4=$ph4");
                    blueProvider.sendMessage("phSetVol6=$ph6");
                  },
                  onCalibratePh4: () async {
                    blueProvider.sendMessage("phCalibrateVol4");
                  },
                  onCalibratePh6: () async {
                    blueProvider.sendMessage("phCalibrateVol6");
                  },
                  onDisconnect: () async {
                    blueProvider.disconnect();
                    context.pop();
                  },
                  onResetCalibration: () async {},
                ),
              ),
      ),
    );
  }
}
