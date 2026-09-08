import 'dart:async';

/// Notification event model for offline state transitions.
enum OfflineAlertLevel { info, warning, error, success }

class OfflineAlertEvent {
  final String title;
  final String message;
  final OfflineAlertLevel level;
  final DateTime timestamp;

  const OfflineAlertEvent({
    required this.title,
    required this.message,
    required this.level,
    required this.timestamp,
  });
}

/// Service broadcasting in-app alerts for connectivity and mesh transitions.
class OfflineNotificationService {
  final _alertController = StreamController<OfflineAlertEvent>.broadcast();

  Stream<OfflineAlertEvent> get onAlert => _alertController.stream;

  void notifyInternetLost() {
    _alertController.add(
      OfflineAlertEvent(
        title: 'Internet Disconnected',
        message: 'Switched to BLE Mesh & Store-and-Forward offline mode.',
        level: OfflineAlertLevel.warning,
        timestamp: DateTime.now(),
      ),
    );
  }

  void notifyInternetRestored() {
    _alertController.add(
      OfflineAlertEvent(
        title: 'Internet Restored',
        message: 'Online link detected. Ready to synchronize queued updates.',
        level: OfflineAlertLevel.success,
        timestamp: DateTime.now(),
      ),
    );
  }

  void notifyBleConnected(String deviceName) {
    _alertController.add(
      OfflineAlertEvent(
        title: 'Mesh Peer Connected',
        message: 'Established high-bandwidth BLE link with $deviceName.',
        level: OfflineAlertLevel.info,
        timestamp: DateTime.now(),
      ),
    );
  }

  void notifyBleDisconnected(String deviceName) {
    _alertController.add(
      OfflineAlertEvent(
        title: 'Mesh Peer Link Dropped',
        message: 'Link lost with $deviceName. Attempting auto-reconnection...',
        level: OfflineAlertLevel.warning,
        timestamp: DateTime.now(),
      ),
    );
  }

  void notifySyncCompleted(int itemCount) {
    _alertController.add(
      OfflineAlertEvent(
        title: 'Synchronization Complete',
        message: 'Successfully uploaded $itemCount offline updates to ResQLink Cloud.',
        level: OfflineAlertLevel.success,
        timestamp: DateTime.now(),
      ),
    );
  }

  void notifySyncFailed(String reason) {
    _alertController.add(
      OfflineAlertEvent(
        title: 'Sync Failed',
        message: 'Unable to complete cloud sync: $reason',
        level: OfflineAlertLevel.error,
        timestamp: DateTime.now(),
      ),
    );
  }

  void dispose() {
    _alertController.close();
  }
}
