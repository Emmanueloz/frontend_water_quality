import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/correlation_method.dart';
import 'package:frontend_water_quality/core/enums/period_type.dart';
import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/param_correlation.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/custom_date_picker.dart';

class FormCorrelationDialog extends StatefulWidget {
  final void Function(ParamCorrelation parameters) onSubmit;

  const FormCorrelationDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<FormCorrelationDialog> createState() => _FormCorrelationDialogState();
}

class _FormCorrelationDialogState extends State<FormCorrelationDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  PeriodType _selectedPeriod = PeriodType.days;
  CorrelationMethod _selectedMethod = CorrelationMethod.pearson;
  final List<SensorType> _selectedSensors = [];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await CustomDatePicker.show(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = DateTime(picked.year, picked.month, picked.day);
        } else {
          _endDate = DateTime(picked.year, picked.month, picked.day, 23, 59);
        }
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _selectedSensors.length >= 2) {
      final parameters = ParamCorrelation(
        startDate: _startDate,
        endDate: _endDate,
        periodType: _selectedPeriod.value,
        method: _selectedMethod.value,
        sensors: _selectedSensors.map((s) => s).toList(),
      );
      widget.onSubmit(parameters);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Text(
                  'Crear análisis de correlación',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                // Selector de período
                DropdownButtonFormField<PeriodType>(
                  decoration: const InputDecoration(
                    labelText: 'Período',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _selectedPeriod,
                  items: PeriodType.values.map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(period.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                    }
                  },
                ),

                // Selector de método
                DropdownButtonFormField<CorrelationMethod>(
                  decoration: const InputDecoration(
                    labelText: 'Método de correlación',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _selectedMethod,
                  items: CorrelationMethod.values.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    }
                  },
                ),

                // Selector de sensores con Chips
                FormField<List<SensorType>>(
                  initialValue: _selectedSensors,
                  validator: (value) {
                    if ((value?.length ?? 0) < 2) {
                      return 'Selecciona al menos 2 sensores';
                    }
                    return null;
                  },
                  builder: (FormFieldState<List<SensorType>> field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Sensores',
                        errorText: field.errorText,
                        border: const OutlineInputBorder(),
                      ),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: SensorType.values.map((sensor) {
                          return FilterChip(
                            label: Text(sensor.nameSpanish),
                            selected: _selectedSensors.contains(sensor),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSensors.add(sensor);
                                } else {
                                  _selectedSensors.remove(sensor);
                                }
                                field.didChange(_selectedSensors);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),

                // Selector de fecha inicial
                ListTile(
                  title: const Text('Fecha inicial'),
                  subtitle: Text(_startDate != null
                      ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                      : 'Seleccionar fecha'),
                  onTap: () => _selectDate(context, true),
                ),
                // Selector de fecha final
                ListTile(
                  title: const Text('Fecha final'),
                  subtitle: Text(_endDate != null
                      ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                      : 'Seleccionar fecha'),
                  onTap: () => _selectDate(context, false),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _startDate != null &&
                              _endDate != null &&
                              _selectedSensors.length >= 2
                          ? _handleSubmit
                          : null,
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
