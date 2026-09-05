import 'package:flutter/material.dart';
import '../../domain/entities/sos_incident_entity.dart';
import '../providers/sos_provider.dart';
import '../widgets/sos_empty_view.dart';
import '../widgets/sos_filter_sheet.dart';
import '../widgets/sos_incident_card.dart';
import '../widgets/sos_skeleton_loader.dart';
import '../widgets/sos_summary_metric_card.dart';
import 'mission_history_screen.dart';
import 'sos_details_screen.dart';

/// Production-ready Live SOS Command Center Dashboard for ResQLink AI.
class SosDashboardScreen extends StatefulWidget {
  final SosNotifier? notifier;

  const SosDashboardScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/alerts';

  @override
  State<SosDashboardScreen> createState() => _SosDashboardScreenState();
}

class _SosDashboardScreenState extends State<SosDashboardScreen> {
  late final SosNotifier _notifier;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? SosDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_notifier.state.status == SosCommandStatus.initial) {
        _notifier.loadSosData();
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
      builder: (_) => SosFilterSheet(
        currentFilters: _notifier.state.filterOptions,
        onApply: (newFilters) => _notifier.updateFilters(newFilters),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = _notifier.state;
    final metrics = state.metrics;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live SOS Command Center',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 1,
        backgroundColor: colorScheme.surface,
        actions: [
          // Search Toggle
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.search_off_rounded : Icons.search_rounded),
            tooltip: 'Search Alerts',
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                  _notifier.searchIncidents('');
                }
              });
            },
          ),
          // Filter Sheet
          Badge(
            isLabelVisible: state.filterOptions.hasActiveFilter,
            smallSize: 8,
            child: IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              tooltip: 'Filter Alerts',
              onPressed: _openFilterSheet,
            ),
          ),
          // Mission History Archive Link
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Mission History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: MissionHistoryScreen.routeName),
                  builder: (_) => MissionHistoryScreen(notifier: _notifier),
                ),
              );
            },
          ),
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Feeds',
            onPressed: () => _notifier.loadSosData(),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _notifier.loadSosData(),
          child: Column(
            children: [
              // Expandable Search Field
              if (_isSearchVisible)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: colorScheme.surface,
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search by ID, civilian name, district, type...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                _notifier.searchIncidents('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                    ),
                    onChanged: (val) => _notifier.searchIncidents(val),
                  ),
                ),

              // Active Filters Row
              if (state.filterOptions.hasActiveFilter)
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_outlined, size: 16),
                      const SizedBox(width: 6),
                      const Text('Active Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _notifier.updateFilters(const SosFilterOptions()),
                        child: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),

              // Top Metric Summary Cards
              if (metrics != null)
                Container(
                  height: 90,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      SizedBox(
                        width: 140,
                        child: SosSummaryMetricCard(
                          title: 'New Alerts',
                          count: metrics.newAlerts,
                          icon: Icons.notification_important_rounded,
                          color: Colors.blue.shade700,
                          onTap: () => _notifier.updateFilters(
                            state.filterOptions.copyWith(status: SosStatus.received),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 140,
                        child: SosSummaryMetricCard(
                          title: 'Assigned',
                          count: metrics.assigned,
                          icon: Icons.assignment_ind_rounded,
                          color: Colors.indigo.shade700,
                          onTap: () => _notifier.updateFilters(
                            state.filterOptions.copyWith(status: SosStatus.assigned),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 140,
                        child: SosSummaryMetricCard(
                          title: 'En Route',
                          count: metrics.enRoute,
                          icon: Icons.directions_car_filled_rounded,
                          color: Colors.orange.shade800,
                          onTap: () => _notifier.updateFilters(
                            state.filterOptions.copyWith(status: SosStatus.enRoute),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 140,
                        child: SosSummaryMetricCard(
                          title: 'High Priority',
                          count: metrics.highPriority,
                          icon: Icons.warning_rounded,
                          color: Colors.red.shade700,
                          onTap: () => _notifier.updateFilters(
                            state.filterOptions.copyWith(priority: SosPriority.critical),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 140,
                        child: SosSummaryMetricCard(
                          title: 'Resolved',
                          count: metrics.resolved,
                          icon: Icons.check_circle_rounded,
                          color: Colors.green.shade700,
                          onTap: () => _notifier.updateFilters(
                            state.filterOptions.copyWith(status: SosStatus.rescueCompleted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // SOS Feed List / States
              Expanded(
                child: _buildListBody(context, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListBody(BuildContext context, SosState state) {
    if (state.isLoading) {
      return const SosSkeletonLoader();
    }

    if (state.isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(state.errorMessage ?? 'Failed to load SOS telemetry'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _notifier.loadSosData(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      );
    }

    if (state.isEmpty || state.filteredIncidents.isEmpty) {
      return SosEmptyView(onRefresh: () => _notifier.loadSosData());
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.filteredIncidents.length,
      itemBuilder: (context, index) {
        final incident = state.filteredIncidents[index];
        return SosIncidentCard(
          incident: incident,
          onTap: () {
            _notifier.selectIncident(incident);
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: SosDetailsScreen.routeName),
                builder: (_) => SosDetailsScreen(
                  incident: incident,
                  notifier: _notifier,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
