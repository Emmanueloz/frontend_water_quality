import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class RadialGaugeMeter extends StatefulWidget {
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
  State<RadialGaugeMeter> createState() => _RadialGaugeMeterState();
}

class _RadialGaugeMeterState extends State<RadialGaugeMeter> {
  double _oldValue = 0;

  @override
  void didUpdateWidget(covariant RadialGaugeMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldValue = oldWidget.value;
  }

  @override
  Widget build(BuildContext context) {
    final double valueValid =
        widget.value > widget.min && widget.value < widget.max
            ? widget.value
            : widget.min;

    List<Color> colors = [
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
    ];

    return Card(
      //width: widget.size.width,
      //height: widget.size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            widget.sensorType,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: _oldValue, end: valueValid),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, _) {
                return GxRadialGauge(
                  startAngleInDegree: 140,
                  sweepAngleInDegree: 260,
                  value: GaugeValue(
                    value: animatedValue,
                    min: widget.min,
                    max: widget.max,
                  ),
                  size: widget.size,
                  interval: widget.interval,
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
                      value: animatedValue,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
