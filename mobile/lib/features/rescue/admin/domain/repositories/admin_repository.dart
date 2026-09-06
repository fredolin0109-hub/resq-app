import '../entities/admin_entities.dart';

/// Abstract repository contract for Rescue Administration, Monitoring, Management, and Settings.
abstract class AdminRepository {
  /// Fetch live system health, API status, hardware state, and resource telemetry.
  Future<SystemHealthMetrics> getSystemHealth();

  /// Retrieve and filter system users.
  Future<List<AdminUser>> getUsers({
    String? searchQuery,
    UserRole? role,
    UserStatus? status,
    String? district,
  });

  /// Update user account status.
  Future<AdminUser> updateUserStatus(String userId, UserStatus status);

  /// Retrieve and filter rescue squads.
  Future<List<AdminRescueTeam>> getRescueTeams({
    String? searchQuery,
    String? district,
    bool? availableOnly,
  });

  /// Retrieve and filter hardware nodes and terminals.
  Future<List<ManagedDevice>> getDevices({
    String? searchQuery,
    DeviceType? type,
    bool? connectedOnly,
  });

  /// Retrieve notification history and alert stream.
  Future<List<AdminNotification>> getNotifications({
    NotificationCategory? category,
    bool? unreadOnly,
  });

  /// Mark specific notification as read.
  Future<void> markNotificationRead(String id);

  /// Mark all notifications as read.
  Future<void> markAllNotificationsRead();

  /// Clear all notifications.
  Future<void> clearNotifications();

  /// Retrieve system audit logs with filters.
  Future<List<AuditLogItem>> getAuditLogs({
    AuditActionType? actionType,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Retrieve current application configuration settings.
  Future<ApplicationSettings> getSettings();

  /// Save application configuration settings.
  Future<ApplicationSettings> updateSettings(ApplicationSettings settings);

  /// Retrieve backup snapshot archive.
  Future<List<BackupSnapshot>> getBackups();

  /// Create a fresh backup snapshot.
  Future<BackupSnapshot> createBackup(String name);

  /// Restore state from a backup snapshot.
  Future<bool> restoreBackup(String backupId);

  /// Reset all configuration settings to defaults.
  Future<bool> resetToDefaults();
}
