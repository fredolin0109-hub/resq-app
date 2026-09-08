import 'package:flutter/material.dart';

// Real Feature Screens from all 11 Rescue Submodules
import '../../admin/presentation/screens/about_system_screen.dart';
import '../../admin/presentation/screens/application_settings_screen.dart';
import '../../admin/presentation/screens/audit_logs_screen.dart';
import '../../admin/presentation/screens/monitoring_dashboard_screen.dart';
import '../../admin/presentation/screens/notification_center_screen.dart';
import '../../admin/presentation/screens/user_management_screen.dart';
import '../../ai_commander/presentation/screens/ai_commander_dashboard_screen.dart';
import '../../analytics/presentation/screens/analytics_dashboard_screen.dart';
import '../../digital_twin/presentation/screens/digital_twin_dashboard_screen.dart';
import '../../map/presentation/screens/rescue_map_screen.dart';
import '../../offline/presentation/screens/offline_dashboard_screen.dart';
import '../../resources/presentation/screens/resource_dashboard_screen.dart';
import '../../sos/presentation/screens/mission_history_screen.dart';
import '../../sos/presentation/screens/sos_dashboard_screen.dart';
import '../../team_management/presentation/screens/rescue_teams_dashboard_screen.dart';
import 'officer_profile_screen.dart';

/// Generic modular fallback screen for unbuilt Rescue subpages.
class RescueSubpagePlaceholderScreen extends StatelessWidget {
  final String title;
  final String routeName;
  final IconData icon;
  final String description;

  const RescueSubpagePlaceholderScreen({
    super.key,
    required this.title,
    required this.routeName,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 42, color: colorScheme.primary),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Route: $routeName',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to Dashboard'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dynamic Route Builders routing directly to production-grade module screens
class RescueRoutePlaceholders {
  static Widget missionMap() => const RescueMapScreen();

  static Widget sosDashboard() => const SosDashboardScreen();

  static Widget digitalTwin() => const DigitalTwinDashboardScreen();

  static Widget aiCommander() => const AICommanderDashboardScreen();

  static Widget resources() => const ResourceDashboardScreen();

  static Widget teams() => const RescueTeamsDashboardScreen();

  static Widget missionHistory() => const MissionHistoryScreen();

  static Widget reports() => const AnalyticsDashboardScreen();

  static Widget profile() => const OfficerProfileScreen();

  static Widget notifications() => const NotificationCenterScreen();

  static Widget settings() => const ApplicationSettingsScreen();

  static Widget offline() => const OfflineDashboardScreen();

  static Widget monitoring() => const MonitoringDashboardScreen();

  static Widget userManagement() => const UserManagementScreen();

  static Widget auditLogs() => const AuditLogsScreen();

  static Widget about() => const AboutSystemScreen();
}
