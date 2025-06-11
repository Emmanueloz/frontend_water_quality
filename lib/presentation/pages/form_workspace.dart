import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/type_workspace.dart';
import 'package:frontend_water_quality/presentation/widgets/common/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class FormWorkspace extends StatelessWidget {
  final String? idWorkspace;
  const FormWorkspace({
    super.key,
    this.idWorkspace,
  });

  @override
  Widget build(BuildContext context) {
    String title = idWorkspace != null ? "Editar workspace" : "Crear workspace";

    return Layout(
      title: title,
      builder: (context, screenSize) {
        return Align(
          alignment: Alignment.topCenter,
          child: BaseContainer(
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
          ),
        );
      },
    );
  }
}
