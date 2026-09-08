import 'package:flutter/material.dart';
import '../../data/datasources/analytics_mock_datasource.dart';
import '../../domain/entities/analytics_entities.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/team_performance_card.dart';
import '../widgets/analytics_empty_view.dart';
import '../widgets/analytics_skeleton_loader.dart';

/// Screen showcasing team performance, leaderboards, mission scorecard, and search across 50 squads.
class TeamPerformanceScreen extends StatefulWidget {
  const TeamPerformanceScreen({super.key});

  @override
  State<TeamPerformanceScreen> createState() => _TeamPerformanceScreenState();
}

class _TeamPerformanceScreenState extends State<TeamPerformanceScreen> {
  final _notifier = AnalyticsDependencies.notifier;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = _notifier.state.teamFilters.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final filters = state.teamFilters;
        final teams = state.filteredTeams;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Squad Scorecards & Leaderboard'),
            centerTitle: true,
            actions: [
              if (filters.hasActiveFilters)
                IconButton(
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  tooltip: 'Clear Filters',
                  onPressed: () {
                    _searchController.clear();
                    _notifier.clearTeamFilters();
                  },
                ),
            ],
          ),
          body: state.status == AnalyticsViewStatus.loading &&
                  state.allTeams.isEmpty
              ? const AnalyticsSkeletonLoader(itemCount: 6)
              : Column(
                  children: [
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),
                    Expanded(
                      child: teams.isEmpty
                          ? AnalyticsEmptyView(
                              title: 'No Matching Squads',
                              message:
                                  'Try adjusting your search query or district filter.',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                _notifier.clearTeamFilters();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: teams.length,
                              itemBuilder: (context, index) {
                                final team = teams[index];
                                return TeamPerformanceCard(
                                  team: team,
                                  rank: index + 1,
                                  onTap: () => _showTeamDetail(context, team, index + 1),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildFilterHeader(BuildContext context, AnalyticsState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filters = state.teamFilters;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search squad name, commander, or district...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _notifier.setTeamSearchQuery('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => _notifier.setTeamSearchQuery(val),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // District dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filters.district,
                      isDense: true,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      items: ['All', ...AnalyticsMockDataSource.tnDistricts]
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text(d == 'All' ? 'All Districts' : d),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) _notifier.setTeamDistrict(val);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Sort dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filters.sortBy,
                      isDense: true,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'score', child: Text('Sort: Score')),
                        DropdownMenuItem(
                            value: 'rescues', child: Text('Sort: Rescues')),
                        DropdownMenuItem(
                            value: 'responseTime',
                            child: Text('Sort: Speed')),
                        DropdownMenuItem(
                            value: 'successRate',
                            child: Text('Sort: Win %')),
                      ],
                      onChanged: (val) {
                        if (val != null) _notifier.setTeamSortBy(val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTeamDetail(BuildContext context, TeamPerformanceItem team, int rank) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#$rank',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.teamName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${team.teamId} • ${team.district} District',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow('Unit Commander', team.leaderName),
              _buildDetailRow('Missions Executed', '${team.missionCount} deployments'),
              _buildDetailRow('Civilians Rescued', '${team.rescuesCompleted} people'),
              _buildDetailRow('Average Response Time', '${team.avgResponseTimeMinutes} minutes'),
              _buildDetailRow('Mission Success Rate', '${team.successRatePercent}%'),
              _buildDetailRow('Operational Distance Logged', '${team.distanceTravelledKm} km'),
              _buildDetailRow('Performance Scorecard', '${team.performanceScore} / 100'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Close Scorecard'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
