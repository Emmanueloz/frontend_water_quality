import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget de Heatmap de Correlación personalizable
class CorrelationHeatmap extends StatelessWidget {
  /// Matriz de correlación (valores entre -1 y 1 típicamente)
  final List<List<double>> matrix;

  /// Etiquetas para las filas y columnas
  final List<String> labels;

  /// Color principal del heatmap (se usará con opacidad según el valor)
  final Color primaryColor;

  /// Tamaño del widget (ancho = alto)
  final double size;

  /// Mostrar valores numéricos en las celdas
  final bool showValues;

  /// Número de decimales a mostrar
  final int decimals;

  /// Color del texto
  final Color textColor;

  /// Color de las líneas de la cuadrícula
  final Color gridColor;

  const CorrelationHeatmap({
    super.key,
    required this.matrix,
    required this.labels,
    this.primaryColor = Colors.blue,
    this.size = 300,
    this.showValues = true,
    this.decimals = 2,
    this.textColor = Colors.black87,
    this.gridColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    // Validar que la matriz sea cuadrada
    assert(matrix.isNotEmpty, 'La matriz no puede estar vacía');
    assert(matrix.length == matrix[0].length, 'La matriz debe ser cuadrada');
    assert(matrix.length == labels.length,
        'El número de labels debe coincidir con el tamaño de la matriz');

    //final dimension = matrix.length;

    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: HeatmapPainter(
          matrix: matrix,
          labels: labels,
          primaryColor: primaryColor,
          showValues: showValues,
          decimals: decimals,
          textColor: textColor,
          gridColor: gridColor,
        ),
      ),
    );
  }
}

/// Painter personalizado para dibujar el heatmap
class HeatmapPainter extends CustomPainter {
  final List<List<double>> matrix;
  final List<String> labels;
  final Color primaryColor;
  final bool showValues;
  final int decimals;
  final Color textColor;
  final Color gridColor;

  HeatmapPainter({
    required this.matrix,
    required this.labels,
    required this.primaryColor,
    required this.showValues,
    required this.decimals,
    required this.textColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dimension = matrix.length;

    // Calcular espacio para labels
    final labelSize = size.width * 0.15;
    final heatmapSize = size.width - labelSize;
    final cellSize = heatmapSize / dimension;

    // Dibujar celdas del heatmap
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        final value = matrix[i][j];
        final x = labelSize + (j * cellSize);
        final y = labelSize + (i * cellSize);

        // Usar el valor absoluto para la opacidad (normalizado entre 0 y 1)
        final opacity = value.abs().clamp(0.0, 1.0);

        // Determinar el color basado en el signo del valor
        Color cellColor;
        if (value >= 0) {
          cellColor = primaryColor.withOpacity(opacity);
        } else {
          // Para valores negativos, usar un color complementario (rojo)
          cellColor = Colors.red.withOpacity(opacity);
        }

        final rect = Rect.fromLTWH(x, y, cellSize, cellSize);
        final paint = Paint()
          ..color = cellColor
          ..style = PaintingStyle.fill;

        canvas.drawRect(rect, paint);

        // Dibujar borde de celda
        final borderPaint = Paint()
          ..color = gridColor.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        canvas.drawRect(rect, borderPaint);

        // Dibujar valor en la celda
        if (showValues) {
          final textSpan = TextSpan(
            text: value.toStringAsFixed(decimals),
            style: TextStyle(
              color: opacity > 0.5 ? Colors.white : textColor,
              fontSize: cellSize * 0.25,
              fontWeight: FontWeight.w500,
            ),
          );

          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          );

          textPainter.layout();

          final textX = x + (cellSize - textPainter.width) / 2;
          final textY = y + (cellSize - textPainter.height) / 2;

          textPainter.paint(canvas, Offset(textX, textY));
        }
      }
    }

    // Dibujar labels horizontales (superior)
    for (int i = 0; i < dimension; i++) {
      final x = labelSize + (i * cellSize) + cellSize / 2;
      final y = labelSize / 2;

      _drawRotatedText(
        canvas: canvas,
        text: labels[i],
        x: x,
        y: y,
        angle: -math.pi / 4, // -45 grados
        fontSize: labelSize * 0.25,
      );
    }

    // Dibujar labels verticales (izquierda)
    for (int i = 0; i < dimension; i++) {
      final x = labelSize * 0.9;
      final y = labelSize + (i * cellSize) + cellSize / 2;

      _drawText(
        canvas: canvas,
        text: labels[i],
        x: x,
        y: y,
        fontSize: labelSize * 0.25,
        align: TextAlign.right,
      );
    }
  }

  void _drawText({
    required Canvas canvas,
    required String text,
    required double x,
    required double y,
    required double fontSize,
    TextAlign align = TextAlign.center,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: align,
    );

    textPainter.layout();

    double offsetX = x;
    if (align == TextAlign.right) {
      offsetX = x - textPainter.width;
    } else if (align == TextAlign.center) {
      offsetX = x - textPainter.width / 2;
    }

    textPainter.paint(canvas, Offset(offsetX, y - textPainter.height / 2));
  }

  void _drawRotatedText({
    required Canvas canvas,
    required String text,
    required double x,
    required double y,
    required double angle,
    required double fontSize,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle);
    textPainter.paint(
        canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(HeatmapPainter oldDelegate) {
    return oldDelegate.matrix != matrix ||
        oldDelegate.labels != labels ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.showValues != showValues ||
        oldDelegate.decimals != decimals;
  }
}
