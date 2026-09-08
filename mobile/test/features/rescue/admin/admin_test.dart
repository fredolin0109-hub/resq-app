import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/rescue/admin/data/datasources/admin_mock_datasource.dart';
import '../../../../lib/features/rescue/admin/data/models/admin_models.dart';
import '../../../../lib/features/rescue/admin/data/repositories/admin_repository_impl.dart';
import '../../../../lib/features/rescue/admin/domain/entities/admin_entities.dart';
import '../../../../lib/features/rescue/admin/domain/usecases/admin_usecases.dart';
import '../../../../lib/features/rescue/admin/presentation/providers/admin_provider.dart';
import '../../../../lib/features/rescue/admin/presentation/providers/admin_state.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/about_system_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/admin_team_management_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/application_settings_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/audit_logs_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/backup_restore_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/device_management_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/monitoring_dashboard_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/notification_center_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/system_dashboard_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/screens/user_management_screen.dart';
import '../../../../lib/features/rescue/admin/presentation/widgets/admin_stat_tile.dart';
import '../../../../lib/features/rescue/admin/presentation/widgets/admin_team_card.dart';
import '../../../../lib/features/rescue/admin/presentation/widgets/audit_log_card.dart';
import '../../../../lib/features/rescue/admin/presentation/widgets/device_card.dart';
import '../../../../lib/features/rescue/admin/presentation/widgets/metric_gauge_card.dart';
import '../../../../lib/features/rescue/admin/presentation/widgets/notification_item_card.dart';
import '../../../../lib/features/rescue/admin/presentation/widgets/system_health_card.dart';
import '../../../../lib/features/rescue/admin/presentation/widgets/user_card.dart';
import '../../../../lib/features/rescue/admin/services/backup_restore_service.dart';

