import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/meter_setup.dart';

class InitialMeterSetup extends StatefulWidget {
  final String idWorkspace;
  final String idMeter;
  final String nameDevice;
  final MeterSetup? initialSetup;

  final Future<void> Function(String ssid, String password) onSaveWifi;
  final Future<void> Function(double ph4, double ph6) onSaveManualCalibration;
  final Future<void> Function() onResetCalibration;
  final Future<void> Function() onCalibratePh4;
  final Future<void> Function() onCalibratePh6;
  final VoidCallback onDisconnect;

  const InitialMeterSetup({
    super.key,
    required this.idWorkspace,
    required this.idMeter,
    required this.nameDevice,
    this.initialSetup,
    required this.onSaveWifi,
    required this.onSaveManualCalibration,
    required this.onResetCalibration,
    required this.onCalibratePh4,
    required this.onCalibratePh6,
    required this.onDisconnect,
  });

  @override
  State<InitialMeterSetup> createState() => _InitialMeterSetupState();
}

class _InitialMeterSetupState extends State<InitialMeterSetup>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();

  double _ph4Value = 0.0;
  double _ph6Value = 0.0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.initialSetup != null) {
      _ssidController.text = widget.initialSetup!.ssidWifi ?? '';
      _passwordController.text = widget.initialSetup!.passwordWifi ?? '';
      _ph4Value = widget.initialSetup!.ph4 ?? 0.0;
      _ph6Value = widget.initialSetup!.ph6 ?? 0.0;
    }
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        _buildDeviceHeader(theme),
        _buildWifiSection(theme),
        _buildCalibrationSection(theme),
      ],
    );
  }

  Widget _buildDeviceHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.bluetooth_connected,
                  color: theme.colorScheme.secondary),
              Text(
                widget.nameDevice,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: widget.onDisconnect,
            icon: Icon(
              Icons.bluetooth_disabled,
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWifiSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              'Configura tu Wi-Fi',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _ssidController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la red',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "El nombre no puede estar vacio";
                }

                if (value.length < 4 || value.length > 20) {
                  return "El nombre debe estar entre 4 y 20 caracteres";
                }

                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "La contraseña no puede estar vacio";
                }

                if (value.length < 4 || value.length > 20) {
                  return "La contraseña debe estar entre 4 y 20 caracteres";
                }

                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  widget.onSaveWifi(
                    _ssidController.text.trim(),
                    _passwordController.text.trim(),
                  );
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: .2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            'Calibración',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.secondary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Ajuste manual'),
              Tab(text: 'Con el sensor'),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 250,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildManualCalibration(theme),
                _buildSensorCalibration(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _roundFloat(double valor) {
    return (valor * 100).round() / 100;
  }

  Widget _buildManualCalibration(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _buildSlider(
          'pH 4',
          _ph4Value,
          (v) => setState(() {
            _ph4Value = _roundFloat(v);
          }),
        ),
        _buildSlider(
          'pH 6',
          _ph6Value,
          (v) => setState(() {
            _ph6Value = _roundFloat(v);
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _ph4Value = 0;
                  _ph6Value = 0;
                });
                widget.onResetCalibration();
              },
              child: const Text('Restablecer'),
            ),
            ElevatedButton(
              onPressed: () =>
                  widget.onSaveManualCalibration(_ph4Value, _ph6Value),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSensorCalibration(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'Envía la orden al medidor para calibrar con pH 4 o pH 6.',
        ),
        Column(
          spacing: 8,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onCalibratePh4,
                child: const Text('Calibrar con pH 4'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onCalibratePh6,
                child: const Text('Calibrar con pH 6'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    ValueChanged<double> onChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text('$label: ${value.toStringAsFixed(2)} mV'),
        Slider(
          value: value,
          inactiveColor: Theme.of(context).colorScheme.tertiaryContainer,
          min: 0,
          max: 14,
          label: '${value.toStringAsFixed(0)} mV',
          onChanged: onChange,
        ),
      ],
    );
  }
}
