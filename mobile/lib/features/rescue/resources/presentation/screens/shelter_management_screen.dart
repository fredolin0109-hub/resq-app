import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';
import '../providers/resource_provider.dart';
import '../providers/resource_state.dart';
import '../widgets/resource_empty_view.dart';
import '../widgets/resource_filter_sheet.dart';
import '../widgets/resource_skeleton_loader.dart';
import '../widgets/shelter_card.dart';
import 'resource_allocation_screen.dart';

/// Screen managing all 25 Disaster Relief Shelters (`/rescue/resources/shelters`).
class ShelterManagementScreen extends StatefulWidget {
  final ResourceNotifier? notifier;

  const ShelterManagementScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/resources/shelters';

  @override
  State<ShelterManagementScreen> createState() => _ShelterManagementScreenState();
}

class _ShelterManagementScreenState extends State<ShelterManagementScreen> {
  late final ResourceNotifier _notifier;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchOpen = false;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? ResourceDependencies.notifier;
    _notifier.addListener(_onStateChanged);
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
      builder: (_) => ResourceFilterSheet(
        selectedDistrict: _notifier.state.shelterFilters.district,
        selectedShelterStatus: _notifier.state.shelterFilters.status,
        showCategoryFilter: false,
        showStatusFilter: false,
        onApply: ({
          required district,
          category,
          status,
          shelterStatus,
          hospitalStatus,
          priority,
        }) {
          final opts = _notifier.state.shelterFilters.copyWith(
            district: district,
            status: shelterStatus,
          );
          _notifier.updateShelterFilters(opts);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shelters = state.filteredShelters;

    final totalCap = shelters.fold(0, (sum, s) => sum + s.capacity);
    final totalOcc = shelters.fold(0, (sum, s) => sum + s.currentOccupancy);
    final totalBeds = shelters.fold(0, (sum, s) => sum + s.availableBeds);

    return Scaffold(
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search shelter, district...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear();
                      _notifier.searchShelters('');
                      setState(() => _isSearchOpen = false);
                    },
                  ),
                ),
                onChanged: (q) => _notifier.searchShelters(q),
              )
            : const Text('Emergency Shelters', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (!_isSearchOpen)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search Shelters',
              onPressed: () => setState(() => _isSearchOpen = true),
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: state.shelterFilters.hasActiveFilters ? theme.colorScheme.primary : null,
            ),
            tooltip: 'Filter Shelters',
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.status == ResourceViewStatus.loading) {
            return const ResourceSkeletonLoader(itemCount: 5);
          }

          return Column(
            children: [
              // Metric Overview Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('Shelters', '${shelters.length}', const Color(0xFF3B82F6), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Total Capacity', '$totalCap', const Color(0xFF10B981), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Occupants', '$totalOcc', const Color(0xFFF59E0B), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Free Beds', '$totalBeds', const Color(0xFF8B5CF6), isDark),
                  ],
                ),
              ),

              // Quick Status Filter Chips
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ChoiceChip(
                      label: const Text('All Statuses'),
                      selected: state.shelterFilters.status == null,
                      onSelected: (_) => _notifier.updateShelterFilters(
                        state.shelterFilters.copyWith(clearStatus: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...ShelterStatus.values.map((st) {
                      final isSelected = state.shelterFilters.status == st;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(st.displayName),
                          selected: isSelected,
                          selectedColor: st.color.withValues(alpha: 0.2),
                          onSelected: (selected) {
                            _notifier.updateShelterFilters(
                              state.shelterFilters.copyWith(
                                status: selected ? st : null,
                                clearStatus: !selected,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Shelter Cards List
              Expanded(
                child: shelters.isEmpty
                    ? ResourceEmptyView(
                        title: 'No Shelters Found',
                        description: 'No active shelters match your search or filter criteria.',
                        icon: Icons.night_shelter_outlined,
                        actionLabel: 'Reset Filters',
                        onAction: () {
                          _searchController.clear();
                          _notifier.updateShelterFilters(const ShelterFilterOptions());
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => _notifier.loadDashboard(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: shelters.length,
                          itemBuilder: (_, idx) {
                            final shelter = shelters[idx];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ShelterCard(
                                shelter: shelter,
                                onTap: () => _showShelterDetailsModal(shelter, isDark),
                                onAllocate: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ResourceAllocationScreen(
                                        notifier: _notifier,
                                        initialTabIndex: 1,
                                        preselectedDestinationType: DestinationType.shelter,
                                        preselectedDestinationId: shelter.id,
                                        preselectedDestinationName: shelter.name,
                                        preselectedDestinationDistrict: shelter.district,
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

  void _showShelterDetailsModal(Shelter shelter, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              shelter.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${shelter.address}, ${shelter.district}',
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person_rounded, size: 16, color: Color(0xFF3B82F6)),
                const SizedBox(width: 6),
                Text('In-charge: ${shelter.contactPerson} (${shelter.contactPhone})'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.pin_drop_rounded, size: 16, color: Color(0xFFEF4444)),
                const SizedBox(width: 6),
                Text('Coordinates: ${shelter.latitude.toStringAsFixed(4)}, ${shelter.longitude.toStringAsFixed(4)} (Map Ready)'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ResourceAllocationScreen(
                        notifier: _notifier,
                        initialTabIndex: 1,
                        preselectedDestinationType: DestinationType.shelter,
                        preselectedDestinationId: shelter.id,
                        preselectedDestinationName: shelter.name,
                        preselectedDestinationDistrict: shelter.district,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.local_shipping_rounded),
                label: const Text('Dispatch Resources to this Shelter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white60 : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(
      width: 1,
      height: 24,
      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
    );
  }
}
