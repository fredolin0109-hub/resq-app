import 'package:flutter/material.dart';
import '../../data/datasources/analytics_mock_datasource.dart';
import '../../domain/entities/analytics_entities.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/incident_chart_card.dart';
import '../widgets/analytics_empty_view.dart';
import '../widgets/analytics_skeleton_loader.dart';

/// Screen for in-depth incident analytics, breakdown charts, and search across 500 records.
class IncidentStatisticsScreen extends StatefulWidget {
  const IncidentStatisticsScreen({super.key});

  @override
  State<IncidentStatisticsScreen> createState() =>
      _IncidentStatisticsScreenState();
}

class _IncidentStatisticsScreenState extends State<IncidentStatisticsScreen> {
  final _notifier = AnalyticsDependencies.notifier;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = _notifier.state.incidentFilters.searchQuery;
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
        final filters = state.incidentFilters;
        final incidents = state.filteredIncidents;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Incident Statistics'),
            centerTitle: true,
            actions: [
              if (filters.hasActiveFilters)
                IconButton(
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  tooltip: 'Clear Filters',
                  onPressed: () {
                    _searchController.clear();
                    _notifier.clearIncidentFilters();
                  },
                ),
            ],
          ),
          body: state.status == AnalyticsViewStatus.loading &&
                  state.allIncidents.isEmpty
              ? const AnalyticsSkeletonLoader(itemCount: 6)
              : Column(
                  children: [
                    // Search Bar & Filter Header
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),

                    // Incident List / Charts
                    Expanded(
                      child: incidents.isEmpty
                          ? AnalyticsEmptyView(
                              title: 'No Matching Incidents',
                              message:
                                  'Try clearing your search query or selecting "All Districts".',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                _notifier.clearIncidentFilters();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: incidents.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: IncidentChartCard(
                                      incidents: incidents,
                                    ),
                                  );
                                }
                                final inc = incidents[index - 1];
                                return _buildIncidentTile(context, inc);
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
    final filters = state.incidentFilters;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Search TextField
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search incident ID, title, district...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _notifier.setIncidentSearchQuery('');
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
            onChanged: (val) => _notifier.setIncidentSearchQuery(val),
          ),
          const SizedBox(height: 8),

          // District & Category Filter Horizontal Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // District Dropdown Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.5),
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
                      items: ['All', ...AnalyticsMockDataSource.tnDistricts]
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text(d == 'All' ? 'All Districts' : d),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) _notifier.setIncidentDistrict(val);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Severity Filter Chips
                ...SeverityLevel.values.map((sev) {
                  final isSelected = filters.severity == sev;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(sev.displayName),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white : sev.color,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedColor: sev.color,
                      backgroundColor: sev.color.withValues(alpha: 0.1),
                      showCheckmark: false,
                      onSelected: (selected) {
                        _notifier.setIncidentSeverity(selected ? sev : null);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentTile(BuildContext context, IncidentStatItem inc) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cat = inc.disasterCategory;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: InkWell(
        onTap: () => _showIncidentDetailModal(context, inc),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(cat.icon, color: cat.color, size: 20),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          inc.id,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: inc.severity.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            inc.severity.displayName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: inc.severity.color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: inc.status.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            inc.status.displayName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: inc.status.color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      inc.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 13, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text(
                          inc.district,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.people_outline_rounded,
                            size: 13, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text(
                          '${inc.victimsCount} victims',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.timer_outlined,
                            size: 13, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text(
                          '${inc.responseTimeMinutes}m',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIncidentDetailModal(BuildContext context, IncidentStatItem inc) {
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
                      color: inc.disasterCategory.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      inc.disasterCategory.icon,
                      color: inc.disasterCategory.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inc.id,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          inc.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow('District', inc.district),
              _buildDetailRow('Category', inc.disasterCategory.displayName),
              _buildDetailRow('Severity', inc.severity.displayName),
              _buildDetailRow('Operational Status', inc.status.displayName),
              _buildDetailRow('Victims Impacted', '${inc.victimsCount} civilians'),
              _buildDetailRow('Response Duration', '${inc.responseTimeMinutes} minutes'),
              _buildDetailRow('Rescue Operation Duration', '${inc.rescueDurationMinutes} minutes'),
              _buildDetailRow('Timestamp', inc.timestamp.toLocal().toString()),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Close Details'),
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
