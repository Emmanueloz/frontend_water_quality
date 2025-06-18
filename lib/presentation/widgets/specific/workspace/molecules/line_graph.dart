import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatefulWidget {
  final String sensorType;
  final double value;
  final List<String> dates;
  final List<double> data;
  final double minY;
  final double maxY;
  final double intervalY;

  const LineGraph({
    super.key,
    required this.sensorType,
    required this.value,
    required this.dates,
    required this.data,
    required this.minY,
    required this.maxY,
    required this.intervalY,
  });

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  List<Color> gradientColors = const [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Texto con ajuste automático
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.sensorType} - ${widget.value}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Gráfica expandida sin scroll
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.70,
                child: LineChart(mainData()),
              ),
            ),
          ],
        ),
      ),
    );
  }
  LineChartData mainData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.data.length; i++) {
      spots.add(FlSpot(i.toDouble(), widget.data[i]));
    }

    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index < 0 || index >= widget.dates.length) {
                return const SizedBox.shrink();
              }
              return Text(widget.dates[index], style: const TextStyle(fontSize: 10));
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: widget.intervalY,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              return Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 10));
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: (widget.data.length - 1).toDouble(),
      minY: widget.minY,
      maxY: widget.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 4,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
