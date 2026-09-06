import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';
import '../providers/resource_provider.dart';
import '../widgets/resource_status_badge.dart';
import 'resource_allocation_screen.dart';

/// Deep-dive Resource Details Screen (`/rescue/resources/details`).
class ResourceDetailsScreen extends StatefulWidget {
  final ResourceItem resourceItem;
  final ResourceNotifier? notifier;

  const ResourceDetailsScreen({
    super.key,
    required this.resourceItem,
    this.notifier,
  });

  static const String routeName = '/rescue/resources/details';

  @override
  State<ResourceDetailsScreen> createState() => _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState extends State<ResourceDetailsScreen> {
  late final ResourceNotifier _notifier;
  late ResourceItem _item;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? ResourceDependencies.notifier;
    _item = widget.resourceItem;
    _notifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      final updated = _notifier.state.allInventory.firstWhere(
        (i) => i.id == _item.id,
        orElse: () => _item,
      );
      setState(() => _item = updated);
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _showRestockDialog() {
    final qtyController = TextEditingController(text: '100');
    final reasonController = TextEditingController(text: 'Emergency stockpile restock');
    final userController = TextEditingController(text: 'District Supply Officer');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Restock ${_item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Stock: ${_item.currentQuantity} ${_item.unit}'),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity to Add (${_item.unit})',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
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
                  resourceId: _item.id,
                  quantityChange: qty,
                  reason: reasonController.text,
                  performedBy: userController.text,
                  destinationName: _item.warehouseName,
                );
                if (mounted && success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added $qty ${_item.unit} to stockpile!')),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ratio = _item.stockRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text(_item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            tooltip: 'Restock Item',
            icon: const Icon(Icons.add_shopping_cart_rounded),
            onPressed: _showRestockDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Auto Warning Alert Banner if low stock
            if (_item.autoWarning) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AUTOMATED LOW-STOCK WARNING',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Current stock (${_item.currentQuantity} ${_item.unit}) is below minimum threshold (${_item.minimumThreshold} ${_item.unit}). Immediate replenishment recommended.',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Main Info Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(_item.category.icon, color: theme.colorScheme.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _item.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Category: ${_item.category.displayName} • ID: ${_item.id}',
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      ResourceStatusBadge(status: _item.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Stock Telemetry
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Available Stock', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text(
                            '${_item.currentQuantity} ${_item.unit}',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _item.status.color),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Safety Minimum Threshold', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text(
                            '${_item.minimumThreshold} ${_item.unit}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(_item.status.color),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Warehouse location
                  Row(
                    children: [
                      const Icon(Icons.warehouse_rounded, size: 16, color: Color(0xFF8B5CF6)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Stored at: ${_item.warehouseName} (${_item.district})',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'Last Logged: ${_formatDateTime(_item.lastUpdated)}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  if (_item.description.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      _item.description,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade800),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showRestockDialog,
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: const Text('Restock Stockpile'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResourceAllocationScreen(
                            notifier: _notifier,
                            initialTabIndex: 1,
                            preselectedResourceItem: _item,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Allocate Item'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Usage & Movement History Log
            Text(
              'Stock Movement & Usage History (${_item.usageHistory.length})',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_item.usageHistory.isEmpty)
              const Text('No recent usage history recorded.', style: TextStyle(fontSize: 12, color: Colors.grey))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _item.usageHistory.length,
                itemBuilder: (_, idx) {
                  final log = _item.usageHistory[idx];
                  final isPositive = log.changeAmount > 0;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isPositive
                            ? const Color(0xFF10B981).withValues(alpha: 0.15)
                            : const Color(0xFFEF4444).withValues(alpha: 0.15),
                        child: Icon(
                          isPositive ? Icons.add_rounded : Icons.remove_rounded,
                          color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                      title: Text(log.reason, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text(
                        '${_formatDateTime(log.timestamp)} • Dest: ${log.destinationName}\nBy: ${log.performedBy}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isPositive ? '+' : ''}${log.changeAmount} ${_item.unit}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            ),
                          ),
                          Text('Rem: ${log.remainingQuantity}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
