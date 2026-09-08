import 'package:flutter/foundation.dart';
import '../../data/datasources/offline_mock_datasource.dart';
import '../../data/repositories/offline_repository_impl.dart';
import '../../domain/entities/offline_entities.dart';
import '../../domain/repositories/offline_repository.dart';
import '../../domain/usecases/offline_usecases.dart';
import '../../services/ble_communication_service.dart';
import '../../services/connectivity_monitor_service.dart';
import '../../services/future_protocols_service.dart';
import '../../services/offline_cache_service.dart';
import '../../services/offline_notification_service.dart';
import '../../services/offline_sync_service.dart';
import '../../services/store_and_forward_service.dart';
import 'offline_state.dart';

/// Central state notifier orchestrating mesh devices, message queue, BLE links,
/// synchronization routines, and offline configuration.
class OfflineNotifier extends ChangeNotifier {
  final GetOfflineSystemStatusUseCase _getStatusUseCase;
  final GetMeshDevicesUseCase _getMeshDevicesUseCase;
  final ManageBleConnectionUseCase _manageBleConnectionUseCase;
  final GetQueuedMessagesUseCase _getQueuedMessagesUseCase;
  final EnqueueOfflineMessageUseCase _enqueueMessageUseCase;
  final RetryOfflineMessageUseCase _retryMessageUseCase;
  final PerformOfflineSyncUseCase _performSyncUseCase;
  final GetOfflineCachedMapUseCase _getCachedMapUseCase;
  final ManageOfflineSettingsUseCase _manageSettingsUseCase;
  final BleCommunicationService _bleService;
  final ConnectivityMonitorService _connectivityService;

  OfflineState _state = OfflineState.initial();

  OfflineNotifier({
    required GetOfflineSystemStatusUseCase getStatusUseCase,
    required GetMeshDevicesUseCase getMeshDevicesUseCase,
    required ManageBleConnectionUseCase manageBleConnectionUseCase,
    required GetQueuedMessagesUseCase getQueuedMessagesUseCase,
    required EnqueueOfflineMessageUseCase enqueueMessageUseCase,
    required RetryOfflineMessageUseCase retryMessageUseCase,
    required PerformOfflineSyncUseCase performSyncUseCase,
    required GetOfflineCachedMapUseCase getCachedMapUseCase,
    required ManageOfflineSettingsUseCase manageSettingsUseCase,
    required BleCommunicationService bleService,
    required ConnectivityMonitorService connectivityService,
  })  : _getStatusUseCase = getStatusUseCase,
        _getMeshDevicesUseCase = getMeshDevicesUseCase,
        _manageBleConnectionUseCase = manageBleConnectionUseCase,
        _getQueuedMessagesUseCase = getQueuedMessagesUseCase,
        _enqueueMessageUseCase = enqueueMessageUseCase,
        _retryMessageUseCase = retryMessageUseCase,
        _performSyncUseCase = performSyncUseCase,
        _getCachedMapUseCase = getCachedMapUseCase,
        _manageSettingsUseCase = manageSettingsUseCase,
        _bleService = bleService,
        _connectivityService = connectivityService;

  OfflineState get state => _state;

