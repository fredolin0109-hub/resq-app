import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';
import '../providers/admin_provider.dart';

/// Screen for configuring application settings, themes, caching, BLE power, and GPS accuracy.
class ApplicationSettingsScreen extends StatefulWidget {
  const ApplicationSettingsScreen({super.key});

  @override
  State<ApplicationSettingsScreen> createState() =>
      _ApplicationSettingsScreenState();
}

class _ApplicationSettingsScreenState extends State<ApplicationSettingsScreen> {
  final _notifier = AdminDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final settings = _notifier.state.settings;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Application Settings'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.restore_rounded),
                tooltip: 'Reset to Defaults',
                onPressed: () => _confirmReset(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // 1. General & Display
              _buildSectionTitle(context, 'Display & Regional', Icons.palette_outlined),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_6_rounded),
                      title: const Text('Theme Mode'),
                      subtitle: Text(settings.themeMode.toUpperCase()),
                      trailing: DropdownButton<String>(
                        value: settings.themeMode,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(value: 'dark', child: Text('Dark Mode')),
                          DropdownMenuItem(value: 'light', child: Text('Light Mode')),
                          DropdownMenuItem(value: 'system', child: Text('System Default')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            _notifier.updateSettings(
                              settings.copyWith(themeMode: val),
                            );
                          }
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language_rounded),
                      title: const Text('Language & Localization'),
                      subtitle: Text(settings.language == 'ta'
                          ? 'Tamil (தமிழ்)'
                          : 'English (US/IN)'),
                      trailing: DropdownButton<String>(
                        value: settings.language,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'ta', child: Text('Tamil (தமிழ்)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            _notifier.updateSettings(
                              settings.copyWith(language: val),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Notification Preferences
              _buildSectionTitle(context, 'Notification Preferences', Icons.notifications_outlined),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_active_rounded),
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receive mission and SOS updates'),
                      value: settings.notificationsEnabled,
                      onChanged: (val) {
                        _notifier.updateSettings(
                          settings.copyWith(notificationsEnabled: val),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.volume_up_rounded),
                      title: const Text('Emergency Sirens & Audio'),
                      subtitle: const Text('Play sound alerts for critical events'),
                      value: settings.soundAlertsEnabled,
                      onChanged: (val) {
                        _notifier.updateSettings(
                          settings.copyWith(soundAlertsEnabled: val),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.vibration_rounded),
                      title: const Text('Haptic Feedback'),
                      subtitle: const Text('Tactile response on urgent alerts'),
                      value: settings.hapticFeedback,
                      onChanged: (val) {
                        _notifier.updateSettings(
                          settings.copyWith(hapticFeedback: val),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Offline & Connectivity Settings
              _buildSectionTitle(context, 'Network & Hardware Mesh', Icons.bluetooth_audio_rounded),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.airplanemode_active_rounded),
                      title: const Text('Force Offline Mode'),
                      subtitle: const Text('Rely exclusively on BLE mesh network'),
                      value: settings.offlineModeForced,
                      onChanged: (val) {
                        _notifier.updateSettings(
                          settings.copyWith(offlineModeForced: val),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.map_rounded),
                      title: const Text('Map Cache Limit'),
                      subtitle: Text('${settings.mapCacheLimitMb} MB Allocated'),
                      trailing: DropdownButton<int>(
                        value: settings.mapCacheLimitMb,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(value: 128, child: Text('128 MB')),
                          DropdownMenuItem(value: 256, child: Text('256 MB')),
                          DropdownMenuItem(value: 512, child: Text('512 MB')),
                          DropdownMenuItem(value: 1024, child: Text('1024 MB (1 GB)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            _notifier.updateSettings(
                              settings.copyWith(mapCacheLimitMb: val),
                            );
                          }
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.sync_rounded),
                      title: const Text('Sync Interval'),
                      subtitle: Text('Every ${settings.syncIntervalSeconds} seconds'),
                      trailing: DropdownButton<int>(
                        value: settings.syncIntervalSeconds,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(value: 5, child: Text('5 sec (Fast)')),
                          DropdownMenuItem(value: 15, child: Text('15 sec (Balanced)')),
                          DropdownMenuItem(value: 30, child: Text('30 sec')),
                          DropdownMenuItem(value: 60, child: Text('60 sec (Eco)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            _notifier.updateSettings(
                              settings.copyWith(syncIntervalSeconds: val),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. GNSS & Developer Diagnostics
              _buildSectionTitle(context, 'GNSS & Developer Diagnostics', Icons.developer_mode_rounded),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.gps_fixed_rounded),
                      title: const Text('GNSS / GPS Accuracy Mode'),
                      subtitle: Text(settings.gpsAccuracy),
                      trailing: DropdownButton<String>(
                        value: settings.gpsAccuracy,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(value: 'High', child: Text('High Precision')),
                          DropdownMenuItem(value: 'Balanced', child: Text('Balanced')),
                          DropdownMenuItem(value: 'BatterySaving', child: Text('Battery Saver')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            _notifier.updateSettings(
                              settings.copyWith(gpsAccuracy: val),
                            );
                          }
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.bug_report_outlined),
                      title: const Text('Logging Level'),
                      subtitle: Text(settings.loggingLevel),
                      trailing: DropdownButton<String>(
                        value: settings.loggingLevel,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(value: 'Debug', child: Text('Debug (Verbose)')),
                          DropdownMenuItem(value: 'Info', child: Text('Info (Standard)')),
                          DropdownMenuItem(value: 'Warn', child: Text('Warn')),
                          DropdownMenuItem(value: 'Error', child: Text('Error Only')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            _notifier.updateSettings(
                              settings.copyWith(loggingLevel: val),
                            );
                          }
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.code_rounded),
                      title: const Text('Developer Mode'),
                      subtitle: const Text('Enable debug inspector & mock telemetry'),
                      value: settings.developerMode,
                      onChanged: (val) {
                        _notifier.updateSettings(
                          settings.copyWith(developerMode: val),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(
      BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Reset Configuration?'),
          content: const Text(
            'This will restore all application settings, telemetry sync intervals, and cache configurations to factory defaults.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _notifier.resetSettingsToDefault();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuration reset to default settings.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Reset Settings'),
            ),
          ],
        );
      },
    );
  }
}
