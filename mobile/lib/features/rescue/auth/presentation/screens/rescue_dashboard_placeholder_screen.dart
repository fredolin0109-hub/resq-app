import 'package:flutter/material.dart';
import '../../domain/entities/rescue_user.dart';

/// Navigation placeholder screen for `/rescue/dashboard`.
/// Does not implement full dashboard yet, but fulfills the routing target.
class RescueDashboardPlaceholderScreen extends StatelessWidget {
  final RescueUser? user;

  const RescueDashboardPlaceholderScreen({
    super.key,
    this.user,
  });

  static const String routeName = '/rescue/dashboard';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rescue Dashboard (Placeholder)'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard_customize_rounded,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  'Rescue Operations Dashboard',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  user != null
                      ? 'Authenticated as ${user!.name} (${user!.rescueId}) - Team ${user!.teamId}'
                      : 'Authenticated Rescue Session Active',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/rescue/login');
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
