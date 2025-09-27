import 'package:frontend_water_quality/domain/models/analysis/data.dart';

class DataPredSensor extends Data {
  TimeSeriesData? data;
  TimeSeriesData? pred;
  String? sensor;

  DataPredSensor({
    this.data,
    this.pred,
    this.sensor,
  });

  factory DataPredSensor.fromJson(Map<String, dynamic> json) => DataPredSensor(
        data:
            json["data"] == null ? null : TimeSeriesData.fromJson(json["data"]),
        pred:
            json["pred"] == null ? null : TimeSeriesData.fromJson(json["pred"]),
        sensor: json["sensor"],
      );
}

class TimeSeriesData {
  List<DateTime?>? labels;
  List<double>? values;

  TimeSeriesData({
    this.labels,
    this.values,
  });

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) => TimeSeriesData(
        labels: json["labels"] == null
            ? []
            : List<DateTime>.from(
                json["labels"]!.map((x) => DateTime.parse(x))),
        values: json["values"] == null
            ? []
            : List<double>.from(json["values"]!.map((x) => x?.toDouble())),
      );
}
