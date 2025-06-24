import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend_water_quality/core/interface/meter_ubication.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';

class MainMapUbications extends StatefulWidget {
  final List<MeterUbication> ubications;
  final ScreenSize screenSize;
  const MainMapUbications({
    super.key,
    required this.ubications,
    required this.screenSize,
  });

  @override
  State<MainMapUbications> createState() => _MainMapUbicationsState();
}

class _MainMapUbicationsState extends State<MainMapUbications> {
  late final MapController _mapController;
  late final LatLng _initialCenter;
  late final double _initialZoom;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initialCenter = LatLng(
      widget.ubications.first.latitude,
      widget.ubications.first.longitude,
    );
    // Usa el mismo valor que en options.initialZoom
    _initialZoom = kIsWeb ? 8.0 : 6.0;
  }

  @override
  Widget build(BuildContext context) {
    final markers = _buildMarkers(context);
    final mapWidget = _MainMap(
        mapController: _mapController,
        initialCenter: _initialCenter,
        initialZoom: _initialZoom,
        markers: markers);


    return Stack(
      children: [
        BaseContainer(
          width: _getWidth(),
          height: _getHeight(),
          margin: const EdgeInsets.all(10),
          child:  mapWidget,
        ),
        // Botón para resetear vista
        Positioned(
          top: 16,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              _mapController.move(_initialCenter, _initialZoom);
            },
            tooltip: 'Volver al zoom inicial',
            child: const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers(BuildContext context) {
    return widget.ubications.map((d) {
      return Marker(
        point: LatLng(d.latitude, d.longitude),
        width: 100,
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 2)
                ],
              ),
              child: Text(
                d.name,
                style: TextStyle(
                  fontSize: d.name.length > 12 ? 8 : 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.location_pin, color: Colors.blue, size: 40),
          ],
        ),
      );
    }).toList();
  }

  double _getWidth() {
    if (widget.screenSize == ScreenSize.largeDesktop) return 1200;
    if (widget.screenSize == ScreenSize.smallDesktop) return 900;
    return double.infinity;
  }

  double _getHeight() {
    if (widget.screenSize == ScreenSize.largeDesktop) return 1000;
    if (widget.screenSize == ScreenSize.smallDesktop) return 600;
    return double.infinity;
  }
}

class _MainMap extends StatelessWidget {
  const _MainMap({
    required MapController mapController,
    required LatLng initialCenter,
    required double initialZoom,
    required this.markers,
  })  : _mapController = mapController,
        _initialCenter = initialCenter,
        _initialZoom = initialZoom;

  final MapController _mapController;
  final LatLng _initialCenter;
  final double _initialZoom;
  final List<Marker> markers;

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
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          maxZoom: kIsWeb ? 16 : 19,
          minZoom: kIsWeb ? 6 : 5,
          tileDimension: 256,
          retinaMode: kIsWeb ? false : RetinaMode.isHighDensity(context),
          tileProvider:
              kIsWeb ? CancellableNetworkTileProvider() : NetworkTileProvider(),
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
