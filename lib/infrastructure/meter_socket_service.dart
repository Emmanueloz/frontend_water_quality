import 'package:socket_io_client/socket_io_client.dart' as IO;

class MeterSocketService {
  IO.Socket? _socket;

  void connect({
    required String baseUrl,
    required String token,
    required String idWorkspace,
    required String idMeter,
    required Function(dynamic) onData,
  }) {
    // Limpiar socket anterior si existe
    if (_socket != null) {
      _socket!
        ..off('connect')
        ..off('message')
        ..off('disconnect')
        ..disconnect()
        ..destroy();
      _socket = null;
    }

    // Construir URL con namespace /subscribe
    final host = baseUrl;
    const namespace = '/subscribe';
    final url = '$host$namespace';

    // Crear socket apuntando al namespace
    _socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'Access-Token': token})
            .setQuery({'id_workspace': idWorkspace, 'id_meter': idMeter})
            .setPath('/socket.io')
            .setTimeout(30000) // Timeout de 30 segundos
            .setReconnectionAttempts(3) // Reintentos de reconexión
            .setReconnectionDelay(2000)
            .build());

    // Definir listeners
    _socket!.on('connect', (data) {
      print('✔️ Conectado a $namespace data: $data');
      // onConnect?.call(data);
    });

    _socket!.on('message', (data) {
      print('Event received: $data'); // Corregido: escape de $ removido
      try {
        onData(data);
      } catch (e) {
        print('Error procesando mensaje: $e');
      }
    });
    _socket!.on('disconnect', (_) => print('⏹ Desconectado del socket'));

    // Iniciar conexión
    _socket!.connect();
  }

  void disconnect() {
    if (_socket != null) {
      _socket!
        ..off('connect')
        ..off('message')
        ..off('disconnect')
        ..disconnect()
        ..destroy();
      _socket = null;
    }
  }
}
