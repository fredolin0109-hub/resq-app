import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';
import '../providers/ai_commander_provider.dart';
import '../providers/ai_commander_state.dart';
import '../widgets/ai_empty_view.dart';
import '../widgets/ai_filter_sheet.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/incident_analysis_card.dart';
import 'ai_chat_screen.dart';

/// Screen displaying in-depth multi-sensor AI Incident Analyses (`/rescue/ai/analysis`).
class IncidentAnalysisScreen extends StatefulWidget {
  final AICommanderNotifier? notifier;
  final IncidentSeverity? initialSeverity;

  const IncidentAnalysisScreen({
    super.key,
    this.notifier,
    this.initialSeverity,
  });

  static const String routeName = '/rescue/ai/analysis';

  @override
  State<IncidentAnalysisScreen> createState() => _IncidentAnalysisScreenState();
}

class _IncidentAnalysisScreenState extends State<IncidentAnalysisScreen> {
  late final AICommanderNotifier _notifier;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchOpen = false;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? AICommanderDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    if (widget.initialSeverity != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifier.updateIncidentFilters(
          _notifier.state.incidentFilters.copyWith(severity: widget.initialSeverity),
        );
      });
    }
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

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AIFilterSheet(
        selectedDistrict: _notifier.state.incidentFilters.district,
        selectedIncidentType: _notifier.state.incidentFilters.incidentType,
        selectedSeverity: _notifier.state.incidentFilters.severity,
        showPriorityFilter: false,
        onApply: ({required district, incidentType, severity, priority}) {
          final opts = _notifier.state.incidentFilters.copyWith(
            district: district,
            incidentType: incidentType,
            severity: severity,
            clearType: incidentType == null,
            clearSeverity: severity == null,
          );
          _notifier.updateIncidentFilters(opts);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final incidents = state.filteredIncidents;

    final totalPop = incidents.fold(0, (sum, i) => sum + i.estimatedPopulation);
    final highRisk = incidents.where((i) => i.riskScore >= 80).length;

    return Scaffold(
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search incidents, districts, areas...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear();
                      _notifier.searchIncidents('');
                      setState(() => _isSearchOpen = false);
                    },
                  ),
                ),
                onChanged: (q) => _notifier.searchIncidents(q),
              )
            : const Text('Incident Hazard Analyses', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (!_isSearchOpen)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search Incidents',
              onPressed: () => setState(() => _isSearchOpen = true),
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: state.incidentFilters.hasActiveFilters ? theme.colorScheme.primary : null,
            ),
            tooltip: 'Filter Incidents',
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.status == AICommanderViewStatus.loading) {
            return const AISkeletonLoader(itemCount: 4);
          }

          return Column(
            children: [
              // Analysis Metric Overview Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  border: Border(
                    bottom: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('Incidents', '${incidents.length}', const Color(0xFF3B82F6), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('High Risk (>80)', '$highRisk', const Color(0xFFEF4444), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Pop. at Risk', '~${(totalPop / 1000).toStringAsFixed(1)}k', const Color(0xFFF59E0B), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('AI Sensors', 'Active', const Color(0xFF10B981), isDark),
                  ],
                ),
              ),

              // Hazard Type Filter Chips
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ChoiceChip(
                      label: const Text('All Hazard Types'),
                      selected: state.incidentFilters.incidentType == null,
                      onSelected: (_) => _notifier.updateIncidentFilters(
                        state.incidentFilters.copyWith(clearType: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...IncidentType.values.map((type) {
                      final isSelected = state.incidentFilters.incidentType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          avatar: Icon(type.icon, size: 14),
                          label: Text(type.displayName),
                          selected: isSelected,
                          onSelected: (selected) {
                            _notifier.updateIncidentFilters(
                              state.incidentFilters.copyWith(
                                incidentType: selected ? type : null,
                                clearType: !selected,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Incident Analyses List
              Expanded(
                child: incidents.isEmpty
                    ? AIEmptyView(
                        title: 'No Incidents Found',
                        description: 'No hazard analyses match your search or filter options.',
                        icon: Icons.analytics_outlined,
                        actionLabel: 'Reset Filters',
                        onAction: () {
                          _searchController.clear();
                          _notifier.updateIncidentFilters(const IncidentFilterOptions());
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => _notifier.loadDashboard(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: incidents.length,
                          itemBuilder: (_, idx) {
                            final inc = incidents[idx];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: IncidentAnalysisCard(
                                analysis: inc,
                                onToggleAction: (actId, val) {
                                  _notifier.toggleActionItem(
                                    incidentId: inc.id,
                                    actionItemId: actId,
                                    isCompleted: val,
                                  );
                                },
                                onChatAbout: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AIChatScreen(
                                        notifier: _notifier,
                                        initialPrompt: 'Provide real-time operational advice for incident ${inc.title} (${inc.district})',
                                        relatedIncidentId: inc.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCol(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : const Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(width: 1, height: 24, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
  }
}
