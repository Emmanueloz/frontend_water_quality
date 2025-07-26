import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:provider/provider.dart';

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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      padding: const EdgeInsets.all(16),
      child: Consumer<BlueProvider>(
        builder: (context, blueProvider, _) {
          if (!blueProvider.isSupported) {
            return const Center(
              child: Text("Bluetooth no es soportado, usa la aplicación móvil"),
            );
          }

          return Column(
            children: [
              if (!blueProvider.isConnected) _buildScanSection(blueProvider),
              if (blueProvider.isConnected) _buildChatSection(blueProvider),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScanSection(BlueProvider blueProvider) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (blueProvider.isScanning)
                const CircularProgressIndicator(strokeWidth: 2),
              FloatingActionButton.large(
                onPressed: blueProvider.isScanning 
                    ? blueProvider.stopScan 
                    : blueProvider.initScan,
                backgroundColor: blueProvider.isScanning 
                    ? Theme.of(context).colorScheme.error 
                    : null,
                child: Icon(
                  blueProvider.isScanning 
                      ? Icons.stop 
                      : Icons.bluetooth_searching, 
                  size: 36,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            blueProvider.isScanning
                ? 'Buscando dispositivos...'
                : 'Toque para buscar dispositivos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (blueProvider.isScanning) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: blueProvider.stopScan,
              icon: const Icon(Icons.stop_circle_outlined),
              label: const Text('Detener búsqueda'),
            ),
          ],
          const SizedBox(height: 32),
          if (blueProvider.devices.isNotEmpty) ...[
            const Text(
              "Dispositivos encontrados:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _buildChatSection(BlueProvider blueProvider) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: blueProvider.messages.length,
            itemBuilder: (context, index) {
              final message = blueProvider.messages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Align(
                  alignment: message.startsWith('Sent:')
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.startsWith('Sent:')
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message
                          .replaceAll('Sent: ', '')
                          .replaceAll('Received: ', ''),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onSubmitted: (value) => _sendMessage(blueProvider),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => _sendMessage(blueProvider),
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => blueProvider.disconnect(),
          icon: const Icon(Icons.bluetooth_disabled),
          label: const Text('Desconectar'),
        ),
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
