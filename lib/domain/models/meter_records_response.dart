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
    try{
      return MeterRecordsResponse(
      colorRecords: (json['color'] as List<dynamic>)
          .map((item) => Record<SRColorValue>.fromJson(item as Map<String, dynamic>, (v) => SRColorValue.fromJson(v as Map<String, dynamic>)))
          .toList(),
      conductivityRecords: (json['conductivity'] as List<dynamic>)
          .map((item) => Record<double>.fromJson(item as Map<String, dynamic>, (v) => (v as num).toDouble()))
          .toList(),
      phRecords: (json['ph'] as List<dynamic>)
          .map((item) => Record<double>.fromJson(item as Map<String, dynamic>, (v) => (v as num).toDouble()))
          .toList(),
      temperatureRecords: (json['temperature'] as List<dynamic>)
          .map((item) => Record<double>.fromJson(item as Map<String, dynamic>, (v) => (v as num).toDouble()))
          .toList(),
      tdsRecords: (json['tds'] as List<dynamic>)
          .map((item) => Record<double>.fromJson(item as Map<String, dynamic>, (v) => (v as num).toDouble()))
          .toList(),
      turbidityRecords: (json['turbidity'] as List<dynamic>)
          .map((item) => Record<double>.fromJson(item as Map<String, dynamic>, (v) => (v as num).toDouble()))
          .toList(),
    );
    } catch (e) {
      throw FormatException('Error parsing MeterRecordsResponse: $e');
    }
  }
}