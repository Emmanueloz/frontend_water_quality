import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class MeterSocketService {
  socket_io.Socket? _socket; 

  void connect({
    required String baseUrl,
    required String token,
    required String idWorkspace,
    required String idMeter,
    required Function(dynamic) onData,
  }) {
    final url = '$baseUrl/subscribe/';
    _socket = socket_io.io(
      url,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {
          'id_workspace': idWorkspace,
          'id_meter': idMeter,
        },
        'extraHeaders': {
          'access_token': token,
        },
        'path': '/socket.io',
      },
    );

    _socket!.on('connect', (_) => print('Connected to meter socket'));
    _socket!.on('meter_data', onData); // Ajusta el nombre del evento según tu backend
    _socket!.on('disconnect', (_) => print('Disconnected from meter socket'));
    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }
} 