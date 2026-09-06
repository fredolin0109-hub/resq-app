import 'dart:math';
import '../models/admin_models.dart';
import '../../domain/entities/admin_entities.dart';

/// Comprehensive mock data provider for Administration, Monitoring & Management.
/// Populates 50 Users, 20 Rescue Teams, 25 Devices, 200 Notifications, 100 Audit Logs.
class AdminMockDataSource {
  static final AdminMockDataSource _instance = AdminMockDataSource._internal();
  factory AdminMockDataSource() => _instance;

  AdminMockDataSource._internal() {
    _initializeData();
  }

  static const List<String> tnDistricts = [
    'Chennai',
    'Cuddalore',
    'Nagapattinam',
    'Tirunelveli',
    'Thoothukudi',
    'Madurai',
    'Coimbatore',
    'Salem',
    'Tiruchirappalli',
    'Vellore',
    'Thanjavur',
    'Erode',
    'Kanyakumari',
  ];

  late final List<AdminUserModel> _users;
  late final List<AdminRescueTeamModel> _teams;
  late final List<ManagedDeviceModel> _devices;
  late final List<AdminNotificationModel> _notifications;
  late final List<AuditLogItemModel> _auditLogs;
  late final List<BackupSnapshotModel> _backups;
  late ApplicationSettings _settings;
  late SystemHealthMetrics _systemHealth;

