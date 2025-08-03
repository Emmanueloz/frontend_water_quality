import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';

class ScanSection extends StatelessWidget {
  final BlueProvider blueProvider;
  final void Function() onTap;

  const ScanSection({
    super.key,
    required this.blueProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: blueProvider.isScanning
              ? blueProvider.stopScan
              : blueProvider.initScan,
          color: blueProvider.isScanning
              ? Theme.of(context).colorScheme.error
              : null,
          icon: Icon(
            blueProvider.isScanning ? Icons.stop : Icons.bluetooth_searching,
            size: 36,
          ),
        ),
        Text(
          blueProvider.isScanning
              ? 'Buscando dispositivos...'
              : 'Toque para buscar dispositivos',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (blueProvider.devices.isNotEmpty) ...[
          const Text(
            "Dispositivos encontrados:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: blueProvider.devices.length,
            itemBuilder: (context, index) {
              final device = blueProvider.devices[index];

              print(device.remoteId);
              print(blueProvider.connectedDevice?.remoteId);

              if (device.remoteId.str ==
                  blueProvider.connectedDevice?.remoteId.str) {
                if (blueProvider.isConnected) {
                  return ListTile(
                    leading: const Icon(Icons.bluetooth),
                    title: Text(device.advName.isNotEmpty
                        ? device.advName
                        : 'Dispositivo desconocido'),
                    subtitle: Text(device.remoteId.toString()),
                    onTap: onTap,
                    trailing: Icon(
                      Icons.bluetooth_connected,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                } else {
                  return ListTile(
                    leading: const Icon(Icons.bluetooth_audio),
                    title: Text(device.advName.isNotEmpty
                        ? device.advName
                        : 'Dispositivo desconocido'),
                    subtitle: Text(device.remoteId.toString()),
                    trailing: CircularProgressIndicator.adaptive(),
                    onTap: blueProvider.cancelConnect,
                  );
                }
              } else if (blueProvider.isConnected ||
                  blueProvider.isConnecting) {
                return ListTile(
                  leading: const Icon(Icons.bluetooth_audio),
                  title: Text(device.advName.isNotEmpty
                      ? device.advName
                      : 'Dispositivo desconocido'),
                  subtitle: Text(device.remoteId.toString()),
                );
              }

              return ListTile(
                leading: const Icon(Icons.bluetooth_audio),
                title: Text(device.advName.isNotEmpty
                    ? device.advName
                    : 'Dispositivo desconocido'),
                subtitle: Text(device.remoteId.toString()),
                onTap: () async {
                  try {
                    await blueProvider.connectToDevice(device);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al conectar: $e')),
                    );
                  }
                },
              );
            },
          ),
        ],
      ],
    );
  }
}
