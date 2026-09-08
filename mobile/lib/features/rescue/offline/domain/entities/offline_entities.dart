import 'package:flutter/material.dart';

/// Connection mode of the rescue device.
enum NetworkMode {
  onlineWiFi,
  onlineCellular,
  meshOnly,
  offlineAirgap,
}

extension NetworkModeX on NetworkMode {
  String get displayName {
    switch (this) {
      case NetworkMode.onlineWiFi:
        return 'Online (Wi-Fi)';
      case NetworkMode.onlineCellular:
        return 'Online (Mobile Data)';
      case NetworkMode.meshOnly:
        return 'Mesh BLE Network Active';
      case NetworkMode.offlineAirgap:
        return 'Air-Gapped Offline';
    }
  }

  IconData get icon {
    switch (this) {
      case NetworkMode.onlineWiFi:
        return Icons.wifi_rounded;
      case NetworkMode.onlineCellular:
        return Icons.cell_tower_rounded;
      case NetworkMode.meshOnly:
        return Icons.hub_rounded;
      case NetworkMode.offlineAirgap:
        return Icons.cloud_off_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NetworkMode.onlineWiFi:
      case NetworkMode.onlineCellular:
        return const Color(0xFF10B981); // Green
      case NetworkMode.meshOnly:
        return const Color(0xFF3B82F6); // Blue
      case NetworkMode.offlineAirgap:
        return const Color(0xFFEF4444); // Red
    }
  }

  bool get isOnline =>
      this == NetworkMode.onlineWiFi || this == NetworkMode.onlineCellular;
}

/// Bluetooth Low Energy state of the node.
enum BleConnectionState {
  disconnected,
  scanning,
  advertising,
  connecting,
  connected,
  reconnecting,
}

extension BleConnectionStateX on BleConnectionState {
  String get displayName {
    switch (this) {
      case BleConnectionState.disconnected:
        return 'BLE Inactive';
      case BleConnectionState.scanning:
        return 'Scanning Peers...';
      case BleConnectionState.advertising:
        return 'Broadcasting Beacon...';
      case BleConnectionState.connecting:
        return 'Establishing Link...';
      case BleConnectionState.connected:
        return 'Mesh Linked';
      case BleConnectionState.reconnecting:
        return 'Recovering Link...';
    }
  }

  Color get color {
    switch (this) {
      case BleConnectionState.disconnected:
        return const Color(0xFF6B7280);
      case BleConnectionState.scanning:
      case BleConnectionState.advertising:
        return const Color(0xFFF59E0B);
      case BleConnectionState.connecting:
      case BleConnectionState.reconnecting:
        return const Color(0xFF8B5CF6);
      case BleConnectionState.connected:
        return const Color(0xFF10B981);
    }
  }
}

/// Classification of peer devices in the disaster mesh.
enum DeviceType {
  rescueNode,
  civilianDevice,
  meshRepeater,
  baseGateway,
}

extension DeviceTypeX on DeviceType {
  String get displayName {
    switch (this) {
      case DeviceType.rescueNode:
        return 'Rescue Officer Node';
      case DeviceType.civilianDevice:
        return 'Civilian SOS Beacon';
      case DeviceType.meshRepeater:
        return 'Mesh Tactical Repeater';
      case DeviceType.baseGateway:
        return 'Command Base Gateway';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceType.rescueNode:
        return Icons.security_rounded;
      case DeviceType.civilianDevice:
        return Icons.person_pin_circle_rounded;
      case DeviceType.meshRepeater:
        return Icons.router_rounded;
      case DeviceType.baseGateway:
        return Icons.account_balance_rounded;
    }
  }

  Color get color {
    switch (this) {
      case DeviceType.rescueNode:
        return const Color(0xFF3B82F6);
      case DeviceType.civilianDevice:
        return const Color(0xFFEF4444);
      case DeviceType.meshRepeater:
        return const Color(0xFF10B981);
      case DeviceType.baseGateway:
        return const Color(0xFF8B5CF6);
    }
  }
}

/// Message state inside the Store-and-Forward transmission queue.
enum MessageQueueStatus {
  queued,
  sending,
  delivered,
  failed,
  synchronized,
}