  void _initializeData() {
    final random = Random(101);
    final now = DateTime.now();

    // 1. Generate 50 Users
    final firstNames = [
      'Aarav', 'Ananya', 'Karthik', 'Divya', 'Vikram', 'Pooja', 'Sundar', 'Sneha',
      'Ramesh', 'Priya', 'Vignesh', 'Deepa', 'Arvind', 'Revathi', 'Balaji', 'Swathi',
      'Saravanan', 'Meera', 'Vijay', 'Nandhini', 'Manoj', 'Kavitha', 'Dinesh', 'Pavithra',
      'Ganesh', 'Sowmya', 'Suresh', 'Bhavani', 'Rajesh', 'Harini', 'Praveen', 'Lakshmi',
      'Ashok', 'Gayathri', 'Manikandan', 'Abirami', 'Senthil', 'Keerthana', 'Muthu', 'Janani',
    ];
    final lastNames = [
      'Ramaraj', 'Kumar', 'Sundaram', 'Natarajan', 'Krishnan', 'Subramanian',
      'Venkatesh', 'Iyer', 'Murugan', 'Pandian', 'Ganesan', 'Chettiar', 'Selvam',
    ];
    final departments = [
      'State Disaster Management Authority (TNSDMA)',
      'National Disaster Response Force (NDRF 04 BN)',
      'Tamil Nadu Fire & Rescue Services (TNFRS)',
      'Department of Health & Family Welfare',
      'Coastal Marine Police & Coast Guard Wing',
      'State Emergency Operations Centre (SEOC)',
      'Aviation & Drone Reconnaissance Unit',
    ];

    _users = [];
    for (int i = 1; i <= 50; i++) {
      final id = 'USR-${(100 + i).toString()}';
      final fn = firstNames[i % firstNames.length];
      final ln = lastNames[i % lastNames.length];
      final name = '$fn $ln';
      final role = i == 1
          ? UserRole.superAdmin
          : UserRole.values[(i - 1) % (UserRole.values.length)];
      final dept = departments[i % departments.length];
      final dist = tnDistricts[i % tnDistricts.length];
      final phone = '+91 98${(40000000 + i * 12345).toString().substring(0, 8)}';
      final email = '${fn.toLowerCase()}.${ln.toLowerCase()}@resqlink.tn.gov.in';
      final status = i % 8 == 0
          ? UserStatus.suspended
          : i % 6 == 0
              ? UserStatus.pendingVerification
              : i % 4 == 0
                  ? UserStatus.offDuty
                  : i % 3 == 0
                      ? UserStatus.onDuty
                      : UserStatus.active;

      final lastLogin = now.subtract(Duration(
        hours: random.nextInt(72),
        minutes: random.nextInt(60),
      ));

      final permissions = _getPermissionsForRole(role);

      _users.add(
        AdminUserModel(
          id: id,
          name: name,
          role: role,
          department: dept,
          district: dist,
          phone: phone,
          email: email,
          status: status,
          lastLogin: lastLogin,
          permissions: permissions,
        ),
      );
    }

    // 2. Generate 20 Rescue Teams
    final squadTypes = [
      'Alpha Flood Evacuation Squad',
      'Bravo Coastal Marine Lifesaving Unit',
      'Charlie Hazardous Material Containment',
      'Delta Urban Search & Rescue Heavy',
      'Echo Heli-Ambulance Air Squad',
      'Foxtrot Rapid Medical Triage Unit',
      'Golf Mountain & Landslide Taskforce',
      'Hotel Heavy Vehicle Recovery Wing',
      'India Drone Recon & Surveillance Fleet',
      'Juliet Tactical Fire & Thermal Relief',
    ];

    _teams = [];
    for (int i = 1; i <= 20; i++) {
      final teamId = 'TEAM-${(200 + i).toString()}';
      final teamName = '${squadTypes[(i - 1) % squadTypes.length]} ${(i % 3) + 1}';
      final leader = _users[i].name;
      final members = 6 + (i % 6);
      final vehicles = 2 + (i % 4);
      final isAvail = i % 3 != 0;
      final dist = tnDistricts[i % tnDistricts.length];
      final mission = isAvail ? 'Standby (Ready for Dispatch)' : 'Active: $dist Flood Relief Sector ${(i % 5) + 1}';
      final score = 88.0 + (random.nextDouble() * 11.5);

      _teams.add(
        AdminRescueTeamModel(
          teamId: teamId,
          teamName: teamName,
          leaderName: leader,
          memberCount: members,
          vehicleCount: vehicles,
          currentMission: mission,
          isAvailable: isAvail,
          performanceScore: double.parse(score.toStringAsFixed(1)),
          district: dist,
        ),
      );
    }

    // 3. Generate 25 Managed Devices
    _devices = [];
    for (int i = 1; i <= 25; i++) {
      final devId = 'DEV-${(300 + i).toString()}';
      final type = DeviceType.values[(i - 1) % DeviceType.values.length];
      final pairedTeam = _teams[i % _teams.length].teamName;
      final battery = 45 + random.nextInt(55);
      final signal = -50.0 - (random.nextDouble() * 40.0);
      final isConn = i % 7 != 0;
      final sync = now.subtract(Duration(minutes: random.nextInt(45)));

      _devices.add(
        ManagedDeviceModel(
          id: devId,
          name: '${type.displayName} Node #$i',
          type: type,
          pairedTeam: pairedTeam,
          batteryPercent: battery,
          signalStrengthDbm: double.parse(signal.toStringAsFixed(1)),
          isConnected: isConn,
          lastSync: sync,
          mapCacheMb: (120.0 + (i * 15)).clamp(50.0, 512.0),
          offlineStorageMb: (240.0 + (i * 25)).clamp(100.0, 1024.0),
          firmwareVersion: 'v2.4.${(i % 5) + 1}',
        ),
      );
    }

    // 4. Generate 200 Notifications
    _notifications = [];
    final titles = [
      'Critical SOS Broadcast Initiated',
      'Air Squad Heli-Rescue Dispatched',
      'Severe Flood Gate Discharge Alert',
      'BLE Mesh Gateway Sync Complete',
      'AI Commander Suggested Asset Reroute',
      'Relief Camp Capacity Exceeded 90%',
      'Ambulance Unit Reached Destination',
      'High Wind Warning Issued (Gale 85 km/h)',
      'Audit Log Auto-Archive Succeeded',
      'Device Offline: Battery Depleted Below 10%',
    ];

    for (int i = 1; i <= 200; i++) {
      final notifId = 'NOTIF-${(1000 + i).toString()}';
      final cat = NotificationCategory.values[i % NotificationCategory.values.length];
      final title = titles[i % titles.length];
      final isRead = i > 25; // 25 unread notifications
      final ts = now.subtract(Duration(minutes: i * 18));

      _notifications.add(
        AdminNotificationModel(
          id: notifId,
          title: '$title #$i',
          message:
              'Official automated broadcast generated by ResQLink Command Core for district ${tnDistricts[i % tnDistricts.length]}. Immediate supervisory monitoring advised.',
          category: cat,
          timestamp: ts,
          isRead: isRead,
          relatedEntityId: 'INC-${1000 + (i % 50)}',
        ),
      );
    }

    // 5. Generate 100 Audit Logs
    _auditLogs = [];
    final detailsTemplates = [
      'User authenticated via biometric 2FA token successfully.',
      'Dispatched emergency mission for flash flood inundation sector.',
      'Updated incident operational status from In-Progress to Resolved.',
      'Allocated 500 First Aid kits and 2 inflatable boats from central depot.',
      'AI Commander queried optimal route through non-waterlogged bypass.',
      'Changed system synchronization interval from 30s to 15s.',
      'Created automated full snapshot backup archive (size 2.4 MB).',
      'BLE hardware peripheral mesh node paired and encryption keys verified.',
    ];

    for (int i = 1; i <= 100; i++) {
      final logId = 'LOG-${(5000 + i).toString()}';
      final user = _users[i % _users.length];
      final action = AuditActionType.values[i % AuditActionType.values.length];
      final detail = detailsTemplates[action.index % detailsTemplates.length];
      final ip = '192.168.1.${10 + (i % 90)}';
      final ts = now.subtract(Duration(minutes: i * 25));

      _auditLogs.add(
        AuditLogItemModel(
          id: logId,
          userId: user.id,
          userName: user.name,
          actionType: action,
          details: detail,
          ipAddress: ip,
          timestamp: ts,
          isSuccess: i % 15 != 0,
        ),
      );
    }

    // 6. Pre-existing Backups
    _backups = [
      BackupSnapshotModel(
        id: 'BCK-2026-0906-01',
        name: 'Daily Operational Full State Backup',
        createdAt: now.subtract(const Duration(hours: 4)),
        sizeKb: 3420,
        recordsCount: 850,
        version: 'v2.4.0-PROD',
      ),
      BackupSnapshotModel(
        id: 'BCK-2026-0901-02',
        name: 'Weekly Disaster Audit & Telemetry Snapshot',
        createdAt: now.subtract(const Duration(days: 5)),
        sizeKb: 8940,
        recordsCount: 2400,
        version: 'v2.3.9-PROD',
      ),
      BackupSnapshotModel(
        id: 'BCK-2026-0825-03',
        name: 'Pre-Monsoon Disaster Preparedness Baseline',
        createdAt: now.subtract(const Duration(days: 12)),
        sizeKb: 14200,
        recordsCount: 5120,
        version: 'v2.3.8-PROD',
      ),
    ];

    // 7. System Health Metrics
    _systemHealth = const SystemHealthMetrics(
      systemStatus: 'Operational',
      isApiHealthy: true,
      apiLatencyMs: 38,
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
    );

    // 8. Application Settings
    _settings = const ApplicationSettings();
  }

