enum PairingErrorType {
  // Network errors
  networkTimeout,
  networkUnavailable,
  serverError,
  unauthorized,
  notFound,
  badRequest,
  
  // Bluetooth errors
  bluetoothDisabled,
  bluetoothUnavailable,
  deviceNotFound,
  connectionLost,
  transmissionFailed,
  permissionDenied,
  
  // Validation errors
  invalidToken,
  tokenMismatch,
  tokenExpired,
  
  // General errors
  unknown,
}

class PairingError {
  final PairingErrorType type;
  final String message;
  final String? technicalDetails;
  final bool isRetryable;

  const PairingError({
    required this.type,
    required this.message,
    this.technicalDetails,
    this.isRetryable = false,
  });

  factory PairingError.networkTimeout() {
    return const PairingError(
      type: PairingErrorType.networkTimeout,
      message: 'La conexión tardó demasiado tiempo. Verifica tu conexión a internet.',
      isRetryable: true,
    );
  }

  factory PairingError.networkUnavailable() {
    return const PairingError(
      type: PairingErrorType.networkUnavailable,
      message: 'No hay conexión a internet. Verifica tu conexión y vuelve a intentar.',
      isRetryable: true,
    );
  }

  factory PairingError.serverError([String? details]) {
    return PairingError(
      type: PairingErrorType.serverError,
      message: 'Error del servidor. Intenta nuevamente en unos momentos.',
      technicalDetails: details,
      isRetryable: true,
    );
  }

  factory PairingError.unauthorized() {
    return const PairingError(
      type: PairingErrorType.unauthorized,
      message: 'Tu sesión ha expirado. Inicia sesión nuevamente.',
      isRetryable: false,
    );
  }

  factory PairingError.notFound() {
    return const PairingError(
      type: PairingErrorType.notFound,
      message: 'El medidor no fue encontrado. Verifica que el medidor esté registrado.',
      isRetryable: false,
    );
  }

  factory PairingError.badRequest([String? details]) {
    return PairingError(
      type: PairingErrorType.badRequest,
      message: 'Datos inválidos enviados al servidor.',
      technicalDetails: details,
      isRetryable: false,
    );
  }

  factory PairingError.bluetoothDisabled() {
    return const PairingError(
      type: PairingErrorType.bluetoothDisabled,
      message: 'Bluetooth está desactivado. Activa Bluetooth para continuar.',
      isRetryable: false,
    );
  }

  factory PairingError.bluetoothUnavailable() {
    return const PairingError(
      type: PairingErrorType.bluetoothUnavailable,
      message: 'Bluetooth no está disponible en este dispositivo.',
      isRetryable: false,
    );
  }

  factory PairingError.deviceNotFound() {
    return const PairingError(
      type: PairingErrorType.deviceNotFound,
      message: 'No se pudo encontrar el medidor. Asegúrate de que esté encendido y cerca.',
      isRetryable: true,
    );
  }

  factory PairingError.connectionLost() {
    return const PairingError(
      type: PairingErrorType.connectionLost,
      message: 'Se perdió la conexión con el medidor. Intenta reconectar.',
      isRetryable: true,
    );
  }

  factory PairingError.transmissionFailed() {
    return const PairingError(
      type: PairingErrorType.transmissionFailed,
      message: 'Error al enviar datos al medidor. Verifica la conexión Bluetooth.',
      isRetryable: true,
    );
  }

  factory PairingError.permissionDenied() {
    return const PairingError(
      type: PairingErrorType.permissionDenied,
      message: 'Se requieren permisos de ubicación para usar Bluetooth. Otorga los permisos en configuración.',
      isRetryable: false,
    );
  }

  factory PairingError.invalidToken() {
    return const PairingError(
      type: PairingErrorType.invalidToken,
      message: 'El token del medidor no es válido.',
      isRetryable: false,
    );
  }

  factory PairingError.tokenMismatch() {
    return const PairingError(
      type: PairingErrorType.tokenMismatch,
      message: 'El token del medidor no coincide con el registrado en la aplicación.',
      isRetryable: false,
    );
  }

  factory PairingError.tokenExpired() {
    return const PairingError(
      type: PairingErrorType.tokenExpired,
      message: 'El token del medidor ha expirado. Es necesario emparejar nuevamente.',
      isRetryable: false,
    );
  }

  factory PairingError.unknown([String? details]) {
    return PairingError(
      type: PairingErrorType.unknown,
      message: 'Ocurrió un error inesperado. Intenta nuevamente.',
      technicalDetails: details,
      isRetryable: true,
    );
  }

  factory PairingError.fromException(dynamic exception) {
    final String exceptionString = exception.toString().toLowerCase();
    
    if (exceptionString.contains('timeout') || exceptionString.contains('timed out')) {
      return PairingError.networkTimeout();
    }
    
    if (exceptionString.contains('network') || exceptionString.contains('connection')) {
      return PairingError.networkUnavailable();
    }
    
    if (exceptionString.contains('bluetooth') || exceptionString.contains('ble')) {
      if (exceptionString.contains('permission')) {
        return PairingError.permissionDenied();
      }
      if (exceptionString.contains('disabled') || exceptionString.contains('off')) {
        return PairingError.bluetoothDisabled();
      }
      if (exceptionString.contains('not found') || exceptionString.contains('device')) {
        return PairingError.deviceNotFound();
      }
      return PairingError.connectionLost();
    }
    
    return PairingError.unknown(exception.toString());
  }

  factory PairingError.fromHttpStatus(int statusCode, [String? responseBody]) {
    switch (statusCode) {
      case 400:
        return PairingError.badRequest(responseBody);
      case 401:
        return PairingError.unauthorized();
      case 403:
        return PairingError.tokenMismatch();
      case 404:
        return PairingError.notFound();
      case >= 500:
        return PairingError.serverError(responseBody);
      default:
        return PairingError.unknown('HTTP $statusCode: $responseBody');
    }
  }

  @override
  String toString() {
    return 'PairingError(type: $type, message: $message, isRetryable: $isRetryable)';
  }
}