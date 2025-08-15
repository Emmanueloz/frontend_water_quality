import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_meter.dart';

class ViewMeterFullScreen extends StatelessWidget {
  final String id;
  final String idMeter;
  const ViewMeterFullScreen({
    super.key,
    required this.id,
    required this.idMeter,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: MainMeter(
          idMeter: idMeter,
          screenSize: screenSize,
          id: id,
          isFullScreen: true,
        ),
      ),
    );
  }
}
