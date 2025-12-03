import 'dart:convert';
import 'package:frontend_water_quality/core/enums/meter_state.dart';
import 'package:frontend_water_quality/core/enums/work_roles.dart';

class Meter {
  final String? id;
  final String name;
  final Location location;
  final MeterState? state;
  final WorkRole? role;

  Meter({
    this.id,
    required this.name,
    required this.location,
    this.state,
    this.role,
  });

  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      id: json['id'] as String?,
      name: json['name'] as String,
      location: Location.fromJson(json['location']),
      state: json['state'] == null
          ? null
          : MeterStateExtension.fromName(json['state']),
      role:
          json["rol"] == null ? null : WorkRoleExtension.fromName(json["rol"]),
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
    if (state != null) data['state'] = state!.name;
    return data;
  }

  String toJsonEncode() {
    return jsonEncode(toJson());
  }
}

class Location {
  final String? nameLocation;
  final double lat;
  final double lon;

  Location({required this.nameLocation, required this.lat, required this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      nameLocation: json['name_location'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_location': nameLocation,
      'lat': lat,
      'lon': lon,
    };
  }
}
