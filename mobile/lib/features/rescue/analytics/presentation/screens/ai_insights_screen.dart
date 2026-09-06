import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/analytics_empty_view.dart';
import '../widgets/analytics_skeleton_loader.dart';

/// Screen displaying AI operational and predictive recommendations with action triggers.
class AIInsightsScreen extends StatefulWidget {
  const AIInsightsScreen({super.key});

  @override
  State<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends State<AIInsightsScreen> {
  final _notifier = AnalyticsDependencies.notifier;
  final TextEditingController _searchController = TextEditingController();

  static const List<String> categories = [
    'All',
    'High Risk District',
    'Resource Shortage',
    'Suggested Allocation',
    'Infrastructure Risk',
    'Medical Outbreak',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = _notifier.state.insightFilters.searchQuery;
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
        final filters = state.insightFilters;
        final insights = state.filteredInsights;

        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Operational Insights'),
            centerTitle: true,
            actions: [
              if (filters.hasActiveFilters)
                IconButton(
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  tooltip: 'Clear Filters',
                  onPressed: () {
                    _searchController.clear();
                    _notifier.clearInsightFilters();
                  },
                ),
            ],
          ),
          body: state.status == AnalyticsViewStatus.loading &&
                  state.allInsights.isEmpty
              ? const AnalyticsSkeletonLoader(itemCount: 4)
              : Column(
                  children: [
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),
                    Expanded(
                      child: insights.isEmpty
                          ? AnalyticsEmptyView(
                              title: 'No Matching Insights',
                              message:
                                  'Try clearing your search query or selecting "All Categories".',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                _notifier.clearInsightFilters();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: insights.length,
                              itemBuilder: (context, index) {
                                final ins = insights[index];
                                return AIInsightCard(
                                  insight: ins,
                                  onApplyAction: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Dispatch action authorized for: ${ins.title}'),
                                        backgroundColor: Colors.purple,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
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
    final filters = state.insightFilters;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search AI recommendations, risks, predictions...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _notifier.setInsightSearchQuery('');
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
            onChanged: (val) => _notifier.setInsightSearchQuery(val),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = filters.category == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(cat),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                    selectedColor: colorScheme.primary,
                    showCheckmark: false,
                    onSelected: (_) => _notifier.setInsightCategory(cat),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
