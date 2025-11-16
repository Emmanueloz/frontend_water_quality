import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/analysis_type.dart';

/// A widget that displays a brief, user-friendly description for each analysis chart type.
/// 
/// This component helps users understand how to interpret different types of analysis charts
/// by providing contextual information in Spanish.
class ChartDescription extends StatelessWidget {
  /// The type of analysis chart being described
  final AnalysisType type;

  const ChartDescription({
    super.key,
    required this.type,
  });

  /// Returns the appropriate description text based on the analysis type
  String _getDescription() {
    switch (type) {
      case AnalysisType.average:
        return 'Este gráfico muestra el promedio de los valores de los sensores durante el período seleccionado. Los valores más altos o bajos indican tendencias en la calidad del agua.';
      case AnalysisType.correlation:
        return 'Este gráfico muestra la relación entre diferentes parámetros del agua. Los valores cercanos a 1 o -1 indican una fuerte correlación positiva o negativa.';
      case AnalysisType.prediction:
        return 'Este gráfico muestra valores predichos para el futuro basados en datos históricos. Las áreas sombreadas representan el rango de confianza de la predicción.';
      case AnalysisType.averagePeriod:
        return 'Este gráfico muestra promedios calculados por períodos específicos (diario, semanal, mensual). Útil para identificar patrones recurrentes.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(80),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: Text(
              _getDescription(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