extension MessageQueueStatusX on MessageQueueStatus {
  String get displayName {
    switch (this) {
      case MessageQueueStatus.queued:
        return 'Queued Local';
      case MessageQueueStatus.sending:
        return 'Transmitting...';
      case MessageQueueStatus.delivered:
        return 'Delivered Peer';
      case MessageQueueStatus.failed:
        return 'Retry Exhausted';
      case MessageQueueStatus.synchronized:
        return 'Synced Cloud';
    }
  }

  Color get color {
    switch (this) {
      case MessageQueueStatus.queued:
        return const Color(0xFFF59E0B);
      case MessageQueueStatus.sending:
        return const Color(0xFF3B82F6);
      case MessageQueueStatus.delivered:
        return const Color(0xFF10B981);
      case MessageQueueStatus.failed:
        return const Color(0xFFEF4444);
      case MessageQueueStatus.synchronized:
        return const Color(0xFF059669);
    }
  }

  IconData get icon {
    switch (this) {
      case MessageQueueStatus.queued:
        return Icons.schedule_rounded;
      case MessageQueueStatus.sending:
        return Icons.send_rounded;
      case MessageQueueStatus.delivered:
        return Icons.done_all_rounded;
      case MessageQueueStatus.failed:
        return Icons.error_outline_rounded;
      case MessageQueueStatus.synchronized:
        return Icons.cloud_done_rounded;
    }
  }
}

/// Priority tier of an offline message packet.
enum MessagePriority {
  critical,
  high,
  normal,
  low,
}

extension MessagePriorityX on MessagePriority {
  String get displayName {
    switch (this) {
      case MessagePriority.critical:
        return 'CRITICAL';
      case MessagePriority.high:
        return 'HIGH';
      case MessagePriority.normal:
        return 'NORMAL';
      case MessagePriority.low:
        return 'LOW';
    }
  }

  Color get color {
    switch (this) {
      case MessagePriority.critical:
        return const Color(0xFFEF4444);
      case MessagePriority.high:
        return const Color(0xFFF97316);
      case MessagePriority.normal:
        return const Color(0xFF3B82F6);
      case MessagePriority.low:
        return const Color(0xFF6B7280);
    }
  }
}

/// Offline payload packet type.
enum OfflineMessageType {
  sosAlert,
  missionUpdate,
  resourceUpdate,
  teamStatus,
  chatMessage,
  analyticsTelemetry,
}

extension OfflineMessageTypeX on OfflineMessageType {
  String get displayName {
    switch (this) {
      case OfflineMessageType.sosAlert:
        return 'SOS Distress Beacon';
      case OfflineMessageType.missionUpdate:
        return 'Mission Waypoint Update';
      case OfflineMessageType.resourceUpdate:
        return 'Resource Inventory Delta';
      case OfflineMessageType.teamStatus:
        return 'Officer Vitals & Status';
      case OfflineMessageType.chatMessage:
        return 'Tactical Field Chat';
      case OfflineMessageType.analyticsTelemetry:
        return 'Sensor & Flood Telemetry';
    }
  }

  IconData get icon {
    switch (this) {
      case OfflineMessageType.sosAlert:
        return Icons.sos_rounded;
      case OfflineMessageType.missionUpdate:
        return Icons.assignment_turned_in_rounded;
      case OfflineMessageType.resourceUpdate:
        return Icons.inventory_2_rounded;
      case OfflineMessageType.teamStatus:
        return Icons.groups_rounded;
      case OfflineMessageType.chatMessage:
        return Icons.chat_bubble_outline_rounded;
      case OfflineMessageType.analyticsTelemetry:
        return Icons.sensors_rounded;
    }
  }
}

/// Synchronization process status.
enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
}

/// Strategy for conflict resolution during synchronization.
enum ConflictResolutionStrategy {
  latestTimestampWins,
  manualOverride,
  serverAuthoritative,
}

/// Supported and pluggable wireless transmission protocols.
enum ProtocolType {
  bleMesh,
  loraRadio,
  satellite,
  wifiDirect,
  nfc,
}

extension ProtocolTypeX on ProtocolType {
  String get displayName {
    switch (this) {
      case ProtocolType.bleMesh:
        return 'BLE Mesh Network';
      case ProtocolType.loraRadio:
        return 'LoRa Long-Range Radio';
      case ProtocolType.satellite:
        return 'Satellite Iridium Relay';
      case ProtocolType.wifiDirect:
        return 'Wi-Fi Direct P2P';
      case ProtocolType.nfc:
        return 'NFC Tap Sync';
    }
  }

