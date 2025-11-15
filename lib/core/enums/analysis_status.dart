enum AnalysisStatus {
  creating,
  updating,
  saved,
  error;
}

extension AnalysisStatusExtension on AnalysisStatus {
  String get nameSpanish {
    switch (this) {
      case AnalysisStatus.creating:
        return 'Creando';
      case AnalysisStatus.updating:
        return 'Actualizando';
      case AnalysisStatus.saved:
        return 'Guardado';
      case AnalysisStatus.error:
        return 'Error';
    }
  }

  static AnalysisStatus fromString(String value) {
    return AnalysisStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => AnalysisStatus.saved,
    );
  }
}
