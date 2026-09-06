import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';
import 'resource_status_badge.dart';

/// Interactive inventory card displaying individual resource stock levels, thresholds, and warehouse location.
class ResourceItemCard extends StatelessWidget {
  final ResourceItem item;
  final VoidCallback? onTap;
  final VoidCallback? onAllocate;
  final VoidCallback? onRestock;

  const ResourceItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onAllocate,
    this.onRestock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ratio = item.stockRatio;

    return Semantics(
      label: '${item.name}, Category ${item.category.displayName}, Current Quantity ${item.currentQuantity} ${item.unit}, Status ${item.status.displayName}',
      child: Material(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isDark ? 0 : 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: item.autoWarning
                    ? const Color(0xFFEF4444).withValues(alpha: 0.5)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                width: item.autoWarning ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Category & Status Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.category.icon,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.category.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ResourceStatusBadge(status: item.status),
                  ],
                ),
                const SizedBox(height: 12),

                // Quantity & Threshold Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${item.currentQuantity}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: item.status.color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.unit,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Min: ${item.minimumThreshold} ${item.unit}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Stock Level Gauge
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 6,
                    backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(item.status.color),
                  ),
                ),
                const SizedBox(height: 10),

                // Warehouse Location & Auto Warning Badge
                Row(
                  children: [
                    Icon(
                      Icons.warehouse_outlined,
                      size: 13,
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${item.warehouseName} (${item.district})',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.autoWarning) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 11, color: Color(0xFFEF4444)),
                            SizedBox(width: 2),
                            Text(
                              'LOW STOCK',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                if (onAllocate != null || onRestock != null) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onRestock != null)
                        TextButton.icon(
                          onPressed: onRestock,
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          icon: const Icon(Icons.add_shopping_cart_rounded, size: 14),
                          label: const Text('Restock', style: TextStyle(fontSize: 11)),
                        ),
                      if (onAllocate != null) ...[
                        const SizedBox(width: 6),
                        ElevatedButton.icon(
                          onPressed: onAllocate,
                          style: ElevatedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          icon: const Icon(Icons.send_rounded, size: 13),
                          label: const Text('Allocate', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
