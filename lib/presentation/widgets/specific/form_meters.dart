import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_ubications/search_map.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class UbicacionSeleccionada {
  final LatLng coordenadas;
  final String nombreLugar;

  UbicacionSeleccionada({required this.coordenadas, required this.nombreLugar});
}

class FormMeters extends StatefulWidget {
  final String title;
  final String idWorkspace;
  final String? idMeter;
  final bool isLoading;
  final String errorMessage;
  final Future<void> Function(Meter meter)? onSave;
  
  // Parámetros opcionales para edición
  final String? name;
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
    // Parámetros opcionales para edición
    this.name,
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _latController = TextEditingController(text: widget.lat?.toStringAsFixed(6) ?? '');
    _lngController = TextEditingController(text: widget.lng?.toStringAsFixed(6) ?? '');
    _placeNameController = TextEditingController(text: widget.placeName ?? '');
    
    if (widget.lat != null && widget.lng != null) {
      selectedLocation = LatLng(widget.lat!, widget.lng!);
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

  bool validarCoordenadas(LatLng? location) {
    if (location == null) return false;
    return location.latitude >= -90 &&
        location.latitude <= 90 &&
        location.longitude >= -180 &&
        location.longitude <= 180;
  }

  Future<UbicacionSeleccionada?> showMapSelectionScreen(
      BuildContext context, LatLng? initial) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (widget.idMeter != null) {
            return SearchMap(
              screenSize: ResponsiveScreenSize.getScreenSize(context),
              initialLocation: initial,
              onLocationSelected: (UbicacionSeleccionada ubicacion) {
                Navigator.pop(context, ubicacion);
              },
            );
          }

          return Layout(
            title: "Seleccionar ubicación",
            builder: (context, screenSize) {
              return SearchMap(
                screenSize: screenSize,
                onLocationSelected: (UbicacionSeleccionada ubicacion) {
                  Navigator.pop(context, ubicacion);
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return _builderMain(context, screenSize, widget.title);
  }

  Widget _builderMain(
      BuildContext context, ScreenSize screenSize, String title) {
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return BaseContainer(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: _buildForm(context, screenSize, title),
      );
    }

    return BaseContainer(
      margin: EdgeInsets.all(widget.idMeter != null ? 0 : 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: _buildForm(context, screenSize, title),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ScreenSize screenSize, String title) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              title,
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
                final result = await showMapSelectionScreen(
                    context,
                    selectedLocation);
                if (result != null) {
                  setState(() {
                    _latController.text =
                        result.coordenadas.latitude.toStringAsFixed(6);
                    _lngController.text =
                        result.coordenadas.longitude.toStringAsFixed(6);
                    _placeNameController.text = result.nombreLugar;
                    selectedLocation = result.coordenadas;
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
          ],
        ),
      );
  }
}