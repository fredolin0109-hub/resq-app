import 'dart:async';
import '../domain/entities/offline_entities.dart';

/// Connectivity monitoring service tracking Wi-Fi, Cellular, BLE Mesh, and Air-gapped offline transitions.
class ConnectivityMonitorService {
  NetworkMode _currentMode = NetworkMode.meshOnly;
  final _modeController = StreamController<NetworkMode>.broadcast();

  ConnectivityMonitorService({NetworkMode initialMode = NetworkMode.meshOnly}) {
    _currentMode = initialMode;
  }

  NetworkMode get currentMode => _currentMode;
  Stream<NetworkMode> get onModeChanged => _modeController.stream;

  bool get isOnline => _currentMode.isOnline;
  bool get isMeshOnly => _currentMode == NetworkMode.meshOnly;
  bool get isAirgapped => _currentMode == NetworkMode.offlineAirgap;

  /// Manually switch or automatically transition connection mode.
  void setNetworkMode(NetworkMode newMode) {
    if (_currentMode != newMode) {
      _currentMode = newMode;
      _modeController.add(_currentMode);
    }
  }

  /// Simulate sudden field network disruption (Internet lost).
  void simulateInternetLoss() {
    setNetworkMode(NetworkMode.meshOnly);
  }

  /// Simulate total RF silence (Airgap mode).
  void simulateTotalAirgap() {
    setNetworkMode(NetworkMode.offlineAirgap);
  }

  /// Simulate internet restoration (Wi-Fi or Cellular).
  void simulateInternetRestored({bool isWiFi = true}) {
    setNetworkMode(isWiFi ? NetworkMode.onlineWiFi : NetworkMode.onlineCellular);
  }

  void dispose() {
    _modeController.close();
  }
}
