import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/scan_section.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class ConnectionMeterPage extends StatelessWidget {
  final String id;
  final String idMeter;
  const ConnectionMeterPage({
    super.key,
    required this.id,
    required this.idMeter,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return BaseContainer(
      margin: EdgeInsets.all(
          screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
              ? 10
              : 0),
      padding: const EdgeInsets.all(16),
      child: Consumer<BlueProvider>(
        builder: (context, blueProvider, _) {
          if (!blueProvider.isSupported) {
            return const Center(
              child: Text("Bluetooth no es soportado, usa la aplicación móvil"),
            );
          }

          return ScanSection(
            blueProvider: blueProvider,
            onTap: () => context.goNamed(
              Routes.connectionMeterDevice.name,
              pathParameters: {
                "id": id,
                "idMeter": idMeter,
              },
            ),
          );
        },
      ),
    );
  }
}
