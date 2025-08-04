import 'dart:convert';

class SRColorValue {
  final int r;
  final int g;
  final int b;

  SRColorValue({required this.r, required this.g, required this.b});

  factory SRColorValue.fromJson(Map<String, dynamic> json) {
    return SRColorValue(
      r: json['r'] ?? 0,
      g: json['g'] ?? 0,
      b: json['b'] ?? 0,
    );
  }
}

class Record<T> {
  final String? id;
  final T value;
  final String datetime;

  Record({this.id, required this.value, required this.datetime});

  factory Record.fromJson(Map<String, dynamic> json, T Function(dynamic) fromValue) {
    return Record<T>(
      id: json['id'] as String?,
      value: fromValue(json['value']),
      datetime: json['datetime'] as String,
    );
  }
}

class RecordResponse {
  final Record<SRColorValue> color;
  final Record<double> conductivity;
  final Record<double> ph;
  final Record<double> temperature;
  final Record<double> tds;
  final Record<double> turbidity;

  RecordResponse({
    required this.color,
    required this.conductivity,
    required this.ph,
    required this.temperature,
    required this.tds,
    required this.turbidity,
  });

  factory RecordResponse.fromJson(Map<String, dynamic> json) {
    return RecordResponse(
      color: Record<SRColorValue>.fromJson(json['color'], (v) => SRColorValue.fromJson(v)),
      conductivity: Record<double>.fromJson(json['conductivity'], (v) => (v as num).toDouble()),
      ph: Record<double>.fromJson(json['ph'], (v) => (v as num).toDouble()),
      temperature: Record<double>.fromJson(json['temperature'], (v) => (v as num).toDouble()),
      tds: Record<double>.fromJson(json['tds'], (v) => (v as num).toDouble()),
      turbidity: Record<double>.fromJson(json['turbidity'], (v) => (v as num).toDouble()),
    );
  }

  static RecordResponse fromRawJson(String str) => RecordResponse.fromJson(json.decode(str));
} 