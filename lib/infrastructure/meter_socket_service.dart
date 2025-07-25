import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class MeterSocketService {
  IO.Socket? _socket;

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

    // Construir URL correctamente para FastAPI
    final cleanUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    const namespace = '/subscribe/'; // Mantener consistente con el servidor
    
    print('🔌 Conectando a: $cleanUrl$namespace');
    print('🔑 Token: ${token.substring(0, 20)}...');
    print('🏢 Workspace: $idWorkspace, Meter: $idMeter');

    // Crear socket con configuración para FastAPI + Socket.IO
    _socket = IO.io(
        '$cleanUrl$namespace',
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling']) // Websocket primero, polling como fallback
            .disableAutoConnect()
            .setExtraHeaders({
              'Access-Token': token, // Cambiado a Access-Token como espera el servidor
            })
            .setQuery({
              'id_workspace': idWorkspace, 
              'id_meter': idMeter,
            })
            .setPath('/socket.io/') // IMPORTANTE: Path donde FastAPI monta el socket
            .setTimeout(30000)
            .setReconnectionAttempts(5)
            .setReconnectionDelay(2000)
            .enableForceNew()
            .build());

    // Listener de conexión exitosa
    _socket!.on('connect', (data) {
      print('✅ Conectado exitosamente al namespace $namespace');
      print('📊 Datos de conexión: $data');
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    // Listener de mensajes del servidor
    _socket!.on('message', (data) {
      print('📨 Mensaje recibido del servidor: $data');
      try {
        onData(data);
      } catch (e) {
        print('❌ Error procesando mensaje: $e');
      }
    });

    // Listener de errores del servidor
    _socket!.on('error', (error) {
      print('🚨 Error del servidor: $error');
    });

    // Listener de desconexión
    _socket!.on('disconnect', (reason) {
      print('⏹ Desconectado del socket. Razón: $reason');
    });

    // Manejo de errores de conexión
    _socket!.on('connect_error', (error) {
      print('❌ Error de conexión: $error');
      
      // Información adicional para debugging
      if (error is Map) {
        print('   - Mensaje: ${error['msg']}');
        print('   - Descripción: ${error['desc']}');
        print('   - Tipo: ${error['type']}');
      }
      
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
      print('❌ Reconexión fallida después de múltiples intentos: $error');
    });

    // Eventos adicionales para debugging
    _socket!.on('reconnect', (attemptNumber) {
      print('🔄 Reconectado después de $attemptNumber intentos');
    });

    _socket!.on('reconnect_attempt', (attemptNumber) {
      print('🔄 Intento de reconexión #$attemptNumber');
    });

    // Timeout manual para el completer
    Timer(Duration(seconds: 35), () {
      if (!completer.isCompleted) {
        disconnect(); // Limpiar conexión
        completer.completeError('Timeout: No se pudo conectar en 35 segundos');
      }
    });

    // Iniciar conexión
    print('🚀 Iniciando conexión...');
    _socket!.connect();
    
    return completer.future;
  }

  void disconnect() {
    if (_socket != null) {
      print('🔌 Desconectando socket...');
      _socket!
        ..off('connect')
        ..off('message')
        ..off('error')
        ..off('disconnect')
        ..off('connect_error')
        ..off('connect_timeout')
        ..off('reconnect_failed')
        ..off('reconnect')
        ..off('reconnect_attempt')
        ..disconnect()
        ..destroy();
      _socket = null;
      print('✅ Socket desconectado y limpiado');
    }
  }

  bool get isConnected => _socket?.connected ?? false;
  
  String? get connectionId => _socket?.id;
}