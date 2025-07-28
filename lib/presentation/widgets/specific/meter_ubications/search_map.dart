import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend_water_quality/core/utils/config_map.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_meters.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_ubications/main_map.dart'; // importa tu MainMap aquí

class SearchMap extends StatefulWidget {
  final ScreenSize screenSize;
  final LatLng? initialLocation;
  final void Function(UbicacionSeleccionada)? onLocationSelected;

  const SearchMap({
    super.key,
    required this.screenSize,
    this.initialLocation,
    this.onLocationSelected,
  });

  @override
  State<SearchMap> createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  late final MapController _mapController;
  late final LatLng _initialCenter;
  late final double _initialZoom;
  LatLng? _selectedLocation;
  String? _nombreDelLugar;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initialCenter = LatLng(19.4326, -99.1332); // CDMX
    _initialZoom = kIsWeb ? 8.0 : 6.0;
  }

  Future<void> _buscarDireccion(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    try {
      final response =
          await http.get(url, headers: {'User-Agent': ConfigMap.userAgent});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          final result = LatLng(lat, lon);
          _mapController.move(result, 10);
        } else {
          _showSnackBar("No se encontró la dirección");
        }
      } else {
        _showSnackBar("Error al buscar dirección");
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
    }
  }

  Future<void> _buscarNombreLugar(LatLng coords) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${coords.latitude}&lon=${coords.longitude}&format=json');
    try {
      final response =
          await http.get(url, headers: {'User-Agent': ConfigMap.userAgent});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nombreDelLugar = data['display_name'] ?? 'Ubicación sin nombre';
        });
      }
    } catch (_) {
      setState(() {
        _nombreDelLugar = 'Ubicación sin nombre';
      });
    }
  }

  void _showSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      if (_selectedLocation != null)
        Marker(
          point: _selectedLocation!,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
    ];

    final stackMap = Stack(
      children: [
        BaseContainer(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.all(widget.initialLocation == null ? 0 : 0),
          child: MainMap(
            mapController: _mapController,
            initialCenter: _initialCenter,
            initialZoom: _initialZoom,
            markers: markers,
            onTap: (tapPosition, latLng) {
              setState(() => _selectedLocation = latLng);
              _buscarNombreLugar(latLng);
            },
          ),
        ),

        // 🔍 Buscador
        Positioned(
          top: 16,
          left: 16,
          right: 70,
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: "Buscar dirección...",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) _buscarDireccion(value);
              },
            ),
          ),
        ),

        // 🔄 Reset
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

        // ✅ Confirmar ubicación
        if (_selectedLocation != null)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              icon: Icon(Icons.check_circle_outline,
                  size: 20, color: Theme.of(context).colorScheme.onPrimary),
              label: Text("Confirmar ubicación",
                  style: Theme.of(context).textTheme.labelLarge),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: const Size.fromHeight(36),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 2,
              ),
              onPressed: () {
                if (_selectedLocation != null && _nombreDelLugar != null) {
                  widget.onLocationSelected?.call(
                    UbicacionSeleccionada(
                      coordenadas: _selectedLocation!,
                      nombreLugar: _nombreDelLugar!,
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );

    return stackMap;
  }
}
