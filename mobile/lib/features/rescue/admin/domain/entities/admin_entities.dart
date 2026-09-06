import 'package:flutter/material.dart';

/// User Role classification.
enum UserRole {
  superAdmin,
  incidentCommander,
  fieldLeader,
  paramedic,
  logisticsCoordinator,
  reconSpecialist,
  volunteer,
}

extension UserRoleX on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.incidentCommander:
        return 'Incident Commander';
      case UserRole.fieldLeader:
        return 'Field Squad Leader';
      case UserRole.paramedic:
        return 'Paramedic & Triage';
      case UserRole.logisticsCoordinator:
        return 'Logistics Coordinator';
      case UserRole.reconSpecialist:
        return 'Drone & Recon Specialist';
      case UserRole.volunteer:
        return 'Civilian Volunteer';
    }
  }

  Color get color {
    switch (this) {
      case UserRole.superAdmin:
        return const Color(0xFFE11D48);
      case UserRole.incidentCommander:
        return const Color(0xFF8B5CF6);
      case UserRole.fieldLeader:
        return const Color(0xFF3B82F6);
      case UserRole.paramedic:
        return const Color(0xFF10B981);
      case UserRole.logisticsCoordinator:
        return const Color(0xFFF59E0B);
      case UserRole.reconSpecialist:
        return const Color(0xFF06B6D4);
      case UserRole.volunteer:
        return const Color(0xFF6B7280);
    }
  }
}

/// User account operational status.
enum UserStatus {
  active,
  onDuty,
  offDuty,
  suspended,
  pendingVerification,
}

extension UserStatusX on UserStatus {
  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.onDuty:
        return 'On Duty (Deployed)';
      case UserStatus.offDuty:
        return 'Off Duty (Standby)';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.pendingVerification:
        return 'Pending Verification';
    }
  }

  Color get color {
    switch (this) {
      case UserStatus.active:
        return const Color(0xFF10B981);
      case UserStatus.onDuty:
        return const Color(0xFF3B82F6);
      case UserStatus.offDuty:
        return const Color(0xFF9CA3AF);
      case UserStatus.suspended:
        return const Color(0xFFEF4444);
      case UserStatus.pendingVerification:
        return const Color(0xFFF59E0B);
    }
  }
}

/// Admin User Profile entity.
class AdminUser {
  final String id;
  final String name;
  final UserRole role;
  final String department;
  final String district;
  final String phone;
  final String email;
  final UserStatus status;
  final DateTime lastLogin;
  final List<String> permissions;

  const AdminUser({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.district,
    required this.phone,
    required this.email,
    required this.status,
    required this.lastLogin,
    required this.permissions,
  });
}

/// Admin Rescue Team entity.
class AdminRescueTeam {
  final String teamId;
  final String teamName;
  final String leaderName;
  final int memberCount;
  final int vehicleCount;
  final String currentMission;
  final bool isAvailable;
  final double performanceScore;
  final String district;

  const AdminRescueTeam({
    required this.teamId,
    required this.teamName,
    required this.leaderName,
    required this.memberCount,
    required this.vehicleCount,
    required this.currentMission,
    required this.isAvailable,
    required this.performanceScore,
    required this.district,
  });
}

/// Device connectivity classification.
enum DeviceType {
  bleMeshNode,
  gpsTracker,
  mobileTerminal,
  satelliteTransceiver,
  droneHub,
}

extension DeviceTypeX on DeviceType {
  String get displayName {
    switch (this) {
      case DeviceType.bleMeshNode:
        return 'BLE Mesh Node';
      case DeviceType.gpsTracker:
        return 'Tactical GPS Tracker';
      case DeviceType.mobileTerminal:
        return 'Field Mobile Terminal';
      case DeviceType.satelliteTransceiver:
        return 'Satellite Transceiver';
      case DeviceType.droneHub:
        return 'Drone Telemetry Hub';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceType.bleMeshNode:
        return Icons.bluetooth_audio_rounded;
      case DeviceType.gpsTracker:
        return Icons.gps_fixed_rounded;
      case DeviceType.mobileTerminal:
        return Icons.phone_android_rounded;
      case DeviceType.satelliteTransceiver:
        return Icons.satellite_alt_rounded;
      case DeviceType.droneHub:
        return Icons.flight_takeoff_rounded;
    }
  }
}

