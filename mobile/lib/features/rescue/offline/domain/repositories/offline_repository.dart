import '../entities/offline_entities.dart';

/// Abstract repository contract for Offline Communication, Mesh BLE,
/// Store-and-Forward Queue, Synchronization, and Offline Caching.
abstract class OfflineRepository {
  /// Fetch real-time offline communication system status and telemetry.
  Future<OfflineSystemStatus> getSystemStatus();

  /// Retrieve discovered mesh devices, optionally filtered by type or query.
  Future<List<MeshDevice>> getMeshDevices({
    DeviceType? type,
    String? searchQuery,
    String? district,
  });

  /// Retrieve list of currently connected peer nodes.
  Future<List<MeshDevice>> getConnectedDevices();

  /// Connect to a discovered peer node over BLE mesh.
  Future<bool> connectToDevice(String deviceId);

  /// Disconnect from a peer node.
  Future<bool> disconnectFromDevice(String deviceId);

  /// Retrieve messages in the Store-and-Forward transmission queue.
  Future<List<OfflineMessage>> getQueuedMessages({
    MessageQueueStatus? status,
    MessagePriority? priority,
    OfflineMessageType? type,
    String? searchQuery,
  });

  /// Enqueue a new offline message into local storage and forward queue.
  Future<OfflineMessage> enqueueMessage(OfflineMessage message);

  /// Manually retry transmission of a failed or queued message.
  Future<OfflineMessage> retryMessage(String messageId);

  /// Clear all expired messages exceeding TTL.
  Future<int> clearExpiredMessages();

  /// Retrieve synchronization history logs and audit records.
  Future<List<SyncRecord>> getSyncRecords();

  /// Perform automatic or manual batch upload of all local updates with conflict resolution.
  Future<SyncRecord> triggerFullSync({
    ConflictResolutionStrategy strategy =
        ConflictResolutionStrategy.latestTimestampWins,
  });

  /// Retrieve cached disaster map intelligence for offline viewing.
  Future<List<CachedMapData>> getCachedMapData({String? district});

  /// Retrieve offline system configuration settings.
  Future<OfflineSettings> getSettings();

  /// Persist updated offline settings.
  Future<OfflineSettings> updateSettings(OfflineSettings settings);

  /// Broadcast high-priority emergency distress packet across all available nodes.
  Future<OfflineMessage> broadcastEmergencyBeacon({
    required String senderId,
    required String senderName,
    required String payload,
    required String district,
  });
}
