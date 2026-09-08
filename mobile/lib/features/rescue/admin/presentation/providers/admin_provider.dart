import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/datasources/admin_mock_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/entities/admin_entities.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/usecases/admin_usecases.dart';
import '../../services/backup_restore_service.dart';
import 'admin_state.dart';

/// Central state notifier orchestrating System Health, User RBAC, Squad Management,
/// Hardware Telemetry, Notifications, Audit Logs, Settings, and Backups.
class AdminNotifier extends ChangeNotifier {
  final GetSystemHealthUseCase _getHealthUseCase;
  final GetUsersUseCase _getUsersUseCase;
  final UpdateUserStatusUseCase _updateUserStatusUseCase;
  final GetAdminRescueTeamsUseCase _getTeamsUseCase;
  final GetDevicesUseCase _getDevicesUseCase;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final ManageNotificationsUseCase _manageNotificationsUseCase;
  final GetAuditLogsUseCase _getAuditLogsUseCase;
  final ManageSettingsUseCase _manageSettingsUseCase;
  final ManageBackupsUseCase _manageBackupsUseCase;
  final BackupRestoreService _backupService;

  AdminState _state = AdminState.initial();

  AdminNotifier({
    required GetSystemHealthUseCase getHealthUseCase,
    required GetUsersUseCase getUsersUseCase,
    required UpdateUserStatusUseCase updateUserStatusUseCase,
    required GetAdminRescueTeamsUseCase getTeamsUseCase,
    required GetDevicesUseCase getDevicesUseCase,
    required GetNotificationsUseCase getNotificationsUseCase,
    required ManageNotificationsUseCase manageNotificationsUseCase,
    required GetAuditLogsUseCase getAuditLogsUseCase,
    required ManageSettingsUseCase manageSettingsUseCase,
    required ManageBackupsUseCase manageBackupsUseCase,
    BackupRestoreService? backupService,
  })  : _getHealthUseCase = getHealthUseCase,
        _getUsersUseCase = getUsersUseCase,
        _updateUserStatusUseCase = updateUserStatusUseCase,
        _getTeamsUseCase = getTeamsUseCase,
        _getDevicesUseCase = getDevicesUseCase,
        _getNotificationsUseCase = getNotificationsUseCase,
        _manageNotificationsUseCase = manageNotificationsUseCase,
        _getAuditLogsUseCase = getAuditLogsUseCase,
        _manageSettingsUseCase = manageSettingsUseCase,
        _manageBackupsUseCase = manageBackupsUseCase,
        _backupService = backupService ?? BackupRestoreService();

  AdminState get state => _state;

  /// Load all administrative data, system telemetry, and configurations.
  Future<void> loadAdminData() async {
    _state = _state.copyWith(status: AdminViewStatus.loading);
    notifyListeners();

    try {
      final health = await _getHealthUseCase();
      final settings = await _manageSettingsUseCase.getSettings();
      final users = await _getUsersUseCase();
      final teams = await _getTeamsUseCase();
      final devices = await _getDevicesUseCase();
      final notifications = await _getNotificationsUseCase();
      final auditLogs = await _getAuditLogsUseCase();
      final backups = await _manageBackupsUseCase.getBackups();

      final filteredUsers = _applyUserFilters(users, _state.userFilters);
      final filteredTeams = _applyTeamFilters(teams, _state.teamFilters);
      final filteredDevices = _applyDeviceFilters(devices, _state.deviceFilters);
      final filteredNotifs = _applyNotificationFilters(notifications, _state.notificationFilters);
      final filteredLogs = _applyAuditFilters(auditLogs, _state.auditFilters);

      _state = _state.copyWith(
        status: AdminViewStatus.loaded,
        health: health,
        settings: settings,
        allUsers: users,
        filteredUsers: filteredUsers,
        allTeams: teams,
        filteredTeams: filteredTeams,
        allDevices: devices,
        filteredDevices: filteredDevices,
        allNotifications: notifications,
        filteredNotifications: filteredNotifs,
        allAuditLogs: auditLogs,
        filteredAuditLogs: filteredLogs,
        backups: backups,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: AdminViewStatus.error,
        errorMessage: 'Failed to load system administration data: $e',
      );
      notifyListeners();
    }
  }

