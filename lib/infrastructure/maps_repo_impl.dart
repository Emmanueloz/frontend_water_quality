import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:frontend_water_quality/core/utils/config_map.dart';

class MapsRepoImpl {
  static Future<String> buscarNombreLugar(LatLng coords) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?lat=${coords.latitude}&lon=${coords.longitude}&format=json',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': ConfigMap.userAgent},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] ?? 'Ubicación sin nombre';
      } else {
        return 'Ubicación sin nombre';
      }
    } catch (_) {
      return 'Ubicación sin nombre';
    }
  }

  static Future<LatLng?> buscarDireccion(String query) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': ConfigMap.userAgent},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
