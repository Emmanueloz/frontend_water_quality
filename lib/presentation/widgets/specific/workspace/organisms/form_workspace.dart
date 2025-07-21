import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/type_workspace.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';

class FormWorkspace extends StatefulWidget {
  final String title;
  final String? idWorkspace;
  final String? name;
  final TypeWorkspace? type;
  final String? errorMessage;
  final void Function(Workspace workspace)? onSubmit;

  const FormWorkspace({
    super.key,
    required this.title,
    this.onSubmit,
    this.idWorkspace,
    this.name,
    this.type,
    this.errorMessage,
  });

  @override
  State<FormWorkspace> createState() => _FormWorkspaceState();
}

class _FormWorkspaceState extends State<FormWorkspace> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  TypeWorkspace _typeWorkspace = TypeWorkspace.private;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _typeWorkspace = widget.type ?? TypeWorkspace.private;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 10,
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
            decoration: InputDecoration(
              labelText: "Nombre",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "El nombre es obligatorio";
              }

              if (value.length < 3) {
                return "El nombre debe tener al menos 3 caracteres";
              }
              if (value.length > 40) {
                return "El nombre no puede tener más de 40 caracteres";
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Tipo de workspace",
            ),
            value: _typeWorkspace,
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
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _typeWorkspace = value;
                });
              }
            },
          ),
          if (widget.errorMessage != null)
            Text(
              widget.errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  _nameController.clear();
                  setState(() {
                    _typeWorkspace = TypeWorkspace.private;
                  });
                },
                child: Text("Restablecer"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final workspace = Workspace(
                      id: widget.idWorkspace,
                      name: _nameController.text,
                      type: _typeWorkspace.name,
                    );
                    widget.onSubmit?.call(workspace);
                  }
                },
                child: Text("Aceptar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
