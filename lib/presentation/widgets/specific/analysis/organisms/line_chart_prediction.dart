import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:intl/intl.dart';

class LineChartPrediction extends StatelessWidget {
  final SensorType sensor;
  final List<DateTime?> titles;
  final List<double?> dataValues;
  final List<double?> predValues;
  final String periodType;
  final double? width;
  final ScreenSize screenSize;
  const LineChartPrediction({
    super.key,
    required this.sensor,
    required this.titles,
    required this.periodType,
    required this.dataValues,
    required this.predValues,
    this.width,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final length = dataValues.length + predValues.length;
    final maxY = LimitChartSensor.getMaxY(sensor);

    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: _getAspectRatio(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                Text(
                  "${sensor.nameSpanish} - Cantidad de valores $length",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      maxY: maxY,
                      minY: 0,
                      maxX: length.toDouble(),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          // Fondo del tooltip personalizado
                          getTooltipColor: (touchedSpot) {
                            return theme.colorScheme.surface.withAlpha(90);
                          },
                          // Elementos del tooltip personalizados
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final flSpot = barSpot;
                              final textStyle = TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              );

                              // Determinar si es dato real o predicción
                              String label = flSpot.x < dataValues.length
                                  ? 'Real'
                                  : 'Predicción';

                              return LineTooltipItem(
                                '$label\n${flSpot.y.toStringAsFixed(2)}',
                                textStyle,
                              );
                            }).toList();
                          },
                          // Configuración del tooltip
                          tooltipBorderRadius: BorderRadius.circular(8),
                          tooltipPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          tooltipMargin: 8,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          tooltipBorder: BorderSide(
                            color: theme.colorScheme.outline.withAlpha(30),
                            width: 1,
                          ),
                        ),
                      ),
                      lineBarsData: [
                        _createLineChart(
                          dataValues,
                          theme.colorScheme.tertiary,
                        ),
                        _createLineChart(
                          predValues,
                          theme.colorScheme.primary,
                          index: dataValues.length,
                        )
                      ],
                      showingTooltipIndicators: [],
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        verticalInterval: _getInterval(length),
                        horizontalInterval: _getIntervalY(maxY),
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: theme.colorScheme.outline.withAlpha(20),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: theme.colorScheme.outline.withAlpha(20),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            interval: _getInterval(length),
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index < 0 || index >= titles.length) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  _formatDate(titles[index] ?? DateTime.now()),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 55,
                            interval: _getIntervalY(maxY),
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    value.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  double _getAspectRatio() {
    switch (screenSize) {
      case ScreenSize.mobile:
        return 1 / 1; // Cuadrado para móviles
      case ScreenSize.tablet:
        return 4 / 3; // Más ancho para tablets
      case ScreenSize.smallDesktop:
        return 16 / 9;
      case ScreenSize.largeDesktop:
        return 16 / 9;
    }
  }

  LineChartBarData _createLineChart(List<double?> values, Color color,
      {int index = 0}) {
    List<FlSpot> segment = [];

    for (int i = 0; i < values.length; i++) {
      final value = values[i];

      if (value != null) {
        segment.add(FlSpot((i + index).toDouble(), value));
      }
    }

    return LineChartBarData(
      spots: segment,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false, // Ocultar puntos por defecto
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  String _formatDate(DateTime datetime) {
    String format = "dd/MMM";
    if (periodType == "months") {
      format = "MMM";
    } else if (periodType == "years") {
      format = "yyyy";
    }
    return DateFormat(format).format(datetime);
  }

  double _getIntervalY(double maxY) {
    if (maxY < 20) {
      return 2; // Aumentado para más separación
    }
    return maxY / 10; // Reducido de 10 a 8 para menos líneas
  }

  double _getInterval(int length) {
    if (length < 10) {
      return 1;
    }
    return length / 10; // Reducido para menos líneas verticales
  }
}
