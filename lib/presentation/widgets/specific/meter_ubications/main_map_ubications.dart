import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_ubications/main_map.dart';
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
    final mapWidget = MainMap(
        mapController: _mapController,
        initialCenter: _initialCenter,
        initialZoom: _initialZoom,
        markers: markers);
    final widthBox = _getWidth(context);
    final heightBox = _getHeight(context);
    final bool isDesktop = widget.screenSize == ScreenSize.smallDesktop ||
        widget.screenSize == ScreenSize.largeDesktop;
    final double verticalMargin = isDesktop ? 0 : 10;
    final stackMap = Stack(
      children: [
        BaseContainer(
          width: widthBox,
          height: heightBox,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical:  verticalMargin),
          child: mapWidget,
        ),
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

    if (isDesktop) {
      return Expanded(
        child: Column(
          children: [
            Expanded(child: stackMap),
          ],
        ),
      );
    } else {
      return stackMap;
    }
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

  double _getWidth(BuildContext context) {
    if (widget.screenSize == ScreenSize.largeDesktop) {
      return MediaQuery.of(context).size.width * 0.65;
    }
    if (widget.screenSize == ScreenSize.smallDesktop) {
      return MediaQuery.of(context).size.width * 0.70;
    }
    return double.infinity;
  }

  double _getHeight(BuildContext context) {
    if (widget.screenSize == ScreenSize.largeDesktop) {
      return MediaQuery.of(context).size.height * 0.85;
    }
    if (widget.screenSize == ScreenSize.smallDesktop) {
      return MediaQuery.of(context).size.height * 0.85;
    }
    return double.infinity;
  }
}