  /// Refresh all data.
  Future<void> refresh() => loadAdminData();

  // --- User Management Actions ---

  void setUserSearchQuery(String query) {
    final newFilters = _state.userFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(
      userFilters: newFilters,
      filteredUsers: _applyUserFilters(_state.allUsers, newFilters),
    );
    notifyListeners();
  }

  void setUserRole(UserRole? role) {
    final newFilters = role == null
        ? _state.userFilters.copyWith(clearRole: true)
        : _state.userFilters.copyWith(role: role);
    _state = _state.copyWith(
      userFilters: newFilters,
      filteredUsers: _applyUserFilters(_state.allUsers, newFilters),
    );
    notifyListeners();
  }

  void setUserStatusFilter(UserStatus? status) {
    final newFilters = status == null
        ? _state.userFilters.copyWith(clearStatus: true)
        : _state.userFilters.copyWith(status: status);
    _state = _state.copyWith(
      userFilters: newFilters,
      filteredUsers: _applyUserFilters(_state.allUsers, newFilters),
    );
    notifyListeners();
  }

  void setUserDistrict(String district) {
    final newFilters = _state.userFilters.copyWith(district: district);
    _state = _state.copyWith(
      userFilters: newFilters,
      filteredUsers: _applyUserFilters(_state.allUsers, newFilters),
    );
    notifyListeners();
  }

  void clearUserFilters() {
    const newFilters = UserFilterOptions();
    _state = _state.copyWith(
      userFilters: newFilters,
      filteredUsers: _applyUserFilters(_state.allUsers, newFilters),
    );
    notifyListeners();
  }

