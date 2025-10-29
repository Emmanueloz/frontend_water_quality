import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';

class ParameterRangeInput extends StatefulWidget {
  final Parameter? initialParameter;
  final Function(Parameter) onParameterChanged;

  const ParameterRangeInput({
    super.key,
    this.initialParameter,
    required this.onParameterChanged,
  });

  @override
  State<ParameterRangeInput> createState() => _ParameterRangeInputState();
}

class _ParameterRangeInputState extends State<ParameterRangeInput> {
  bool _isExpanded = false;
  
  // Controllers para pH
  late TextEditingController _phMinController;
  late TextEditingController _phMaxController;
  
  // Controllers para temperatura
  late TextEditingController _tempMinController;
  late TextEditingController _tempMaxController;
  
  // Controllers para TDS
  late TextEditingController _tdsMinController;
  late TextEditingController _tdsMaxController;
  
  // Controllers para conductividad
  late TextEditingController _condMinController;
  late TextEditingController _condMaxController;
  
  // Controllers para turbidez
  late TextEditingController _turbMinController;
  late TextEditingController _turbMaxController;

  @override
  void initState() {
    super.initState();
    
    final param = widget.initialParameter;
    
    _phMinController = TextEditingController(
      text: param?.ph.min.toString() ?? '6.5',
    );
    _phMaxController = TextEditingController(
      text: param?.ph.max.toString() ?? '8.5',
    );
    
    _tempMinController = TextEditingController(
      text: param?.temperature.min.toString() ?? '15.0',
    );
    _tempMaxController = TextEditingController(
      text: param?.temperature.max.toString() ?? '30.0',
    );
    
    _tdsMinController = TextEditingController(
      text: param?.tds.min.toString() ?? '0.0',
    );
    _tdsMaxController = TextEditingController(
      text: param?.tds.max.toString() ?? '500.0',
    );
    
    _condMinController = TextEditingController(
      text: param?.conductivity.min.toString() ?? '0.0',
    );
    _condMaxController = TextEditingController(
      text: param?.conductivity.max.toString() ?? '1000.0',
    );
    
    _turbMinController = TextEditingController(
      text: param?.turbidity.min.toString() ?? '0.0',
    );
    _turbMaxController = TextEditingController(
      text: param?.turbidity.max.toString() ?? '5.0',
    );
    
    // Add listeners to notify changes
    _addListeners();
  }

  void _addListeners() {
    _phMinController.addListener(_notifyChanges);
    _phMaxController.addListener(_notifyChanges);
    _tempMinController.addListener(_notifyChanges);
    _tempMaxController.addListener(_notifyChanges);
    _tdsMinController.addListener(_notifyChanges);
    _tdsMaxController.addListener(_notifyChanges);
    _condMinController.addListener(_notifyChanges);
    _condMaxController.addListener(_notifyChanges);
    _turbMinController.addListener(_notifyChanges);
    _turbMaxController.addListener(_notifyChanges);
  }

  void _notifyChanges() {
    final parameter = Parameter(
      ph: RangeValue(
        min: double.tryParse(_phMinController.text) ?? 0.0,
        max: double.tryParse(_phMaxController.text) ?? 0.0,
      ),
      temperature: RangeValue(
        min: double.tryParse(_tempMinController.text) ?? 0.0,
        max: double.tryParse(_tempMaxController.text) ?? 0.0,
      ),
      tds: RangeValue(
        min: double.tryParse(_tdsMinController.text) ?? 0.0,
        max: double.tryParse(_tdsMaxController.text) ?? 0.0,
      ),
      conductivity: RangeValue(
        min: double.tryParse(_condMinController.text) ?? 0.0,
        max: double.tryParse(_condMaxController.text) ?? 0.0,
      ),
      turbidity: RangeValue(
        min: double.tryParse(_turbMinController.text) ?? 0.0,
        max: double.tryParse(_turbMaxController.text) ?? 0.0,
      ),
    );
    widget.onParameterChanged(parameter);
  }

  @override
  void dispose() {
    _phMinController.dispose();
    _phMaxController.dispose();
    _tempMinController.dispose();
    _tempMaxController.dispose();
    _tdsMinController.dispose();
    _tdsMaxController.dispose();
    _condMinController.dispose();
    _condMaxController.dispose();
    _turbMinController.dispose();
    _turbMaxController.dispose();
    super.dispose();
  }

  Widget _buildRangeInput({
    required String label,
    required String unit,
    required TextEditingController minController,
    required TextEditingController maxController,
    required IconData icon,
    String? hint,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (hint != null) ...[
              const SizedBox(height: 4),
              Text(
                hint,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: minController,
                    decoration: InputDecoration(
                      labelText: 'Mínimo',
                      suffixText: unit,
                      border: const OutlineInputBorder(),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: maxController,
                    decoration: InputDecoration(
                      labelText: 'Máximo',
                      suffixText: unit,
                      border: const OutlineInputBorder(),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Parámetros de calidad del agua',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Define los rangos aceptables para cada parámetro',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable content
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildRangeInput(
                    label: 'pH',
                    unit: 'pH',
                    minController: _phMinController,
                    maxController: _phMaxController,
                    icon: Icons.water_drop,
                    hint: 'Rango típico: 6.5 - 8.5',
                  ),
                  _buildRangeInput(
                    label: 'Temperatura',
                    unit: '°C',
                    minController: _tempMinController,
                    maxController: _tempMaxController,
                    icon: Icons.thermostat,
                    hint: 'Rango típico: 15 - 30°C',
                  ),
                  _buildRangeInput(
                    label: 'TDS (Sólidos Disueltos Totales)',
                    unit: 'ppm',
                    minController: _tdsMinController,
                    maxController: _tdsMaxController,
                    icon: Icons.grain,
                    hint: 'Rango típico: 0 - 500 ppm',
                  ),
                  _buildRangeInput(
                    label: 'Conductividad',
                    unit: 'µS/cm',
                    minController: _condMinController,
                    maxController: _condMaxController,
                    icon: Icons.flash_on,
                    hint: 'Rango típico: 0 - 1000 µS/cm',
                  ),
                  _buildRangeInput(
                    label: 'Turbidez',
                    unit: 'NTU',
                    minController: _turbMinController,
                    maxController: _turbMaxController,
                    icon: Icons.blur_on,
                    hint: 'Rango típico: 0 - 5 NTU',
                  ),
                ],
              ),
            ),
          ],
        ],
      );
  }
}
