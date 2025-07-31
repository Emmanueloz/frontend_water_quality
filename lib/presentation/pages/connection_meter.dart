import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/initial_meter_setup.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/scan_section.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class ConnectionMeterPage extends StatefulWidget {
  final String id;
  final String idMeter;
  const ConnectionMeterPage({
    super.key,
    required this.id,
    required this.idMeter,
  });

  @override
  State<ConnectionMeterPage> createState() => _ConnectionMeterPageState();
}

class _ConnectionMeterPageState extends State<ConnectionMeterPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return BaseContainer(
      margin: EdgeInsets.all(
          screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
              ? 10
              : 0),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Consumer<BlueProvider>(
          builder: (context, blueProvider, _) {
            if (!blueProvider.isSupported) {
              return const Center(
                child:
                    Text("Bluetooth no es soportado, usa la aplicación móvil"),
              );
            }

            if (!blueProvider.isConnected) {
              return ScanSection(
                blueProvider: blueProvider,
              );
            }

            return InitialMeterSetup(
              idWorkspace: widget.id,
              idMeter: widget.idMeter,
              nameDevice: blueProvider.connectedDevice!.advName,
              onSaveWifi: (String ssid, String password) async {
                blueProvider.sendMessage("cSsid=$ssid,cPassword=$password");
              },
              onSaveManualCalibration: (double ph4, double ph6) async {
                blueProvider.sendMessage("cSetPh4=$ph4,cSetPh6=$ph6");
              },
              onCalibratePh4: () async {
                blueProvider.sendMessage("cPhCalibration=4");
              },
              onCalibratePh6: () async {
                blueProvider.sendMessage("cPhCalibration=6");
              },
              onDisconnect: () async {
                blueProvider.disconnect();
              },
              onResetCalibration: () async {},
            );
          },
        ),
      ),
    );
  }
}
