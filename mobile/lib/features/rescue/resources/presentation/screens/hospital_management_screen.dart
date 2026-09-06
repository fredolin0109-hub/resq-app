import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';
import '../providers/resource_provider.dart';
import '../providers/resource_state.dart';
import '../widgets/hospital_card.dart';
import '../widgets/resource_empty_view.dart';
import '../widgets/resource_filter_sheet.dart';
import '../widgets/resource_skeleton_loader.dart';
import 'resource_allocation_screen.dart';

/// Screen managing all 20 Emergency Medical Hospitals (`/rescue/resources/hospitals`).
class HospitalManagementScreen extends StatefulWidget {
  final ResourceNotifier? notifier;

  const HospitalManagementScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/resources/hospitals';

  @override
  State<HospitalManagementScreen> createState() => _HospitalManagementScreenState();
}

class _HospitalManagementScreenState extends State<HospitalManagementScreen> {
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
        selectedDistrict: _notifier.state.hospitalFilters.district,
        selectedHospitalStatus: _notifier.state.hospitalFilters.status,
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
          final opts = _notifier.state.hospitalFilters.copyWith(
            district: district,
            status: hospitalStatus,
          );
          _notifier.updateHospitalFilters(opts);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hospitals = state.filteredHospitals;

    final totalAvailBeds = hospitals.fold(0, (sum, h) => sum + h.availableBeds);
    final totalIcuBeds = hospitals.fold(0, (sum, h) => sum + h.icuBeds);
    final totalDoctors = hospitals.fold(0, (sum, h) => sum + h.emergencyDoctors);
    final totalAmbulances = hospitals.fold(0, (sum, h) => sum + h.ambulances);

    return Scaffold(
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search hospital, district, trauma...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear();
                      _notifier.searchHospitals('');
                      setState(() => _isSearchOpen = false);
                    },
                  ),
                ),
                onChanged: (q) => _notifier.searchHospitals(q),
              )
            : const Text('Emergency Medical Network', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (!_isSearchOpen)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search Hospitals',
              onPressed: () => setState(() => _isSearchOpen = true),
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: state.hospitalFilters.hasActiveFilters ? theme.colorScheme.primary : null,
            ),
            tooltip: 'Filter Hospitals',
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
              // Medical Telemetry Top Banner
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
                    _buildStatCol('Hospitals', '${hospitals.length}', const Color(0xFF3B82F6), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Avail Beds', '$totalAvailBeds', const Color(0xFF10B981), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('ICU Beds', '$totalIcuBeds', const Color(0xFFEF4444), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('ER Doctors', '$totalDoctors', const Color(0xFF8B5CF6), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Ambulances', '$totalAmbulances', const Color(0xFFF59E0B), isDark),
                  ],
                ),
              ),

              // Trauma Center & Status Quick Filters
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FilterChip(
                      label: const Text('Trauma Centers Only'),
                      selected: state.hospitalFilters.requiresTrauma == true,
                      onSelected: (selected) {
                        _notifier.updateHospitalFilters(
                          state.hospitalFilters.copyWith(
                            requiresTrauma: selected ? true : null,
                            clearTrauma: !selected,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('All Statuses'),
                      selected: state.hospitalFilters.status == null,
                      onSelected: (_) => _notifier.updateHospitalFilters(
                        state.hospitalFilters.copyWith(clearStatus: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...HospitalStatus.values.map((st) {
                      final isSelected = state.hospitalFilters.status == st;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(st.displayName),
                          selected: isSelected,
                          selectedColor: st.color.withValues(alpha: 0.2),
                          onSelected: (selected) {
                            _notifier.updateHospitalFilters(
                              state.hospitalFilters.copyWith(
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

              // Hospital Cards List
              Expanded(
                child: hospitals.isEmpty
                    ? ResourceEmptyView(
                        title: 'No Hospitals Found',
                        description: 'No medical facilities match your filter or search criteria.',
                        icon: Icons.local_hospital_outlined,
                        actionLabel: 'Reset Filters',
                        onAction: () {
                          _searchController.clear();
                          _notifier.updateHospitalFilters(const HospitalFilterOptions());
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => _notifier.loadDashboard(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: hospitals.length,
                          itemBuilder: (_, idx) {
                            final hospital = hospitals[idx];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HospitalCard(
                                hospital: hospital,
                                onTap: () => _showHospitalDetailsModal(hospital, isDark),
                                onAllocate: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ResourceAllocationScreen(
                                        notifier: _notifier,
                                        initialTabIndex: 1,
                                        preselectedDestinationType: DestinationType.hospital,
                                        preselectedDestinationId: hospital.id,
                                        preselectedDestinationName: hospital.name,
                                        preselectedDestinationDistrict: hospital.district,
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

  void _showHospitalDetailsModal(Hospital hospital, bool isDark) {
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
              hospital.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${hospital.address}, ${hospital.district}',
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            const Text('Specialty Emergency Units:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: hospital.specialtyServices.map((s) {
                return Chip(
                  label: Text(s, style: const TextStyle(fontSize: 11)),
                  backgroundColor: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.pin_drop_rounded, size: 16, color: Color(0xFFEF4444)),
                const SizedBox(width: 6),
                Text('Coordinates: ${hospital.latitude.toStringAsFixed(4)}, ${hospital.longitude.toStringAsFixed(4)} (Map Ready)'),
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
                        preselectedDestinationType: DestinationType.hospital,
                        preselectedDestinationId: hospital.id,
                        preselectedDestinationName: hospital.name,
                        preselectedDestinationDistrict: hospital.district,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.medical_services_rounded),
                label: const Text('Dispatch Medical Supplies to this Hospital'),
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
