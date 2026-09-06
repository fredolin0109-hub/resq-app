import '../../domain/entities/offline_entities.dart';

enum OfflineViewStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// Filter options for Mesh Devices list.
class MeshFilterOptions {
  final DeviceType? type;
  final String district;
  final bool? isConnectedOnly;
  final String searchQuery;

  const MeshFilterOptions({
    this.type,
    this.district = 'All',
    this.isConnectedOnly,
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      type != null || district != 'All' || (isConnectedOnly ?? false) || searchQuery.isNotEmpty;

  MeshFilterOptions copyWith({
    DeviceType? type,
    String? district,
    bool? isConnectedOnly,
    String? searchQuery,
    bool clearType = false,
  }) {
    return MeshFilterOptions(
      type: clearType ? null : (type ?? this.type),
      district: district ?? this.district,
      isConnectedOnly: isConnectedOnly ?? this.isConnectedOnly,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Filter options for Store-and-Forward Message Queue.
class QueueFilterOptions {
  final MessageQueueStatus? status;
  final MessagePriority? priority;
  final OfflineMessageType? type;
  final String district;
  final String searchQuery;

  const QueueFilterOptions({
    this.status,
    this.priority,
    this.type,
    this.district = 'All',
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      status != null || priority != null || type != null || district != 'All' || searchQuery.isNotEmpty;

  QueueFilterOptions copyWith({
    MessageQueueStatus? status,
    MessagePriority? priority,
    OfflineMessageType? type,
    String? district,
    String? searchQuery,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearType = false,
  }) {
    return QueueFilterOptions(
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      type: clearType ? null : (type ?? this.type),
      district: district ?? this.district,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Central state model for the Offline Communication Module.
class OfflineState {
  final OfflineViewStatus status;
  final String? errorMessage;
  final OfflineSystemStatus systemStatus;
  final OfflineSettings settings;

  // Master collections
  final List<MeshDevice> allDevices;
  final List<MeshDevice> connectedDevices;
  final List<OfflineMessage> allMessages;
  final List<SyncRecord> allSyncRecords;
  final List<CachedMapData> cachedMapList;

  // Filtered views
  final List<MeshDevice> filteredDevices;
  final List<OfflineMessage> filteredMessages;

  // Active filters
  final MeshFilterOptions meshFilters;
  final QueueFilterOptions queueFilters;

  // Selections & Action states
  final MeshDevice? selectedDevice;
  final OfflineMessage? selectedMessage;
  final bool isScanning;
  final bool isSyncing;
  final bool isBroadcasting;

  const OfflineState({
    required this.status,
    this.errorMessage,
    required this.systemStatus,
    required this.settings,
    required this.allDevices,
    required this.connectedDevices,
    required this.allMessages,
    required this.allSyncRecords,
    required this.cachedMapList,
    required this.filteredDevices,
    required this.filteredMessages,
    required this.meshFilters,
    required this.queueFilters,
    this.selectedDevice,
    this.selectedMessage,
    this.isScanning = false,
    this.isSyncing = false,
    this.isBroadcasting = false,
  });

  factory OfflineState.initial() => const OfflineState(
        status: OfflineViewStatus.initial,
        errorMessage: null,
        systemStatus: OfflineSystemStatus.empty,
        settings: OfflineSettings(),
        allDevices: [],
        connectedDevices: [],
        allMessages: [],
        allSyncRecords: [],
        cachedMapList: [],
        filteredDevices: [],
        filteredMessages: [],
        meshFilters: MeshFilterOptions(),
        queueFilters: QueueFilterOptions(),
        selectedDevice: null,
        selectedMessage: null,
        isScanning: false,
        isSyncing: false,
        isBroadcasting: false,
      );

  bool get isLoading => status == OfflineViewStatus.loading;
  bool get isLoaded => status == OfflineViewStatus.loaded;
  bool get isError => status == OfflineViewStatus.error;

  OfflineState copyWith({
    OfflineViewStatus? status,
    String? errorMessage,
    OfflineSystemStatus? systemStatus,
    OfflineSettings? settings,
    List<MeshDevice>? allDevices,
    List<MeshDevice>? connectedDevices,
    List<OfflineMessage>? allMessages,
    List<SyncRecord>? allSyncRecords,
    List<CachedMapData>? cachedMapList,
    List<MeshDevice>? filteredDevices,
    List<OfflineMessage>? filteredMessages,
    MeshFilterOptions? meshFilters,
    QueueFilterOptions? queueFilters,
    MeshDevice? selectedDevice,
    OfflineMessage? selectedMessage,
    bool? isScanning,
    bool? isSyncing,
    bool? isBroadcasting,
    bool clearSelectedDevice = false,
    bool clearSelectedMessage = false,
  }) {
    return OfflineState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      systemStatus: systemStatus ?? this.systemStatus,
      settings: settings ?? this.settings,
      allDevices: allDevices ?? this.allDevices,
      connectedDevices: connectedDevices ?? this.connectedDevices,
      allMessages: allMessages ?? this.allMessages,
      allSyncRecords: allSyncRecords ?? this.allSyncRecords,
      cachedMapList: cachedMapList ?? this.cachedMapList,
      filteredDevices: filteredDevices ?? this.filteredDevices,
      filteredMessages: filteredMessages ?? this.filteredMessages,
      meshFilters: meshFilters ?? this.meshFilters,
      queueFilters: queueFilters ?? this.queueFilters,
      selectedDevice: clearSelectedDevice ? null : (selectedDevice ?? this.selectedDevice),
      selectedMessage: clearSelectedMessage ? null : (selectedMessage ?? this.selectedMessage),
      isScanning: isScanning ?? this.isScanning,
      isSyncing: isSyncing ?? this.isSyncing,
      isBroadcasting: isBroadcasting ?? this.isBroadcasting,
    );
  }
}
