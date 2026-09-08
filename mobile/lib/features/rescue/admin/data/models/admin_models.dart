import '../../domain/entities/admin_entities.dart';

/// DTO Model for AdminUser.
class AdminUserModel extends AdminUser {
  const AdminUserModel({
    required super.id,
    required super.name,
    required super.role,
    required super.department,
    required super.district,
    required super.phone,
    required super.email,
    required super.status,
    required super.lastLogin,
    required super.permissions,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    final roleIdx = (json['role'] as num?)?.toInt() ?? 0;
    final statIdx = (json['status'] as num?)?.toInt() ?? 0;

    return AdminUserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: roleIdx >= 0 && roleIdx < UserRole.values.length
          ? UserRole.values[roleIdx]
          : UserRole.volunteer,
      department: json['department'] as String? ?? 'Disaster Management',
      district: json['district'] as String? ?? 'Chennai',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: statIdx >= 0 && statIdx < UserStatus.values.length
          ? UserStatus.values[statIdx]
          : UserStatus.active,
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'] as String) ?? DateTime.now()
          : DateTime.now(),
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role.index,
        'department': department,
        'district': district,
        'phone': phone,
        'email': email,
        'status': status.index,
        'lastLogin': lastLogin.toIso8601String(),
        'permissions': permissions,
      };

  AdminUser toEntity() => this;
}

/// DTO Model for AdminRescueTeam.
class AdminRescueTeamModel extends AdminRescueTeam {
  const AdminRescueTeamModel({
    required super.teamId,
    required super.teamName,
    required super.leaderName,
    required super.memberCount,
    required super.vehicleCount,
    required super.currentMission,
    required super.isAvailable,
    required super.performanceScore,
    required super.district,
  });

  factory AdminRescueTeamModel.fromJson(Map<String, dynamic> json) {
    return AdminRescueTeamModel(
      teamId: json['teamId'] as String? ?? '',
      teamName: json['teamName'] as String? ?? '',
      leaderName: json['leaderName'] as String? ?? '',
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 6,
      vehicleCount: (json['vehicleCount'] as num?)?.toInt() ?? 2,
      currentMission: json['currentMission'] as String? ?? 'Standby',
      isAvailable: json['isAvailable'] as bool? ?? true,
      performanceScore:
          (json['performanceScore'] as num?)?.toDouble() ?? 90.0,
      district: json['district'] as String? ?? 'Chennai',
    );
  }

  Map<String, dynamic> toJson() => {
        'teamId': teamId,
        'teamName': teamName,
        'leaderName': leaderName,
        'memberCount': memberCount,
        'vehicleCount': vehicleCount,
        'currentMission': currentMission,
        'isAvailable': isAvailable,
        'performanceScore': performanceScore,
        'district': district,
      };

  AdminRescueTeam toEntity() => this;
}

/// DTO Model for ManagedDevice.
class ManagedDeviceModel extends ManagedDevice {
  const ManagedDeviceModel({
    required super.id,
    required super.name,
    required super.type,
    required super.pairedTeam,
    required super.batteryPercent,
    required super.signalStrengthDbm,
    required super.isConnected,
    required super.lastSync,
    required super.mapCacheMb,
    required super.offlineStorageMb,
    required super.firmwareVersion,
  });

  factory ManagedDeviceModel.fromJson(Map<String, dynamic> json) {
    final typeIdx = (json['type'] as num?)?.toInt() ?? 0;
    return ManagedDeviceModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: typeIdx >= 0 && typeIdx < DeviceType.values.length
          ? DeviceType.values[typeIdx]
          : DeviceType.bleMeshNode,
      pairedTeam: json['pairedTeam'] as String? ?? 'Squad Alpha',
      batteryPercent: (json['batteryPercent'] as num?)?.toInt() ?? 80,
      signalStrengthDbm:
          (json['signalStrengthDbm'] as num?)?.toDouble() ?? -65.0,
      isConnected: json['isConnected'] as bool? ?? true,
      lastSync: json['lastSync'] != null
          ? DateTime.tryParse(json['lastSync'] as String) ?? DateTime.now()
          : DateTime.now(),
      mapCacheMb: (json['mapCacheMb'] as num?)?.toDouble() ?? 128.0,
      offlineStorageMb:
          (json['offlineStorageMb'] as num?)?.toDouble() ?? 256.0,
      firmwareVersion: json['firmwareVersion'] as String? ?? 'v2.4.1',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.index,
        'pairedTeam': pairedTeam,
        'batteryPercent': batteryPercent,
        'signalStrengthDbm': signalStrengthDbm,
        'isConnected': isConnected,
        'lastSync': lastSync.toIso8601String(),
        'mapCacheMb': mapCacheMb,
        'offlineStorageMb': offlineStorageMb,
        'firmwareVersion': firmwareVersion,
      };

  ManagedDevice toEntity() => this;
}

/// DTO Model for AdminNotification.
class AdminNotificationModel extends AdminNotification {
  const AdminNotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.category,
    required super.timestamp,
    required super.isRead,
    super.relatedEntityId,
  });

  factory AdminNotificationModel.fromJson(Map<String, dynamic> json) {
    final catIdx = (json['category'] as num?)?.toInt() ?? 0;
    return AdminNotificationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      category: catIdx >= 0 && catIdx < NotificationCategory.values.length
          ? NotificationCategory.values[catIdx]
          : NotificationCategory.systemAlert,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      relatedEntityId: json['relatedEntityId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'category': category.index,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
        'relatedEntityId': relatedEntityId,
      };

  AdminNotification toEntity() => this;
}

/// DTO Model for AuditLogItem.
class AuditLogItemModel extends AuditLogItem {
  const AuditLogItemModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.actionType,
    required super.details,
    required super.ipAddress,
    required super.timestamp,
    required super.isSuccess,
  });

  factory AuditLogItemModel.fromJson(Map<String, dynamic> json) {
    final actIdx = (json['actionType'] as num?)?.toInt() ?? 0;
    return AuditLogItemModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      actionType: actIdx >= 0 && actIdx < AuditActionType.values.length
          ? AuditActionType.values[actIdx]
          : AuditActionType.userLogin,
      details: json['details'] as String? ?? '',
      ipAddress: json['ipAddress'] as String? ?? '127.0.0.1',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      isSuccess: json['isSuccess'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'actionType': actionType.index,
        'details': details,
        'ipAddress': ipAddress,
        'timestamp': timestamp.toIso8601String(),
        'isSuccess': isSuccess,
      };

  AuditLogItem toEntity() => this;
}

/// DTO Model for BackupSnapshot.
class BackupSnapshotModel extends BackupSnapshot {
  const BackupSnapshotModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.sizeKb,
    required super.recordsCount,
    required super.version,
  });

  factory BackupSnapshotModel.fromJson(Map<String, dynamic> json) {
    return BackupSnapshotModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      sizeKb: (json['sizeKb'] as num?)?.toInt() ?? 512,
      recordsCount: (json['recordsCount'] as num?)?.toInt() ?? 100,
      version: json['version'] as String? ?? '2.0-PROD',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'sizeKb': sizeKb,
        'recordsCount': recordsCount,
        'version': version,
      };

  BackupSnapshot toEntity() => this;
}
