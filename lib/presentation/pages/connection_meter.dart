import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/meter_setup.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/initial_meter_setup.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class ConnectionMeterPage extends StatefulWidget {
  final String id;
  final String idMeter;
  const ConnectionMeterPage({
    super.key,
    required this.id,
    required this.idMeter,
  });

  @override
  State<ConnectionMeterPage> createState() => _ConnectionMeterPageState();
}

class _ConnectionMeterPageState extends State<ConnectionMeterPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return BaseContainer(
      margin: EdgeInsets.all(
          screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
              ? 10
              : 0),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Consumer<BlueProvider>(
          builder: (context, blueProvider, _) {
            if (!blueProvider.isSupported) {
              return const Center(
                child:
                    Text("Bluetooth no es soportado, usa la aplicación móvil"),
              );
            }

            if (!blueProvider.isConnected) {
              return _buildScanSection(blueProvider);
            }

            return InitialMeterSetup(
              idWorkspace: widget.id,
              idMeter: widget.idMeter,
              onSendData: (message) {},
            );
          },
        ),
      ),
    );
  }

  Widget _buildScanSection(BlueProvider blueProvider) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
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
          Expanded(
            child: ListView.builder(
              itemCount: blueProvider.devices.length,
              itemBuilder: (context, index) {
                final device = blueProvider.devices[index];
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al conectar: $e')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _sendMessage(BlueProvider blueProvider) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      blueProvider.sendMessage(message);
      _messageController.clear();
    }
  }
}
