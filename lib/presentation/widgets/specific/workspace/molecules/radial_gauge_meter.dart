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

    List<Color> colors = [
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
    ];

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            sensorType,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: GxRadialGauge(
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
                position: RadialElementPosition.inside,
                padding: 10,
              ),
              majorTickStyle: RadialTickStyle(
                color: Theme.of(context).colorScheme.primary,
                position: RadialElementPosition.inside,
                length: 8,
                thickness: 1,
              ),
              style: RadialGaugeStyle(
                thickness: 10,
                gradient: LinearGradient(
                  colors: colors,
                ),
              ),
              pointers: [
                RadialPointer(
                  value: valueValid,
                  shape: RadialPointerShape.circle,
                  showNeedle: false,
                  style: RadialPointerStyle(
                    color: Theme.of(context).colorScheme.primary,
                    paintingStyle: PaintingStyle.fill,
                    size: 12,
                    thickness: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
