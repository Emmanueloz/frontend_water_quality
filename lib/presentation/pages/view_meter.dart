import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/organisms/main_meter.dart';

class ViewMeter extends StatelessWidget {
  final String id;
  final String idMeter;
  const ViewMeter({
    super.key,
    required this.idMeter,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutMeters(
      title: "Medidor $idMeter",
      id: id,
      idMeter: idMeter,
      selectedIndex: 0,
      builder: (context, screenSize) {
        return MainMeter(
          idMeter: idMeter,
          screenSize: screenSize,
          id: id,
        );
      },
    );
  }
}
