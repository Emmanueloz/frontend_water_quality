enum AnalysisType {
  average,
  correlation,
  prediction,
  averagePeriod;
}

extension AnalysisTypeExtension on AnalysisType {
  String get nameSpanish {
    switch (this) {
      case AnalysisType.average:
        return 'Promedio';
      case AnalysisType.correlation:
        return 'Correlación';
      case AnalysisType.prediction:
        return 'Predicción';
      case AnalysisType.averagePeriod:
        return 'Promedio por Período';
    }
  }

  static AnalysisType fromString(String value) {
    final normalized = value.toLowerCase().replaceAll('_', '');
    return AnalysisType.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => AnalysisType.average,
    );
  }
}
