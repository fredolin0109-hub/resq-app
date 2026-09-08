import 'package:flutter/material.dart';
import '../../domain/entities/digital_twin_entities.dart';
import '../providers/digital_twin_provider.dart';
import '../providers/digital_twin_state.dart';
import '../widgets/digital_twin_summary_card.dart';
import '../widgets/digital_twin_skeleton_loader.dart';
import '../widgets/digital_twin_empty_view.dart';
import '../widgets/prediction_card.dart';
import '../widgets/simulation_control_panel.dart';
import 'live_analytics_screen.dart';
import 'disaster_heatmap_screen.dart';
import 'timeline_monitor_screen.dart';
import 'infrastructure_status_screen.dart';
import 'ai_prediction_center_screen.dart';
import 'simulation_panel_screen.dart';
import 'twin_resource_allocation_screen.dart';

/// Central Command Center Dashboard for the ResQLink Digital Twin.
class DigitalTwinDashboardScreen extends StatefulWidget {
  const DigitalTwinDashboardScreen({super.key});

  @override
  State<DigitalTwinDashboardScreen> createState() =>
      _DigitalTwinDashboardScreenState();
}

class _DigitalTwinDashboardScreenState
    extends State<DigitalTwinDashboardScreen> {
  final _notifier = DigitalTwinDependencies.notifier;

  @override
  void initState() {
    super.initState();
    if (_notifier.state.status == DigitalTwinViewStatus.initial) {
      _notifier.loadDashboard();
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
            title: const Text('Digital Twin Command Center'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Refresh Telemetry',
                onPressed: () => _notifier.refresh(),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DigitalTwinState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.isLoading) {
      return const DigitalTwinSkeletonLoader();
    }

    if (state.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load Digital Twin',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'Unknown telemetry network error',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => _notifier.refresh(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry Telemetry Sync'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isEmpty) {
      return DigitalTwinEmptyView(
        onResetFilters: () => _notifier.loadDashboard(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _notifier.refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Digital Twin Aggregated Summary Metrics
          DigitalTwinSummaryCard(
            summary: state.summary,
            onHeatmapTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DisasterHeatmapScreen()),
            ),
            onInfrastructureTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const InfrastructureStatusScreen()),
            ),
            onPredictionsTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AIPredictionCenterScreen()),
            ),
            onAnalyticsTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LiveAnalyticsScreen()),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Quick Access Sub-Modules Hub Grid
          Text(
            'Operational Modules',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.45,
            children: [
              _ModuleHubCard(
                title: 'Live Analytics',
                subtitle: 'Telemetry & Graphs',
                icon: Icons.auto_graph_rounded,
                color: Colors.blue.shade700,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LiveAnalyticsScreen()),
                ),
              ),
              _ModuleHubCard(
                title: 'Disaster Heatmaps',
                subtitle: '10 Spatial Layers',
                icon: Icons.layers_rounded,
                color: Colors.purple.shade700,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const DisasterHeatmapScreen()),
                ),
              ),
              _ModuleHubCard(
                title: 'Timeline Monitor',
                subtitle: '50 Chrono Events',
                icon: Icons.timeline_rounded,
                color: Colors.teal.shade700,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TimelineMonitorScreen()),
                ),
              ),
              _ModuleHubCard(
                title: 'Infrastructure',
                subtitle: '30 Key Civil Assets',
                icon: Icons.domain_rounded,
                color: Colors.indigo.shade700,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const InfrastructureStatusScreen()),
                ),
              ),
              _ModuleHubCard(
                title: 'AI Predictions',
                subtitle: '40 Risk Forecasts',
                icon: Icons.psychology_rounded,
                color: Colors.amber.shade900,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AIPredictionCenterScreen()),
                ),
              ),
              _ModuleHubCard(
                title: 'Simulation Lab',
                subtitle: '5 Scenarios Interactive',
                icon: Icons.science_rounded,
                color: Colors.deepOrange.shade700,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SimulationPanelScreen()),
                ),
              ),
              _ModuleHubCard(
                title: 'Twin Allocation',
                subtitle: 'AI Resource Dispatch',
                icon: Icons.hub_rounded,
                color: Colors.cyan.shade800,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TwinResourceAllocationScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Active Simulation Quick Workbench Preview
          if (state.activeSimulation != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Scenario Simulation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SimulationPanelScreen()),
                  ),
                  child: const Text('Open Full Lab'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SimulationControlPanel(
              simulation: state.activeSimulation!,
              onTogglePlay: () => _notifier.togglePlaySimulation(),
              onScrubProgress: (p) => _notifier.scrubSimulation(p),
              onSpeedChanged: (s) => _notifier.setSimulationSpeed(s),
              onReset: () => _notifier.resetSimulation(),
              onSelectSimulationType: (t) => _notifier.selectSimulation(t),
            ),
            const SizedBox(height: 24),
          ],

          // 4. Critical Emerging AI Predictions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top AI Predicted Alerts',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AIPredictionCenterScreen()),
                ),
                child: const Text('View All (40)'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final prediction in state.allPredictions.take(3)) ...[
            PredictionCard(
              prediction: prediction,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AIPredictionCenterScreen()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ModuleHubCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModuleHubCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
