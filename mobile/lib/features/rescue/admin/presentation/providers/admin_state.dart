import '../../domain/entities/admin_entities.dart';

enum AdminViewStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// User filter options.
class UserFilterOptions {
  final String searchQuery;
  final UserRole? role;
  final UserStatus? status;
  final String district;

  const UserFilterOptions({
    this.searchQuery = '',
    this.role,
    this.status,
    this.district = 'All',
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      role != null ||
      status != null ||
      district != 'All';

  UserFilterOptions copyWith({
    String? searchQuery,
    UserRole? role,
    UserStatus? status,
    String? district,
    bool clearRole = false,
    bool clearStatus = false,
  }) {
    return UserFilterOptions(
      searchQuery: searchQuery ?? this.searchQuery,
      role: clearRole ? null : (role ?? this.role),
      status: clearStatus ? null : (status ?? this.status),
      district: district ?? this.district,
    );
  }
}

/// Rescue team filter options.
class AdminTeamFilterOptions {
  final String searchQuery;
  final String district;
  final bool? availableOnly;

  const AdminTeamFilterOptions({
    this.searchQuery = '',
    this.district = 'All',
    this.availableOnly,
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || district != 'All' || availableOnly != null;

  AdminTeamFilterOptions copyWith({
    String? searchQuery,
    String? district,
    bool? availableOnly,
    bool clearAvailable = false,
  }) {
    return AdminTeamFilterOptions(
      searchQuery: searchQuery ?? this.searchQuery,
      district: district ?? this.district,
      availableOnly: clearAvailable ? null : (availableOnly ?? this.availableOnly),
    );
  }
}

/// Device filter options.
class DeviceFilterOptions {
  final String searchQuery;
  final DeviceType? type;
  final bool? connectedOnly;

  const DeviceFilterOptions({
    this.searchQuery = '',
    this.type,
    this.connectedOnly,
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || type != null || connectedOnly != null;

  DeviceFilterOptions copyWith({
    String? searchQuery,
    DeviceType? type,
    bool? connectedOnly,
    bool clearType = false,
    bool clearConnected = false,
  }) {
    return DeviceFilterOptions(
      searchQuery: searchQuery ?? this.searchQuery,
      type: clearType ? null : (type ?? this.type),
      connectedOnly:
          clearConnected ? null : (connectedOnly ?? this.connectedOnly),
    );
  }
}

/// Notification filter options.
class NotificationFilterOptions {
  final NotificationCategory? category;
  final bool unreadOnly;

  const NotificationFilterOptions({
    this.category,
    this.unreadOnly = false,
  });

  bool get hasActiveFilters => category != null || unreadOnly;

  NotificationFilterOptions copyWith({
    NotificationCategory? category,
    bool? unreadOnly,
    bool clearCategory = false,
  }) {
    return NotificationFilterOptions(
      category: clearCategory ? null : (category ?? this.category),
      unreadOnly: unreadOnly ?? this.unreadOnly,
    );
  }
}

/// Audit log filter options.
class AuditLogFilterOptions {
  final AuditActionType? actionType;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;

  const AuditLogFilterOptions({
    this.actionType,
    this.searchQuery = '',
    this.startDate,
    this.endDate,
  });

  bool get hasActiveFilters =>
      actionType != null ||
      searchQuery.isNotEmpty ||
      startDate != null ||
      endDate != null;

  AuditLogFilterOptions copyWith({
    AuditActionType? actionType,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    bool clearAction = false,
    bool clearDates = false,
  }) {
    return AuditLogFilterOptions(
      actionType: clearAction ? null : (actionType ?? this.actionType),
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
    );
  }
}

/// Master immutable state for Administration, Monitoring & Settings.
class AdminState {
  final AdminViewStatus status;
  final String? errorMessage;
  final SystemHealthMetrics health;
  final ApplicationSettings settings;
  final List<AdminUser> allUsers;
  final List<AdminUser> filteredUsers;
  final UserFilterOptions userFilters;
  final List<AdminRescueTeam> allTeams;
  final List<AdminRescueTeam> filteredTeams;
  final AdminTeamFilterOptions teamFilters;
  final List<ManagedDevice> allDevices;
  final List<ManagedDevice> filteredDevices;
  final DeviceFilterOptions deviceFilters;
  final List<AdminNotification> allNotifications;
  final List<AdminNotification> filteredNotifications;
  final NotificationFilterOptions notificationFilters;
  final List<AuditLogItem> allAuditLogs;
  final List<AuditLogItem> filteredAuditLogs;
  final AuditLogFilterOptions auditFilters;
  final List<BackupSnapshot> backups;
  final bool isCreatingBackup;
  final bool isRestoringBackup;

  const AdminState({
    required this.status,
    this.errorMessage,
    required this.health,
    required this.settings,
    required this.allUsers,
    required this.filteredUsers,
    required this.userFilters,
    required this.allTeams,
    required this.filteredTeams,
    required this.teamFilters,
    required this.allDevices,
    required this.filteredDevices,
    required this.deviceFilters,
    required this.allNotifications,
    required this.filteredNotifications,
    required this.notificationFilters,
    required this.allAuditLogs,
    required this.filteredAuditLogs,
    required this.auditFilters,
    required this.backups,
    required this.isCreatingBackup,
    required this.isRestoringBackup,
  });

  factory AdminState.initial() {
    return const AdminState(
      status: AdminViewStatus.initial,
      errorMessage: null,
      health: SystemHealthMetrics(
        systemStatus: 'Operational',
        isApiHealthy: true,
        apiLatencyMs: 35,
        isDatabaseConnected: true,
        isBleServiceActive: true,
        isGpsLocked: true,
        isInternetConnected: true,
        storageUsedGb: 18.4,
        storageTotalGb: 64.0,
        memoryUsageMb: 1240.0,
        memoryTotalMb: 4096.0,
        cpuLoadPercent: 24.5,
        batteryPercent: 92,
        isCharging: true,
        appVersion: 'v2.4.0',
        buildNumber: '2405',
        syncQueueLength: 3,
        crashReportsCount: 0,
      ),
      settings: ApplicationSettings(),
      allUsers: [],
      filteredUsers: [],
      userFilters: UserFilterOptions(),
      allTeams: [],
      filteredTeams: [],
      teamFilters: AdminTeamFilterOptions(),
      allDevices: [],
      filteredDevices: [],
      deviceFilters: DeviceFilterOptions(),
      allNotifications: [],
      filteredNotifications: [],
      notificationFilters: NotificationFilterOptions(),
      allAuditLogs: [],
      filteredAuditLogs: [],
      auditFilters: AuditLogFilterOptions(),
      backups: [],
      isCreatingBackup: false,
      isRestoringBackup: false,
    );
  }

  int get unreadNotificationCount =>
      allNotifications.where((n) => !n.isRead).length;

  AdminState copyWith({
    AdminViewStatus? status,
    String? errorMessage,
    SystemHealthMetrics? health,
    ApplicationSettings? settings,
    List<AdminUser>? allUsers,
    List<AdminUser>? filteredUsers,
    UserFilterOptions? userFilters,
    List<AdminRescueTeam>? allTeams,
    List<AdminRescueTeam>? filteredTeams,
    AdminTeamFilterOptions? teamFilters,
    List<ManagedDevice>? allDevices,
    List<ManagedDevice>? filteredDevices,
    DeviceFilterOptions? deviceFilters,
    List<AdminNotification>? allNotifications,
    List<AdminNotification>? filteredNotifications,
    NotificationFilterOptions? notificationFilters,
    List<AuditLogItem>? allAuditLogs,
    List<AuditLogItem>? filteredAuditLogs,
    AuditLogFilterOptions? auditFilters,
    List<BackupSnapshot>? backups,
    bool? isCreatingBackup,
    bool? isRestoringBackup,
  }) {
    return AdminState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      health: health ?? this.health,
      settings: settings ?? this.settings,
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      userFilters: userFilters ?? this.userFilters,
      allTeams: allTeams ?? this.allTeams,
      filteredTeams: filteredTeams ?? this.filteredTeams,
      teamFilters: teamFilters ?? this.teamFilters,
      allDevices: allDevices ?? this.allDevices,
      filteredDevices: filteredDevices ?? this.filteredDevices,
      deviceFilters: deviceFilters ?? this.deviceFilters,
      allNotifications: allNotifications ?? this.allNotifications,
      filteredNotifications:
          filteredNotifications ?? this.filteredNotifications,
      notificationFilters: notificationFilters ?? this.notificationFilters,
      allAuditLogs: allAuditLogs ?? this.allAuditLogs,
      filteredAuditLogs: filteredAuditLogs ?? this.filteredAuditLogs,
      auditFilters: auditFilters ?? this.auditFilters,
      backups: backups ?? this.backups,
      isCreatingBackup: isCreatingBackup ?? this.isCreatingBackup,
      isRestoringBackup: isRestoringBackup ?? this.isRestoringBackup,
    );
  }
}
