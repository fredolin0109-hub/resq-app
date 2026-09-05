import 'package:flutter/material.dart';

/// Generic modular placeholder screen for unbuilt Rescue subpages.
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

/// Helper builders for each subpage route
class RescueRoutePlaceholders {
  static Widget missionMap() => const RescueSubpagePlaceholderScreen(
        title: 'Mission Map',
        routeName: '/rescue/map',
        icon: Icons.map_rounded,
        description: 'Interactive live mission map, field responder waypoints, and tactical navigation overlays.',
      );

  static Widget sosDashboard() => const RescueSubpagePlaceholderScreen(
        title: 'SOS Alerts & Triage',
        routeName: '/rescue/alerts',
        icon: Icons.sos_rounded,
        description: 'Real-time SOS distress alerts, victim prioritization, and urgent rescue queue.',
      );

  static Widget digitalTwin() => const RescueSubpagePlaceholderScreen(
        title: 'Digital Twin Simulation',
        routeName: '/rescue/digital-twin',
        icon: Icons.view_in_ar_rounded,
        description: '3D structural models, hazard perimeter simulations, and infrastructure damage telemetry.',
      );

  static Widget aiCommander() => const RescueSubpagePlaceholderScreen(
        title: 'AI Tactical Commander',
        routeName: '/rescue/ai',
        icon: Icons.psychology_rounded,
        description: 'AI-assisted response optimization, triage suggestions, and squad dispatch suggestions.',
      );

  static Widget resources() => const RescueSubpagePlaceholderScreen(
        title: 'Rescue Resources',
        routeName: '/rescue/resources',
        icon: Icons.inventory_2_rounded,
        description: 'Logistics tracking for medical kits, boats, drones, stretchers, and relief supplies.',
      );

  static Widget teams() => const RescueSubpagePlaceholderScreen(
        title: 'Rescue Teams',
        routeName: '/rescue/teams',
        icon: Icons.groups_rounded,
        description: 'Personnel status, squad rosters, deployment tracking, and mesh check-in status.',
      );

  static Widget missionHistory() => const RescueSubpagePlaceholderScreen(
        title: 'Mission History',
        routeName: '/rescue/history',
        icon: Icons.history_rounded,
        description: 'Archived rescue mission logs, incident post-mortems, and response telemetry records.',
      );

  static Widget reports() => const RescueSubpagePlaceholderScreen(
        title: 'Field Reports',
        routeName: '/rescue/reports',
        icon: Icons.assessment_rounded,
        description: 'Incident summaries, casualty assessments, and operational export logs.',
      );

  static Widget profile() => const RescueSubpagePlaceholderScreen(
        title: 'Officer Profile',
        routeName: '/rescue/profile',
        icon: Icons.person_rounded,
        description: 'Commander credentials, assigned squad, mesh radio IDs, and encryption keys.',
      );

  static Widget notifications() => const RescueSubpagePlaceholderScreen(
        title: 'Mission Notifications',
        routeName: '/rescue/notifications',
        icon: Icons.notifications_rounded,
        description: 'Broadcast alerts, mesh priority pings, and escalation notices.',
      );

  static Widget settings() => const RescueSubpagePlaceholderScreen(
        title: 'Command Settings',
        routeName: '/rescue/settings',
        icon: Icons.settings_rounded,
        description: 'Mesh sync interval, offline map tile cache, telemetry parameters, and security.',
      );
}