  IconData get icon {
    switch (this) {
      case ProtocolType.bleMesh:
        return Icons.bluetooth_searching_rounded;
      case ProtocolType.loraRadio:
        return Icons.settings_input_antenna_rounded;
      case ProtocolType.satellite:
        return Icons.satellite_alt_rounded;
      case ProtocolType.wifiDirect:
        return Icons.wifi_tethering_rounded;
      case ProtocolType.nfc:
        return Icons.nfc_rounded;
    }
  }
}

/// Domain entity representing a discovered peer device in the BLE / LoRa mesh.
class MeshDevice {
  final String id;
  final String name;
  final DeviceType type;
  final int rssiDbm; // e.g. -65 dBm
  final DateTime lastSeen;
  final bool isConnected;
  final int hopsCount;
  final int batteryPercent;
  final double latitude;
  final double longitude;
  final String district;

  const MeshDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.rssiDbm,
    required this.lastSeen,
    required this.isConnected,
    required this.hopsCount,
    required this.batteryPercent,
    required this.latitude,
    required this.longitude,
    required this.district,
  });

  int get signalStrengthPercent {
    // Convert RSSI (-100 dBm to -40 dBm) to 0-100%
    if (rssiDbm >= -40) return 100;
    if (rssiDbm <= -100) return 0;
    return (((rssiDbm + 100) / 60.0) * 100).toInt().clamp(0, 100);
  }

  String get signalBarLabel {
    final pct = signalStrengthPercent;
    if (pct > 75) return 'Excellent';
    if (pct > 50) return 'Good';
    if (pct > 25) return 'Fair';
    return 'Weak';
  }

  MeshDevice copyWith({
    String? id,
    String? name,
    DeviceType? type,
    int? rssiDbm,
    DateTime? lastSeen,
    bool? isConnected,
    int? hopsCount,
    int? batteryPercent,
    double? latitude,
    double? longitude,
    String? district,
  }) {
    return MeshDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rssiDbm: rssiDbm ?? this.rssiDbm,
      lastSeen: lastSeen ?? this.lastSeen,
      isConnected: isConnected ?? this.isConnected,
      hopsCount: hopsCount ?? this.hopsCount,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      district: district ?? this.district,
    );
  }
}

/// Store-and-Forward packet stored in the offline message queue.
class OfflineMessage {
  final String id;
  final OfflineMessageType type;
  final MessagePriority priority;
  final MessageQueueStatus status;
  final String senderId;
  final String senderName;
  final String recipientId; // 'BROADCAST_ALL' or peer ID
  final String payload;
  final DateTime timestamp;
  final int retryCount;
  final int maxRetries;
  final DateTime? acknowledgedAt;
  final bool isRelayed;
  final int ttlSeconds;
  final String district;

  const OfflineMessage({
    required this.id,
    required this.type,
    required this.priority,
    required this.status,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.payload,
    required this.timestamp,
    required this.retryCount,
    required this.maxRetries,
    this.acknowledgedAt,
    required this.isRelayed,
    required this.ttlSeconds,
    required this.district,
  });

  bool get isExpired =>
      DateTime.now().difference(timestamp).inSeconds > ttlSeconds;

  OfflineMessage copyWith({
    String? id,
    OfflineMessageType? type,
    MessagePriority? priority,
    MessageQueueStatus? status,
    String? senderId,
    String? senderName,
    String? recipientId,
    String? payload,
    DateTime? timestamp,
    int? retryCount,
    int? maxRetries,
    DateTime? acknowledgedAt,
    bool? isRelayed,
    int? ttlSeconds,
    String? district,
  }) {
    return OfflineMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      recipientId: recipientId ?? this.recipientId,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      isRelayed: isRelayed ?? this.isRelayed,
      ttlSeconds: ttlSeconds ?? this.ttlSeconds,
      district: district ?? this.district,
    );
  }
}

/// Audit log record of a completed or attempted synchronization batch.
class SyncRecord {
  final String id;
  final OfflineMessageType syncType;
  final int itemCount;
  final DateTime startedAt;
  final DateTime? completedAt;
  final SyncStatus status;
  final String? failureReason;
  final ConflictResolutionStrategy resolutionApplied;
  final int deduplicatedCount;

