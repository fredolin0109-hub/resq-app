import 'package:flutter/material.dart';
import '../../data/datasources/digital_twin_mock_datasource.dart';
import '../providers/digital_twin_provider.dart';
import '../widgets/analytics_chart_tile.dart';

/// Screen displaying real-time disaster telemetry, river hydrology, power grid stability, and trend graphs.
class LiveAnalyticsScreen extends StatefulWidget {
  const LiveAnalyticsScreen({super.key});

  @override
  State<LiveAnalyticsScreen> createState() => _LiveAnalyticsScreenState();
}

class _LiveAnalyticsScreenState extends State<LiveAnalyticsScreen> {
  final _notifier = DigitalTwinDependencies.notifier;
  String _selectedDistrict = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final analytics = state.liveAnalytics;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Live Disaster Telemetry'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // District Filter Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_city_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Target District:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDistrict,
                        borderRadius: BorderRadius.circular(12),
                        items: ['All', ...DigitalTwinMockDatasource.tamilNaduDistricts]
                            .map(
                              (d) => DropdownMenuItem(
                                value: d,
                                child: Text(d),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedDistrict = val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Critical Telemetry Metric Cards
              Row(
                children: [
                  Expanded(
                    child: _UptimeCard(
                      label: 'Road Transit Health',
                      value: '${analytics.roadAvailabilityPercent}%',
                      subtitle: 'Operational Flow',
                      icon: Icons.alt_route_rounded,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _UptimeCard(
                      label: 'Tower Comms Uptime',
                      value: '${analytics.commsUptimePercent}%',
                      subtitle: 'Active Cellular/Sat',
                      icon: Icons.cell_tower_rounded,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _UptimeCard(
                      label: 'Power Grid Stability',
                      value: analytics.powerGridStable ? 'STABLE' : 'VULNERABLE',
                      subtitle: analytics.powerGridStable
                          ? 'Zero Major Blackouts'
                          : 'Load-Shedding Active',
                      icon: Icons.electric_bolt_rounded,
                      color: analytics.powerGridStable
                          ? Colors.teal.shade600
                          : Colors.amber.shade800,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _UptimeCard(
                      label: 'Population at Risk',
                      value: '${analytics.populationImpacted}',
                      subtitle: 'In High-Hazard Perimeter',
                      icon: Icons.people_alt_rounded,
                      color: Colors.purple.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sparklines and Hydrology Chart Widgets
              AnalyticsChartTile(
                data: analytics,
                district: _selectedDistrict,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UptimeCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _UptimeCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const Spacer(),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
