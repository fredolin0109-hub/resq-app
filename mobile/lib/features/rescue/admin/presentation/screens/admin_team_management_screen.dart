import 'package:flutter/material.dart';
import '../../data/datasources/admin_mock_datasource.dart';
import '../../domain/entities/admin_entities.dart';
import '../providers/admin_provider.dart';
import '../providers/admin_state.dart';
import '../widgets/admin_team_card.dart';
import '../widgets/admin_empty_view.dart';
import '../widgets/admin_skeleton_loader.dart';

/// Screen for administrative oversight and telemetry of 20 rescue teams.
class AdminTeamManagementScreen extends StatefulWidget {
  const AdminTeamManagementScreen({super.key});

  @override
  State<AdminTeamManagementScreen> createState() =>
      _AdminTeamManagementScreenState();
}

class _AdminTeamManagementScreenState
    extends State<AdminTeamManagementScreen> {
  final _notifier = AdminDependencies.notifier;
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
            title: const Text('Rescue Squad Operations'),
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
          body: state.status == AdminViewStatus.loading && teams.isEmpty
              ? const AdminSkeletonLoader(itemCount: 6)
              : Column(
                  children: [
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),
                    Expanded(
                      child: teams.isEmpty
                          ? AdminEmptyView(
                              title: 'No Matching Squads',
                              message:
                                  'Try clearing your search query or selecting "All Districts".',
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
                                return AdminTeamCard(
                                  team: team,
                                  onTap: () => _showTeamDetail(context, team),
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

  Widget _buildFilterHeader(BuildContext context, AdminState state) {
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
              hintText: 'Search squad name, commander, or mission...',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // District Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filters.district,
                      isDense: true,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                      items: ['All', ...AdminMockDataSource.tnDistricts]
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
                const SizedBox(width: 8),
                FilterChip(
                  selected: filters.availableOnly == null,
                  label: const Text('All Squads'),
                  selectedColor: colorScheme.primary,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filters.availableOnly == null
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  showCheckmark: false,
                  onSelected: (_) => _notifier.setTeamAvailableOnly(null),
                ),
                const SizedBox(width: 6),
                FilterChip(
                  selected: filters.availableOnly == true,
                  label: const Text('Available Only'),
                  selectedColor: Colors.green,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filters.availableOnly == true
                        ? Colors.white
                        : Colors.green,
                  ),
                  backgroundColor: Colors.green.withValues(alpha: 0.1),
                  showCheckmark: false,
                  onSelected: (val) =>
                      _notifier.setTeamAvailableOnly(val ? true : null),
                ),
                const SizedBox(width: 6),
                FilterChip(
                  selected: filters.availableOnly == false,
                  label: const Text('Deployed / Active'),
                  selectedColor: Colors.orange,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filters.availableOnly == false
                        ? Colors.white
                        : Colors.orange,
                  ),
                  backgroundColor: Colors.orange.withValues(alpha: 0.1),
                  showCheckmark: false,
                  onSelected: (val) =>
                      _notifier.setTeamAvailableOnly(val ? false : null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTeamDetail(BuildContext context, AdminRescueTeam team) {
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
                      color: Colors.blue,
                      size: 24,
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
                          '${team.teamId} • ${team.district}',
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
              _buildDetailRow(
                  'Personnel Deployed', '${team.memberCount} certified rescuers'),
              _buildDetailRow(
                  'Vehicles & Crafts', '${team.vehicleCount} assigned assets'),
              _buildDetailRow('Operational Status',
                  team.isAvailable ? 'Available on Standby' : 'Deployed on Mission'),
              _buildDetailRow('Current Assignment', team.currentMission),
              _buildDetailRow('Performance Rating',
                  '${team.performanceScore} / 100 Scorecard'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Close Squad Telemetry'),
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
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
