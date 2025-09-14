import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/infrastructure/maps_repo_impl.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_ubications/search_map.dart';

class SelectedLocation {
  final LatLng coordinates;
  final String placeName;

  SelectedLocation({required this.coordinates, required this.placeName});
}

class FormMeters extends StatefulWidget {
  final String title;
  final String idWorkspace;
  final String? idMeter;
  final bool isLoading;
  final String errorMessage;
  final Future<void> Function(Meter meter)? onSave;

  final String? name;
  final String? nameLocation;
  final double? lat;
  final double? lng;
  final String? placeName;

  const FormMeters({
    super.key,
    required this.title,
    required this.idWorkspace,
    this.idMeter,
    required this.isLoading,
    required this.errorMessage,
    this.onSave,
    this.name,
    this.nameLocation,
    this.lat,
    this.lng,
    this.placeName,
  });

  @override
  State<FormMeters> createState() => _FormMetersState();
}

class _FormMetersState extends State<FormMeters> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _placeNameController;

  LatLng? selectedLocation;

  Future<void> _loadPlaceName(LatLng coords) async {
    final name = await MapsRepoImpl.searchPlaceName(coords);
    if (mounted) {
      setState(() {
        _placeNameController.text = name;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _latController = TextEditingController();
    _lngController = TextEditingController();
    _placeNameController = TextEditingController();

    // Fill only if initial data exists
    if (widget.name != null) {
      _nameController.text = widget.name!;
    }
    if (widget.lat != null) {
      _latController.text = widget.lat!.toStringAsFixed(6);
    }
    if (widget.lng != null) {
      _lngController.text = widget.lng!.toStringAsFixed(6);
    }
    if (widget.placeName != null) {
      _placeNameController.text = widget.placeName!;
    }

    if (widget.lat != null && widget.lng != null) {
      selectedLocation = LatLng(widget.lat!, widget.lng!);
      if (_placeNameController.text.isEmpty) {
        _loadPlaceName(selectedLocation!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _placeNameController.dispose();
    super.dispose();
  }

  bool validateCoordinates(LatLng? location) {
    if (location == null) {
      return false;
    }
    return location.latitude >= -90 &&
        location.latitude <= 90 &&
        location.longitude >= -180 &&
        location.longitude <= 180;
  }

  Future<SelectedLocation?> showMapSelectionScreen(
      BuildContext context, LatLng? initial) async {
    return await showModalBottomSheet<SelectedLocation>(
      context: context,
      isScrollControlled: true, // Allow modal to take full screen
      builder: (BuildContext context) {
        return SearchMap(
          screenSize: ResponsiveScreenSize.getScreenSize(context),
          initialLocation: initial,
          onLocationSelected: (SelectedLocation location) {
            Navigator.pop(context, location);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre del medidor",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "El nombre del medidor es obligatorio";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _placeNameController,
              decoration: const InputDecoration(labelText: 'Ubicación'),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _latController,
              decoration: const InputDecoration(labelText: 'Latitud'),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _lngController,
              decoration: const InputDecoration(labelText: 'Longitud'),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text("Seleccionar ubicación"),
              onPressed: () async {
                final result =
                    await showMapSelectionScreen(context, selectedLocation);
                if (result != null) {
                  setState(() {
                    _latController.text =
                        result.coordinates.latitude.toStringAsFixed(6);
                    _lngController.text =
                        result.coordinates.longitude.toStringAsFixed(6);
                    _placeNameController.text = result.placeName;
                    selectedLocation = result.coordinates;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _formKey.currentState?.reset();
                    _nameController.clear();
                    _latController.clear();
                    _lngController.clear();
                    _placeNameController.clear();
                    setState(() => selectedLocation = null);
                  },
                  child: const Text("Restablecer"),
                ),
                ElevatedButton(
                  onPressed: widget.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final lat = double.tryParse(_latController.text);
                            final lng = double.tryParse(_lngController.text);

                            if (lat == null || lng == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Ubicación inválida")),
                              );
                              return;
                            }
                            final location = LatLng(lat, lng);

                            if (widget.onSave != null) {
                              final meter = Meter(
                                id: widget.idMeter,
                                name: _nameController.text.trim(),
                                location: Location(
                                  nameLocation: _placeNameController.text.trim(),
                                  lat: location.latitude,
                                  lon: location.longitude,
                                ),
                              );
                              await widget.onSave!(meter);
                            }
                          }
                        },
                  child: widget.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.idMeter != null ? "Actualizar" : "Guardar"),
                ),
              ],
            ),
            if (widget.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
