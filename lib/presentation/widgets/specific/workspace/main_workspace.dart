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
        padding: const EdgeInsets.symmetric(
          horizontal: 60.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(179, 211, 211, 211),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Medidor $idMeter",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            RadialGaugeMeter(
              sensorType: "Temperatura",
              value: 54,
              min: 0,
              max: 60,
              interval: 10,
            ),
          ],
        ),
      ),
    );
  }
}
