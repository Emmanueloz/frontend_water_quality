import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:frontend_water_quality/core/utils/config_map.dart';
import 'package:latlong2/latlong.dart';

class MainMap extends StatelessWidget {
  final MapController _mapController;
  final LatLng _initialCenter;
  final double _initialZoom;
  final List<Marker> markers;
  final void Function(TapPosition, LatLng)? onTap;

  const MainMap({
    super.key,
    required MapController mapController,
    required LatLng initialCenter,
    required double initialZoom,
    required this.markers,
    this.onTap,
  })  : _mapController = mapController,
        _initialCenter = initialCenter,
        _initialZoom = initialZoom;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialCenter,
        initialZoom: _initialZoom,
        minZoom: kIsWeb ? 6.0 : 5.0,
        maxZoom: kIsWeb ? 16.0 : 18.0,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(LatLng(-90, -180), LatLng(90, 180)),
        ),
        onTap: onTap,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          maxZoom: kIsWeb ? 16 : 19,
          minZoom: kIsWeb ? 6 : 5,
          tileDimension: 256,
          retinaMode: kIsWeb ? false : RetinaMode.isHighDensity(context),
          tileProvider: kIsWeb
              ? CancellableNetworkTileProvider()
              : NetworkTileProvider(
                  headers: {
                    'User-Agent': ConfigMap.userAgent,
                  },
                ),
        ),
        MarkerLayer(markers: markers),
        RichAttributionWidget(
          // Include a stylish prebuilt attribution widget that meets all requirments
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
            ),
            // Also add images...
          ],
        ),
      ],
    );
  }
}
