import '../../domain/entities/admin_entities.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_mock_datasource.dart';

/// Concrete repository implementation for Rescue Administration & Management.
class AdminRepositoryImpl implements AdminRepository {
  final AdminMockDataSource _dataSource;

  AdminRepositoryImpl({AdminMockDataSource? dataSource})
      : _dataSource = dataSource ?? AdminMockDataSource();

  @override
  Future<SystemHealthMetrics> getSystemHealth() {
    return _dataSource.getSystemHealth();
  }

  @override
  Future<List<AdminUser>> getUsers({
    String? searchQuery,
    UserRole? role,
    UserStatus? status,
    String? district,
  }) async {
    final list = await _dataSource.getUsers(
      searchQuery: searchQuery,
      role: role,
      status: status,
      district: district,
    );
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AdminUser> updateUserStatus(String userId, UserStatus status) async {
    final model = await _dataSource.updateUserStatus(userId, status);
    return model.toEntity();
  }

  @override
  Future<List<AdminRescueTeam>> getRescueTeams({
    String? searchQuery,
    String? district,
    bool? availableOnly,
  }) async {
    final list = await _dataSource.getRescueTeams(
      searchQuery: searchQuery,
      district: district,
      availableOnly: availableOnly,
    );
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ManagedDevice>> getDevices({
    String? searchQuery,
    DeviceType? type,
    bool? connectedOnly,
  }) async {
    final list = await _dataSource.getDevices(
      searchQuery: searchQuery,
      type: type,
      connectedOnly: connectedOnly,
    );
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AdminNotification>> getNotifications({
    NotificationCategory? category,
    bool? unreadOnly,
  }) async {
    final list = await _dataSource.getNotifications(
      category: category,
      unreadOnly: unreadOnly,
    );
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> markNotificationRead(String id) {
    return _dataSource.markNotificationRead(id);
  }

  @override
  Future<void> markAllNotificationsRead() {
    return _dataSource.markAllNotificationsRead();
  }

  @override
  Future<void> clearNotifications() {
    return _dataSource.clearNotifications();
  }

  @override
  Future<List<AuditLogItem>> getAuditLogs({
    AuditActionType? actionType,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final list = await _dataSource.getAuditLogs(
      actionType: actionType,
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
    );
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ApplicationSettings> getSettings() {
    return _dataSource.getSettings();
  }

  @override
  Future<ApplicationSettings> updateSettings(ApplicationSettings settings) {
    return _dataSource.updateSettings(settings);
  }

  @override
  Future<List<BackupSnapshot>> getBackups() async {
    final list = await _dataSource.getBackups();
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<BackupSnapshot> createBackup(String name) async {
    final model = await _dataSource.createBackup(name);
    return model.toEntity();
  }

  @override
  Future<bool> restoreBackup(String backupId) {
    return _dataSource.restoreBackup(backupId);
  }

  @override
  Future<bool> resetToDefaults() {
    return _dataSource.resetToDefaults();
  }
}
