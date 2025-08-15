import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class MeterSocketService {
  socket_io.Socket? _socket;
  Timer? _connectionTimer;

  Future<void> connect({
    required String baseUrl,
    required String token,
    required String idWorkspace,
    required String idMeter,
    required Function(dynamic) onData,
  }) {
    final completer = Completer<void>();

    // Limpiar socket anterior si existe
    if (_socket != null) {
      _socket!
        ..off('connect')
        ..off('message')
        ..off('disconnect')
        ..off('connect_error')
        ..off('connect_timeout')
        ..off('reconnect_failed')
        ..disconnect()
        ..destroy();
      _socket = null;
    }

    final socketUrl = baseUrl;

    print('🔌 Conectando a: $socketUrl');
    print('🔑 Token: ${token.substring(0, 20)}...');
    print('🏢 Workspace: $idWorkspace, Meter: $idMeter');

    final optionsSocket = socket_io.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .setPath('/socket.io/') // Path estándar de Socket.IO
        .disableAutoConnect()
        .setQuery({
          'id_workspace': idWorkspace,
          'id_meter': idMeter,
          'access_token': token
        })
        .setTimeout(30000)
        .setReconnectionAttempts(5)
        .setReconnectionDelay(2000)
        .setReconnectionDelayMax(10000);

    // Crear socket con configuración corregida - NAMESPACE SEPARADO
    _socket = socket_io.io(
        '$socketUrl/subscribe/', // Especificar el namespace en la URL
        optionsSocket.build());

    // Configurar eventos antes de conectar
    _setupSocketEvents(completer, onData);

    // Timeout manual para el completer
    _connectionTimer = Timer(Duration(seconds: 65), () {
      if (!completer.isCompleted) {
        disconnect();
        completer.completeError('Revise su conexión a internet');
      }
    });

    // Iniciar conexión
    print('🚀 Iniciando conexión...');
    _socket!.connect();

    return completer.future;
  }

  void _setupSocketEvents(Completer<void> completer, Function(dynamic) onData) {
    // Listener de conexión exitosa
    _socket!.on('connect', (data) {
      print('✅ Conectado exitosamente al socket');
      print('📊 Datos de conexión: $data');
      print('🆔 Connection ID: ${_socket!.id}');

      // Esperar un momento para que el backend procese la conexión al namespace
      Timer(Duration(seconds: 2), () {
        if (_socket?.connected == true) {
          print('🔄 Verificando si estamos en el namespace /subscribe/...');
        }
      });

      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    // Listener de mensajes del servidor - UNIFICADO
    _socket!.on('message', (data) {
      // Verificar si realmente deberíamos procesar este mensaje
      if (_socket == null || !_socket!.connected) {
        print('🚫 Mensaje ignorado - socket desconectado');
        return;
      }

      print('📨 Mensaje recibido del servidor: $data');
      try {
        onData(data);
      } catch (e) {
        print('❌ Error procesando mensaje: $e');
      }
    });

    // Listener para errores específicos del backend
    _socket!.on('error', (error) {
      print('🚨 Error del servidor: $error');
      // El backend envía errores con este formato
    });

    // Listener de desconexión
    _socket!.on('disconnect', (reason) {
      print('⏹ Desconectado del socket. Razón: $reason');
    });

    // Manejo de errores de conexión
    _socket!.on('connect_error', (error) {
      print('❌ Error de conexión detallado: $error');

      if (!completer.isCompleted) {
        completer.completeError('Error de conexión: $error');
      }
    });

    _socket!.on('connect_timeout', (error) {
      print('⏳ Timeout de conexión: $error');
      if (!completer.isCompleted) {
        completer.completeError('Timeout de conexión: $error');
      }
    });

    _socket!.on('reconnect_failed', (error) {
      print('❌ Reconexión fallida: $error');
      if (!completer.isCompleted) {
        completer.completeError('Reconexión fallida: $error');
      }
    });

    // Eventos de reconexión
    _socket!.on('reconnect', (attemptNumber) {
      print('🔄 Reconectado después de $attemptNumber intentos');
      // No necesitamos re-suscribirse, el backend lo hace automáticamente
    });

    _socket!.on('reconnect_attempt', (attemptNumber) {
      print('🔄 Intento de reconexión #$attemptNumber');
    });
  }

  // Método para verificar el estado de la conexión
  bool isConnected() {
    return _socket?.connected ?? false;
  }

  // Método para obtener información de debugging
  String getConnectionInfo() {
    if (_socket == null) return 'Socket no inicializado';
    return 'Connected: ${_socket!.connected}, ID: ${_socket!.id}';
  }

  void disconnect() {
    if (_socket != null) {
      print('🔌 Desconectando socket...');
      _connectionTimer?.cancel();
      _connectionTimer = null;
      _socket!
        ..off('connect')
        ..off('message')
        ..off('subscription_confirmed')
        ..off('subscription_error')
        ..off('error')
        ..off('disconnect')
        ..off('connect_error')
        ..off('connect_timeout')
        ..off('reconnect_failed')
        ..off('reconnect')
        ..off('reconnect_attempt')
        ..off('reconnecting')
        ..off('unauthorized')
        ..off('namespace_joined')
        ..off('permission_denied')
        ..disconnect()
        ..destroy();
      _socket = null;
      print('✅ Socket desconectado y limpiado');
    }
  }
}
