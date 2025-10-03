import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/period_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/param_period.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/custom_date_picker.dart';

class FormPeriodDialog extends StatefulWidget {
  final void Function(ParamPeriod parameters) onSubmit;

  const FormPeriodDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<FormPeriodDialog> createState() => _FormPeriodDialogState();
}

class _FormPeriodDialogState extends State<FormPeriodDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  PeriodType _selectedPeriod = PeriodType.days;

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
      final parameters = ParamPeriod(
        startDate: _startDate,
        endDate: _endDate,
        periodType: _selectedPeriod.value,
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
                  'Crear análisis por período',
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

                const SizedBox(height: 16),

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
