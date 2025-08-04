import 'dart:convert';

class Meter {
  final String? id;
  final String name;
  final Location location;
  final String? state;

  Meter({
    this.id,
    required this.name,
    required this.location,
    this.state,
  });

  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      id: json['id'] as String?,
      name: json['name'] as String,
      location: Location.fromJson(json['location']),
      state: json['state'] as String?,
    );
  }

  factory Meter.fromString(String meterString) {
    final meterJson = jsonDecode(meterString);
    return Meter.fromJson(meterJson);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['location'] = location.toJson();
    if (state != null) data['state'] = state;
    return data;
  }

  String toJsonEncode() {
    return jsonEncode(toJson());
  }
}

class Location {
  final double lat;
  final double lon;

  Location({required this.lat, required this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }
}
