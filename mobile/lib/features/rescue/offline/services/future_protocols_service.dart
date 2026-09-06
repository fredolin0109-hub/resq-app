import '../domain/entities/offline_entities.dart';

/// Abstract future-ready interface for LoRa Long-Range Radio Communication (868/915 MHz).
abstract class ILoRaRadioProtocol {
  Future<bool> initializeRadio({int frequencyMhz = 868, int txPowerDbm = 14});
  Future<bool> transmitLoRaPacket(List<int> bytes);
  Stream<List<int>> get onLoRaPacketReceived;
  Future<int> getRssi();
  Future<double> getSnr();
  Future<void> shutdownRadio();
}

/// Abstract future-ready interface for Satellite Communication (e.g., Iridium / Globalstar).
abstract class ISatelliteCommProtocol {
  Future<bool> connectToConstellation();
  Future<bool> transmitShortBurstData(String payload);
  Stream<String> get onSatelliteDataReceived;
  Future<int> getSatelliteSignalQuality();
  Future<void> disconnect();
}

/// Abstract future-ready interface for Wi-Fi Direct P2P Group Communication.
abstract class IWiFiDirectProtocol {
  Future<void> discoverPeers();
  Future<bool> connectToPeer(String deviceAddress);
  Future<bool> sendP2PData(String peerAddress, List<int> data);
  Stream<List<int>> get onP2PDataReceived;
  Future<void> disconnectFromPeer(String deviceAddress);
}

/// Abstract future-ready interface for Near Field Communication (NFC) Tap-to-Sync.
abstract class INfcProtocol {
  Future<bool> isNfcAvailable();
  Future<void> startNfcListening();
  Future<bool> writeNfcPayload(String payload);
  Stream<String> get onNfcPayloadRead;
  Future<void> stopNfcListening();
}

/// Mock implementations of future protocols for testing & simulated hardware validation.
class MockLoRaRadioProtocol implements ILoRaRadioProtocol {
  bool _initialized = false;

  @override
  Future<bool> initializeRadio({int frequencyMhz = 868, int txPowerDbm = 14}) async {
    _initialized = true;
    return true;
  }

  @override
  Future<bool> transmitLoRaPacket(List<int> bytes) async {
    return _initialized;
  }

  @override
  Stream<List<int>> get onLoRaPacketReceived => const Stream.empty();

  @override
  Future<int> getRssi() async => -92;

  @override
  Future<double> getSnr() async => 8.5;

  @override
  Future<void> shutdownRadio() async {
    _initialized = false;
  }
}

class MockSatelliteCommProtocol implements ISatelliteCommProtocol {
  @override
  Future<bool> connectToConstellation() async => true;

  @override
  Future<bool> transmitShortBurstData(String payload) async => true;

  @override
  Stream<String> get onSatelliteDataReceived => const Stream.empty();

  @override
  Future<int> getSatelliteSignalQuality() async => 4; // 4 out of 5 bars

  @override
  Future<void> disconnect() async {}
}
