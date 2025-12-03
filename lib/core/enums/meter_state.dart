enum MeterState {
  disconnected,
  connected,
  sendingData,
  error,
  unknown,
}

extension MeterStateExtension on MeterState {
  static MeterState fromName(String name) {
    switch (name) {
      case 'disconnected':
        return MeterState.disconnected;
      case 'connected':
        return MeterState.connected;
      case 'sending_data':
        return MeterState.sendingData;
      case 'error':
        return MeterState.error;
      default:
        return MeterState.unknown;
    }
  }

  String get nameSpanish {
    switch (this) {
      case MeterState.disconnected:
        return "Desconectado";
      case MeterState.connected:
        return "Conectado";
      case MeterState.sendingData:
        return "Enviando datos";
      case MeterState.error:
        return "Error";
      case MeterState.unknown:
        return "Desconocido";
    }
  }
}
