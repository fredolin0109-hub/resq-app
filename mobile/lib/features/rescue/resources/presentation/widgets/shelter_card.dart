import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';

/// Interactive card component displaying Disaster Relief Shelter status.
class ShelterCard extends StatelessWidget {
  final Shelter shelter;
  final VoidCallback? onTap;
  final VoidCallback? onAllocate;

  const ShelterCard({
    super.key,
    required this.shelter,
    this.onTap,
    this.onAllocate,
  });

  String _formatRelativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final occRatio = shelter.occupancyRate;
    final occPercent = (occRatio * 100).toInt();

    final statusColor = shelter.status.color;
    final occColor = occRatio >= 0.95
        ? const Color(0xFFEF4444)
        : (occRatio >= 0.75 ? const Color(0xFFF59E0B) : const Color(0xFF10B981));

    return Semantics(
      label: 'Shelter ${shelter.name}, District ${shelter.district}, Status ${shelter.status.displayName}, Occupancy $occPercent percent',
      child: Material(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isDark ? 0 : 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shelter.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                shelter.district,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•  Updated ${_formatRelativeTime(shelter.lastUpdated)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        shelter.status.displayName.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Occupancy Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Occupancy: ${shelter.currentOccupancy} / ${shelter.capacity}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : const Color(0xFF334155),
                          ),
                        ),
                        Text(
                          '$occPercent% full (${shelter.availableBeds} beds free)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: occColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: occRatio,
                        minHeight: 7,
                        backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(occColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Amenity and Supplies Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildSupplyTag('Food', shelter.foodAvailability.displayName, shelter.foodAvailability.color, isDark),
                    _buildSupplyTag('Water', shelter.waterAvailability.displayName, shelter.waterAvailability.color, isDark),
                    _buildFeatureChip(Icons.medical_services_outlined, 'Medical', shelter.medicalSupport, isDark),
                    _buildFeatureChip(Icons.bolt_outlined, 'Power', shelter.electricity, isDark),
                    _buildFeatureChip(Icons.wifi_rounded, 'Internet', shelter.internet, isDark),
                  ],
                ),

                if (onAllocate != null) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contact: ${shelter.contactPhone}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: onAllocate,
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          side: BorderSide(color: theme.colorScheme.primary),
                        ),
                        icon: const Icon(Icons.outbox_rounded, size: 14),
                        label: const Text('Allocate Supplies', style: TextStyle(fontSize: 12)),
                      ),
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

  Widget _buildSupplyTag(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label, bool active, bool isDark) {
    final activeColor = active ? const Color(0xFF10B981) : (isDark ? Colors.white24 : Colors.grey.shade400);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: activeColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? (isDark ? Colors.white : const Color(0xFF1E293B)) : (isDark ? Colors.white38 : Colors.grey.shade500),
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              decoration: active ? null : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}