  Future<void> updateUserStatus(String userId, UserStatus newStatus) async {
    try {
      final updatedUser = await _updateUserStatusUseCase(userId, newStatus);
      final updatedList = _state.allUsers.map((u) {
        return u.id == userId ? updatedUser : u;
      }).toList();

      _state = _state.copyWith(
        allUsers: updatedList,
        filteredUsers: _applyUserFilters(updatedList, _state.userFilters),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user status: $e');
    }
  }

  // --- Team Actions ---

  void setTeamSearchQuery(String query) {
    final newFilters = _state.teamFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(
      teamFilters: newFilters,
      filteredTeams: _applyTeamFilters(_state.allTeams, newFilters),
    );
    notifyListeners();
  }

  void setTeamDistrict(String district) {
    final newFilters = _state.teamFilters.copyWith(district: district);
    _state = _state.copyWith(
      teamFilters: newFilters,
      filteredTeams: _applyTeamFilters(_state.allTeams, newFilters),
    );
    notifyListeners();
  }

  void setTeamAvailableOnly(bool? availableOnly) {
    final newFilters = availableOnly == null
        ? _state.teamFilters.copyWith(clearAvailable: true)
        : _state.teamFilters.copyWith(availableOnly: availableOnly);
    _state = _state.copyWith(
      teamFilters: newFilters,
      filteredTeams: _applyTeamFilters(_state.allTeams, newFilters),
    );
    notifyListeners();
  }

  void clearTeamFilters() {
    const newFilters = AdminTeamFilterOptions();
    _state = _state.copyWith(
      teamFilters: newFilters,
      filteredTeams: _applyTeamFilters(_state.allTeams, newFilters),
    );
    notifyListeners();
  }

  // --- Device Actions ---

  void setDeviceSearchQuery(String query) {
    final newFilters = _state.deviceFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(
      deviceFilters: newFilters,
      filteredDevices: _applyDeviceFilters(_state.allDevices, newFilters),
    );
    notifyListeners();
  }

  void setDeviceType(DeviceType? type) {
    final newFilters = type == null
        ? _state.deviceFilters.copyWith(clearType: true)
        : _state.deviceFilters.copyWith(type: type);
    _state = _state.copyWith(
      deviceFilters: newFilters,
      filteredDevices: _applyDeviceFilters(_state.allDevices, newFilters),
    );
    notifyListeners();
  }

  void setDeviceConnectedOnly(bool? connectedOnly) {
    final newFilters = connectedOnly == null
        ? _state.deviceFilters.copyWith(clearConnected: true)
        : _state.deviceFilters.copyWith(connectedOnly: connectedOnly);
    _state = _state.copyWith(
      deviceFilters: newFilters,
      filteredDevices: _applyDeviceFilters(_state.allDevices, newFilters),
    );
    notifyListeners();
  }

  void clearDeviceFilters() {
    const newFilters = DeviceFilterOptions();
    _state = _state.copyWith(
      deviceFilters: newFilters,
      filteredDevices: _applyDeviceFilters(_state.allDevices, newFilters),
    );
    notifyListeners();
  }

  // --- Notification Actions ---

  void setNotificationCategory(NotificationCategory? cat) {
    final newFilters = cat == null
        ? _state.notificationFilters.copyWith(clearCategory: true)
        : _state.notificationFilters.copyWith(category: cat);
    _state = _state.copyWith(
      notificationFilters: newFilters,
      filteredNotifications:
          _applyNotificationFilters(_state.allNotifications, newFilters),
    );
    notifyListeners();
  }

  void setNotificationUnreadOnly(bool unreadOnly) {
    final newFilters =
        _state.notificationFilters.copyWith(unreadOnly: unreadOnly);
    _state = _state.copyWith(
      notificationFilters: newFilters,
      filteredNotifications:
          _applyNotificationFilters(_state.allNotifications, newFilters),
    );
    notifyListeners();
  }

  void clearNotificationFilters() {
    const newFilters = NotificationFilterOptions();
    _state = _state.copyWith(
      notificationFilters: newFilters,
      filteredNotifications:
          _applyNotificationFilters(_state.allNotifications, newFilters),
    );
    notifyListeners();
  }

  Future<void> markNotificationRead(String id) async {
    await _manageNotificationsUseCase.markAsRead(id);
    final updated = _state.allNotifications.map((n) {
      return n.id == id ? n.copyWith(isRead: true) : n;
    }).toList();

    _state = _state.copyWith(
      allNotifications: updated,
      filteredNotifications:
          _applyNotificationFilters(updated, _state.notificationFilters),
    );
    notifyListeners();
  }

  Future<void> markAllNotificationsRead() async {
    await _manageNotificationsUseCase.markAllAsRead();
    final updated =
        _state.allNotifications.map((n) => n.copyWith(isRead: true)).toList();

    _state = _state.copyWith(
      allNotifications: updated,
      filteredNotifications:
          _applyNotificationFilters(updated, _state.notificationFilters),
    );
    notifyListeners();
  }

  Future<void> clearAllNotifications() async {
    await _manageNotificationsUseCase.clearAll();
    _state = _state.copyWith(
      allNotifications: [],
      filteredNotifications: [],
    );
    notifyListeners();
  }

  // --- Audit Log Actions ---

  void setAuditActionType(AuditActionType? action) {
    final newFilters = action == null
        ? _state.auditFilters.copyWith(clearAction: true)
        : _state.auditFilters.copyWith(actionType: action);
    _state = _state.copyWith(
      auditFilters: newFilters,
      filteredAuditLogs: _applyAuditFilters(_state.allAuditLogs, newFilters),
    );
    notifyListeners();
  }

  void setAuditSearchQuery(String query) {
    final newFilters = _state.auditFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(
      auditFilters: newFilters,
      filteredAuditLogs: _applyAuditFilters(_state.allAuditLogs, newFilters),
    );
    notifyListeners();
  }

  void setAuditDateRange(DateTime? start, DateTime? end) {
    final newFilters = (start == null && end == null)
        ? _state.auditFilters.copyWith(clearDates: true)
        : _state.auditFilters.copyWith(startDate: start, endDate: end);
    _state = _state.copyWith(
      auditFilters: newFilters,
      filteredAuditLogs: _applyAuditFilters(_state.allAuditLogs, newFilters),
    );
    notifyListeners();
  }

  void clearAuditFilters() {
    const newFilters = AuditLogFilterOptions();
    _state = _state.copyWith(
      auditFilters: newFilters,
      filteredAuditLogs: _applyAuditFilters(_state.allAuditLogs, newFilters),
    );
    notifyListeners();
  }

  // --- Application Settings Actions ---

  Future<void> updateSettings(ApplicationSettings newSettings) async {
    final updated = await _manageSettingsUseCase.updateSettings(newSettings);
    _state = _state.copyWith(settings: updated);
    notifyListeners();
  }

  Future<void> resetSettingsToDefault() async {
    await _manageSettingsUseCase.resetToDefaults();
    final defaults = await _manageSettingsUseCase.getSettings();
    _state = _state.copyWith(settings: defaults);
    notifyListeners();
  }

  // --- Backup & Restore Actions ---

  Future<BackupSnapshot?> createBackup(String name) async {
    _state = _state.copyWith(isCreatingBackup: true);
    notifyListeners();

    try {
      final newBackup = await _manageBackupsUseCase.createBackup(name);
      final updatedList = await _manageBackupsUseCase.getBackups();
      _state = _state.copyWith(
        isCreatingBackup: false,
        backups: updatedList,
      );
      notifyListeners();
      return newBackup;
    } catch (e) {
      _state = _state.copyWith(isCreatingBackup: false);
      notifyListeners();
      return null;
    }
  }

  Future<bool> restoreBackup(String id) async {
    _state = _state.copyWith(isRestoringBackup: true);
    notifyListeners();

    try {
      final success = await _manageBackupsUseCase.restoreBackup(id);
      _state = _state.copyWith(isRestoringBackup: false);
      notifyListeners();
      return success;
    } catch (e) {
      _state = _state.copyWith(isRestoringBackup: false);
      notifyListeners();
      return false;
    }
  }

  String exportSettingsJson() =>
      _backupService.exportSettingsJson(_state.settings);

  Future<bool> importSettingsJson(String jsonStr) async {
    try {
      final imported = _backupService.importSettingsJson(jsonStr);
      await updateSettings(imported);
      return true;
    } catch (e) {
      return false;
    }
  }

  String generateDiagnosticReport() {
    return _backupService.generateSystemDiagnosticReport(
      health: _state.health,
      settings: _state.settings,
      totalUsers: _state.allUsers.length,
      totalTeams: _state.allTeams.length,
      totalDevices: _state.allDevices.length,
      unreadAlerts: _state.unreadNotificationCount,
    );
  }

  // --- Filter Internal Implementations ---

  List<AdminUser> _applyUserFilters(
      List<AdminUser> users, UserFilterOptions filters) {
    return users.where((u) {
      if (filters.role != null && u.role != filters.role) return false;
      if (filters.status != null && u.status != filters.status) return false;
      if (filters.district != 'All' && u.district != filters.district) {
        return false;
      }
      if (filters.searchQuery.trim().isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        final match = u.name.toLowerCase().contains(q) ||
            u.id.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q) ||
            u.department.toLowerCase().contains(q) ||
            u.district.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<AdminRescueTeam> _applyTeamFilters(
      List<AdminRescueTeam> teams, AdminTeamFilterOptions filters) {
    return teams.where((t) {
      if (filters.district != 'All' && t.district != filters.district) {
        return false;
      }
      if (filters.availableOnly == true && !t.isAvailable) return false;
      if (filters.searchQuery.trim().isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        final match = t.teamName.toLowerCase().contains(q) ||
            t.leaderName.toLowerCase().contains(q) ||
            t.teamId.toLowerCase().contains(q) ||
            t.district.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<ManagedDevice> _applyDeviceFilters(
      List<ManagedDevice> devices, DeviceFilterOptions filters) {
    return devices.where((d) {
      if (filters.type != null && d.type != filters.type) return false;
      if (filters.connectedOnly == true && !d.isConnected) return false;
      if (filters.searchQuery.trim().isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        final match = d.name.toLowerCase().contains(q) ||
            d.id.toLowerCase().contains(q) ||
            d.pairedTeam.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<AdminNotification> _applyNotificationFilters(
      List<AdminNotification> list, NotificationFilterOptions filters) {
    return list.where((n) {
      if (filters.category != null && n.category != filters.category) {
        return false;
      }
      if (filters.unreadOnly && n.isRead) return false;
      return true;
    }).toList();
  }

  List<AuditLogItem> _applyAuditFilters(
      List<AuditLogItem> logs, AuditLogFilterOptions filters) {
    return logs.where((l) {
      if (filters.actionType != null && l.actionType != filters.actionType) {
        return false;
      }
      if (filters.startDate != null && l.timestamp.isBefore(filters.startDate!)) {
        return false;
      }
      if (filters.endDate != null && l.timestamp.isAfter(filters.endDate!)) {
        return false;
      }
      if (filters.searchQuery.trim().isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        final match = l.userName.toLowerCase().contains(q) ||
            l.details.toLowerCase().contains(q) ||
            l.id.toLowerCase().contains(q) ||
            l.ipAddress.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }
}

/// Dependency Injection container for Administration.
class AdminDependencies {
  static final AdminMockDataSource dataSource = AdminMockDataSource();
  static final AdminRepository repository =
      AdminRepositoryImpl(dataSource: dataSource);

  static final GetSystemHealthUseCase getHealthUseCase =
      GetSystemHealthUseCase(repository);
  static final GetUsersUseCase getUsersUseCase =
      GetUsersUseCase(repository);
  static final UpdateUserStatusUseCase updateUserStatusUseCase =
      UpdateUserStatusUseCase(repository);
  static final GetAdminRescueTeamsUseCase getTeamsUseCase =
      GetAdminRescueTeamsUseCase(repository);
  static final GetDevicesUseCase getDevicesUseCase =
      GetDevicesUseCase(repository);
  static final GetNotificationsUseCase getNotificationsUseCase =
      GetNotificationsUseCase(repository);
  static final ManageNotificationsUseCase manageNotificationsUseCase =
      ManageNotificationsUseCase(repository);
  static final GetAuditLogsUseCase getAuditLogsUseCase =
      GetAuditLogsUseCase(repository);
  static final ManageSettingsUseCase manageSettingsUseCase =
      ManageSettingsUseCase(repository);
  static final ManageBackupsUseCase manageBackupsUseCase =
      ManageBackupsUseCase(repository);
  static final BackupRestoreService backupService = BackupRestoreService();

  static final AdminNotifier notifier = AdminNotifier(
    getHealthUseCase: getHealthUseCase,
    getUsersUseCase: getUsersUseCase,
    updateUserStatusUseCase: updateUserStatusUseCase,
    getTeamsUseCase: getTeamsUseCase,
    getDevicesUseCase: getDevicesUseCase,
    getNotificationsUseCase: getNotificationsUseCase,
    manageNotificationsUseCase: manageNotificationsUseCase,
    getAuditLogsUseCase: getAuditLogsUseCase,
    manageSettingsUseCase: manageSettingsUseCase,
    manageBackupsUseCase: manageBackupsUseCase,
    backupService: backupService,
  );
}
