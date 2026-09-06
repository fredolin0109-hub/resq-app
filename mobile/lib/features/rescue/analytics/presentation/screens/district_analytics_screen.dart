import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/district_analytics_card.dart';
import '../widgets/analytics_empty_view.dart';
import '../widgets/analytics_skeleton_loader.dart';

/// Screen displaying disaster profiles and telemetry across all 13 Tamil Nadu districts.
class DistrictAnalyticsScreen extends StatefulWidget {
  const DistrictAnalyticsScreen({super.key});

  @override
  State<DistrictAnalyticsScreen> createState() =>
      _DistrictAnalyticsScreenState();
}

class _DistrictAnalyticsScreenState extends State<DistrictAnalyticsScreen> {
  final _notifier = AnalyticsDependencies.notifier;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = _notifier.state.districtFilters.searchQuery;
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
        final filters = state.districtFilters;
        final districts = state.filteredDistricts;

        return Scaffold(
          appBar: AppBar(
            title: const Text('District Disaster Analytics'),
            centerTitle: true,
            actions: [
              if (filters.hasActiveFilters)
                IconButton(
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  tooltip: 'Clear Filters',
                  onPressed: () {
                    _searchController.clear();
                    _notifier.clearDistrictFilters();
                  },
                ),
            ],
          ),
          body: state.status == AnalyticsViewStatus.loading &&
                  state.allDistricts.isEmpty
              ? const AnalyticsSkeletonLoader(itemCount: 6)
              : Column(
                  children: [
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),
                    Expanded(
                      child: districts.isEmpty
                          ? AnalyticsEmptyView(
                              title: 'No Districts Found',
                              message:
                                  'Try adjusting your search query or risk filter.',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                _notifier.clearDistrictFilters();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: districts.length,
                              itemBuilder: (context, index) {
                                final dist = districts[index];
                                return DistrictAnalyticsCard(
                                  district: dist,
                                  onTap: () =>
                                      _showDistrictDetail(context, dist),
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
    final filters = state.districtFilters;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Tamil Nadu district...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _notifier.setDistrictSearchQuery('');
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
            onChanged: (val) => _notifier.setDistrictSearchQuery(val),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  selected: filters.riskTier == null,
                  label: const Text('All Risk Tiers'),
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filters.riskTier == null
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  selectedColor: colorScheme.primary,
                  showCheckmark: false,
                  onSelected: (_) => _notifier.setDistrictRiskTier(null),
                ),
                const SizedBox(width: 6),
                ...RiskTier.values.map((tier) {
                  final isSelected = filters.riskTier == tier;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(tier.displayName),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white : tier.color,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedColor: tier.color,
                      backgroundColor: tier.color.withValues(alpha: 0.1),
                      showCheckmark: false,
                      onSelected: (selected) {
                        _notifier.setDistrictRiskTier(selected ? tier : null);
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

  void _showDistrictDetail(BuildContext context, DistrictAnalyticsItem dist) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final riskColor = dist.riskTier.color;

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
                      color: riskColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_city_rounded,
                      color: riskColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'District Profile',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: riskColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dist.district,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: riskColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      dist.riskTier.displayName,
                      style: TextStyle(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow(
                  'Total Reported Incidents', '${dist.incidentCount} cases'),
              _buildDetailRow('Impacted Population',
                  '${dist.populationImpacted.toString()} citizens'),
              _buildDetailRow('Community Relief Shelters',
                  '${dist.sheltersOpen} open / ${dist.totalShelters} total'),
              _buildDetailRow('Designated Disaster Hospitals',
                  '${dist.hospitalsActive} operational / ${dist.totalHospitals} total'),
              _buildDetailRow('Logistics Resources Available',
                  '${dist.resourcesAvailable} items'),
              _buildDetailRow('Active Live Rescue Missions',
                  '${dist.activeMissionsCount} deployments in progress'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Close District Profile'),
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
