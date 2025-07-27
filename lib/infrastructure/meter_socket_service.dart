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

    // Construir URL EXACTAMENTE como en Postman
    // Postman muestra: (base_url)/subscribe/?id_workspace=...&id_meter=...
    // final cleanUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

    // NO usar namespace en la URL, solo la base
    final socketUrl =
        baseUrl; // https://api.aqua-minds.org SIN puerto ni namespace

    print('🔌 Conectando a: $socketUrl');
    print('🔑 Token: ${token.substring(0, 20)}...');
    print('🏢 Workspace: $idWorkspace, Meter: $idMeter');

    // Crear socket con configuración que coincida EXACTAMENTE con Postman
    _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // Ambos transportes disponibles
            .setPath(
                '/socket.io/subscribe/') // Path específico para el namespace subscribe
            .disableAutoConnect()
            .setExtraHeaders({
              'ACCESS_TOKEN': token, // EXACTAMENTE como en Postman
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'User-Agent': 'Flutter-App/1.0',
            })
            .setQuery({
              'id_workspace': idWorkspace,
              'id_meter': idMeter,
              // NO incluir token en query si ya está en headers
            })
            .setTimeout(30000)
            .setReconnectionAttempts(5)
            .setReconnectionDelay(2000)
            .setReconnectionDelayMax(10000)
            .build());

    // Configurar eventos antes de conectar
        _socket!.on('message', (data) {
      print('📨 Mensaje recibido del servidor: $data');
      try {
        onData(data);
      } catch (e) {
        print('❌ Error procesando mensaje: $e');
      }
    });
    _setupSocketEvents(completer, onData);

    // Timeout manual para el completer
    Timer(Duration(seconds: 35), () {
      if (!completer.isCompleted) {
        disconnect();
        completer.completeError('Timeout: No se pudo conectar en 35 segundos');
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
      print('✅ Conectado exitosamente');
      print('📊 Datos de conexión: $data');
      print('🆔 Connection ID: ${_socket!.id}');
      // print('🚛 Transporte: ${_socket!.io.engine?.transport?.name}');

      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    // Listener de mensajes del servidor
    // _socket!.on('message', (data) {
    //   print('📨 Mensaje recibido del servidor: $data');
    //   try {
    //     onData(data);
    //   } catch (e) {
    //     print('❌ Error procesando mensaje: $e');
    //   }
    // });
    _socket!.onAny((event, data) {
      print('📬 Evento recibido: $event, Datos: $data');
    });

    // Listener de errores del servidor
    _socket!.on('error', (error) {
      print('🚨 Error del servidor: $error');
    });

    // Listener de desconexión
    _socket!.on('disconnect', (reason) {
      print('⏹ Desconectado del socket. Razón: $reason');

      // Manejar reconexión automática solo en ciertos casos
      if (reason == 'io server disconnect') {
        print('🔄 Servidor desconectó, intentando reconectar...');
        Future.delayed(Duration(seconds: 2), () {
          if (_socket?.connected != true) {
            _socket?.connect();
          }
        });
      }
    });

    // Manejo de errores de conexión
    _socket!.on('connect_error', (error) {
      print('❌ Error de conexión detallado:');
      print('   Error: $error');

      // Información adicional para debugging

      // Diagnosticar problemas comunes
      final errorStr = error.toString().toLowerCase();
      if (errorStr.contains('403')) {
        print('🚫 Error 403: Problema de autenticación/autorización');
        print('   - Verifica que el token ACCESS_TOKEN sea válido');
        print(
            '   - Verifica que el usuario tenga permisos para este workspace/meter');
      } else if (errorStr.contains('404')) {
        print('🚫 Error 404: Endpoint no encontrado');
        print('   - Verifica la URL base y el path del socket');
      } else if (errorStr.contains('cors')) {
        print('🚫 Error CORS: Problema de políticas de origen cruzado');
      }

      // Solo completar con error en el primer intento
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
      if (!completer.isCompleted) {
        completer.completeError('Reconexión fallida: $error');
      }
    });

    // Eventos adicionales para debugging
    _socket!.on('reconnect', (attemptNumber) {
      print('🔄 Reconectado después de $attemptNumber intentos');
    });

    _socket!.on('reconnect_attempt', (attemptNumber) {
      print('🔄 Intento de reconexión #$attemptNumber');
    });

    _socket!.on('reconnecting', (attemptNumber) {
      print('🔄 Reconectando... intento #$attemptNumber');
    });

    // Listeners para eventos de autorización
    _socket!.on('unauthorized', (error) {
      print('🚫 Error de autorización: $error');
      if (!completer.isCompleted) {
        completer.completeError('Error de autorización: $error');
      }
    });

    _socket!.on('authentication_error', (error) {
      print('🚫 Error de autenticación: $error');
      if (!completer.isCompleted) {
        completer.completeError('Error de autenticación: $error');
      }
    });

    // Event listener específico para el handshake
    _socket!.on('connect_success', (data) {
      print('🤝 Handshake exitoso: $data');
    });
  }

  void disconnect() {
    if (_socket != null) {
      print('🔌 Desconectando socket...');
      _socket!
        ..off('connect')
        ..off('message')
        ..off('meter_data')
        ..off('error')
        ..off('disconnect')
        ..off('connect_error')
        ..off('connect_timeout')
        ..off('reconnect_failed')
        ..off('reconnect')
        ..off('reconnect_attempt')
        ..off('reconnecting')
        ..off('unauthorized')
        ..off('authentication_error')
        ..off('connect_success')
        ..disconnect()
        ..destroy();
      _socket = null;
      print('✅ Socket desconectado y limpiado');
    }
  }
}
