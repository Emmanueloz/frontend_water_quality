import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_meter.dart';

class ViewMeter extends StatelessWidget {
  final String id;
  final String idMeter;
  const ViewMeter({
    super.key,
    required this.id,
    required this.idMeter,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return MainMeter(
      id: id,
      idMeter: idMeter,
      screenSize: screenSize,
    );
  }
}
