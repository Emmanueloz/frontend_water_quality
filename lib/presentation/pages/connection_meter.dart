import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
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
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    return BaseContainer(
      margin: EdgeInsets.all(screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet ? 10 : 0),
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
    // Schedule the scroll after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Expanded(
      child: Column(
        children: [
          // Connected device info
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.bluetooth_connected),
              title: const Text('Conectado a:'),
              subtitle:
                  Text(blueProvider.connectedDevice?.advName ?? 'Dispositivo'),
              trailing: IconButton(
                icon: const Icon(Icons.bluetooth_disabled),
                onPressed: () => blueProvider.disconnect(),
              ),
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: blueProvider.messages.length,
              itemBuilder: (context, index) {
                final message = blueProvider.messages[index];
                final isSent = message.startsWith('Sent:');

                return Align(
                  alignment:
                      isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSent
                          ? Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSent
                            ? Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.1)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      message
                          .replaceAll('Sent: ', '')
                          .replaceAll('Received: ', ''),
                      style: TextStyle(
                        color: isSent
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Message input
          Container(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              spacing: 5,
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) => _sendMessage(blueProvider),
                  ),
                ),
                IconButton(
                  onPressed: blueProvider.clearMessages,
                  icon: const Icon(Icons.cleaning_services),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => _sendMessage(blueProvider),
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
