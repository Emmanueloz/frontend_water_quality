import 'package:frontend_water_quality/domain/models/record_models.dart';

class MeterRecordsResponse {
  final List<Record<SRColorValue>> colorRecords;
  final List<Record<double>> conductivityRecords;
  final List<Record<double>> phRecords;
  final List<Record<double>> temperatureRecords;
  final List<Record<double>> tdsRecords;
  final List<Record<double>> turbidityRecords;

  MeterRecordsResponse({
    required this.colorRecords,
    required this.conductivityRecords,
    required this.phRecords,
    required this.temperatureRecords,
    required this.tdsRecords,
    required this.turbidityRecords,
  });


  factory MeterRecordsResponse.fromJson(Map<String, dynamic> json) {
    return MeterRecordsResponse(
      colorRecords: (json['color'] as List)
          .map((item) => Record<SRColorValue>.fromJson(item, (v) => SRColorValue.fromJson(v)))
          .toList(),
      conductivityRecords: (json['conductivity'] as List)
          .map((item) => Record<double>.fromJson(item, (v) => (v as num).toDouble()))
          .toList(),
      phRecords: (json['ph'] as List)
          .map((item) => Record<double>.fromJson(item, (v) => (v as num).toDouble()))
          .toList(),
      temperatureRecords: (json['temperature'] as List)
          .map((item) => Record<double>.fromJson(item, (v) => (v as num).toDouble()))
          .toList(),
      tdsRecords: (json['tds'] as List)
          .map((item) => Record<double>.fromJson(item, (v) => (v as num).toDouble()))
          .toList(),
      turbidityRecords: (json['turbidity'] as List)
          .map((item) => Record<double>.fromJson(item, (v) => (v as num).toDouble()))
          .toList(),
    );
  }
}