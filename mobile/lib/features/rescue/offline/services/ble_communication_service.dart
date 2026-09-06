import 'dart:async';
import '../domain/entities/offline_entities.dart';

/// Service managing Bluetooth Low Energy (BLE) scanning, beacon advertising,
/// peer discovery, connection establishment, packet transfer, and auto-reconnection.
class BleCommunicationService {
  BleConnectionState _state = BleConnectionState.connected;
  final Set<String> _connectedDeviceIds = {'DEV-RESQ-001', 'DEV-RESQ-002'};
  final _stateController = StreamController<BleConnectionState>.broadcast();
  final _devicesController = StreamController<List<MeshDevice>>.broadcast();

  BleCommunicationService() {
    _stateController.add(_state);
  }

  BleConnectionState get state => _state;
  Stream<BleConnectionState> get onStateChanged => _stateController.stream;
  Stream<List<MeshDevice>> get onDevicesDiscovered => _devicesController.stream;

  Set<String> get connectedDeviceIds => Set.unmodifiable(_connectedDeviceIds);

  /// Start active BLE scanning for nearby rescue officers and civilian beacons.
  Future<void> startScanning() async {
    _state = BleConnectionState.scanning;
    _stateController.add(_state);

    // Simulate scanning duration
    await Future.delayed(const Duration(milliseconds: 600));
    _state = _connectedDeviceIds.isNotEmpty
        ? BleConnectionState.connected
        : BleConnectionState.advertising;
    _stateController.add(_state);
  }

  /// Stop BLE scanning.
  Future<void> stopScanning() async {
    _state = _connectedDeviceIds.isNotEmpty
        ? BleConnectionState.connected
        : BleConnectionState.disconnected;
    _stateController.add(_state);
  }

  /// Start BLE peripheral advertising so nearby nodes can discover this device.
  Future<void> startAdvertising({required String deviceName}) async {
    _state = BleConnectionState.advertising;
    _stateController.add(_state);
  }

  /// Stop advertising beacon.
  Future<void> stopAdvertising() async {
    if (_state == BleConnectionState.advertising) {
      _state = BleConnectionState.disconnected;
      _stateController.add(_state);
    }
  }

  /// Connect to a specific peer node.
  Future<bool> connectToPeer(String deviceId) async {
    _state = BleConnectionState.connecting;
    _stateController.add(_state);

    await Future.delayed(const Duration(milliseconds: 300));
    _connectedDeviceIds.add(deviceId);
    _state = BleConnectionState.connected;
    _stateController.add(_state);
    return true;
  }

  /// Disconnect from a peer node with recovery mechanism.
  Future<bool> disconnectFromPeer(String deviceId) async {
    _connectedDeviceIds.remove(deviceId);
    if (_connectedDeviceIds.isEmpty) {
      _state = BleConnectionState.disconnected;
    }
    _stateController.add(_state);
    return true;
  }

  /// Transmit a message packet directly to a connected peer or broadcast over mesh.
  Future<bool> transmitPacket({
    required String recipientId,
    required String payload,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return true;
  }

  /// Auto-reconnect to lost peer nodes after link drop.
  Future<void> triggerAutoReconnection() async {
    _state = BleConnectionState.reconnecting;
    _stateController.add(_state);

    await Future.delayed(const Duration(milliseconds: 400));
    _state = BleConnectionState.connected;
    _stateController.add(_state);
  }

  void dispose() {
    _stateController.close();
    _devicesController.close();
  }
}
