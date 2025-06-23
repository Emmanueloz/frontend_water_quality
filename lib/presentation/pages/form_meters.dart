import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para FilteringTextInputFormatter
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';

class FormMeters extends StatelessWidget {
  final String id;
  final String? idMeter;

  const FormMeters({
    super.key,
    required this.id,
    this.idMeter,
  });

  bool validarCoordenadas(String latStr, String lonStr) {
    final double? lat = double.tryParse(latStr);
    final double? lon = double.tryParse(lonStr);

    if (lat == null || lon == null) return false;

    return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
  }

  @override
  Widget build(BuildContext context) {
    String title = idMeter != null ? "Editar medidor" : "Crear medidor";

    if (idMeter != null) {
      return LayoutMeters(
        title: title,
        id: id,
        idMeter: idMeter ?? "",
        selectedIndex: 5,
        builder: (context, screenSize) =>
            _builderMain(context, screenSize, title),
      );
    }

    return Layout(
      title: title,
      builder: (context, screenSize) =>
          _builderMain(context, screenSize, title),
    );
  }

  Widget _builderMain(
      BuildContext context, ScreenSize screenSize, String title) {
    if (screenSize == ScreenSize.mobile) {
      return BaseContainer(
        margin: EdgeInsets.all(10),
        child: _buildForm(context, screenSize, title),
      );
    }

    if (idMeter != null) {
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
      margin: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topCenter,
        child: _buildForm(context, screenSize, title),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ScreenSize screenSize, String title) {
    final latController = TextEditingController();
    final lonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Container(
      width: screenSize == ScreenSize.mobile ? double.infinity : 600,
      height: screenSize == ScreenSize.mobile ? double.infinity : 600,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Form(
        key: formKey,
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
            SizedBox(height: 10),
            TextFormField(
              controller: latController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: "Latitud",
                hintText: "Ej. 10.1234567",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "La latitud del medidor es obligatoria";
                }
                if (!validarCoordenadas(value, lonController.text)) {
                  return "Latitud inválida";
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: lonController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                  labelText: 'Longitud', 
                  hintText: 'Ej. 16.9063900'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La longitud del medidor es obligatoria';
                }
                if (!validarCoordenadas(latController.text, value)) {
                  return "Longitud inválida";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    formKey.currentState?.reset();
                    latController.clear();
                    lonController.clear();
                  },
                  child: const Text("Restablecer"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
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
