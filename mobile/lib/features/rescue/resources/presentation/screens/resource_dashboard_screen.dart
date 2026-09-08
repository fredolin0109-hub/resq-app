import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';
import '../providers/resource_provider.dart';
import '../providers/resource_state.dart';
import '../widgets/allocation_card.dart';
import '../widgets/resource_item_card.dart';
import '../widgets/resource_skeleton_loader.dart';
import '../widgets/resource_summary_card.dart';
import 'equipment_inventory_screen.dart';
import 'hospital_management_screen.dart';
import 'resource_allocation_screen.dart';
import 'resource_details_screen.dart';
import 'shelter_management_screen.dart';
import 'warehouse_inventory_screen.dart';

/// Central Resource & Shelter Mission Command Dashboard (`/rescue/resources`).
class ResourceDashboardScreen extends StatefulWidget {
  final ResourceNotifier? notifier;

  const ResourceDashboardScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/resources';

  @override
  State<ResourceDashboardScreen> createState() => _ResourceDashboardScreenState();
}

class _ResourceDashboardScreenState extends State<ResourceDashboardScreen> {
  late final ResourceNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? ResourceDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_notifier.state.status == ResourceViewStatus.initial) {
        _notifier.loadDashboard();
      }
    });
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resource & Logistics Hub',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'State Disaster Supply Command',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Data',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _notifier.loadDashboard(),
          ),
          IconButton(
            tooltip: 'New Allocation',
            icon: const Icon(Icons.add_task_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ResourceAllocationScreen(notifier: _notifier, initialTabIndex: 1)),
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.status == ResourceViewStatus.loading) {
            return const ResourceSkeletonLoader(itemCount: 6);
          }

          if (state.status == ResourceViewStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage ?? 'Failed to load resources',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _notifier.loadDashboard(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final sum = state.summary;
          final lowStockItems = state.allInventory.where((r) => r.autoWarning).take(4).toList();
          final recentAllocs = state.allAllocations.take(3).toList();

          return RefreshIndicator(
            onRefresh: () => _notifier.loadDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // High Level Quick Navigation Grid
                  _buildQuickNavPills(context, isDark),
                  const SizedBox(height: 16),

                  // Section Title: Key Metrics
                  Text(
                    'Operational Supply Summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 8 Summary Cards Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      ResourceSummaryCard(
                        title: 'Total Resources',
                        value: '${sum.totalResources} Items',
                        subtitle: '${sum.availableResources} Available',
                        icon: Icons.inventory_2_rounded,
                        color: const Color(0xFF3B82F6),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EquipmentInventoryScreen(notifier: _notifier)),
                        ),
                      ),
                      ResourceSummaryCard(
                        title: 'Active Shelters',
                        value: '${sum.activeShelters} / ${sum.totalShelters}',
                        subtitle: 'Multi-hazard camps',
                        icon: Icons.night_shelter_rounded,
                        color: const Color(0xFF10B981),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ShelterManagementScreen(notifier: _notifier)),
                        ),
                      ),
                      ResourceSummaryCard(
                        title: 'Emergency Hospitals',
                        value: '${sum.totalHospitals} Centers',
                        subtitle: '${sum.availableHospitalBeds} Beds (${sum.availableIcuBeds} ICU)',
                        icon: Icons.local_hospital_rounded,
                        color: const Color(0xFFEF4444),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HospitalManagementScreen(notifier: _notifier)),
                        ),
                      ),
                      ResourceSummaryCard(
                        title: 'Food Ration Packs',
                        value: '${(sum.foodStockPacks / 1000).toStringAsFixed(1)}k Packs',
                        subtitle: 'Ready-to-eat supply',
                        icon: Icons.fastfood_rounded,
                        color: const Color(0xFFF59E0B),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EquipmentInventoryScreen(
                              notifier: _notifier,
                              initialCategory: ResourceCategory.foodPacks,
                            ),
                          ),
                        ),
                      ),
                      ResourceSummaryCard(
                        title: 'Water Reserves',
                        value: '${(sum.waterStockBottles / 1000).toStringAsFixed(1)}k Bottles',
                        subtitle: 'Packaged & bulk water',
                        icon: Icons.water_drop_rounded,
                        color: const Color(0xFF06B6D4),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EquipmentInventoryScreen(
                              notifier: _notifier,
                              initialCategory: ResourceCategory.waterBottles,
                            ),
                          ),
                        ),
                      ),
                      ResourceSummaryCard(
                        title: 'Medical Kits',
                        value: '${sum.medicalKitsCount} Kits',
                        subtitle: 'Trauma & Triage packs',
                        icon: Icons.medical_services_rounded,
                        color: const Color(0xFFEC4899),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EquipmentInventoryScreen(
                              notifier: _notifier,
                              initialCategory: ResourceCategory.medicalKits,
                            ),
                          ),
                        ),
                      ),
                      ResourceSummaryCard(
                        title: 'Fuel Reserves',
                        value: '${(sum.fuelAvailableLiters / 1000).toStringAsFixed(1)}k Litres',
                        subtitle: 'High-speed diesel & petrol',
                        icon: Icons.local_gas_station_rounded,
                        color: const Color(0xFFF97316),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EquipmentInventoryScreen(
                              notifier: _notifier,
                              initialCategory: ResourceCategory.fuel,
                            ),
                          ),
                        ),
                      ),
                      ResourceSummaryCard(
                        title: 'Logistics Depots',
                        value: '${state.allWarehouses.length} Warehouses',
                        subtitle: 'Regional supply bases',
                        icon: Icons.warehouse_rounded,
                        color: const Color(0xFF8B5CF6),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => WarehouseInventoryScreen(notifier: _notifier)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Critical Low-Stock Warning Section
                  if (lowStockItems.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 20),
                            const SizedBox(width: 6),
                            Text(
                              'Low Stock Warnings (${state.summary.criticalAlerts})',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EquipmentInventoryScreen(
                                notifier: _notifier,
                                initialStatus: ResourceStatus.critical,
                              ),
                            ),
                          ),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lowStockItems.length,
                      itemBuilder: (_, idx) {
                        final item = lowStockItems[idx];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ResourceItemCard(
                            item: item,
                            onTap: () {
                              _notifier.selectResource(item);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ResourceDetailsScreen(resourceItem: item, notifier: _notifier),
                                ),
                              );
                            },
                            onAllocate: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ResourceAllocationScreen(
                                    notifier: _notifier,
                                    initialTabIndex: 1,
                                    preselectedResourceItem: item,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Recent Active Dispatches
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live Resource Dispatches (${sum.activeAllocations})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ResourceAllocationScreen(notifier: _notifier)),
                        ),
                        child: const Text('View Dispatches'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentAllocs.length,
                    itemBuilder: (_, idx) {
                      final alloc = recentAllocs[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AllocationCard(
                          allocation: alloc,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ResourceAllocationScreen(notifier: _notifier)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickNavPills(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildNavPill(
            context,
            'Shelters (${_notifier.state.allShelters.length})',
            Icons.night_shelter_rounded,
            const Color(0xFF10B981),
            () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShelterManagementScreen(notifier: _notifier))),
          ),
          const SizedBox(width: 8),
          _buildNavPill(
            context,
            'Hospitals (${_notifier.state.allHospitals.length})',
            Icons.local_hospital_rounded,
            const Color(0xFFEF4444),
            () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => HospitalManagementScreen(notifier: _notifier))),
          ),
          const SizedBox(width: 8),
          _buildNavPill(
            context,
            'Inventory (${_notifier.state.allInventory.length})',
            Icons.inventory_2_rounded,
            const Color(0xFF3B82F6),
            () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EquipmentInventoryScreen(notifier: _notifier))),
          ),
          const SizedBox(width: 8),
          _buildNavPill(
            context,
            'Warehouses (${_notifier.state.allWarehouses.length})',
            Icons.warehouse_rounded,
            const Color(0xFF8B5CF6),
            () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WarehouseInventoryScreen(notifier: _notifier))),
          ),
          const SizedBox(width: 8),
          _buildNavPill(
            context,
            'Allocations (${_notifier.state.allAllocations.length})',
            Icons.local_shipping_rounded,
            const Color(0xFFF59E0B),
            () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ResourceAllocationScreen(notifier: _notifier))),
          ),
        ],
      ),
    );
  }

  Widget _buildNavPill(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ActionChip(
      avatar: Icon(icon, color: color, size: 16),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      onPressed: onTap,
    );
  }
}
