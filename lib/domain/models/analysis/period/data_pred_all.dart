import 'package:frontend_water_quality/domain/models/analysis/data.dart';

class DataPredAll extends Data {
  WaterQualityData? data;
  WaterQualityData? pred;

  DataPredAll({
    this.data,
    this.pred,
  });

  factory DataPredAll.fromJson(Map<String, dynamic> json) => DataPredAll(
        data: json["data"] == null
            ? null
            : WaterQualityData.fromJson(json["data"]),
        pred: json["pred"] == null
            ? null
            : WaterQualityData.fromJson(json["pred"]),
      );
}

class WaterQualityData {
  List<double>? conductivity;
  List<DateTime?>? labels;
  List<double>? ph;
  List<double>? tds;
  List<double>? temperature;
  List<double>? turbidity;

  WaterQualityData({
    this.conductivity,
    this.labels,
    this.ph,
    this.tds,
    this.temperature,
    this.turbidity,
  });

  factory WaterQualityData.fromJson(Map<String, dynamic> json) =>
      WaterQualityData(
        conductivity: json["conductivity"] == null
            ? []
            : List<double>.from(
                json["conductivity"]!.map((x) => x?.toDouble())),
        labels: json["labels"] == null
            ? []
            : List<DateTime>.from(
                json["labels"]!.map((x) => DateTime.parse(x))),
        ph: json["ph"] == null
            ? []
            : List<double>.from(json["ph"]!.map((x) => x?.toDouble())),
        tds: json["tds"] == null
            ? []
            : List<double>.from(json["tds"]!.map((x) => x?.toDouble())),
        temperature: json["temperature"] == null
            ? []
            : List<double>.from(json["temperature"]!.map((x) => x?.toDouble())),
        turbidity: json["turbidity"] == null
            ? []
            : List<double>.from(json["turbidity"]!.map((x) => x?.toDouble())),
      );
}
