class ConnectivityState {
  final bool isOnline;
  final bool hasError;
  final String? errorMessage;
  final DateTime lastChecked;

  ConnectivityState({
    required this.isOnline,
    this.hasError = false,
    this.errorMessage,
    required this.lastChecked,
  });

  ConnectivityState copyWith({
    bool? isOnline,
    bool? hasError,
    String? errorMessage,
    DateTime? lastChecked,
  }) {
    return ConnectivityState(
      isOnline: isOnline ?? this.isOnline,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }
}
