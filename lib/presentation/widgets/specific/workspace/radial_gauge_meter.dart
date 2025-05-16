import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class RadialGaugeMeter extends StatelessWidget {
  const RadialGaugeMeter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Tipo de medidor"),
        const SizedBox(height: 20),
        GxRadialGauge(
          showValueAtCenter: false,
          size: Size(300, 300),
          startAngleInDegree: 180,
          sweepAngleInDegree: 180,
          value: GaugeValue(
            value: 70,
          ),
          showNeedle: true,
          showLabels: true,
          showMajorTicks: true,
          labelTickStyle: RadialTickLabelStyle(
            position: RadialElementPosition.outside,
            padding: 10,
          ),
          majorTickStyle: RadialTickStyle(
            color: Colors.cyan,
            position: RadialElementPosition.outside,
          ),
          style: RadialGaugeStyle(
            color: Colors.white,
            thickness: 10,
            gradient: LinearGradient(
              colors: [
                Colors.cyan.shade300,
                Colors.cyan.shade600,
                Colors.cyan.shade900,
              ],
            ),
          ),
          needle: RadialNeedle(
            color: Colors.cyan,
            shape: RadialNeedleShape.tapperedLine,
            alignment: RadialElementAlignment.end,
            thickness: 12,
            topOffest: -20,
          ),
        ),
      ],
    );
  }
}