  /// Loads full offline system telemetry, discovered mesh devices, queue, and sync records.
  Future<void> loadDashboard() async {
    _state = _state.copyWith(status: OfflineViewStatus.loading);
    notifyListeners();

    try {
      final status = await _getStatusUseCase();
      final devices = await _getMeshDevicesUseCase();
      final connected = await _getMeshDevicesUseCase.getConnected();
      final messages = await _getQueuedMessagesUseCase();
      final syncRecords = await _performSyncUseCase.getRecords();
      final cachedMap = await _getCachedMapUseCase();
      final settings = await _manageSettingsUseCase.getSettings();

      final filteredDevs = _applyMeshFilters(devices, _state.meshFilters);
      final filteredMsgs = _applyQueueFilters(messages, _state.queueFilters);

      _state = _state.copyWith(
        status: OfflineViewStatus.loaded,
        systemStatus: status,
        settings: settings,
        allDevices: devices,
        connectedDevices: connected,
        allMessages: messages,
        allSyncRecords: syncRecords,
        cachedMapList: cachedMap,
        filteredDevices: filteredDevs,
        filteredMessages: filteredMsgs,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: OfflineViewStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  // ===========================================================================
  // BLE SCANNING & PEER CONNECTIONS
  // ===========================================================================

  Future<void> startBleScan() async {
    _state = _state.copyWith(isScanning: true);
    notifyListeners();

    try {
      await _bleService.startScanning();
      final devices = await _getMeshDevicesUseCase();
      final connected = await _getMeshDevicesUseCase.getConnected();
      final filtered = _applyMeshFilters(devices, _state.meshFilters);

      _state = _state.copyWith(
        isScanning: false,
        allDevices: devices,
        connectedDevices: connected,
        filteredDevices: filtered,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isScanning: false);
      notifyListeners();
    }
  }

  Future<bool> connectDevice(String deviceId) async {
    try {
      final success = await _manageBleConnectionUseCase.connect(deviceId);
      if (success) {
        final devices = await _getMeshDevicesUseCase();
        final connected = await _getMeshDevicesUseCase.getConnected();
        _state = _state.copyWith(
          allDevices: devices,
          connectedDevices: connected,
          filteredDevices: _applyMeshFilters(devices, _state.meshFilters),
        );
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> disconnectDevice(String deviceId) async {
    try {
      final success = await _manageBleConnectionUseCase.disconnect(deviceId);
      if (success) {
        final devices = await _getMeshDevicesUseCase();
        final connected = await _getMeshDevicesUseCase.getConnected();
        _state = _state.copyWith(
          allDevices: devices,
          connectedDevices: connected,
          filteredDevices: _applyMeshFilters(devices, _state.meshFilters),
        );
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // STORE-AND-FORWARD MESSAGE QUEUE
  // ===========================================================================

  Future<OfflineMessage> enqueueMessage(OfflineMessage message) async {
    final enqueued = await _enqueueMessageUseCase(message);
    final messages = await _getQueuedMessagesUseCase();
    _state = _state.copyWith(
      allMessages: messages,
      filteredMessages: _applyQueueFilters(messages, _state.queueFilters),
    );
    notifyListeners();
    return enqueued;
  }

  Future<void> retryMessage(String messageId) async {
    try {
      await _retryMessageUseCase.retry(messageId);
      final messages = await _getQueuedMessagesUseCase();
      _state = _state.copyWith(
        allMessages: messages,
        filteredMessages: _applyQueueFilters(messages, _state.queueFilters),
      );
      notifyListeners();
    } catch (_) {}
  }

  Future<int> clearExpired() async {
    final count = await _retryMessageUseCase.clearExpired();
    final messages = await _getQueuedMessagesUseCase();
    _state = _state.copyWith(
      allMessages: messages,
      filteredMessages: _applyQueueFilters(messages, _state.queueFilters),
    );
    notifyListeners();
    return count;
  }

  Future<void> broadcastDistressBeacon(String payload) async {
    _state = _state.copyWith(isBroadcasting: true);
    notifyListeners();

    try {
      await _enqueueMessageUseCase.broadcastBeacon(
        senderId: 'DEV-COMMANDER-01',
        senderName: 'Officer In Charge',
        payload: payload,
        district: _state.meshFilters.district == 'All' ? 'Chennai' : _state.meshFilters.district,
      );
      final messages = await _getQueuedMessagesUseCase();
      _state = _state.copyWith(
        isBroadcasting: false,
        allMessages: messages,
        filteredMessages: _applyQueueFilters(messages, _state.queueFilters),
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isBroadcasting: false);
      notifyListeners();
    }
  }

  // ===========================================================================
  // SYNCHRONIZATION
  // ===========================================================================

  Future<SyncRecord?> triggerFullSync({
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.latestTimestampWins,
  }) async {
    _state = _state.copyWith(isSyncing: true);
    notifyListeners();

    try {
      final record = await _performSyncUseCase(strategy: strategy);
      final syncRecords = await _performSyncUseCase.getRecords();
      final messages = await _getQueuedMessagesUseCase();
      final status = await _getStatusUseCase();

      _state = _state.copyWith(
        isSyncing: false,
        allSyncRecords: syncRecords,
        allMessages: messages,
        filteredMessages: _applyQueueFilters(messages, _state.queueFilters),
        systemStatus: status,
      );
      notifyListeners();
      return record;
    } catch (e) {
      _state = _state.copyWith(isSyncing: false);
      notifyListeners();
      return null;
    }
  }

  // ===========================================================================
  // SETTINGS & NETWORK MODE
  // ===========================================================================

  Future<void> updateSettings(OfflineSettings settings) async {
    final updated = await _manageSettingsUseCase.updateSettings(settings);
    _state = _state.copyWith(settings: updated);
    notifyListeners();
  }

  void switchNetworkMode(NetworkMode mode) {
    _connectivityService.setNetworkMode(mode);
    _state = _state.copyWith(
      systemStatus: OfflineSystemStatus(
        networkMode: mode,
        bleState: _state.systemStatus.bleState,
        isGpsFixed: _state.systemStatus.isGpsFixed,
        gpsAccuracyMeters: _state.systemStatus.gpsAccuracyMeters,
        activeMeshNodesCount: _state.systemStatus.activeMeshNodesCount,
        connectedPeersCount: _state.systemStatus.connectedPeersCount,
        queuedMessagesCount: _state.systemStatus.queuedMessagesCount,
        deliveredMessagesCount: _state.systemStatus.deliveredMessagesCount,
        pendingSyncCount: _state.systemStatus.pendingSyncCount,
        batteryPercent: _state.systemStatus.batteryPercent,
        signalDbm: _state.systemStatus.signalDbm,
        isLowPowerMode: _state.systemStatus.isLowPowerMode,
      ),
    );
    notifyListeners();
  }

  // ===========================================================================
  // FILTER HANDLERS
  // ===========================================================================

  void updateMeshFilters(MeshFilterOptions options) {
    _state = _state.copyWith(
      meshFilters: options,
      filteredDevices: _applyMeshFilters(_state.allDevices, options),
    );
    notifyListeners();
  }

  void searchMesh(String query) {
    final opts = _state.meshFilters.copyWith(searchQuery: query);
    updateMeshFilters(opts);
  }

  void setMeshType(DeviceType? type) {
    final opts = _state.meshFilters.copyWith(type: type, clearType: type == null);
    updateMeshFilters(opts);
  }

  void setMeshDistrict(String district) {
    final opts = _state.meshFilters.copyWith(district: district);
    updateMeshFilters(opts);
  }

  void updateQueueFilters(QueueFilterOptions options) {
    _state = _state.copyWith(
      queueFilters: options,
      filteredMessages: _applyQueueFilters(_state.allMessages, options),
    );
    notifyListeners();
  }

  void searchQueue(String query) {
    final opts = _state.queueFilters.copyWith(searchQuery: query);
    updateQueueFilters(opts);
  }

  void setQueueStatus(MessageQueueStatus? status) {
    final opts = _state.queueFilters.copyWith(status: status, clearStatus: status == null);
    updateQueueFilters(opts);
  }

  void setQueuePriority(MessagePriority? priority) {
    final opts = _state.queueFilters.copyWith(priority: priority, clearPriority: priority == null);
    updateQueueFilters(opts);
  }

  void setQueueType(OfflineMessageType? type) {
    final opts = _state.queueFilters.copyWith(type: type, clearType: type == null);
    updateQueueFilters(opts);
  }

  // ===========================================================================
  // PRIVATE FILTER UTILITIES
  // ===========================================================================

  List<MeshDevice> _applyMeshFilters(List<MeshDevice> devices, MeshFilterOptions opts) {
    return devices.where((d) {
      if (opts.type != null && d.type != opts.type) return false;
      if (opts.district != 'All' && d.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.isConnectedOnly == true && !d.isConnected) return false;
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = d.name.toLowerCase().contains(q) ||
            d.id.toLowerCase().contains(q) ||
            d.district.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<OfflineMessage> _applyQueueFilters(List<OfflineMessage> messages, QueueFilterOptions opts) {
    return messages.where((m) {
      if (opts.status != null && m.status != opts.status) return false;
      if (opts.priority != null && m.priority != opts.priority) return false;
      if (opts.type != null && m.type != opts.type) return false;
      if (opts.district != 'All' && m.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = m.payload.toLowerCase().contains(q) ||
            m.senderName.toLowerCase().contains(q) ||
            m.district.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }
}

/// Global dependency injection container for the Offline Communication module.
class OfflineDependencies {
  static final OfflineMockDatasource datasource = OfflineMockDatasource();
  static final BleCommunicationService bleService = BleCommunicationService();
  static final ConnectivityMonitorService connectivityService = ConnectivityMonitorService();
  static final StoreAndForwardService queueService = StoreAndForwardService(initialMessages: datasource.messages);
  static final OfflineSyncService syncService = OfflineSyncService(initialHistory: datasource.syncRecords);
  static final OfflineCacheService cacheService = OfflineCacheService();
  static final OfflineNotificationService notificationService = OfflineNotificationService();

  static final OfflineRepository repository = OfflineRepositoryImpl(
    datasource: datasource,
    bleService: bleService,
    queueService: queueService,
    syncService: syncService,
    cacheService: cacheService,
  );

  static final GetOfflineSystemStatusUseCase getStatusUseCase = GetOfflineSystemStatusUseCase(repository);
  static final GetMeshDevicesUseCase getMeshDevicesUseCase = GetMeshDevicesUseCase(repository);
  static final ManageBleConnectionUseCase manageBleConnectionUseCase = ManageBleConnectionUseCase(repository);
  static final GetQueuedMessagesUseCase getQueuedMessagesUseCase = GetQueuedMessagesUseCase(repository);
  static final EnqueueOfflineMessageUseCase enqueueMessageUseCase = EnqueueOfflineMessageUseCase(repository);
  static final RetryOfflineMessageUseCase retryMessageUseCase = RetryOfflineMessageUseCase(repository);
  static final PerformOfflineSyncUseCase performSyncUseCase = PerformOfflineSyncUseCase(repository);
  static final GetOfflineCachedMapUseCase getCachedMapUseCase = GetOfflineCachedMapUseCase(repository);
  static final ManageOfflineSettingsUseCase manageSettingsUseCase = ManageOfflineSettingsUseCase(repository);

  static final OfflineNotifier notifier = OfflineNotifier(
    getStatusUseCase: getStatusUseCase,
    getMeshDevicesUseCase: getMeshDevicesUseCase,
    manageBleConnectionUseCase: manageBleConnectionUseCase,
    getQueuedMessagesUseCase: getQueuedMessagesUseCase,
    enqueueMessageUseCase: enqueueMessageUseCase,
    retryMessageUseCase: retryMessageUseCase,
    performSyncUseCase: performSyncUseCase,
    getCachedMapUseCase: getCachedMapUseCase,
    manageSettingsUseCase: manageSettingsUseCase,
    bleService: bleService,
    connectivityService: connectivityService,
  );
}
