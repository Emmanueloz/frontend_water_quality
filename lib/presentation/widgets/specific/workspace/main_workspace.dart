import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/radial_gauge_meter.dart';

class MainWorkspace extends StatelessWidget {
  final String idMeter;
  final ScreenSize screenSize;
  const MainWorkspace({
    super.key,
    required this.idMeter,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(179, 211, 211, 211),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Medidor $idMeter",
            ),
            RadialGaugeMeter()
          ],
        ),
      ),
    );
  }
}
