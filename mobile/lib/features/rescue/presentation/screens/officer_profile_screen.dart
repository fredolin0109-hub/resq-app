import 'package:flutter/material.dart';
import '../../admin/presentation/screens/about_system_screen.dart';
import '../../admin/presentation/screens/application_settings_screen.dart';
import '../../admin/presentation/screens/audit_logs_screen.dart';
import '../../admin/presentation/screens/monitoring_dashboard_screen.dart';
import '../../admin/presentation/screens/user_management_screen.dart';
import '../../offline/presentation/screens/offline_dashboard_screen.dart';

/// Full-featured Officer Profile and Security Command Screen for Rescue Commanders.
class OfficerProfileScreen extends StatefulWidget {
  const OfficerProfileScreen({super.key});

  static const String routeName = '/rescue/profile';

  @override
  State<OfficerProfileScreen> createState() => _OfficerProfileScreenState();
}

class _OfficerProfileScreenState extends State<OfficerProfileScreen> {
  String _dutyStatus = 'ONLINE';
  bool _meshRelayActive = true;
  bool _telemetryBeacon = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commander Profile & Credentials'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ApplicationSettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Officer Header Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'appbar_profile_avatar',
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: colorScheme.primary,
                          child: const Text(
                            'SC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sarah Connor',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade800.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green.shade600),
                                  ),
                                  child: Text(
                                    _dutyStatus,
                                    style: TextStyle(
                                      color: Colors.green.shade300,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'District Control Officer • SDRF',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Badge ID: TN-CMD-8842 • Rank: Grade 1',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Operational Status & Quick Toggles
              Text(
                'Tactical Duty Status',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.radio_button_checked_rounded, color: Colors.green),
                      title: const Text('Duty Deployment Mode'),
                      subtitle: Text('Current: $_dutyStatus'),
                      trailing: DropdownButton<String>(
                        value: _dutyStatus,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'ONLINE', child: Text('Online')),
                          DropdownMenuItem(value: 'STANDBY', child: Text('Standby')),
                          DropdownMenuItem(value: 'DISPATCHED', child: Text('Dispatched')),
                          DropdownMenuItem(value: 'OFFLINE', child: Text('Off-Duty')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _dutyStatus = val);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.hub_rounded),
                      title: const Text('Mesh Node Relay'),
                      subtitle: const Text('Forward encrypted packets for nearby squads'),
                      value: _meshRelayActive,
                      onChanged: (val) => setState(() => _meshRelayActive = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.my_location_rounded),
                      title: const Text('Commander Telemetry Beacon'),
                      subtitle: const Text('Broadcast GPS coordinates to central command'),
                      value: _telemetryBeacon,
                      onChanged: (val) => setState(() => _telemetryBeacon = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Security & Tactical Radio Credentials
              Text(
                'Security & Tactical Mesh Credentials',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildCredentialRow('Tactical Callsign', 'PHOENIX-COMMAND-1', Icons.campaign_rounded),
                      const Divider(height: 16),
                      _buildCredentialRow('Assigned Squad', 'Alpha-1 Rapid Response', Icons.shield_rounded),
                      const Divider(height: 16),
                      _buildCredentialRow('BLE Mesh Radio ID', 'MESH-TN-042-ALPHA', Icons.bluetooth_audio_rounded),
                      const Divider(height: 16),
                      _buildCredentialRow('Encryption Standard', 'AES-256 GCM (E2EE)', Icons.lock_rounded),
                      const Divider(height: 16),
                      _buildCredentialRow('Jurisdiction District', 'Chennai & Coastal Belt', Icons.location_city_rounded),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. Quick Module Shortcuts
              Text(
                'System Command Hub',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.offline_bolt_rounded, color: Colors.amber),
                      title: const Text('Offline Mesh & Sync Center'),
                      subtitle: const Text('Manage local peer radios and message queue'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OfflineDashboardScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.monitor_heart_rounded, color: Colors.blue),
                      title: const Text('System Telemetry & Health'),
                      subtitle: const Text('Live server CPU, database latency, and storage'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MonitoringDashboardScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.manage_accounts_rounded, color: Colors.teal),
                      title: const Text('User & Squad Management'),
                      subtitle: const Text('Role-based access control and officer directories'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const UserManagementScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.history_edu_rounded, color: Colors.purple),
                      title: const Text('Security & Audit Logs'),
                      subtitle: const Text('Tamper-evident logs of tactical actions'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AuditLogsScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded, color: Colors.grey),
                      title: const Text('About ResQLink AI Platform'),
                      subtitle: const Text('Version 2.4.0 • Build 2405 (Production)'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AboutSystemScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 5. Emergency Session Lock / Signout
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Session locked securely. Duty logs synchronized.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.lock_outline_rounded, color: Colors.redAccent),
                  label: const Text(
                    'Lock Tactical Session',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
