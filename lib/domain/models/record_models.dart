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

  Map<String, dynamic> toJson() {
    return {
      "r": r,
      "g": g,
      "b": b,
    };
  }
}

class Record<T> {
  final String? id;
  final T value;
  final String datetime;

  Record({this.id, required this.value, required this.datetime});

  factory Record.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromValue) {
    return Record<T>(
      id: json['id'] as String?,
      value: fromValue(json['value']),
      datetime: json['datetime'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "value": value,
      "datetime": datetime,
    };
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
      color: Record<SRColorValue>.fromJson(
          json['color'], (v) => SRColorValue.fromJson(v)),
      conductivity: Record<double>.fromJson(
          json['conductivity'], (v) => (v as num).toDouble()),
      ph: Record<double>.fromJson(json['ph'], (v) => (v as num).toDouble()),
      temperature: Record<double>.fromJson(
          json['temperature'], (v) => (v as num).toDouble()),
      tds: Record<double>.fromJson(json['tds'], (v) => (v as num).toDouble()),
      turbidity: Record<double>.fromJson(
          json['turbidity'], (v) => (v as num).toDouble()),
    );
  }

  String toJsonEncode() {
    return jsonEncode(toJson());
  }

  static RecordResponse get empty => RecordResponse(
        color: Record<SRColorValue>(
          value: SRColorValue(r: 111, g: 111, b: 111),
          datetime: "",
        ),
        conductivity: Record<double>(value: 0, datetime: ""),
        ph: Record<double>(value: 0, datetime: ""),
        temperature: Record<double>(value: 0, datetime: ""),
        tds: Record<double>(value: 0, datetime: ""),
        turbidity: Record<double>(value: 0, datetime: ""),
      );

  Map<String, dynamic> toJson() {
    return {
      "color": color.toJson(),
      "conductivity": conductivity.toJson(),
      "ph": ph.toJson(),
      "temperature": temperature.toJson(),
      "tds": tds.toJson(),
      "turbidity": turbidity.toJson()
    };
  }

  factory RecordResponse.fromString(String recordString) {
    try {
      dynamic recordJson = jsonDecode(recordString);
      print("record json");
      print(recordJson);
      return RecordResponse.fromJson(recordJson);
    } catch (e) {
      print(e);
      return RecordResponse.empty;
    }
  }
}
