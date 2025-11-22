class MockConnectivityProvider {
  bool _isOnline = true;

  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;
}
