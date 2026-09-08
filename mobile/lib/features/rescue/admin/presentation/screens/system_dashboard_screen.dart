import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';
import '../providers/admin_provider.dart';
import '../providers/admin_state.dart';
import '../widgets/system_health_card.dart';
import '../widgets/admin_stat_tile.dart';
import '../widgets/admin_skeleton_loader.dart';
import '../widgets/admin_empty_view.dart';
import 'user_management_screen.dart';
import 'admin_team_management_screen.dart';
import 'device_management_screen.dart';
import 'notification_center_screen.dart';
import 'audit_logs_screen.dart';
import 'application_settings_screen.dart';
import 'backup_restore_screen.dart';
import 'monitoring_dashboard_screen.dart';
import 'about_system_screen.dart';

/// Central Administration & System Command Dashboard.
class SystemDashboardScreen extends StatefulWidget {
  const SystemDashboardScreen({super.key});

  @override
  State<SystemDashboardScreen> createState() => _SystemDashboardScreenState();
}

class _SystemDashboardScreenState extends State<SystemDashboardScreen> {
  final _notifier = AdminDependencies.notifier;

  @override
  void initState() {
    super.initState();
    if (_notifier.state.status == AdminViewStatus.initial) {
      _notifier.loadAdminData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;

        return Scaffold(
          appBar: AppBar(
            title: const Text('System Administration'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.description_outlined),
                tooltip: 'Diagnostic Report',
                onPressed: () => _showDiagnosticReport(context),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Refresh Status',
                onPressed: () => _notifier.refresh(),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AdminState state) {
    if (state.status == AdminViewStatus.loading && state.allUsers.isEmpty) {
      return const AdminSkeletonLoader(itemCount: 5);
    }

    if (state.status == AdminViewStatus.error && state.allUsers.isEmpty) {
      return AdminEmptyView(
        title: 'Error Loading System Status',
        message: state.errorMessage ?? 'Unable to connect to administration core.',
        icon: Icons.error_outline_rounded,
        actionLabel: 'Retry Connection',
        onAction: () => _notifier.refresh(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _notifier.refresh(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. System Health Telemetry Card
          SystemHealthCard(
            health: state.health,
            onRefresh: () => _notifier.refresh(),
          ),
          const SizedBox(height: 16),

          // 2. Management Hubs Grid
          _buildManagementSection(context, state),
          const SizedBox(height: 16),

          // 3. Operational Settings & Diagnostics
          _buildUtilitySection(context, state),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildManagementSection(BuildContext context, AdminState state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Command & Operations Management',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: AdminStatTile(
                title: 'User RBAC',
                value: '${state.allUsers.length} Users',
                icon: Icons.badge_outlined,
                color: Colors.blueAccent,
                onTap: () => _navigate(const UserManagementScreen()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AdminStatTile(
                title: 'Rescue Squads',
                value: '${state.allTeams.length} Squads',
                icon: Icons.groups_rounded,
                color: Colors.purpleAccent,
                onTap: () => _navigate(const AdminTeamManagementScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AdminStatTile(
                title: 'Hardware Nodes',
                value: '${state.allDevices.length} Devices',
                icon: Icons.devices_other_rounded,
                color: Colors.teal,
                onTap: () => _navigate(const DeviceManagementScreen()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AdminStatTile(
                title: 'Notification Alert',
                value: '${state.unreadNotificationCount} Unread',
                icon: Icons.notifications_active_outlined,
                color: Colors.redAccent,
                onTap: () => _navigate(const NotificationCenterScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AdminStatTile(
                title: 'Audit Trail Logs',
                value: '${state.allAuditLogs.length} Events',
                icon: Icons.receipt_long_rounded,
                color: Colors.orangeAccent,
                onTap: () => _navigate(const AuditLogsScreen()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AdminStatTile(
                title: 'Live Monitoring',
                value: '${state.health.apiLatencyMs}ms Latency',
                icon: Icons.monitor_heart_outlined,
                color: Colors.cyan,
                onTap: () => _navigate(const MonitoringDashboardScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUtilitySection(BuildContext context, AdminState state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuration & Utilities',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: AdminStatTile(
                title: 'App Settings',
                value: 'Preferences',
                icon: Icons.settings_rounded,
                color: Colors.indigoAccent,
                onTap: () => _navigate(const ApplicationSettingsScreen()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AdminStatTile(
                title: 'Backup & Restore',
                value: '${state.backups.length} Snapshots',
                icon: Icons.cloud_sync_rounded,
                color: Colors.amber.shade800,
                onTap: () => _navigate(const BackupRestoreScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AdminStatTile(
          title: 'System & Legal Information',
          value: 'ResQLink AI v${state.health.appVersion}',
          icon: Icons.info_outline_rounded,
          color: Colors.blueGrey,
          onTap: () => _navigate(const AboutSystemScreen()),
        ),
      ],
    );
  }

  void _showDiagnosticReport(BuildContext context) {
    final report = _notifier.generateDiagnosticReport();
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'System Diagnostic Telemetry',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Text(
                          report,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Diagnostic dump exported to secure log.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.file_download_done_rounded),
                      label: const Text('Export Diagnostic File'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigate(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
