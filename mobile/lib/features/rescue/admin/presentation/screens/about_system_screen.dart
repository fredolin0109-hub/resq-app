import 'package:flutter/material.dart';

/// Screen presenting application metadata, versioning, developers, license, and legal terms.
class AboutSystemScreen extends StatelessWidget {
  const AboutSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About ResQLink AI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // App Logo & Identity Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        Colors.deepPurpleAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'ResQLink AI',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Autonomous Disaster Coordination & Rescue Platform',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Version 2.4.0 (Build 2405-PROD)',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Overview Card
          _buildInfoCard(
            context,
            title: 'Mission & Vision',
            icon: Icons.flag_rounded,
            content:
                'ResQLink AI is an advanced AI-powered emergency management and rescue ecosystem designed to ensure zero-casualty operations during natural disasters through offline mesh coordination, real-time spatial digital twin telemetry, and AI command intelligence.',
          ),
          const SizedBox(height: 12),

          // Technical Specifications
          _buildInfoCard(
            context,
            title: 'Architecture & Engine',
            icon: Icons.code_rounded,
            content:
                '• Clean Architecture with Flutter & Riverpod\n• Offline-first BLE Mesh & LoRa Protocol Integration\n• Vector Map Caching with Sub-second Spatial Indexing\n• End-to-End Cryptographic Handshake Security\n• Multi-District State Disaster Registry Sync',
          ),
          const SizedBox(height: 12),

          // Engineering & Development
          _buildInfoCard(
            context,
            title: 'Engineering & Development',
            icon: Icons.engineering_rounded,
            content:
                'Built by the ResQLink Core Engineering Team in partnership with State Disaster Management Authorities and Emergency Response Forces.',
          ),
          const SizedBox(height: 12),

          // Legal, Terms, & Privacy
          _buildInfoCard(
            context,
            title: 'License & Legal Compliance',
            icon: Icons.gavel_rounded,
            content:
                '• License: MIT Open Emergency Disaster Tech License\n• Privacy Policy: Full End-to-End Encryption, Zero Third-Party Tracking\n• Terms of Service: Designed for Authorized Emergency Relief Personnel and Humanitarian Operations',
          ),
          const SizedBox(height: 12),

          // Emergency Support Contact
          _buildInfoCard(
            context,
            title: 'Emergency Help & Operations Desk',
            icon: Icons.support_agent_rounded,
            content:
                '• 24x7 State Emergency Helpline: 1070 / 112\n• Technical Support: support@resqlink.tn.gov.in\n• Disaster Control Room: State EOC, Chepauk, Chennai',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
