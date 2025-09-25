class DataPredSensor {
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

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "pred": pred?.toJson(),
        "sensor": sensor,
      };
}

class TimeSeriesData {
  List<DateTime>? labels;
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

  Map<String, dynamic> toJson() => {
        "labels": labels == null
            ? []
            : List<dynamic>.from(labels!.map((x) =>
                "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "values":
            values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
      };
}
