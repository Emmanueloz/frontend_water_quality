import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/presentation/providers/alert_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class FormAlertPage extends StatefulWidget {
  final String? alertId;
  final Alert? alert;
  final String workspaceTitle;
  final String workspaceId;

  const FormAlertPage({
    super.key,
    this.alertId,
    this.alert,
    required this.workspaceTitle,
    required this.workspaceId,
  });

  @override
  State<FormAlertPage> createState() => _FormAlertPageState();
}

class _FormAlertPageState extends State<FormAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'good';
  String _selectedMeterId = '';
  bool _isLoading = false;
  bool _isEditMode = false;

  final List<String> _alertTypes = ['good', 'moderate', 'poor', 'dangerous', 'excellent'];
  
  // Lista de medidores disponibles (usando los IDs hardcodeados del workspace)
  List<Map<String, String>> get _availableMeters => [
    {'id': '1', 'name': 'Medidor 1'},
    {'id': '2', 'name': 'Medidor 2'},
    {'id': '3', 'name': 'Medidor 3'},
    {'id': '4', 'name': 'Medidor 4'},
  ];

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.alert != null || widget.alertId != null;
    
    // Seleccionar el primer medidor por defecto
    _selectedMeterId = '1';
    
    if (_isEditMode && widget.alert != null) {
      _titleController.text = widget.alert!.title;
      _descriptionController.text = widget.alert!.description;
      _selectedType = widget.alert!.type;
      // TODO: Set meter_id from alert when available
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createAlert() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final alertProvider = context.read<AlertProvider>();
    
    final alertData = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'type': _selectedType,
      'workspace_id': widget.workspaceId,
      'meter_id': _selectedMeterId,
    };

    if (_isEditMode) {
      final alertId = widget.alert?.id ?? widget.alertId!;
      await alertProvider.updateAlert(alertId, alertData);
    } else {
      await alertProvider.createAlert(alertData);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (alertProvider.errorMessage == null) {
        print('FormAlertPage: ${_isEditMode ? 'update' : 'create'} successful, closing page');
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? 'Alerta actualizada exitosamente' : 'Alerta creada exitosamente'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        print('FormAlertPage: ${_isEditMode ? 'update' : 'create'} failed, showing error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(alertProvider.errorMessage ?? 'Error al ${_isEditMode ? 'actualizar' : 'crear'} la alerta'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = _isEditMode ? "Editar alerta" : "Crear alerta";
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildForm(context, screenSize),
    );
  }

  Widget _buildForm(BuildContext context, screenSize) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                Text(
                  _isEditMode ? 'Detalles de la Alerta' : 'Crear Nueva Alerta',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Campo Título
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese el título de la alerta',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es requerido';
                    }
                    if (value.trim().length < 3) {
                      return 'El título debe tener al menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese la descripción de la alerta',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La descripción es requerida';
                    }
                    if (value.trim().length < 10) {
                      return 'La descripción debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Meter ID
                DropdownButtonFormField<String>(
                  value: _selectedMeterId,
                  decoration: const InputDecoration(
                    labelText: 'Medidor',
                    border: OutlineInputBorder(),
                  ),
                  items: _availableMeters.map((meter) {
                    return DropdownMenuItem(
                      value: meter['id'],
                      child: Text(meter['name']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMeterId = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El medidor es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Tipo
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Alerta',
                    border: OutlineInputBorder(),
                  ),
                  items: _alertTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_translateType(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El tipo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Botones
                ElevatedButton(
                  onPressed: _isLoading ? null : _createAlert,
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_isEditMode ? 'Actualizar' : 'Crear'),
                ),
                if (_isEditMode) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _isLoading ? null : () => context.pop(),
                    child: const Text('Cancelar'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _translateType(String type) {
    switch (type.toLowerCase()) {
      case 'good':
        return 'Bueno';
      case 'moderate':
        return 'Moderado';
      case 'poor':
        return 'Malo';
      case 'dangerous':
        return 'Peligroso';
      case 'excellent':
        return 'Excelente';
      default:
        return type.capitalize();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
} 