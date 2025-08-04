class Location {
  final String name;
  final String region;
  final String country;
  final double? lat;
  final double? lon;

  Location({
    required this.name,
    required this.region,
    required this.country,
    this.lat,
    this.lon,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });
  

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'] as String,
      icon: json['icon'] as String,
      code: json['code'] as int,
    );
  }

}

class Current {
  final String lastUpdated;
  final double tempC;
  final double tempF;
  final int humidity;
  final double windKph;
  final double windMph;
  final double pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double uv;
  final double visKm;
  final double visMiles;
  final Condition condition;

  Current({
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.humidity,
    required this.windKph,
    required this.windMph,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.uv,
    required this.visKm,
    required this.visMiles,
    required this.condition,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      lastUpdated: json['last_updated'] as String,
      tempC: (json['temp_c'] as num).toDouble(),
      tempF: (json['temp_f'] as num).toDouble(),
      humidity: json['humidity'] as int,
      windKph: (json['wind_kph'] as num).toDouble(),
      windMph: (json['wind_mph'] as num).toDouble(),
      pressureMb: (json['pressure_mb'] as num).toDouble(),
      pressureIn: (json['pressure_in'] as num).toDouble(),
      precipMm: (json['precip_mm'] as num).toDouble(),
      precipIn: (json['precip_in'] as num).toDouble(),
      cloud: json['cloud'] as int,
      feelslikeC: (json['feelslike_c'] as num).toDouble(),
      feelslikeF: (json['feelslike_f'] as num).toDouble(),
      uv: (json['uv'] as num).toDouble(),
      visKm: (json['vis_km'] as num).toDouble(),
      visMiles: (json['vis_miles'] as num).toDouble(),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class WeatherMeter {
  final Location location;
  final Current current;

  WeatherMeter({
    required this.location,
    required this.current,
  });

  factory WeatherMeter.fromJson(Map<String, dynamic> json) {
    return WeatherMeter(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
    );
  }
}