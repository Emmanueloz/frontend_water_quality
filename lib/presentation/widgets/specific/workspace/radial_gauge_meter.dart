import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class RadialGaugeMeter extends StatelessWidget {
  final String sensorType;
  final double value;
  final double min;
  final double max;
  final int interval;
  final Size size;

  const RadialGaugeMeter({
    super.key,
    required this.sensorType,
    required this.value,
    required this.min,
    required this.max,
    this.interval = 10,
    this.size = const Size(300, 300),
  });

  @override
  Widget build(BuildContext context) {
    final double valueValid = value > min && value < max ? value : min;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(179, 211, 211, 211),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            sensorType,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: GxRadialGauge(
              showValueAtCenter: false,
              startAngleInDegree: 140,
              sweepAngleInDegree: 260,
              value: GaugeValue(
                value: valueValid,
                min: min,
                max: max,
              ),
              size: size,
              interval: interval,
              showNeedle: true,
              showLabels: true,
              showMajorTicks: true,
              labelTickStyle: const RadialTickLabelStyle(
                position: RadialElementPosition.outside,
                padding: 5, // Reducido para optimizar espacio
              ),
              majorTickStyle: RadialTickStyle(
                color: Colors.cyan,
                position: RadialElementPosition.outside,
                length: 8, // Ligeramente reducido
                thickness: 1,
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
              needle: const RadialNeedle(
                color: Colors.cyan,
                shape: RadialNeedleShape.tapperedLine,
                alignment: RadialElementAlignment.end,
                thickness: 12,
                topOffest: -20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