/// Managed Device Entity.
class ManagedDevice {
  final String id;
  final String name;
  final DeviceType type;
  final String pairedTeam;
  final int batteryPercent;
  final double signalStrengthDbm;
  final bool isConnected;
  final DateTime lastSync;
  final double mapCacheMb;
  final double offlineStorageMb;
  final String firmwareVersion;

  const ManagedDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.pairedTeam,
    required this.batteryPercent,
    required this.signalStrengthDbm,
    required this.isConnected,
    required this.lastSync,
    required this.mapCacheMb,
    required this.offlineStorageMb,
    required this.firmwareVersion,
  });
}

/// Notification categories.
enum NotificationCategory {
  missionAlert,
  sosAlert,
  systemAlert,
  aiAlert,
  warningMessage,
}

extension NotificationCategoryX on NotificationCategory {
  String get displayName {
    switch (this) {
      case NotificationCategory.missionAlert:
        return 'Mission Alert';
      case NotificationCategory.sosAlert:
        return 'SOS Emergency';
      case NotificationCategory.systemAlert:
        return 'System Alert';
      case NotificationCategory.aiAlert:
        return 'AI Commander Alert';
      case NotificationCategory.warningMessage:
        return 'Hazard Warning';
    }
  }

  Color get color {
    switch (this) {
      case NotificationCategory.missionAlert:
        return const Color(0xFF3B82F6);
      case NotificationCategory.sosAlert:
        return const Color(0xFFEF4444);
      case NotificationCategory.systemAlert:
        return const Color(0xFF8B5CF6);
      case NotificationCategory.aiAlert:
        return const Color(0xFFEC4899);
      case NotificationCategory.warningMessage:
        return const Color(0xFFF59E0B);
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationCategory.missionAlert:
        return Icons.campaign_rounded;
      case NotificationCategory.sosAlert:
        return Icons.sos_rounded;
      case NotificationCategory.systemAlert:
        return Icons.info_outline_rounded;
      case NotificationCategory.aiAlert:
        return Icons.auto_awesome_rounded;
      case NotificationCategory.warningMessage:
        return Icons.warning_amber_rounded;
    }
  }
}

/// System Notification Entity.
class AdminNotification {
  final String id;
  final String title;
  final String message;
  final NotificationCategory category;
  final DateTime timestamp;
  final bool isRead;
  final String? relatedEntityId;

  const AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timestamp,
    required this.isRead,
    this.relatedEntityId,
  });

  AdminNotification copyWith({bool? isRead}) {
    return AdminNotification(
      id: id,
      title: title,
      message: message,
      category: category,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      relatedEntityId: relatedEntityId,
    );
  }
}

/// Audit Log Category.
enum AuditActionType {
  userLogin,
  missionCreation,
  missionUpdate,
  resourceAllocation,
  aiRequest,
  settingsChange,
  backupRestore,
  devicePairing,
}

extension AuditActionTypeX on AuditActionType {
  String get displayName {
    switch (this) {
      case AuditActionType.userLogin:
        return 'User Authentication';
      case AuditActionType.missionCreation:
        return 'Mission Dispatch';
      case AuditActionType.missionUpdate:
        return 'Mission Status Update';
      case AuditActionType.resourceAllocation:
        return 'Resource Allocation';
      case AuditActionType.aiRequest:
        return 'AI Inference Query';
      case AuditActionType.settingsChange:
        return 'System Configuration';
      case AuditActionType.backupRestore:
        return 'Data Backup & Restore';
      case AuditActionType.devicePairing:
        return 'Hardware Mesh Sync';
    }
  }

  IconData get icon {
    switch (this) {
      case AuditActionType.userLogin:
        return Icons.login_rounded;
      case AuditActionType.missionCreation:
        return Icons.add_task_rounded;
      case AuditActionType.missionUpdate:
        return Icons.update_rounded;
      case AuditActionType.resourceAllocation:
        return Icons.inventory_2_rounded;
      case AuditActionType.aiRequest:
        return Icons.psychology_rounded;
      case AuditActionType.settingsChange:
        return Icons.settings_rounded;
      case AuditActionType.backupRestore:
        return Icons.cloud_sync_rounded;
      case AuditActionType.devicePairing:
        return Icons.bluetooth_connected_rounded;
    }
  }
}

/// Audit Log Entity.
class AuditLogItem {
  final String id;
  final String userId;
  final String userName;
  final AuditActionType actionType;
  final String details;
  final String ipAddress;
  final DateTime timestamp;
  final bool isSuccess;

