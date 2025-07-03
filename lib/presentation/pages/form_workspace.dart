import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/type_workspace.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_workspace.dart';

class FormWorkspace extends StatelessWidget {
  final String? idWorkspace;
  const FormWorkspace({
    super.key,
    this.idWorkspace,
  });

  @override
  Widget build(BuildContext context) {
    String title = idWorkspace != null
        ? "Editar espacio de trabajo"
        : "Crear espacio de trabajo";

    if (idWorkspace != null) {
      return LayoutWorkspace(
        title: title,
        id: idWorkspace ?? "",
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
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return BaseContainer(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: _buildForm(context, screenSize, title),
      );
    }

    if (idWorkspace != null) {
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
              labelText: "Nombre del workspace",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "El nombre del workspace es obligatorio";
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Tipo de workspace",
            ),
            value: TypeWorkspace.private,
            items: [
              DropdownMenuItem(
                value: TypeWorkspace.private,
                child: Text("Privado"),
              ),
              DropdownMenuItem(
                value: TypeWorkspace.public,
                child: Text("Publico"),
              ),
            ],
            onChanged: (value) {},
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
