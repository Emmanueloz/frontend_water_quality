class Parameters {
  DateTime? endDate;
  DateTime? startDate;
  String? sensor;

  Parameters({
    this.endDate,
    this.startDate,
    this.sensor,
  });

  factory Parameters.fromJson(Map<String, dynamic> json) => Parameters(
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        sensor: json["sensor_type"],
      );

  Map<String, dynamic> toJson() => {
        "end_date": endDate?.toIso8601String(),
        "start_date": startDate?.toIso8601String(),
        if (sensor != null) "sensor_type": sensor
      };
}