  const AuditLogItem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.actionType,
    required this.details,
    required this.ipAddress,
    required this.timestamp,
    required this.isSuccess,
  });
}

/// System Telemetry & Operational Health.
class SystemHealthMetrics {
  final String systemStatus; // 'Operational', 'Degraded', 'Critical'
  final bool isApiHealthy;
  final int apiLatencyMs;
  final bool isDatabaseConnected;
  final bool isBleServiceActive;
  final bool isGpsLocked;
  final bool isInternetConnected;
  final double storageUsedGb;
  final double storageTotalGb;
  final double memoryUsageMb;
  final double memoryTotalMb;
  final double cpuLoadPercent;
  final int batteryPercent;
  final bool isCharging;
  final String appVersion;
  final String buildNumber;
  final int syncQueueLength;
  final int crashReportsCount;

  const SystemHealthMetrics({
    required this.systemStatus,
    required this.isApiHealthy,
    required this.apiLatencyMs,
    required this.isDatabaseConnected,
    required this.isBleServiceActive,
    required this.isGpsLocked,
    required this.isInternetConnected,
    required this.storageUsedGb,
    required this.storageTotalGb,
    required this.memoryUsageMb,
    required this.memoryTotalMb,
    required this.cpuLoadPercent,
    required this.batteryPercent,
    required this.isCharging,
    required this.appVersion,
    required this.buildNumber,
    required this.syncQueueLength,
    required this.crashReportsCount,
  });

  double get storagePercent => (storageUsedGb / storageTotalGb * 100).clamp(0, 100);
  double get memoryPercent => (memoryUsageMb / memoryTotalMb * 100).clamp(0, 100);
}

/// System Application Configuration Settings.
class ApplicationSettings {
  final String themeMode; // 'system', 'light', 'dark'
  final String language; // 'en', 'ta'
  final bool notificationsEnabled;
  final bool soundAlertsEnabled;
  final bool hapticFeedback;
  final bool offlineModeForced;
  final int mapCacheLimitMb;
  final int bleTxPowerDbm;
  final int syncIntervalSeconds;
  final String gpsAccuracy; // 'High', 'Balanced', 'BatterySaving'
  final String loggingLevel; // 'Debug', 'Info', 'Warn', 'Error'
  final bool developerMode;
  final bool mockTelemetryEnabled;

  const ApplicationSettings({
    this.themeMode = 'dark',
    this.language = 'en',
    this.notificationsEnabled = true,
    this.soundAlertsEnabled = true,
    this.hapticFeedback = true,
    this.offlineModeForced = false,
    this.mapCacheLimitMb = 512,
    this.bleTxPowerDbm = 4,
    this.syncIntervalSeconds = 15,
    this.gpsAccuracy = 'High',
    this.loggingLevel = 'Info',
    this.developerMode = false,
    this.mockTelemetryEnabled = true,
  });

  ApplicationSettings copyWith({
    String? themeMode,
    String? language,
    bool? notificationsEnabled,
    bool? soundAlertsEnabled,
    bool? hapticFeedback,
    bool? offlineModeForced,
    int? mapCacheLimitMb,
    int? bleTxPowerDbm,
    int? syncIntervalSeconds,
    String? gpsAccuracy,
    String? loggingLevel,
    bool? developerMode,
    bool? mockTelemetryEnabled,
  }) {
    return ApplicationSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundAlertsEnabled: soundAlertsEnabled ?? this.soundAlertsEnabled,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      offlineModeForced: offlineModeForced ?? this.offlineModeForced,
      mapCacheLimitMb: mapCacheLimitMb ?? this.mapCacheLimitMb,
      bleTxPowerDbm: bleTxPowerDbm ?? this.bleTxPowerDbm,
      syncIntervalSeconds: syncIntervalSeconds ?? this.syncIntervalSeconds,
      gpsAccuracy: gpsAccuracy ?? this.gpsAccuracy,
      loggingLevel: loggingLevel ?? this.loggingLevel,
      developerMode: developerMode ?? this.developerMode,
      mockTelemetryEnabled: mockTelemetryEnabled ?? this.mockTelemetryEnabled,
    );
  }
}

/// Backup snapshot metadata.
class BackupSnapshot {
  final String id;
  final String name;
  final DateTime createdAt;
  final int sizeKb;
  final int recordsCount;
  final String version;

  const BackupSnapshot({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.sizeKb,
    required this.recordsCount,
    required this.version,
  });
}
