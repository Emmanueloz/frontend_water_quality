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

  MeterUbication? _selectedUbication;
  Offset? _markerScreenPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initialCenter = LatLng(
      widget.ubications.first.latitude,
      widget.ubications.first.longitude,
    );
    _initialZoom = kIsWeb ? 8.0 : 6.0;
  }

  void _updateMarkerScreenPosition(MeterUbication d) {
    Offset? pos;
    try {
      final camera = _mapController.camera;
      pos = camera.latLngToScreenOffset(LatLng(d.latitude, d.longitude));
    } catch (e) {
      pos = null;
    }

    setState(() {
      _selectedUbication = d;
      _markerScreenPosition = pos;
    });
  }

  void _hideCard() {
    setState(() {
      _selectedUbication = null;
      _markerScreenPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = _buildMarkers(context);
    final mapWidget = MainMap(
      mapController: _mapController,
      initialCenter: _initialCenter,
      initialZoom: _initialZoom,
      markers: markers,
    );

    final widthBox = _getWidth(context);
    final heightBox = _getHeight(context);
    final bool isDesktop = widget.screenSize == ScreenSize.smallDesktop ||
        widget.screenSize == ScreenSize.largeDesktop;

    return Stack(
      children: [
        BaseContainer(
          width: widthBox,
          height: heightBox,
          margin: EdgeInsets.all(isDesktop ? 0 : 10),
          child: mapWidget,
        ),
        Positioned(
          top: 16,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              _mapController.move(_initialCenter, _initialZoom);
              _hideCard();
            },
            tooltip: 'Volver al zoom inicial',
            child: const Icon(Icons.refresh),
          ),
        ),

        if (_selectedUbication != null && _markerScreenPosition != null)
          Positioned(
            left: _markerScreenPosition!.dx - 140,
            top: _markerScreenPosition!.dy - 120,
            child: GestureDetector(
              onTap: _hideCard,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(maxWidth: 220),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(_selectedUbication!.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: _hideCard,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(_selectedUbication?.nameLocation ?? "Ubicación desconocida",
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                          "Estado: ${_selectedUbication?.state ?? 'Desconocido'}",
                          style: const TextStyle(fontSize: 12)),
                          
                    ],
                  ),
                ),
              ),
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
        child: GestureDetector(
          onTap: () => _updateMarkerScreenPosition(d),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
              Icon(
                Icons.location_pin, 
                color: _selectedUbication == d ? Colors.red : Colors.blue, 
                size: 40
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  double _getWidth(BuildContext context) => double.infinity;
  double _getHeight(BuildContext context) => double.infinity;
}