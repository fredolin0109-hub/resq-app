import '../../domain/entities/offline_entities.dart';
import '../../domain/repositories/offline_repository.dart';
import '../datasources/offline_mock_datasource.dart';
import '../models/offline_models.dart';
import '../../services/ble_communication_service.dart';
import '../../services/store_and_forward_service.dart';
import '../../services/offline_sync_service.dart';
import '../../services/offline_cache_service.dart';

/// Concrete implementation of OfflineRepository backed by mock datasource and offline services.
class OfflineRepositoryImpl implements OfflineRepository {
  final OfflineMockDatasource datasource;
  final BleCommunicationService bleService;
  final StoreAndForwardService queueService;
  final OfflineSyncService syncService;
  final OfflineCacheService cacheService;

  OfflineRepositoryImpl({
    required this.datasource,
    required this.bleService,
    required this.queueService,
    required this.syncService,
    required this.cacheService,
  });

  @override
  Future<OfflineSystemStatus> getSystemStatus() async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      return datasource.getSystemStatus();
    } catch (e) {
      throw Exception('Failed to fetch offline system telemetry: $e');
    }
  }

  @override
  Future<List<MeshDevice>> getMeshDevices({
    DeviceType? type,
    String? searchQuery,
    String? district,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 60));
      return datasource.devices.where((d) {
        if (type != null && d.type != type) return false;
        if (district != null && district != 'All' && d.district.toLowerCase() != district.toLowerCase()) {
          return false;
        }
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final q = searchQuery.toLowerCase().trim();
          final match = d.name.toLowerCase().contains(q) ||
              d.id.toLowerCase().contains(q) ||
              d.district.toLowerCase().contains(q);
          if (!match) return false;
        }
        return true;
      }).toList();
    } catch (e) {
      throw Exception('Failed to discover mesh devices: $e');
    }
  }

  @override
  Future<List<MeshDevice>> getConnectedDevices() async {
    try {
      await Future.delayed(const Duration(milliseconds: 40));
      final connectedIds = bleService.connectedDeviceIds;
      return datasource.devices.where((d) => connectedIds.contains(d.id) || d.isConnected).toList();
    } catch (e) {
      throw Exception('Failed to fetch connected devices: $e');
    }
  }

  @override
  Future<bool> connectToDevice(String deviceId) async {
    try {
      return await bleService.connectToPeer(deviceId);
    } catch (e) {
      throw Exception('Failed to connect to mesh device $deviceId: $e');
    }
  }

  @override
  Future<bool> disconnectFromDevice(String deviceId) async {
    try {
      return await bleService.disconnectFromPeer(deviceId);
    } catch (e) {
      throw Exception('Failed to disconnect from device $deviceId: $e');
    }
  }

  @override
  Future<List<OfflineMessage>> getQueuedMessages({
    MessageQueueStatus? status,
    MessagePriority? priority,
    OfflineMessageType? type,
    String? searchQuery,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 60));
      return datasource.messages.where((m) {
        if (status != null && m.status != status) return false;
        if (priority != null && m.priority != priority) return false;
        if (type != null && m.type != type) return false;
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final q = searchQuery.toLowerCase().trim();
          final match = m.payload.toLowerCase().contains(q) ||
              m.senderName.toLowerCase().contains(q) ||
              m.district.toLowerCase().contains(q);
          if (!match) return false;
        }
        return true;
      }).toList();
    } catch (e) {
      throw Exception('Failed to load message queue: $e');
    }
  }

  @override
  Future<OfflineMessage> enqueueMessage(OfflineMessage message) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      final model = OfflineMessageModel(
        id: message.id,
        type: message.type,
        priority: message.priority,
        status: message.status,
        senderId: message.senderId,
        senderName: message.senderName,
        recipientId: message.recipientId,
        payload: message.payload,
        timestamp: message.timestamp,
        retryCount: message.retryCount,
        maxRetries: message.maxRetries,
        acknowledgedAt: message.acknowledgedAt,
        isRelayed: message.isRelayed,
        ttlSeconds: message.ttlSeconds,
        district: message.district,
      );
      datasource.messages.insert(0, model);
      return model;
    } catch (e) {
      throw Exception('Failed to enqueue offline message: $e');
    }
  }

  @override
  Future<OfflineMessage> retryMessage(String messageId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 80));
      final idx = datasource.messages.indexWhere((m) => m.id == messageId);
      if (idx != -1) {
        final current = datasource.messages[idx];
        final updated = current.copyWith(
          retryCount: current.retryCount + 1,
          status: MessageQueueStatus.sending,
          timestamp: DateTime.now(),
        );
        datasource.messages[idx] = OfflineMessageModel(
          id: updated.id,
          type: updated.type,
          priority: updated.priority,
          status: updated.status,
          senderId: updated.senderId,
          senderName: updated.senderName,
          recipientId: updated.recipientId,
          payload: updated.payload,
          timestamp: updated.timestamp,
          retryCount: updated.retryCount,
          maxRetries: updated.maxRetries,
          isRelayed: updated.isRelayed,
          ttlSeconds: updated.ttlSeconds,
          district: updated.district,
        );
        return updated;
      }
      throw Exception('Message $messageId not found in local store');
    } catch (e) {
      throw Exception('Failed to retry message $messageId: $e');
    }
  }

  @override
  Future<int> clearExpiredMessages() async {
    try {
      final before = datasource.messages.length;
      datasource.messages.removeWhere((m) => m.isExpired);
      return before - datasource.messages.length;
    } catch (e) {
      throw Exception('Failed to clear expired messages: $e');
    }
  }

  @override
  Future<List<SyncRecord>> getSyncRecords() async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      return datasource.syncRecords;
    } catch (e) {
      throw Exception('Failed to retrieve sync audit records: $e');
    }
  }

  @override
  Future<SyncRecord> triggerFullSync({
    ConflictResolutionStrategy strategy =
        ConflictResolutionStrategy.latestTimestampWins,
  }) async {
    try {
      final pending = datasource.messages.where((m) => m.status != MessageQueueStatus.synchronized).toList();
      final record = await syncService.syncAllCategories(
        pendingMessages: pending,
        strategy: strategy,
      );

      // Mark synchronized messages
      for (int i = 0; i < datasource.messages.length; i++) {
        if (datasource.messages[i].status == MessageQueueStatus.delivered ||
            datasource.messages[i].status == MessageQueueStatus.queued) {
          datasource.messages[i] = datasource.messages[i].copyWith(
            status: MessageQueueStatus.synchronized,
          ) as OfflineMessageModel;
        }
      }

      datasource.syncRecords.insert(0, record as SyncRecordModel);
      return record;
    } catch (e) {
      throw Exception('Failed to execute full cloud sync: $e');
    }
  }

  @override
  Future<List<CachedMapData>> getCachedMapData({String? district}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 40));
      return cacheService.getCachedData(district: district);
    } catch (e) {
      throw Exception('Failed to read cached offline map telemetry: $e');
    }
  }

  @override
  Future<OfflineSettings> getSettings() async {
    return datasource.settings;
  }

  @override
  Future<OfflineSettings> updateSettings(OfflineSettings settings) async {
    datasource.updateSettings(settings);
    return datasource.settings;
  }

  @override
  Future<OfflineMessage> broadcastEmergencyBeacon({
    required String senderId,
    required String senderName,
    required String payload,
    required String district,
  }) async {
    final beacon = OfflineMessageModel(
      id: 'BEACON-${DateTime.now().millisecondsSinceEpoch}',
      type: OfflineMessageType.sosAlert,
      priority: MessagePriority.critical,
      status: MessageQueueStatus.sending,
      senderId: senderId,
      senderName: senderName,
      recipientId: 'BROADCAST_ALL',
      payload: payload,
      timestamp: DateTime.now(),
      retryCount: 0,
      maxRetries: 10,
      isRelayed: false,
      ttlSeconds: 86400 * 3, // 72 hrs TTL
      district: district,
    );
    datasource.messages.insert(0, beacon);
    return beacon;
  }
}
