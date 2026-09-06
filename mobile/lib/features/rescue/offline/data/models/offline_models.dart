import '../../domain/entities/offline_entities.dart';

/// DTO Model for MeshDevice with JSON serialization.
class MeshDeviceModel extends MeshDevice {
  const MeshDeviceModel({
    required super.id,
    required super.name,
    required super.type,
    required super.rssiDbm,
    required super.lastSeen,
    required super.isConnected,
    required super.hopsCount,
    required super.batteryPercent,
    required super.latitude,
    required super.longitude,
    required super.district,
  });

  factory MeshDeviceModel.fromJson(Map<String, dynamic> json) {
    final typeIdx = (json['type'] as num?)?.toInt() ?? 0;
    return MeshDeviceModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: typeIdx >= 0 && typeIdx < DeviceType.values.length
          ? DeviceType.values[typeIdx]
          : DeviceType.rescueNode,
      rssiDbm: (json['rssiDbm'] as num?)?.toInt() ?? -70,
      lastSeen: json['lastSeen'] != null
          ? DateTime.tryParse(json['lastSeen'] as String) ?? DateTime.now()
          : DateTime.now(),
      isConnected: json['isConnected'] as bool? ?? false,
      hopsCount: (json['hopsCount'] as num?)?.toInt() ?? 1,
      batteryPercent: (json['batteryPercent'] as num?)?.toInt() ?? 80,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      district: json['district'] as String? ?? 'Chennai',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.index,
        'rssiDbm': rssiDbm,
        'lastSeen': lastSeen.toIso8601String(),
        'isConnected': isConnected,
        'hopsCount': hopsCount,
        'batteryPercent': batteryPercent,
        'latitude': latitude,
        'longitude': longitude,
        'district': district,
      };

  MeshDevice toEntity() => this;
}

/// DTO Model for OfflineMessage with JSON serialization.
class OfflineMessageModel extends OfflineMessage {
  const OfflineMessageModel({
    required super.id,
    required super.type,
    required super.priority,
    required super.status,
    required super.senderId,
    required super.senderName,
    required super.recipientId,
    required super.payload,
    required super.timestamp,
    required super.retryCount,
    required super.maxRetries,
    super.acknowledgedAt,
    required super.isRelayed,
    required super.ttlSeconds,
    required super.district,
  });

  factory OfflineMessageModel.fromJson(Map<String, dynamic> json) {
    final typeIdx = (json['type'] as num?)?.toInt() ?? 0;
    final prioIdx = (json['priority'] as num?)?.toInt() ?? 2;
    final statIdx = (json['status'] as num?)?.toInt() ?? 0;

    return OfflineMessageModel(
      id: json['id'] as String? ?? '',
      type: typeIdx >= 0 && typeIdx < OfflineMessageType.values.length
          ? OfflineMessageType.values[typeIdx]
          : OfflineMessageType.sosAlert,
      priority: prioIdx >= 0 && prioIdx < MessagePriority.values.length
          ? MessagePriority.values[prioIdx]
          : MessagePriority.normal,
      status: statIdx >= 0 && statIdx < MessageQueueStatus.values.length
          ? MessageQueueStatus.values[statIdx]
          : MessageQueueStatus.queued,
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      recipientId: json['recipientId'] as String? ?? 'BROADCAST_ALL',
      payload: json['payload'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 5,
      acknowledgedAt: json['acknowledgedAt'] != null
          ? DateTime.tryParse(json['acknowledgedAt'] as String)
          : null,
      isRelayed: json['isRelayed'] as bool? ?? false,
      ttlSeconds: (json['ttlSeconds'] as num?)?.toInt() ?? 86400,
      district: json['district'] as String? ?? 'Chennai',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'priority': priority.index,
        'status': status.index,
        'senderId': senderId,
        'senderName': senderName,
        'recipientId': recipientId,
        'payload': payload,
        'timestamp': timestamp.toIso8601String(),
        'retryCount': retryCount,
        'maxRetries': maxRetries,
        'acknowledgedAt': acknowledgedAt?.toIso8601String(),
        'isRelayed': isRelayed,
        'ttlSeconds': ttlSeconds,
        'district': district,
      };

  OfflineMessage toEntity() => this;
}

/// DTO Model for SyncRecord with JSON serialization.
class SyncRecordModel extends SyncRecord {
  const SyncRecordModel({
    required super.id,
    required super.syncType,
    required super.itemCount,
    required super.startedAt,
    super.completedAt,
    required super.status,
    super.failureReason,
    required super.resolutionApplied,
    required super.deduplicatedCount,
  });

  factory SyncRecordModel.fromJson(Map<String, dynamic> json) {
    final typeIdx = (json['syncType'] as num?)?.toInt() ?? 0;
    final statIdx = (json['status'] as num?)?.toInt() ?? 0;
    final resIdx = (json['resolutionApplied'] as num?)?.toInt() ?? 0;

    return SyncRecordModel(
      id: json['id'] as String? ?? '',
      syncType: typeIdx >= 0 && typeIdx < OfflineMessageType.values.length
          ? OfflineMessageType.values[typeIdx]
          : OfflineMessageType.missionUpdate,
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
      status: statIdx >= 0 && statIdx < SyncStatus.values.length
          ? SyncStatus.values[statIdx]
          : SyncStatus.completed,
      failureReason: json['failureReason'] as String?,
      resolutionApplied: resIdx >= 0 &&
              resIdx < ConflictResolutionStrategy.values.length
          ? ConflictResolutionStrategy.values[resIdx]
          : ConflictResolutionStrategy.latestTimestampWins,
      deduplicatedCount: (json['deduplicatedCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'syncType': syncType.index,
        'itemCount': itemCount,
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'status': status.index,
        'failureReason': failureReason,
        'resolutionApplied': resolutionApplied.index,
        'deduplicatedCount': deduplicatedCount,
      };

  SyncRecord toEntity() => this;
}

/// DTO Model for CachedMapData.
class CachedMapDataModel extends CachedMapData {
  const CachedMapDataModel({
    required super.district,
    required super.cachedRiskZonesCount,
    required super.cachedSheltersCount,
    required super.cachedHospitalsCount,
    required super.cachedTeamsCount,
    required super.lastCachedAt,
    required super.cacheSizeKb,
  });

  factory CachedMapDataModel.fromJson(Map<String, dynamic> json) {
    return CachedMapDataModel(
      district: json['district'] as String? ?? '',
      cachedRiskZonesCount: (json['cachedRiskZonesCount'] as num?)?.toInt() ?? 0,
      cachedSheltersCount: (json['cachedSheltersCount'] as num?)?.toInt() ?? 0,
      cachedHospitalsCount: (json['cachedHospitalsCount'] as num?)?.toInt() ?? 0,
      cachedTeamsCount: (json['cachedTeamsCount'] as num?)?.toInt() ?? 0,
      lastCachedAt: json['lastCachedAt'] != null
          ? DateTime.tryParse(json['lastCachedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      cacheSizeKb: (json['cacheSizeKb'] as num?)?.toInt() ?? 512,
    );
  }

  Map<String, dynamic> toJson() => {
        'district': district,
        'cachedRiskZonesCount': cachedRiskZonesCount,
        'cachedSheltersCount': cachedSheltersCount,
        'cachedHospitalsCount': cachedHospitalsCount,
        'cachedTeamsCount': cachedTeamsCount,
        'lastCachedAt': lastCachedAt.toIso8601String(),
        'cacheSizeKb': cacheSizeKb,
      };

  CachedMapData toEntity() => this;
}
