import '../entities/offline_entities.dart';
import '../repositories/offline_repository.dart';

/// Retrieve real-time status and telemetry for offline operations.
class GetOfflineSystemStatusUseCase {
  final OfflineRepository repository;
  GetOfflineSystemStatusUseCase(this.repository);

  Future<OfflineSystemStatus> call() async {
    return await repository.getSystemStatus();
  }
}

/// Retrieve and filter mesh devices discovered via BLE / LoRa.
class GetMeshDevicesUseCase {
  final OfflineRepository repository;
  GetMeshDevicesUseCase(this.repository);

  Future<List<MeshDevice>> call({
    DeviceType? type,
    String? searchQuery,
    String? district,
  }) async {
    return await repository.getMeshDevices(
      type: type,
      searchQuery: searchQuery,
      district: district,
    );
  }

  Future<List<MeshDevice>> getConnected() async {
    return await repository.getConnectedDevices();
  }
}

/// Manage connection states with peer devices.
class ManageBleConnectionUseCase {
  final OfflineRepository repository;
  ManageBleConnectionUseCase(this.repository);

  Future<bool> connect(String deviceId) async {
    return await repository.connectToDevice(deviceId);
  }

  Future<bool> disconnect(String deviceId) async {
    return await repository.disconnectFromDevice(deviceId);
  }
}

/// Retrieve and filter messages in the store-and-forward queue.
class GetQueuedMessagesUseCase {
  final OfflineRepository repository;
  GetQueuedMessagesUseCase(this.repository);

  Future<List<OfflineMessage>> call({
    MessageQueueStatus? status,
    MessagePriority? priority,
    OfflineMessageType? type,
    String? searchQuery,
  }) async {
    return await repository.getQueuedMessages(
      status: status,
      priority: priority,
      type: type,
      searchQuery: searchQuery,
    );
  }
}

/// Store a message locally and forward it over mesh hops.
class EnqueueOfflineMessageUseCase {
  final OfflineRepository repository;
  EnqueueOfflineMessageUseCase(this.repository);

  Future<OfflineMessage> call(OfflineMessage message) async {
    return await repository.enqueueMessage(message);
  }

  Future<OfflineMessage> broadcastBeacon({
    required String senderId,
    required String senderName,
    required String payload,
    required String district,
  }) async {
    return await repository.broadcastEmergencyBeacon(
      senderId: senderId,
      senderName: senderName,
      payload: payload,
      district: district,
    );
  }
}

/// Retry failed messages or purge expired packets.
class RetryOfflineMessageUseCase {
  final OfflineRepository repository;
  RetryOfflineMessageUseCase(this.repository);

  Future<OfflineMessage> retry(String messageId) async {
    return await repository.retryMessage(messageId);
  }

  Future<int> clearExpired() async {
    return await repository.clearExpiredMessages();
  }
}

/// Execute two-way synchronization and history fetching.
class PerformOfflineSyncUseCase {
  final OfflineRepository repository;
  PerformOfflineSyncUseCase(this.repository);

  Future<SyncRecord> call({
    ConflictResolutionStrategy strategy =
        ConflictResolutionStrategy.latestTimestampWins,
  }) async {
    return await repository.triggerFullSync(strategy: strategy);
  }

  Future<List<SyncRecord>> getRecords() async {
    return await repository.getSyncRecords();
  }
}

/// Retrieve cached offline map telemetry.
class GetOfflineCachedMapUseCase {
  final OfflineRepository repository;
  GetOfflineCachedMapUseCase(this.repository);

  Future<List<CachedMapData>> call({String? district}) async {
    return await repository.getCachedMapData(district: district);
  }
}

/// Read and update offline settings.
class ManageOfflineSettingsUseCase {
  final OfflineRepository repository;
  ManageOfflineSettingsUseCase(this.repository);

  Future<OfflineSettings> getSettings() async {
    return await repository.getSettings();
  }

  Future<OfflineSettings> updateSettings(OfflineSettings settings) async {
    return await repository.updateSettings(settings);
  }
}
