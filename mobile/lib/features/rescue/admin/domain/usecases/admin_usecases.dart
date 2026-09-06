import '../entities/admin_entities.dart';
import '../repositories/admin_repository.dart';

/// Retrieve live system health telemetry.
class GetSystemHealthUseCase {
  final AdminRepository repository;
  GetSystemHealthUseCase(this.repository);

  Future<SystemHealthMetrics> call() async {
    return await repository.getSystemHealth();
  }
}

/// Retrieve and filter users.
class GetUsersUseCase {
  final AdminRepository repository;
  GetUsersUseCase(this.repository);

  Future<List<AdminUser>> call({
    String? searchQuery,
    UserRole? role,
    UserStatus? status,
    String? district,
  }) async {
    return await repository.getUsers(
      searchQuery: searchQuery,
      role: role,
      status: status,
      district: district,
    );
  }
}

/// Update user status.
class UpdateUserStatusUseCase {
  final AdminRepository repository;
  UpdateUserStatusUseCase(this.repository);

  Future<AdminUser> call(String userId, UserStatus status) async {
    return await repository.updateUserStatus(userId, status);
  }
}

/// Retrieve rescue squads.
class GetAdminRescueTeamsUseCase {
  final AdminRepository repository;
  GetAdminRescueTeamsUseCase(this.repository);

  Future<List<AdminRescueTeam>> call({
    String? searchQuery,
    String? district,
    bool? availableOnly,
  }) async {
    return await repository.getRescueTeams(
      searchQuery: searchQuery,
      district: district,
      availableOnly: availableOnly,
    );
  }
}

/// Retrieve managed devices.
class GetDevicesUseCase {
  final AdminRepository repository;
  GetDevicesUseCase(this.repository);

  Future<List<ManagedDevice>> call({
    String? searchQuery,
    DeviceType? type,
    bool? connectedOnly,
  }) async {
    return await repository.getDevices(
      searchQuery: searchQuery,
      type: type,
      connectedOnly: connectedOnly,
    );
  }
}

/// Retrieve notifications.
class GetNotificationsUseCase {
  final AdminRepository repository;
  GetNotificationsUseCase(this.repository);

  Future<List<AdminNotification>> call({
    NotificationCategory? category,
    bool? unreadOnly,
  }) async {
    return await repository.getNotifications(
      category: category,
      unreadOnly: unreadOnly,
    );
  }
}

/// Notification actions.
class ManageNotificationsUseCase {
  final AdminRepository repository;
  ManageNotificationsUseCase(this.repository);

  Future<void> markAsRead(String id) => repository.markNotificationRead(id);
  Future<void> markAllAsRead() => repository.markAllNotificationsRead();
  Future<void> clearAll() => repository.clearNotifications();
}

/// Retrieve audit logs.
class GetAuditLogsUseCase {
  final AdminRepository repository;
  GetAuditLogsUseCase(this.repository);

  Future<List<AuditLogItem>> call({
    AuditActionType? actionType,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getAuditLogs(
      actionType: actionType,
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

/// Manage application settings.
class ManageSettingsUseCase {
  final AdminRepository repository;
  ManageSettingsUseCase(this.repository);

  Future<ApplicationSettings> getSettings() => repository.getSettings();
  Future<ApplicationSettings> updateSettings(ApplicationSettings settings) =>
      repository.updateSettings(settings);
  Future<bool> resetToDefaults() => repository.resetToDefaults();
}

/// Manage backup snapshots.
class ManageBackupsUseCase {
  final AdminRepository repository;
  ManageBackupsUseCase(this.repository);

  Future<List<BackupSnapshot>> getBackups() => repository.getBackups();
  Future<BackupSnapshot> createBackup(String name) => repository.createBackup(name);
  Future<bool> restoreBackup(String id) => repository.restoreBackup(id);
}