  const SyncRecord({
    required this.id,
    required this.syncType,
    required this.itemCount,
    required this.startedAt,
    this.completedAt,
    required this.status,
    this.failureReason,
    required this.resolutionApplied,
    required this.deduplicatedCount,
  });
}

/// Overall real-time offline communication telemetry.
class OfflineSystemStatus {
  final NetworkMode networkMode;
  final BleConnectionState bleState;
  final bool isGpsFixed;
  final double gpsAccuracyMeters;
  final int activeMeshNodesCount;
  final int connectedPeersCount;
  final int queuedMessagesCount;
  final int deliveredMessagesCount;
  final int pendingSyncCount;
  final int batteryPercent;
  final int signalDbm;
  final bool isLowPowerMode;

  const OfflineSystemStatus({
    required this.networkMode,
    required this.bleState,
    required this.isGpsFixed,
    required this.gpsAccuracyMeters,
    required this.activeMeshNodesCount,
    required this.connectedPeersCount,
    required this.queuedMessagesCount,
    required this.deliveredMessagesCount,
    required this.pendingSyncCount,
    required this.batteryPercent,
    required this.signalDbm,
    required this.isLowPowerMode,
  });

  static const OfflineSystemStatus empty = OfflineSystemStatus(
    networkMode: NetworkMode.meshOnly,
    bleState: BleConnectionState.connected,
    isGpsFixed: true,
    gpsAccuracyMeters: 4.2,
    activeMeshNodesCount: 15,
    connectedPeersCount: 4,
    queuedMessagesCount: 12,
    deliveredMessagesCount: 88,
    pendingSyncCount: 24,
    batteryPercent: 82,
    signalDbm: -68,
    isLowPowerMode: false,
  );
}

/// Configuration settings for offline storage, relays, and sync.
class OfflineSettings {
  final bool enableBle;
  final bool enableScanning;
  final bool enableAdvertising;
  final bool autoSyncOnInternet;
  final bool meshRelayEnabled;
  final int messageExpiryHours;
  final int storageLimitMb;
  final int retryIntervalSeconds;
  final bool lowPowerOptimization;
  final Set<ProtocolType> activeProtocols;

  const OfflineSettings({
    this.enableBle = true,
    this.enableScanning = true,
    this.enableAdvertising = true,
    this.autoSyncOnInternet = true,
    this.meshRelayEnabled = true,
    this.messageExpiryHours = 24,
    this.storageLimitMb = 100,
    this.retryIntervalSeconds = 30,
    this.lowPowerOptimization = true,
    this.activeProtocols = const {
      ProtocolType.bleMesh,
    },
  });

  OfflineSettings copyWith({
    bool? enableBle,
    bool? enableScanning,
    bool? enableAdvertising,
    bool? autoSyncOnInternet,
    bool? meshRelayEnabled,
    int? messageExpiryHours,
    int? storageLimitMb,
    int? retryIntervalSeconds,
    bool? lowPowerOptimization,
    Set<ProtocolType>? activeProtocols,
  }) {
    return OfflineSettings(
      enableBle: enableBle ?? this.enableBle,
      enableScanning: enableScanning ?? this.enableScanning,
      enableAdvertising: enableAdvertising ?? this.enableAdvertising,
      autoSyncOnInternet: autoSyncOnInternet ?? this.autoSyncOnInternet,
      meshRelayEnabled: meshRelayEnabled ?? this.meshRelayEnabled,
      messageExpiryHours: messageExpiryHours ?? this.messageExpiryHours,
      storageLimitMb: storageLimitMb ?? this.storageLimitMb,
      retryIntervalSeconds:
          retryIntervalSeconds ?? this.retryIntervalSeconds,
      lowPowerOptimization: lowPowerOptimization ?? this.lowPowerOptimization,
      activeProtocols: activeProtocols ?? this.activeProtocols,
    );
  }
}

/// Cached Map Intelligence for complete zero-network offline map viewing.
class CachedMapData {
  final String district;
  final int cachedRiskZonesCount;
  final int cachedSheltersCount;
  final int cachedHospitalsCount;
  final int cachedTeamsCount;
  final DateTime lastCachedAt;
  final int cacheSizeKb;

  const CachedMapData({
    required this.district,
    required this.cachedRiskZonesCount,
    required this.cachedSheltersCount,
    required this.cachedHospitalsCount,
    required this.cachedTeamsCount,
    required this.lastCachedAt,
    required this.cacheSizeKb,
  });
}
