import 'package:flutter/material.dart';
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
  final String id;
  final String? idMeter;

  const FormMeters({
    super.key,
    required this.id,
    this.idMeter,
  });

  @override
  State<FormMeters> createState() => _FormMetersState();
}

class _FormMetersState extends State<FormMeters> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _placeNameController = TextEditingController();

  LatLng? selectedLocation;

  bool validarCoordenadas(LatLng? location) {
    if (location == null) return false;
    return location.latitude >= -90 &&
        location.latitude <= 90 &&
        location.longitude >= -180 &&
        location.longitude <= 180;
  }

  Future<UbicacionSeleccionada?> showMapSelectionScreen(
      BuildContext context, LatLng? initial) async {
    print(initial);
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
    final String title =
        widget.idMeter != null ? "Editar medidor" : "Crear medidor";

    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    if (widget.idMeter == null) {
      return Layout(
        title: title,
        builder: (context, screenSize) {
          return _builderMain(context, screenSize, title);
        },
      );
    }
    return _builderMain(context, screenSize, title);
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
    if (widget.idMeter != null) {
      return Expanded(
        child: BaseContainer(
          child: Align(
            alignment: Alignment.topCenter,
            child: _buildForm(context, screenSize, title),
          ),
        ),
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
    return Container(
      width: screenSize == ScreenSize.mobile ? double.infinity : 600,
      height: screenSize == ScreenSize.mobile ? double.infinity : 600,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Form(
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
                    widget.idMeter != null
                        ? LatLng(
                            16.76665940722355,
                            -93.05139011695141,
                          )
                        : null);
                if (result != null) {
                  setState(() {
                    _latController.text =
                        result.coordenadas.latitude.toStringAsFixed(6);
                    _lngController.text =
                        result.coordenadas.longitude.toStringAsFixed(6);
                    _placeNameController.text = result.nombreLugar;
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (!validarCoordenadas(selectedLocation)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ubicación inválida")),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Formulario válido")),
                      );
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
