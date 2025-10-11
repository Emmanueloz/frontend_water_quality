import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/alert_type.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/presentation/providers/alert_provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/molecules/multi_user_selector.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/molecules/parameter_range_input.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class FormAlertPage extends StatefulWidget {
  final String workspaceTitle;
  final String workspaceId;
  final Alert?
      alert; // Si es null, es modo crear; si tiene valor, es modo editar

  const FormAlertPage({
    super.key,
    required this.workspaceTitle,
    required this.workspaceId,
    this.alert,
  });

  @override
  State<FormAlertPage> createState() => _FormAlertPageState();
}

class _FormAlertPageState extends State<FormAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  AlertType _selectedType = AlertType.good;
  String _selectedMeterId = '';
  bool _isLoading = false;
  bool get _isEditMode => widget.alert != null;
  final List<AlertType> _alertTypes = AlertType.values;
  
  // Nuevas propiedades para parámetros y usuarios
  Parameter? _parameters;
  List<String> _selectedUserIds = [];
  
  // Datos hardcodeados de usuarios (temporal)
  final List<Guest> _mockGuests = [
    Guest(
      id: 'user1',
      name: 'Juan Pérez',
      email: 'juan.perez@example.com',
      role: 'admin',
    ),
    Guest(
      id: 'user2',
      name: 'María García',
      email: 'maria.garcia@example.com',
      role: 'viewer',
    ),
    Guest(
      id: 'user3',
      name: 'Carlos López',
      email: 'carlos.lopez@example.com',
      role: 'editor',
    ),
  ];

  late Future<Result<List<Meter>>> _metersFuture;

  @override
  void initState() {
    super.initState();
    _metersFuture = _fetchMeters();

    _selectedMeterId = widget.alert?.meterId ?? '';

    if (_isEditMode) {
      _titleController.text = widget.alert!.title;
      _selectedType = widget.alert!.type;
      _parameters = widget.alert!.parameters;
      _selectedUserIds = widget.alert!.sendToUsers ?? [];
    }
  }

  Future<Result<List<Meter>>> _fetchMeters() async {
    final meterProvider = context.read<MeterProvider>();
    return await meterProvider.getMeters(widget.workspaceId);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _createAlert() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final alertProvider = context.read<AlertProvider>();

    final alertData = Alert(
      title: _titleController.text.trim(),
      type: _selectedType,
      workspaceId: widget.workspaceId,
      meterId: _selectedMeterId,
      parameters: _parameters,
      sendToUsers: _selectedUserIds.isNotEmpty ? _selectedUserIds : null,
    );

    if (_isEditMode) {
      final alertId = widget.alert!.id;
      await alertProvider.updateAlert(alertId, alertData);
    } else {
      await alertProvider.createAlert(alertData);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (alertProvider.errorMessage == null) {
        print(
            'FormAlertPage: ${_isEditMode ? 'update' : 'create'} successful, closing page');
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode
                ? 'Alerta actualizada exitosamente'
                : 'Alerta creada exitosamente'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        print(
            'FormAlertPage: ${_isEditMode ? 'update' : 'create'} failed, showing error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(alertProvider.errorMessage ??
                'Error al ${_isEditMode ? 'actualizar' : 'crear'} la alerta'),
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

    return Layout(
      title: title,
      builder: (context, screenSize) {
        return _buildMain(context, screenSize);
      },
    );
  }

  Widget _buildMain(BuildContext context, ScreenSize screenSize) {
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return BaseContainer(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: _buildForm(context, screenSize),
      );
    }

    return BaseContainer(
      margin: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topCenter,
        child: _buildForm(context, screenSize),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ScreenSize screenSize) {
    return Container(
      width: screenSize == ScreenSize.mobile ? double.infinity : 600,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<Result<List<Meter>>>(
        future: _metersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.isSuccess) {
            return Center(
              child: Text(
                snapshot.data?.message ?? 'Error cargando medidores',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final meters = snapshot.data!.value ?? [];

          if (meters.isEmpty) {
            return const Center(
              child: Text('No hay medidores disponibles'),
            );
          }

          // Establecer el medidor seleccionado por defecto si no hay uno
          if (_selectedMeterId.isEmpty && meters.isNotEmpty) {
            _selectedMeterId = meters.first.id ?? '';
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isEditMode ? 'Detalles de la Alerta' : 'Crear Nueva Alerta',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Información básica
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
                  
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMeterId,
                    decoration: const InputDecoration(
                      labelText: 'Medidor',
                      border: OutlineInputBorder(),
                    ),
                    items: meters.map((meter) {
                      return DropdownMenuItem(
                        value: meter.id,
                        child: Text(meter.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      print(value);
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
                  
                  DropdownButtonFormField<AlertType>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Alerta',
                      border: OutlineInputBorder(),
                    ),
                    items: _alertTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.nameSpanish),
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
                      if (value == null) {
                        return 'El tipo es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Widget de parámetros
                  ParameterRangeInput(
                    initialParameter: _parameters,
                    onParameterChanged: (parameter) {
                      setState(() {
                        _parameters = parameter;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Widget de selección de usuarios (datos hardcodeados)
                  MultiUserSelector(
                    availableUsers: _mockGuests,
                    selectedUserIds: _selectedUserIds,
                    onSelectionChanged: (selectedIds) {
                      setState(() {
                        _selectedUserIds = selectedIds;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Botones de acción
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createAlert,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(
                            _isEditMode ? 'Actualizar Alerta' : 'Crear Alerta',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                  if (_isEditMode) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _isLoading ? null : () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
