import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/meter_setup.dart';

class InitialMeterSetup extends StatefulWidget {
  final String idWorkspace;
  final String idMeter;
  final MeterSetup? meterSetup;
  final void Function(String message) onSendData;
  const InitialMeterSetup({
    super.key,
    this.meterSetup,
    required this.onSendData,
    required this.idWorkspace,
    required this.idMeter,
  });

  @override
  State<InitialMeterSetup> createState() => _InitialMeterSetupState();
}

class _InitialMeterSetupState extends State<InitialMeterSetup> {
  double pH4 = 0;
  double pH6 = 0;

  @override
  void initState() {
    super.initState();

    pH4 = widget.meterSetup?.ph4 ?? 0;
    pH6 = widget.meterSetup?.ph6 ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: 10,
        children: [
          Card(
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  text: "Dispositivo: ",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "Medidor 0.6",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.bluetooth_disabled),
              ),
            ),
          ),
          Text(
            "Conexión con el medidor",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Enlazar a este medidor"),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            "Configura tu wifi",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Nombre de la red",
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Contraseña",
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            "Calibración",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ListTile(
            title: Slider(
              padding: EdgeInsets.zero,
              value: pH4,
              max: 14,
              onChanged: (value) {
                setState(() {
                  pH4 = value;
                });
              },
            ),
            subtitle: Text("ph4: ${pH4.toStringAsFixed(2)}"),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Usar sensor"),
            ),
          ),
          ListTile(
            title: Slider(
              padding: EdgeInsets.zero,
              value: pH6,
              max: 14,
              onChanged: (value) {
                setState(() {
                  pH6 = value;
                });
              },
            ),
            subtitle: Text("ph6: ${pH6.toStringAsFixed(2)}"),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Usar sensor"),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Acualizar"),
          )
        ],
      ),
    );
  }
}
