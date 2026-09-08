import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';
import '../providers/resource_provider.dart';
import '../providers/resource_state.dart';
import '../widgets/resource_empty_view.dart';
import '../widgets/resource_filter_sheet.dart';
import '../widgets/resource_item_card.dart';
import '../widgets/resource_skeleton_loader.dart';
import 'resource_allocation_screen.dart';
import 'resource_details_screen.dart';

/// Screen managing full 100-item inventory across all 12 categories (`/rescue/resources/inventory`).
class EquipmentInventoryScreen extends StatefulWidget {
  final ResourceNotifier? notifier;
  final ResourceCategory? initialCategory;
  final ResourceStatus? initialStatus;

  const EquipmentInventoryScreen({
    super.key,
    this.notifier,
    this.initialCategory,
    this.initialStatus,
  });

  static const String routeName = '/rescue/resources/inventory';

  @override
  State<EquipmentInventoryScreen> createState() => _EquipmentInventoryScreenState();
}

class _EquipmentInventoryScreenState extends State<EquipmentInventoryScreen> {
  late final ResourceNotifier _notifier;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchOpen = false;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? ResourceDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    if (widget.initialCategory != null || widget.initialStatus != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifier.updateInventoryFilters(
          _notifier.state.inventoryFilters.copyWith(
            category: widget.initialCategory,
            status: widget.initialStatus,
          ),
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
      builder: (_) => ResourceFilterSheet(
        selectedDistrict: _notifier.state.inventoryFilters.district,
        selectedCategory: _notifier.state.inventoryFilters.category,
        selectedStatus: _notifier.state.inventoryFilters.status,
        showCategoryFilter: true,
        showStatusFilter: true,
        onApply: ({
          required district,
          category,
          status,
          shelterStatus,
          hospitalStatus,
          priority,
        }) {
          final opts = _notifier.state.inventoryFilters.copyWith(
            district: district,
            category: category,
            status: status,
            clearCategory: category == null,
            clearStatus: status == null,
          );
          _notifier.updateInventoryFilters(opts);
        },
      ),
    );
  }

  void _showRestockDialog(ResourceItem item) {
    final qtyController = TextEditingController(text: '100');
    final reasonController = TextEditingController(text: 'Logistics replenishment');
    final performedByController = TextEditingController(text: 'Supply Officer');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Restock ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Stock: ${item.currentQuantity} ${item.unit}'),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity to Add (${item.unit})',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Restock',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final qty = int.tryParse(qtyController.text) ?? 0;
              if (qty > 0) {
                Navigator.of(ctx).pop();
                final success = await _notifier.updateStock(
                  resourceId: item.id,
                  quantityChange: qty,
                  reason: reasonController.text,
                  performedBy: performedByController.text,
                  destinationName: item.warehouseName,
                );
                if (mounted && success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully restocked $qty ${item.unit} for ${item.name}')),
                  );
                }
              }
            },
            child: const Text('Confirm Restock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final items = state.filteredInventory;

    return Scaffold(
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search 100+ resources, warehouses...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () {
                      _searchController.clear();
                      _notifier.searchInventory('');
                      setState(() => _isSearchOpen = false);
                    },
                  ),
                ),
                onChanged: (q) => _notifier.searchInventory(q),
              )
            : const Text('Disaster Supplies & Fleet', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (!_isSearchOpen)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search Inventory',
              onPressed: () => setState(() => _isSearchOpen = true),
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: state.inventoryFilters.hasActiveFilters ? theme.colorScheme.primary : null,
            ),
            tooltip: 'Filter Inventory',
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.status == ResourceViewStatus.loading) {
            return const ResourceSkeletonLoader(itemCount: 6);
          }

          return Column(
            children: [
              // Category Horizontal Chip Selector
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ChoiceChip(
                      label: const Text('All Equipment'),
                      selected: state.inventoryFilters.category == null,
                      onSelected: (_) => _notifier.updateInventoryFilters(
                        state.inventoryFilters.copyWith(clearCategory: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...ResourceCategory.values.map((cat) {
                      final isSelected = state.inventoryFilters.category == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          avatar: Icon(cat.icon, size: 16),
                          label: Text(cat.displayName),
                          selected: isSelected,
                          onSelected: (selected) {
                            _notifier.updateInventoryFilters(
                              state.inventoryFilters.copyWith(
                                category: selected ? cat : null,
                                clearCategory: !selected,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Items Count & Low-Stock Warning Strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${items.length} of ${state.allInventory.length} resources',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (state.summary.criticalAlerts > 0)
                      GestureDetector(
                        onTap: () {
                          _notifier.updateInventoryFilters(
                            state.inventoryFilters.copyWith(status: ResourceStatus.critical),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFEF4444)),
                            const SizedBox(width: 4),
                            Text(
                              '${state.summary.criticalAlerts} Items Low Stock',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Resource Item Cards List
              Expanded(
                child: items.isEmpty
                    ? ResourceEmptyView(
                        title: 'No Resources Available',
                        description: 'No supply or equipment items match your search or active filters.',
                        icon: Icons.inventory_2_outlined,
                        actionLabel: 'Reset All Filters',
                        onAction: () {
                          _searchController.clear();
                          _notifier.updateInventoryFilters(const InventoryFilterOptions());
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () => _notifier.loadDashboard(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: items.length,
                          itemBuilder: (_, idx) {
                            final item = items[idx];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
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
                                onRestock: () => _showRestockDialog(item),
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