void main() {
  group('Admin Domain & Model Serialization Tests', () {
    test('AdminUserModel JSON serialization test', () {
      final now = DateTime.now();
      final model = AdminUserModel(
        id: 'USR-101',
        name: 'Aarav Ramaraj',
        role: UserRole.superAdmin,
        department: 'TNSDMA',
        district: 'Chennai',
        phone: '+91 9840000001',
        email: 'aarav.ramaraj@resqlink.tn.gov.in',
        status: UserStatus.active,
        lastLogin: now,
        permissions: const ['ALL_PERMISSIONS', 'SYSTEM_CONFIG'],
      );

      final json = model.toJson();
      expect(json['id'], 'USR-101');
      expect(json['role'], UserRole.superAdmin.index);

      final deserialized = AdminUserModel.fromJson(json);
      expect(deserialized.id, 'USR-101');
      expect(deserialized.role, UserRole.superAdmin);
      expect(deserialized.permissions.length, 2);
    });

    test('AdminRescueTeamModel JSON serialization test', () {
      const team = AdminRescueTeamModel(
        teamId: 'TEAM-201',
        teamName: 'Alpha Flood Squad 1',
        leaderName: 'Commander Ramesh',
        memberCount: 8,
        vehicleCount: 3,
        currentMission: 'Chennai Flood Relief',
        isAvailable: false,
        performanceScore: 96.5,
        district: 'Chennai',
      );

      final json = team.toJson();
      expect(json['teamId'], 'TEAM-201');
      expect(json['isAvailable'], false);

      final deserialized = AdminRescueTeamModel.fromJson(json);
      expect(deserialized.teamName, 'Alpha Flood Squad 1');
      expect(deserialized.isAvailable, false);
      expect(deserialized.performanceScore, 96.5);
    });

    test('ManagedDeviceModel JSON serialization test', () {
      final now = DateTime.now();
      final dev = ManagedDeviceModel(
        id: 'DEV-301',
        name: 'BLE Mesh Node #1',
        type: DeviceType.bleMeshNode,
        pairedTeam: 'Alpha Squad',
        batteryPercent: 88,
        signalStrengthDbm: -55.0,
        isConnected: true,
        lastSync: now,
        mapCacheMb: 256.0,
        offlineStorageMb: 512.0,
        firmwareVersion: 'v2.4.1',
      );

      final json = dev.toJson();
      expect(json['id'], 'DEV-301');
      expect(json['type'], DeviceType.bleMeshNode.index);

      final deserialized = ManagedDeviceModel.fromJson(json);
      expect(deserialized.name, 'BLE Mesh Node #1');
      expect(deserialized.batteryPercent, 88);
      expect(deserialized.isConnected, true);
    });

    test('AdminNotificationModel JSON serialization test', () {
      final now = DateTime.now();
      final notif = AdminNotificationModel(
        id: 'NOTIF-1001',
        title: 'Critical SOS Broadcast Initiated',
        message: 'High priority alert',
        category: NotificationCategory.sosAlert,
        timestamp: now,
        isRead: false,
      );

      final json = notif.toJson();
      expect(json['id'], 'NOTIF-1001');

      final deserialized = AdminNotificationModel.fromJson(json);
      expect(deserialized.title, 'Critical SOS Broadcast Initiated');
      expect(deserialized.category, NotificationCategory.sosAlert);
      expect(deserialized.isRead, false);
    });

    test('AuditLogItemModel JSON serialization test', () {
      final now = DateTime.now();
      final log = AuditLogItemModel(
        id: 'LOG-5001',
        userId: 'USR-101',
        userName: 'Aarav Ramaraj',
        actionType: AuditActionType.userLogin,
        details: 'User authenticated via 2FA',
        ipAddress: '192.168.1.10',
        timestamp: now,
        isSuccess: true,
      );

      final json = log.toJson();
      expect(json['id'], 'LOG-5001');
      expect(json['isSuccess'], true);

      final deserialized = AuditLogItemModel.fromJson(json);
      expect(deserialized.userName, 'Aarav Ramaraj');
      expect(deserialized.actionType, AuditActionType.userLogin);
    });
  });

  group('Data Source & Repository Integration Tests', () {
    late AdminMockDataSource dataSource;
    late AdminRepositoryImpl repository;

    setUp(() {
      dataSource = AdminMockDataSource();
      repository = AdminRepositoryImpl(dataSource: dataSource);
    });

    test('Mock data source populates 50 users, 20 squads, 25 devices, 200 notifications, 100 audit logs', () async {
      final users = await repository.getUsers();
      expect(users.length, 50);

      final teams = await repository.getRescueTeams();
      expect(teams.length, 20);

      final devices = await repository.getDevices();
      expect(devices.length, 25);

      final notifications = await repository.getNotifications();
      expect(notifications.length, 200);

      final auditLogs = await repository.getAuditLogs();
      expect(auditLogs.length, 100);

      final health = await repository.getSystemHealth();
      expect(health.systemStatus, 'Operational');
      expect(health.isApiHealthy, true);
    });

    test('User status update persists successfully', () async {
      final updated = await repository.updateUserStatus('USR-102', UserStatus.suspended);
      expect(updated.status, UserStatus.suspended);

      final fetched = await repository.getUsers();
      final target = fetched.firstWhere((u) => u.id == 'USR-102');
      expect(target.status, UserStatus.suspended);
    });

    test('Notification mark read operations function properly', () async {
      await repository.markNotificationRead('NOTIF-1001');
      final notifs = await repository.getNotifications();
      final target = notifs.firstWhere((n) => n.id == 'NOTIF-1001');
      expect(target.isRead, true);

      await repository.markAllNotificationsRead();
      final unread = await repository.getNotifications(unreadOnly: true);
      expect(unread.isEmpty, true);
    });
  });

  group('Backup, Settings & Diagnostic Service Tests', () {
    test('BackupRestoreService export and import JSON accurately', () {
      final service = BackupRestoreService();
      const settings = ApplicationSettings(
        themeMode: 'light',
        language: 'ta',
        notificationsEnabled: true,
        offlineModeForced: true,
        mapCacheLimitMb: 1024,
      );

      final jsonStr = service.exportSettingsJson(settings);
      expect(jsonStr.contains('light'), true);
      expect(jsonStr.contains('ta'), true);

      final imported = service.importSettingsJson(jsonStr);
      expect(imported.themeMode, 'light');
      expect(imported.language, 'ta');
      expect(imported.offlineModeForced, true);
      expect(imported.mapCacheLimitMb, 1024);
    });

    test('Diagnostic report contains system health dump', () {
      final service = BackupRestoreService();
      const health = SystemHealthMetrics(
        systemStatus: 'Operational',
        isApiHealthy: true,
        apiLatencyMs: 42,
        isDatabaseConnected: true,
        isBleServiceActive: true,
        isGpsLocked: true,
        isInternetConnected: true,
        storageUsedGb: 20.0,
        storageTotalGb: 64.0,
        memoryUsageMb: 1400.0,
        memoryTotalMb: 4096.0,
        cpuLoadPercent: 30.0,
        batteryPercent: 85,
        isCharging: false,
        appVersion: 'v2.4.0',
        buildNumber: '2405',
        syncQueueLength: 2,
        crashReportsCount: 0,
      );

      final report = service.generateSystemDiagnosticReport(
        health: health,
        settings: const ApplicationSettings(),
        totalUsers: 50,
        totalTeams: 20,
        totalDevices: 25,
        unreadAlerts: 10,
      );

      expect(report.contains('RESQLINK AI RESCUE SYSTEM DIAGNOSTIC DUMP'), true);
      expect(report.contains('OPERATIONAL'), true);
      expect(report.contains('50 users'), true);
    });
  });

  group('Presentation Provider State Tests', () {
    late AdminNotifier notifier;

    setUp(() {
      notifier = AdminDependencies.notifier;
    });

    test('loadAdminData populates state and filter mutations work', () async {
      await notifier.loadAdminData();
      expect(notifier.state.status, AdminViewStatus.loaded);
      expect(notifier.state.allUsers.length, 50);
      expect(notifier.state.allTeams.length, 20);
      expect(notifier.state.allDevices.length, 25);
      expect(notifier.state.allNotifications.length, 200);
      expect(notifier.state.allAuditLogs.length, 100);

      // Filter by user role
      notifier.setUserRole(UserRole.paramedic);
      expect(notifier.state.filteredUsers.every((u) => u.role == UserRole.paramedic), true);

      // Clear filters
      notifier.clearUserFilters();
      expect(notifier.state.filteredUsers.length, 50);
    });
  });

  group('Admin UI Widgets & Screens Tests', () {
    testWidgets('SystemHealthCard renders telemetry values', (tester) async {
      const health = SystemHealthMetrics(
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

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SystemHealthCard(health: health),
          ),
        ),
      );

      expect(find.text('OPERATIONAL'), findsOneWidget);
      expect(find.text('API Core'), findsOneWidget);
      expect(find.text('38ms'), findsOneWidget);
      expect(find.text('GNSS / GPS'), findsOneWidget);
    });

    testWidgets('AdminStatTile renders title and value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdminStatTile(
              title: 'Registered Users',
              value: '50 Users',
              icon: Icons.people_outline,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('50 Users'), findsOneWidget);
      expect(find.text('Registered Users'), findsOneWidget);
    });

    testWidgets('UserCard renders user identity and status', (tester) async {
      final user = AdminUser(
        id: 'USR-101',
        name: 'Aarav Ramaraj',
        role: UserRole.superAdmin,
        department: 'TNSDMA',
        district: 'Chennai',
        phone: '+91 9840000001',
        email: 'aarav@resqlink.tn.gov.in',
        status: UserStatus.active,
        lastLogin: DateTime.now(),
        permissions: const ['ALL_PERMISSIONS'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserCard(user: user),
          ),
        ),
      );

      expect(find.text('Aarav Ramaraj'), findsOneWidget);
      expect(find.text('Super Admin'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('AdminTeamCard renders team information', (tester) async {
      const team = AdminRescueTeam(
        teamId: 'TEAM-201',
        teamName: 'Alpha Flood Squad 1',
        leaderName: 'Commander Ramesh',
        memberCount: 8,
        vehicleCount: 3,
        currentMission: 'Chennai Standby',
        isAvailable: true,
        performanceScore: 94.2,
        district: 'Chennai',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdminTeamCard(team: team),
          ),
        ),
      );

      expect(find.text('Alpha Flood Squad 1'), findsOneWidget);
      expect(find.text('Leader: Commander Ramesh'), findsOneWidget);
      expect(find.text('AVAILABLE'), findsOneWidget);
      expect(find.text('94.2'), findsOneWidget);
    });

    testWidgets('DeviceCard renders device metadata', (tester) async {
      final dev = ManagedDevice(
        id: 'DEV-301',
        name: 'BLE Mesh Node #1',
        type: DeviceType.bleMeshNode,
        pairedTeam: 'Alpha Squad',
        batteryPercent: 88,
        signalStrengthDbm: -55.0,
        isConnected: true,
        lastSync: DateTime.now(),
        mapCacheMb: 256.0,
        offlineStorageMb: 512.0,
        firmwareVersion: 'v2.4.1',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeviceCard(device: dev),
          ),
        ),
      );

      expect(find.text('BLE Mesh Node #1'), findsOneWidget);
      expect(find.text('ONLINE'), findsOneWidget);
      expect(find.text('88%'), findsOneWidget);
    });

    testWidgets('SystemDashboardScreen mounts and displays telemetry', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SystemDashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('System Administration'), findsOneWidget);
      expect(find.text('Command & Operations Management'), findsOneWidget);
    });

    testWidgets('AboutSystemScreen mounts and displays versioning info', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutSystemScreen(),
        ),
      );

      expect(find.text('About ResQLink AI'), findsOneWidget);
      expect(find.text('ResQLink AI'), findsOneWidget);
      expect(find.textContaining('Version 2.4.0'), findsOneWidget);
    });
  });
}
