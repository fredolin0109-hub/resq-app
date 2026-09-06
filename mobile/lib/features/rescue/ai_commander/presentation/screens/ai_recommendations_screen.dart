import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';
import '../providers/ai_commander_provider.dart';
import '../providers/ai_commander_state.dart';
import '../widgets/ai_empty_view.dart';
import '../widgets/ai_filter_sheet.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/recommendation_card.dart';

/// Screen displaying all 20+ tactical AI Directives & Recommendations (`/rescue/ai/recommendations`).
class AIRecommendationsScreen extends StatefulWidget {
  final AICommanderNotifier? notifier;
  final RecommendationPriority? initialPriority;

  const AIRecommendationsScreen({
    super.key,
    this.notifier,
    this.initialPriority,
  });

  static const String routeName = '/rescue/ai/recommendations';

  @override
  State<AIRecommendationsScreen> createState() => _AIRecommendationsScreenState();
}

class _AIRecommendationsScreenState extends State<AIRecommendationsScreen> {
  late final AICommanderNotifier _notifier;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchOpen = false;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? AICommanderDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    if (widget.initialPriority != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifier.updateRecommendationFilters(
          _notifier.state.recommendationFilters.copyWith(priority: widget.initialPriority),
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
        selectedDistrict: 'All',
        selectedPriority: _notifier.state.recommendationFilters.priority,
        showPriorityFilter: true,
        onApply: ({required district, incidentType, severity, priority}) {
          final opts = _notifier.state.recommendationFilters.copyWith(
            priority: priority,
            clearPriority: priority == null,
          );
          _notifier.updateRecommendationFilters(opts);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recs = state.filteredRecommendations;

    final immediateCount = recs.where((r) => r.priority == RecommendationPriority.immediate).length;
    final executedCount = recs.where((r) => r.isExecuted).length;

    return Scaffold(
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search directives, reasoning, impact...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear();
                      _notifier.searchRecommendations('');
                      setState(() => _isSearchOpen = false);
                    },
                  ),
                ),
                onChanged: (q) => _notifier.searchRecommendations(q),
              )
            : const Text('AI Tactical Directives', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (!_isSearchOpen)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search Recommendations',
              onPressed: () => setState(() => _isSearchOpen = true),
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: state.recommendationFilters.hasActiveFilters ? theme.colorScheme.primary : null,
            ),
            tooltip: 'Filter Recommendations',
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.status == AICommanderViewStatus.loading) {
            return const AISkeletonLoader(itemCount: 5);
          }

          return Column(
            children: [
              // Directive Summary Top Strip
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
                    _buildStatCol('Directives', '${recs.length}', const Color(0xFF3B82F6), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Immediate', '$immediateCount', const Color(0xFFEF4444), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Executed', '$executedCount', const Color(0xFF10B981), isDark),
                  ],
                ),
              ),

              // Priority Filter Chips
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ChoiceChip(
                      label: const Text('All Priorities'),
                      selected: state.recommendationFilters.priority == null,
                      onSelected: (_) => _notifier.updateRecommendationFilters(
                        state.recommendationFilters.copyWith(clearPriority: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...RecommendationPriority.values.map((p) {
                      final isSelected = state.recommendationFilters.priority == p;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(p.displayName),
                          selected: isSelected,
                          selectedColor: p.color.withValues(alpha: 0.2),
                          onSelected: (selected) {
                            _notifier.updateRecommendationFilters(
                              state.recommendationFilters.copyWith(
                                priority: selected ? p : null,
                                clearPriority: !selected,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Recommendations List
              Expanded(
                child: recs.isEmpty
                    ? AIEmptyView(
                        title: 'No AI recommendations available',
                        description: 'No tactical directives match your filter or search criteria.',
                        icon: Icons.lightbulb_outline_rounded,
                        actionLabel: 'Reset Filters',
                        onAction: () {
                          _searchController.clear();
                          _notifier.updateRecommendationFilters(const RecommendationFilterOptions());
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => _notifier.loadDashboard(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: recs.length,
                          itemBuilder: (_, idx) {
                            final rec = recs[idx];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: RecommendationCard(
                                recommendation: rec,
                                onExecute: () async {
                                  final success = await _notifier.executeRecommendation(rec.id);
                                  if (mounted && success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Field Directive "${rec.title}" confirmed!')),
                                    );
                                  }
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
