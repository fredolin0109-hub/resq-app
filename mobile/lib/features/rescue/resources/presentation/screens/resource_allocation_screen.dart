import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';
import '../providers/resource_provider.dart';
import '../widgets/allocation_card.dart';
import '../widgets/resource_empty_view.dart';

/// Screen managing Resource Allocation and Rapid Dispatch Missions (`/rescue/resources/allocation`).
class ResourceAllocationScreen extends StatefulWidget {
  final ResourceNotifier? notifier;
  final int initialTabIndex;
  final DestinationType? preselectedDestinationType;
  final String? preselectedDestinationId;
  final String? preselectedDestinationName;
  final String? preselectedDestinationDistrict;
  final ResourceItem? preselectedResourceItem;

  const ResourceAllocationScreen({
    super.key,
    this.notifier,
    this.initialTabIndex = 0,
    this.preselectedDestinationType,
    this.preselectedDestinationId,
    this.preselectedDestinationName,
    this.preselectedDestinationDistrict,
    this.preselectedResourceItem,
  });

  static const String routeName = '/rescue/resources/allocation';

  @override
  State<ResourceAllocationScreen> createState() => _ResourceAllocationScreenState();
}

class _ResourceAllocationScreenState extends State<ResourceAllocationScreen>
    with SingleTickerProviderStateMixin {
  late final ResourceNotifier _notifier;
  late final TabController _tabController;

  // Form Controllers & State
  final _formKey = GlobalKey<FormState>();
  late DestinationType _selectedDestType;
  String? _selectedDestId;
  String _destName = '';
  String _destDistrict = 'Chennai';
  AllocationPriority _selectedPriority = AllocationPriority.high;
  String _selectedVehicle = 'TN-01-GA-1101 (Heavy Supply Truck)';
  String _selectedTeam = 'Alpha Rescue Squad (HQ)';
  String _eta = '30 mins';
  String _notes = '';

  final List<AllocatedItem> _allocatedItems = [];

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? ResourceDependencies.notifier;
    _notifier.addListener(_onStateChanged);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    _selectedDestType = widget.preselectedDestinationType ?? DestinationType.shelter;
    _selectedDestId = widget.preselectedDestinationId;
    _destName = widget.preselectedDestinationName ?? '';
    _destDistrict = widget.preselectedDestinationDistrict ?? 'Chennai';

    if (widget.preselectedResourceItem != null) {
      _allocatedItems.add(
        AllocatedItem(
          resourceItemId: widget.preselectedResourceItem!.id,
          resourceName: widget.preselectedResourceItem!.name,
          category: widget.preselectedResourceItem!.category,
          quantity: 50,
          unit: widget.preselectedResourceItem!.unit,
        ),
      );
    }
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _addItemToAllocation() {
    final available = _notifier.state.allInventory;
    ResourceItem selected = available.first;
    final qtyController = TextEditingController(text: '50');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Resource Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ResourceItem>(
                isExpanded: true,
                value: selected,
                decoration: const InputDecoration(labelText: 'Select Item', border: OutlineInputBorder()),
                items: available.take(30).map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text('${item.name} (${item.currentQuantity} ${item.unit})', overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selected = val);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Dispatch Quantity (${selected.unit})',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final qty = int.tryParse(qtyController.text) ?? 1;
                setState(() {
                  _allocatedItems.add(
                    AllocatedItem(
                      resourceItemId: selected.id,
                      resourceName: selected.name,
                      category: selected.category,
                      quantity: qty,
                      unit: selected.unit,
                    ),
                  );
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Add to Order'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAllocation() async {
    if (_allocatedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one resource item to allocate.')),
      );
      return;
    }

    if (_destName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or select a destination name.')),
      );
      return;
    }

    final newAlloc = ResourceAllocation(
      id: 'ALC-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      items: List.from(_allocatedItems),
      destinationType: _selectedDestType,
      destinationId: _selectedDestId ?? 'DEST-${DateTime.now().millisecondsSinceEpoch}',
      destinationName: _destName,
      destinationDistrict: _destDistrict,
      priority: _selectedPriority,
      vehicleId: 'VEH-${DateTime.now().millisecond}',
      vehicleName: _selectedVehicle,
      assignedTeamId: 'TEAM-${DateTime.now().millisecond}',
      assignedTeamName: _selectedTeam,
      estimatedArrival: _eta,
      deliveryStatus: DeliveryStatus.dispatched,
      createdAt: DateTime.now(),
      notes: _notes,
    );

    final success = await _notifier.createResourceAllocation(newAlloc);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order ${newAlloc.id} dispatched successfully!')),
        );
        setState(() {
          _allocatedItems.clear();
          _destName = '';
        });
        _tabController.animateTo(0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create allocation.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allocations = state.filteredAllocations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Dispatch & Allocation', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Live Dispatches (${allocations.length})'),
            const Tab(text: 'Create Allocation'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Live Dispatches
          allocations.isEmpty
              ? ResourceEmptyView(
                  title: 'No Active Dispatches',
                  description: 'There are no active resource allocations in transit.',
                  icon: Icons.local_shipping_outlined,
                  actionLabel: 'Create New Allocation',
                  onAction: () => _tabController.animateTo(1),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allocations.length,
                  itemBuilder: (_, idx) {
                    final alloc = allocations[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AllocationCard(
                        allocation: alloc,
                        onTap: () => _showAllocationTimelineModal(alloc, isDark),
                      ),
                    );
                  },
                ),

          // Tab 2: New Allocation Form
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Destination Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Destination Type Dropdown
                  DropdownButtonFormField<DestinationType>(
                    value: _selectedDestType,
                    decoration: const InputDecoration(
                      labelText: 'Destination Category',
                      border: OutlineInputBorder(),
                    ),
                    items: DestinationType.values.map((dt) {
                      return DropdownMenuItem(value: dt, child: Text(dt.displayName));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedDestType = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Destination Quick Selector or Manual Input
                  if (_selectedDestType == DestinationType.shelter)
                    DropdownButtonFormField<Shelter>(
                      decoration: const InputDecoration(
                        labelText: 'Select Registered Shelter',
                        border: OutlineInputBorder(),
                      ),
                      items: state.allShelters.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text('${s.name} (${s.district})', overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (s) {
                        if (s != null) {
                          setState(() {
                            _selectedDestId = s.id;
                            _destName = s.name;
                            _destDistrict = s.district;
                          });
                        }
                      },
                    )
                  else if (_selectedDestType == DestinationType.hospital)
                    DropdownButtonFormField<Hospital>(
                      decoration: const InputDecoration(
                        labelText: 'Select Registered Hospital',
                        border: OutlineInputBorder(),
                      ),
                      items: state.allHospitals.map((h) {
                        return DropdownMenuItem(
                          value: h,
                          child: Text('${h.name} (${h.district})', overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (h) {
                        if (h != null) {
                          setState(() {
                            _selectedDestId = h.id;
                            _destName = h.name;
                            _destDistrict = h.district;
                          });
                        }
                      },
                    )
                  else
                    TextFormField(
                      initialValue: _destName,
                      decoration: const InputDecoration(
                        labelText: 'Target Site Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => _destName = val,
                    ),

                  const SizedBox(height: 20),
                  Text(
                    '2. Mission Logistics & Priority',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Priority Selector
                  DropdownButtonFormField<AllocationPriority>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Emergency Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: AllocationPriority.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: p.color, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text(p.displayName),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedPriority = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Transport Vehicle
                  TextFormField(
                    initialValue: _selectedVehicle,
                    decoration: const InputDecoration(
                      labelText: 'Assigned Transport Vehicle',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => _selectedVehicle = val,
                  ),
                  const SizedBox(height: 12),

                  // Rescue Squad
                  TextFormField(
                    initialValue: _selectedTeam,
                    decoration: const InputDecoration(
                      labelText: 'Assigned Logistics Squad',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => _selectedTeam = val,
                  ),
                  const SizedBox(height: 12),

                  // ETA
                  TextFormField(
                    initialValue: _eta,
                    decoration: const InputDecoration(
                      labelText: 'Estimated Arrival (ETA)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => _eta = val,
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '3. Supply Manifest (${_allocatedItems.length} items)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _addItemToAllocation,
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Add Item'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_allocatedItems.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      child: const Center(
                        child: Text(
                          'No items added yet. Click "+ Add Item" to select from inventory.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._allocatedItems.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final itm = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(itm.category.icon, color: theme.colorScheme.primary),
                          title: Text(itm.resourceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text('Quantity: ${itm.quantity} ${itm.unit}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            onPressed: () => setState(() => _allocatedItems.removeAt(idx)),
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 24),

                  // Submit Dispatch Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: state.isAllocating ? null : _submitAllocation,
                      icon: state.isAllocating
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        state.isAllocating ? 'Dispatching...' : 'Confirm & Dispatch Mission',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllocationTimelineModal(ResourceAllocation alloc, bool isDark) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(alloc.id, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  alloc.deliveryStatus.displayName.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, color: alloc.deliveryStatus.color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Destination: ${alloc.destinationName} (${alloc.destinationDistrict})'),
            Text('Squad: ${alloc.assignedTeamName} | Transport: ${alloc.vehicleName}'),
            Text('ETA: ${alloc.estimatedArrival}'),
            const SizedBox(height: 14),
            const Text('Manifest Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...alloc.items.map((i) => Text('• ${i.quantity} ${i.unit} ${i.resourceName}')),
            const SizedBox(height: 20),
            if (alloc.deliveryStatus != DeliveryStatus.delivered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ResourceDependencies.repository.updateAllocationStatus(
                      allocationId: alloc.id,
                      newStatus: DeliveryStatus.delivered,
                    );
                    _notifier.loadDashboard();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Mark as Delivered'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
