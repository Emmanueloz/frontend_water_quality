import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/alert_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/main_grid_alerts.dart';

class AlertsScreen extends StatelessWidget {
  final String idWorkspace;
  const AlertsScreen({super.key, required this.idWorkspace});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return MainGridAlerts(
      screenSize: screenSize,
      alertItems: [
        AlertItem(
          id: "1",
          title: "El agua esta bueno",
          type: "Bueno",
        ),
        AlertItem(
          id: "2",
          title: "El agua esta malo",
          type: "malo",
        ),
        AlertItem(
          id: "3",
          title: "El agua es inaceptable",
          type: "inaceptable",
        ),
      ],
    );
  }
}
