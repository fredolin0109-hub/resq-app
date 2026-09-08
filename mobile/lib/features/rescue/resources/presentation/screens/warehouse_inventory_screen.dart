import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';
import '../providers/resource_provider.dart';
import '../providers/resource_state.dart';
import '../widgets/resource_empty_view.dart';
import '../widgets/resource_filter_sheet.dart';
import '../widgets/resource_skeleton_loader.dart';
import '../widgets/warehouse_card.dart';
import 'equipment_inventory_screen.dart';

/// Screen managing all 15 Regional Disaster Supply Warehouses.
class WarehouseInventoryScreen extends StatefulWidget {
  final ResourceNotifier? notifier;

  const WarehouseInventoryScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/resources/warehouses';

  @override
  State<WarehouseInventoryScreen> createState() => _WarehouseInventoryScreenState();
}

class _WarehouseInventoryScreenState extends State<WarehouseInventoryScreen> {
  late final ResourceNotifier _notifier;
  String _searchQuery = '';
  String _selectedDistrict = 'All';

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? ResourceDependencies.notifier;
    _notifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  List<Warehouse> _getFilteredWarehouses() {
    var list = _notifier.state.allWarehouses;
    if (_selectedDistrict != 'All') {
      list = list.where((w) => w.district.toLowerCase() == _selectedDistrict.toLowerCase()).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((w) =>
          w.name.toLowerCase().contains(q) ||
          w.district.toLowerCase().contains(q) ||
          w.managerName.toLowerCase().contains(q) ||
          w.address.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final warehouses = _getFilteredWarehouses();

    final totalCap = warehouses.fold(0, (sum, w) => sum + w.totalCapacity);
    final totalUtil = warehouses.fold(0, (sum, w) => sum + w.utilizedCapacity);
    final avgUtilPercent = totalCap > 0 ? ((totalUtil / totalCap) * 100).toInt() : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logistics & Warehouses', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Builder(
        builder: (context) {
          if (state.status == ResourceViewStatus.loading) {
            return const ResourceSkeletonLoader(itemCount: 5);
          }

          return Column(
            children: [
              // Search & District Filters
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search warehouse, manager, district...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),

              // Capacity Telemetry Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    _buildStatCol('Depots', '${warehouses.length}', const Color(0xFF8B5CF6), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Total Capacity', '$totalCap MT', const Color(0xFF3B82F6), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Utilized', '$totalUtil MT', const Color(0xFF10B981), isDark),
                    _buildStatDivider(isDark),
                    _buildStatCol('Occupancy', '$avgUtilPercent%', const Color(0xFFF59E0B), isDark),
                  ],
                ),
              ),

              // District Filter Chips
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ResourceFilterSheet.districts.map((d) {
                    final isSelected = _selectedDistrict.toLowerCase() == d.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(d),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedDistrict = d);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Warehouse Cards List
              Expanded(
                child: warehouses.isEmpty
                    ? ResourceEmptyView(
                        title: 'No Warehouses Found',
                        description: 'No supply warehouses match your filter.',
                        icon: Icons.warehouse_outlined,
                        actionLabel: 'Reset',
                        onAction: () => setState(() {
                          _selectedDistrict = 'All';
                          _searchQuery = '';
                        }),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: warehouses.length,
                        itemBuilder: (_, idx) {
                          final wh = warehouses[idx];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: WarehouseCard(
                              warehouse: wh,
                              onTap: () => _showWarehouseDetailsModal(wh, isDark),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showWarehouseDetailsModal(Warehouse warehouse, bool isDark) {
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
            Text(warehouse.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${warehouse.address}, ${warehouse.district}', style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade700)),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.person_pin_rounded, size: 16, color: Color(0xFF3B82F6)),
                const SizedBox(width: 6),
                Text('Depot Manager: ${warehouse.managerName} (${warehouse.contactPhone})'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.pin_drop_rounded, size: 16, color: Color(0xFFEF4444)),
                const SizedBox(width: 6),
                Text('GPS: ${warehouse.latitude.toStringAsFixed(4)}, ${warehouse.longitude.toStringAsFixed(4)} (Map Compatible)'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _notifier.updateInventoryFilters(
                    _notifier.state.inventoryFilters.copyWith(warehouseId: warehouse.id),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EquipmentInventoryScreen(notifier: _notifier)),
                  );
                },
                icon: const Icon(Icons.inventory_2_rounded),
                label: const Text('View All Inventory in this Warehouse'),
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
