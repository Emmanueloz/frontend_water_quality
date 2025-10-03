import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/period_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/param_prediction.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/custom_date_picker.dart';

class FormPredictionDialog extends StatefulWidget {
  final void Function(ParamPrediction parameters) onSubmit;

  const FormPredictionDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<FormPredictionDialog> createState() => _FormPredictionDialogState();
}

class _FormPredictionDialogState extends State<FormPredictionDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  PeriodType _selectedPeriod = PeriodType.days;
  int _selectedAhead = 10; // Valor por defecto

  // Lista de valores permitidos para ahead
  static const List<int> _aheadValues = [10, 15, 20];

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
    if (_formKey.currentState!.validate()) {
      final parameters = ParamPrediction(
        startDate: _startDate,
        endDate: _endDate,
        periodType: _selectedPeriod.value,
        ahead: _selectedAhead,
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
                  'Crear predicción',
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

                // Selector de ahead
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Días a predecir',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _selectedAhead,
                  items: _aheadValues.map((ahead) {
                    return DropdownMenuItem(
                      value: ahead,
                      child: Text('$ahead días'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedAhead = value;
                      });
                    }
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
                      onPressed: _startDate != null && _endDate != null
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
