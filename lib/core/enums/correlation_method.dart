enum CorrelationMethod {
  spearman,
  pearson;
}

extension CorrelationMethodLabel on CorrelationMethod {
  String get label {
    switch (this) {
      case CorrelationMethod.spearman:
        return 'Spearman';
      case CorrelationMethod.pearson:
        return 'Pearson';
    }
  }

  String get value => name;
}
