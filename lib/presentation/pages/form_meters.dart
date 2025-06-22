import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';

class FormMeters extends StatelessWidget {
  final String? idMeter;
  const FormMeters({
    super.key,
    this.idMeter,
  });

  @override
  Widget build(BuildContext context) {
    String title = idMeter != null ? "Editar medidor" : "Crear medidor";

    if (idMeter != null) {
      return LayoutMeters(
        title: title,
        id: idMeter ?? "",
        idMeter: idMeter ?? "",
        selectedIndex: 4,
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
    return Container(
      width: screenSize == ScreenSize.mobile ? double.infinity : 600,
      height: screenSize == ScreenSize.mobile ? double.infinity : 600,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Nombre del medidor",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "El nombre del medidor es obligatorio";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Latitud",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "La latitud del medidor es obligatoria";
              }
              return null;
            },
          ),
                    TextFormField(
            decoration: InputDecoration(
              labelText: "Longitud",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "La longitud del medidor es obligatoria";
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {},
                child: Text("Restablecer"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Guardar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