  List<String> _getPermissionsForRole(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return [
          'ALL_PERMISSIONS',
          'SYSTEM_CONFIG',
          'USER_MANAGEMENT',
          'SQUAD_DISPATCH',
          'LOGISTICS_ALLOCATE',
          'AUDIT_EXPORT',
          'BACKUP_RESTORE',
        ];
      case UserRole.incidentCommander:
        return [
          'MISSION_COMMAND',
          'SQUAD_DISPATCH',
          'AI_COMMANDER_ACCESS',
          'MAP_OVERLAY_CONTROL',
          'TELEMETRY_MONITOR',
        ];
      case UserRole.fieldLeader:
        return [
          'SQUAD_TELEMETRY',
          'INCIDENT_STATUS_UPDATE',
          'BLE_MESH_SYNC',
          'MAP_OFFLINE_ACCESS',
        ];
      case UserRole.paramedic:
        return [
          'TRIAGE_STATUS_UPDATE',
          'MEDICAL_INVENTORY_REPORT',
          'PATIENT_VITALS_LOG',
        ];
      case UserRole.logisticsCoordinator:
        return [
          'RESOURCE_DISPATCH',
          'SHELTER_CAPACITY_UPDATE',
          'SUPPLY_CHAIN_MONITOR',
        ];
      case UserRole.reconSpecialist:
        return [
          'DRONE_STREAM_BROADCAST',
          'HAZARD_PINPOINT',
          'INFRASTRUCTURE_ASSESS',
        ];
      case UserRole.volunteer:
        return [
          'VIEW_ASSIGNED_MISSION',
          'OFFLINE_SOS_BEACON',
        ];
    }
  }

  // --- Public APIs ---

  Future<SystemHealthMetrics> getSystemHealth() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _systemHealth;
  }

  Future<List<AdminUserModel>> getUsers({
    String? searchQuery,
    UserRole? role,
    UserStatus? status,
    String? district,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _users.where((user) {
      if (role != null && user.role != role) return false;
      if (status != null && user.status != status) return false;
      if (district != null && district != 'All' && user.district != district) {
        return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final match = user.name.toLowerCase().contains(q) ||
            user.id.toLowerCase().contains(q) ||
            user.email.toLowerCase().contains(q) ||
            user.department.toLowerCase().contains(q) ||
            user.district.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Future<AdminUserModel> updateUserStatus(String userId, UserStatus status) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final old = _users[index];
      final updated = AdminUserModel(
        id: old.id,
        name: old.name,
        role: old.role,
        department: old.department,
        district: old.district,
        phone: old.phone,
        email: old.email,
        status: status,
        lastLogin: old.lastLogin,
        permissions: old.permissions,
      );
      _users[index] = updated;
      return updated;
    }
    throw Exception('User $userId not found');
  }

  Future<List<AdminRescueTeamModel>> getRescueTeams({
    String? searchQuery,
    String? district,
    bool? availableOnly,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _teams.where((team) {
      if (district != null && district != 'All' && team.district != district) {
        return false;
      }
      if (availableOnly == true && !team.isAvailable) return false;
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final match = team.teamName.toLowerCase().contains(q) ||
            team.leaderName.toLowerCase().contains(q) ||
            team.teamId.toLowerCase().contains(q) ||
            team.district.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Future<List<ManagedDeviceModel>> getDevices({
    String? searchQuery,
    DeviceType? type,
    bool? connectedOnly,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _devices.where((dev) {
      if (type != null && dev.type != type) return false;
      if (connectedOnly == true && !dev.isConnected) return false;
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final match = dev.name.toLowerCase().contains(q) ||
            dev.id.toLowerCase().contains(q) ||
            dev.pairedTeam.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Future<List<AdminNotificationModel>> getNotifications({
    NotificationCategory? category,
    bool? unreadOnly,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _notifications.where((n) {
      if (category != null && n.category != category) return false;
      if (unreadOnly == true && n.isRead) return false;
      return true;
    }).toList();
  }

  Future<void> markNotificationRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = _notifications[index];
      _notifications[index] = AdminNotificationModel(
        id: old.id,
        title: old.title,
        message: old.message,
        category: old.category,
        timestamp: old.timestamp,
        isRead: true,
        relatedEntityId: old.relatedEntityId,
      );
    }
  }

  Future<void> markAllNotificationsRead() async {
    await Future.delayed(const Duration(milliseconds: 150));
    for (int i = 0; i < _notifications.length; i++) {
      final old = _notifications[i];
      if (!old.isRead) {
        _notifications[i] = AdminNotificationModel(
          id: old.id,
          title: old.title,
          message: old.message,
          category: old.category,
          timestamp: old.timestamp,
          isRead: true,
          relatedEntityId: old.relatedEntityId,
        );
      }
    }
  }

  Future<void> clearNotifications() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _notifications.clear();
  }

  Future<List<AuditLogItemModel>> getAuditLogs({
    AuditActionType? actionType,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _auditLogs.where((log) {
      if (actionType != null && log.actionType != actionType) return false;
      if (startDate != null && log.timestamp.isBefore(startDate)) return false;
      if (endDate != null && log.timestamp.isAfter(endDate)) return false;
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final match = log.userName.toLowerCase().contains(q) ||
            log.details.toLowerCase().contains(q) ||
            log.id.toLowerCase().contains(q) ||
            log.ipAddress.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Future<ApplicationSettings> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _settings;
  }

  Future<ApplicationSettings> updateSettings(ApplicationSettings settings) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _settings = settings;
    return _settings;
  }

  Future<List<BackupSnapshotModel>> getBackups() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_backups);
  }

  Future<BackupSnapshotModel> createBackup(String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final id = 'BCK-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final newBackup = BackupSnapshotModel(
      id: id,
      name: name.trim().isEmpty ? 'Manual Snapshot Backup' : name,
      createdAt: DateTime.now(),
      sizeKb: 4280,
      recordsCount: _users.length + _teams.length + _devices.length + _auditLogs.length,
      version: 'v2.4.0-PROD',
    );
    _backups.insert(0, newBackup);
    return newBackup;
  }

  Future<bool> restoreBackup(String backupId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  Future<bool> resetToDefaults() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _settings = const ApplicationSettings();
    return true;
  }
}
