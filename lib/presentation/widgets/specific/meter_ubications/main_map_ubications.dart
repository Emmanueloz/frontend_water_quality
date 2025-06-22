import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend_water_quality/core/interface/meter_ubication.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';

class MainMapUbications extends StatelessWidget {
  final List<MeterUbication> ubications;
  final ScreenSize screenSize;
  const MainMapUbications({
    super.key,
    required this.ubications,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final markers = _buildMarkers(context);

    final initialCenter = LatLng(
      ubications.first.latitude,
      ubications.first.longitude,
    );

    if (screenSize == ScreenSize.smallDesktop ||
        screenSize == ScreenSize.largeDesktop) {
          return Expanded(
            child: _buildMap(initialCenter, context, markers),
          );
    }
    return _buildMap(initialCenter, context, markers);
  }

  Widget _buildMap(LatLng initialCenter, BuildContext context, List<Marker> markers) {
    return BaseContainer(
    width: _getwidht(),
    height: _getHeight(),
    margin: const EdgeInsets.all(10),
    child: FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: kIsWeb ? 8.0 : 6.0, // Zoom más conservador en web
        minZoom: kIsWeb ? 6.0 : 5.0, // Límites más restrictivos en web
        maxZoom: kIsWeb ? 16.0 : 18.0, // Máximo menor en web
        // Límites más conservadores para web
        cameraConstraint: kIsWeb
            ? CameraConstraint.contain(
                bounds: LatLngBounds(
                  LatLng(-90, -180),
                  LatLng(90, 180), // NE: Norte-este de tu región
                ),
              )
            : CameraConstraint.contain(
                bounds: LatLngBounds(
                  LatLng(-90, -180),
                  LatLng(90, 180),
                ),
              ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          maxZoom: kIsWeb ? 16 : 19,
          minZoom: kIsWeb ? 6 : 5,
          tileDimension: 256,
          retinaMode: kIsWeb ? false : RetinaMode.isHighDensity(context),
          errorTileCallback: (tile, error, stackTrace) {
            if (kDebugMode) {
              print('Error loading tile: $error');
            }
          },
          maxNativeZoom: 18,
          tileProvider: kIsWeb
              ? CancellableNetworkTileProvider()
              : NetworkTileProvider(),
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    ),
  );
  }

  List<Marker> _buildMarkers(BuildContext context) {
    return ubications.map((d) {
      return Marker(
        point: LatLng(d.latitude, d.longitude),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(context, d.name),
          child: Icon(
            Icons.location_pin,
            color: Colors.blue,
            size: 40,
          ),
        ),
      );
    }).toList();
  }

  void _showMarkerInfo(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          // content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  double _getwidht() {
    if (screenSize == ScreenSize.largeDesktop) {
      return 1100;
    } else if (screenSize == ScreenSize.smallDesktop) {
      return 800;
    }
    return double.infinity;
  }

  double _getHeight() {
    if (screenSize == ScreenSize.largeDesktop) {
      return 900;
    } else if (screenSize == ScreenSize.smallDesktop) {
      return 600;
    }
    return double.infinity;
  }
}
