enum PeriodType {
  days,
  months,
  years;
}

extension PeriodTypeLabel on PeriodType {
  String get label {
    switch (this) {
      case PeriodType.days:
        return 'Días';
      case PeriodType.months:
        return 'Meses';
      case PeriodType.years:
        return 'Años';
    }
  }

  String get value {
    return name; // Retorna el nombre del enum en inglés (days, months, years)
  }
}
