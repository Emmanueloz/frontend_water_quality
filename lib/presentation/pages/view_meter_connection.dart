import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/main_meter_connection_widget.dart';

class ViewMeterConnection extends StatelessWidget {
  final String title;
  final String id;
  final String idMeter;

  const ViewMeterConnection(
      {super.key,
      required this.title,
      required this.id,
      required this.idMeter});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    return MainMeterConnectionWidget(
      idWorkspace: id,
      idMeter: idMeter,
      screenSize: screenSize,
    );
  }
}
