import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';

/// Warehouse summary card showing capacity metrics and contact details.
class WarehouseCard extends StatelessWidget {
  final Warehouse warehouse;
  final VoidCallback? onTap;

  const WarehouseCard({
    super.key,
    required this.warehouse,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final utilRatio = warehouse.utilizationRate;
    final utilPercent = (utilRatio * 100).toInt();

    return Semantics(
      label: 'Warehouse ${warehouse.name}, District ${warehouse.district}, Capacity $utilPercent percent utilized',
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
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.warehouse_rounded, color: Color(0xFF6366F1), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            warehouse.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            warehouse.district,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: warehouse.status.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: warehouse.status.color.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        warehouse.status.displayName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: warehouse.status.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Utilization Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Capacity: ${warehouse.utilizedCapacity} / ${warehouse.totalCapacity} MT',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                      ),
                    ),
                    Text(
                      '$utilPercent% utilized',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: utilRatio > 0.9 ? const Color(0xFFEF4444) : const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: utilRatio,
                    minHeight: 6,
                    backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      utilRatio > 0.9 ? const Color(0xFFEF4444) : const Color(0xFF3B82F6),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Manager & Contact
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline_rounded, size: 13, color: isDark ? Colors.white60 : Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          warehouse.managerName,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 13, color: isDark ? Colors.white60 : Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${warehouse.itemCount} item categories',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
