import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';
import '../providers/team_management_provider.dart';
import '../providers/team_management_state.dart';
import '../widgets/fleet_summary_widget.dart';
import '../widgets/team_card.dart';
import '../widgets/team_filter_sheet.dart';
import '../widgets/team_management_skeleton_loader.dart';
import 'dispatch_team_screen.dart';
import 'fleet_management_screen.dart';
import 'team_details_screen.dart';

/// Master Dashboard for Rescue Squads and Fleet Operations.
class RescueTeamsDashboardScreen extends StatefulWidget {
  final TeamManagementNotifier? notifier;

  const RescueTeamsDashboardScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/teams';

  @override
  State<RescueTeamsDashboardScreen> createState() => _RescueTeamsDashboardScreenState();
}

class _RescueTeamsDashboardScreenState extends State<RescueTeamsDashboardScreen> {
  late final TeamManagementNotifier _notifier;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? TeamManagementDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_notifier.state.status == TeamManagementStatus.initial) {
        _notifier.loadDashboard();
      }
    });
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TeamFilterSheet(
        currentFilters: _notifier.state.filterOptions,
        onApply: (newOpts) => _notifier.updateFilters(newOpts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = _notifier.state;
    final summary = state.teamsSummary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rescue Teams & Fleet Command',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.search_off_rounded : Icons.search_rounded),
            tooltip: 'Search Squads',
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                  _notifier.search('');
                }
              });
            },
          ),
          Badge(
            isLabelVisible: state.filterOptions.hasActiveFilters,
            smallSize: 8,
            child: IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              tooltip: 'Filter Squads',
              onPressed: _openFilterSheet,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.directions_car_filled_rounded),
            tooltip: 'Fleet Management',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: FleetManagementScreen.routeName),
                  builder: (_) => FleetManagementScreen(notifier: _notifier),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded),
            tooltip: 'Emergency Dispatch',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: DispatchTeamScreen.routeName),
                  builder: (_) => DispatchTeamScreen(notifier: _notifier),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Telemetry',
            onPressed: () => _notifier.loadDashboard(),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _notifier.loadDashboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expandable Search
                if (_isSearchVisible) ...[
                  TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search squad name, leader, vehicle, district...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                    ),
                    onChanged: (val) => _notifier.search(val),
                  ),
                  const SizedBox(height: 12),
                ],

                // Top Metric Summary Cards (4 Cards)
                if (summary != null) ...[
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard(context, 'Total Teams', summary.totalTeams, Icons.shield_rounded, colorScheme.primary)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMetricCard(context, 'Active Teams', summary.activeTeams, Icons.verified_user_rounded, Colors.teal.shade700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard(context, 'Available', summary.availableTeams, Icons.check_circle_rounded, Colors.green.shade700)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMetricCard(context, 'On Mission', summary.teamsOnMission, Icons.crisis_alert_rounded, Colors.orange.shade800)),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],

                // Fleet Summary Widget
                if (state.fleetSummary != null) ...[
                  FleetSummaryWidget(
                    fleet: state.fleetSummary!,
                    onTypeSelected: (type) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: const RouteSettings(name: FleetManagementScreen.routeName),
                          builder: (_) => FleetManagementScreen(notifier: _notifier),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Field Squads (${state.filteredTeams.length})',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: DispatchTeamScreen.routeName),
                            builder: (_) => DispatchTeamScreen(notifier: _notifier),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Dispatch Squad'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Body States (Skeleton, Empty, List)
                if (state.isLoading)
                  const TeamManagementSkeletonLoader()
                else if (state.isEmpty || state.filteredTeams.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          const Icon(Icons.group_off_rounded, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text('No Teams Available', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          const Text('No rescue squads match current search or filter criteria.', textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () => _notifier.updateFilters(const TeamFilterOptions()),
                            child: const Text('Reset Filters'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = state.filteredTeams[index];
                      return TeamCard(
                        team: team,
                        onTap: () {
                          _notifier.selectTeam(team);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: const RouteSettings(name: TeamDetailsScreen.routeName),
                              builder: (_) => TeamDetailsScreen(
                                team: team,
                                notifier: _notifier,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, int count, IconData icon, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(count.toString(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
