import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:intl/intl.dart';

class LineChartAnalysis extends StatelessWidget {
  final String title;
  final List<DateTime?> titles;
  final List<double?> values;
  final String periodType;
  final double maxY;
  final double? width;
  final ScreenSize screenSize;

  const LineChartAnalysis({
    super.key,
    required this.title,
    required this.titles,
    required this.values,
    required this.periodType,
    required this.maxY,
    this.width,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final length = values.length;

    final List<LineChartBarData> lineSegments = _createSegmentedLines(theme);

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
                  "${title.toUpperCase()} - Cantidad de valores $length",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      maxY: maxY,
                      minY: 0,
                      // Configuración de touch/tooltip
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

                              // Para este chart solo mostramos el valor
                              return LineTooltipItem(
                                flSpot.y.toStringAsFixed(2),
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
                      lineBarsData: lineSegments,
                      borderData: FlBorderData(show: false),
                      // Grid personalizado
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        verticalInterval: _getInterval(length),
                        horizontalInterval: _getIntervalY(),
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
                            reservedSize: 55, // Aumentado para dar más espacio
                            interval: _getIntervalY(),
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8), // Separación del grid
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

  List<LineChartBarData> _createSegmentedLines(ThemeData theme) {
    List<LineChartBarData> lines = [];
    List<FlSpot> currentSegment = [];

    for (int i = 0; i < values.length; i++) {
      final value = values[i];

      if (value != null) {
        currentSegment.add(FlSpot(i.toDouble(), value));
      } else {
        // Guardar segmento actual si tiene al menos un punto
        if (currentSegment.isNotEmpty) {
          lines.add(LineChartBarData(
            spots: List.from(currentSegment),
            color: theme.colorScheme.primary,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false, // Ocultar puntos por defecto
            ),
            belowBarData: BarAreaData(show: false),
          ));
          currentSegment.clear();
        }
      }
    }

    // Agregar último segmento si existe
    if (currentSegment.isNotEmpty) {
      lines.add(LineChartBarData(
        spots: List.from(currentSegment),
        color: theme.colorScheme.primary,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false, // Ocultar puntos por defecto
        ),
        belowBarData: BarAreaData(show: false),
      ));
    }

    return lines;
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

  double _getIntervalY() {
    if (maxY < 20) {
      return 2; // Aumentado para más separación
    }

    return maxY / 8; // Reducido de 10 a 8 para menos líneas
  }

  double _getInterval(int length) {
    if (length < 10) {
      return 1;
    }
    return length / 8; // Reducido para menos líneas verticales
  }
}
