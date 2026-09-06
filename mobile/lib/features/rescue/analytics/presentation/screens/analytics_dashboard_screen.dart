import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/analytics_summary_card.dart';
import '../widgets/incident_chart_card.dart';
import '../widgets/resource_utilization_card.dart';
import '../widgets/team_performance_card.dart';
import '../widgets/district_analytics_card.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/analytics_skeleton_loader.dart';
import '../widgets/analytics_empty_view.dart';
import 'incident_statistics_screen.dart';
import 'resource_utilization_screen.dart';
import 'team_performance_screen.dart';
import 'district_analytics_screen.dart';
import 'ai_insights_screen.dart';
import 'reports_center_screen.dart';

/// Central Dashboard Screen for Disaster Analytics & Reporting.
class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  final _notifier = AnalyticsDependencies.notifier;

  @override
  void initState() {
    super.initState();
    if (_notifier.state.status == AnalyticsViewStatus.initial) {
      _notifier.loadAnalytics();
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
            title: const Text('Disaster Analytics & Reports'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined),
                tooltip: 'Reports Center',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ReportsCenterScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Refresh Analytics',
                onPressed: () => _notifier.refresh(),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AnalyticsState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.status == AnalyticsViewStatus.loading &&
        state.allIncidents.isEmpty) {
      return const AnalyticsSkeletonLoader(itemCount: 5);
    }

    if (state.status == AnalyticsViewStatus.error &&
        state.allIncidents.isEmpty) {
      return AnalyticsEmptyView(
        title: 'Error Loading Analytics',
        message: state.errorMessage ?? 'An unexpected error occurred.',
        icon: Icons.error_outline_rounded,
        actionLabel: 'Try Again',
        onAction: () => _notifier.refresh(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _notifier.refresh(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. Executive Summary Telemetry
          AnalyticsSummaryCard(
            summary: state.summary,
            onIncidentsTap: () => _navigate(const IncidentStatisticsScreen()),
            onTeamsTap: () => _navigate(const TeamPerformanceScreen()),
            onResourcesTap: () => _navigate(const ResourceUtilizationScreen()),
          ),
          const SizedBox(height: 12),

          // 2. Navigation Quick Hub
          _buildQuickHub(context),
          const SizedBox(height: 12),

          // 3. Incident Breakdown Chart Card
          IncidentChartCard(
            incidents: state.allIncidents,
            onViewDetails: () => _navigate(const IncidentStatisticsScreen()),
          ),
          const SizedBox(height: 12),

          // 4. Resource Telemetry
          ResourceUtilizationCard(
            resources: state.resourceAnalytics,
            district: state.selectedResourceDistrict,
            onViewDetails: () => _navigate(const ResourceUtilizationScreen()),
          ),
          const SizedBox(height: 16),

          // 5. AI Operational Insights Preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: Colors.purple, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'AI Operational Alerts',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => _navigate(const AIInsightsScreen()),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('View All (5)'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...state.allInsights.take(2).map((ins) => AIInsightCard(
                insight: ins,
                onApplyAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dispatched recommendation for ${ins.title}'),
                      backgroundColor: Colors.purple,
                    ),
                  );
                },
              )),
          const SizedBox(height: 16),

          // 6. District Profiles Quick Overview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.map_rounded, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'High Risk District Profiles',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => _navigate(const DistrictAnalyticsScreen()),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('All 13 Districts'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...state.allDistricts
              .where((d) => d.riskTier == RiskTier.critical || d.riskTier == RiskTier.high)
              .take(2)
              .map((dist) => DistrictAnalyticsCard(
                    district: dist,
                    onTap: () => _navigate(const DistrictAnalyticsScreen()),
                  )),
          const SizedBox(height: 16),

          // 7. Top Rescue Teams
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Squad Leaderboard',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => _navigate(const TeamPerformanceScreen()),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('All 50 Teams'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...state.allTeams.take(3).toList().asMap().entries.map((entry) {
            return TeamPerformanceCard(
              team: entry.value,
              rank: entry.key + 1,
              onTap: () => _navigate(const TeamPerformanceScreen()),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickHub(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hubs = [
      {
        'title': 'Incidents',
        'icon': Icons.bar_chart_rounded,
        'color': Colors.blueAccent,
        'screen': const IncidentStatisticsScreen(),
      },
      {
        'title': 'Resources',
        'icon': Icons.inventory_2_rounded,
        'color': Colors.teal,
        'screen': const ResourceUtilizationScreen(),
      },
      {
        'title': 'Teams',
        'icon': Icons.groups_rounded,
        'color': Colors.purpleAccent,
        'screen': const TeamPerformanceScreen(),
      },
      {
        'title': 'Districts',
        'icon': Icons.location_city_rounded,
        'color': Colors.orangeAccent,
        'screen': const DistrictAnalyticsScreen(),
      },
      {
        'title': 'AI Insights',
        'icon': Icons.auto_awesome_rounded,
        'color': Colors.pinkAccent,
        'screen': const AIInsightsScreen(),
      },
      {
        'title': 'Reports',
        'icon': Icons.picture_as_pdf_rounded,
        'color': Colors.redAccent,
        'screen': const ReportsCenterScreen(),
      },
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: hubs.map((h) {
            final col = h['color'] as Color;
            return InkWell(
              onTap: () => _navigate(h['screen'] as Widget),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: col.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(h['icon'] as IconData, color: col, size: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      h['title'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _navigate(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
