import 'dart:async';
import '../domain/entities/offline_entities.dart';
import '../data/models/offline_models.dart';

/// Synchronization orchestrator uploading local delta queues upon Internet reconnection.
class OfflineSyncService {
  final List<SyncRecord> _syncHistory = [];
  final _syncHistoryController = StreamController<List<SyncRecord>>.broadcast();

  OfflineSyncService({List<SyncRecord>? initialHistory}) {
    if (initialHistory != null) {
      _syncHistory.addAll(initialHistory);
    }
  }

  List<SyncRecord> get syncHistory => List.unmodifiable(_syncHistory);
  Stream<List<SyncRecord>> get onSyncHistoryUpdated => _syncHistoryController.stream;

  /// Perform full synchronization batch across all offline categories.
  Future<SyncRecord> syncAllCategories({
    required List<OfflineMessage> pendingMessages,
    ConflictResolutionStrategy strategy =
        ConflictResolutionStrategy.latestTimestampWins,
  }) async {
    final startTime = DateTime.now();

    // Simulate batch network upload with artificial delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Deduplicate pending messages
    final uniqueIds = <String>{};
    int deduplicated = 0;
    for (final m in pendingMessages) {
      if (!uniqueIds.add(m.id)) {
        deduplicated++;
      }
    }

    final record = SyncRecordModel(
      id: 'SYNC-${DateTime.now().millisecondsSinceEpoch}',
      syncType: OfflineMessageType.missionUpdate,
      itemCount: pendingMessages.length,
      startedAt: startTime,
      completedAt: DateTime.now(),
      status: SyncStatus.completed,
      resolutionApplied: strategy,
      deduplicatedCount: deduplicated,
    );

    _syncHistory.insert(0, record);
    _syncHistoryController.add(_syncHistory);
    return record;
  }

  void dispose() {
    _syncHistoryController.close();
  }
}
