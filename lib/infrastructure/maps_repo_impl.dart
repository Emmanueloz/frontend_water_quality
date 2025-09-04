import 'package:latlong2/latlong.dart';
import 'package:frontend_water_quality/core/utils/config_map.dart';
import 'package:dio/dio.dart';

class MapsRepoImpl {
  // Instancia de Dio reutilizable
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://nominatim.openstreetmap.org',
      headers: {'User-Agent': ConfigMap.userAgent},
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Busca el nombre de un lugar dado sus coordenadas
  static Future<String> searchPlaceName(LatLng coords) async {
    try {
      final response = await dio.get(
        '/reverse',
        queryParameters: {
          'lat': coords.latitude,
          'lon': coords.longitude,
          'format': 'json',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['display_name'] ?? 'Ubicación sin nombre';
      } else {
        return 'Ubicación sin nombre';
      }
    } catch (_) {
      return 'Ubicación sin nombre';
    }
  }

  /// Busca las coordenadas de una dirección escrita en texto
  static Future<LatLng?> searchDirection(String query) async {
    try {
      final response = await dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 1,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data.isNotEmpty) {
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
