import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';

/// Hospital operational overview card with bed telemetry, ICU capacity, and blood inventory.
class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback? onTap;
  final VoidCallback? onAllocate;

  const HospitalCard({
    super.key,
    required this.hospital,
    this.onTap,
    this.onAllocate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = hospital.status.color;

    return Semantics(
      label: 'Hospital ${hospital.name}, District ${hospital.district}, Available Beds ${hospital.availableBeds}, ICU Beds ${hospital.icuBeds}',
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
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospital.name,
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
                                hospital.district,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (hospital.traumaCenter) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                                  ),
                                  child: const Text(
                                    'TRAUMA CENTER',
                                    style: TextStyle(
                                      color: Color(0xFFEF4444),
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        hospital.status.displayName.toUpperCase(),
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

                // Medical Capacity Metrics Grid
                Row(
                  children: [
                    Expanded(child: _buildMetricTile('Available Beds', '${hospital.availableBeds} / ${hospital.totalBeds}', Icons.hotel_rounded, const Color(0xFF3B82F6), isDark)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMetricTile('ICU Beds', '${hospital.icuBeds}', Icons.local_hospital_rounded, const Color(0xFFEF4444), isDark)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMetricTile('ER Doctors', '${hospital.emergencyDoctors}', Icons.person_rounded, const Color(0xFF10B981), isDark)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMetricTile('Ambulances', '${hospital.ambulances}', Icons.emergency_rounded, const Color(0xFFF59E0B), isDark)),
                  ],
                ),
                const SizedBox(height: 12),

                // Blood Bank Status Strip
                if (hospital.bloodAvailability.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Blood Bank: ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: hospital.bloodAvailability.entries.map((e) {
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: e.value.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: e.value.color.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  '${e.key}: ${e.value.displayName}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: e.value.color,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Footer with Phone and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hospital.contactNumber,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white70 : const Color(0xFF334155),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (onAllocate != null)
                      OutlinedButton.icon(
                        onPressed: onAllocate,
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          side: BorderSide(color: theme.colorScheme.primary),
                        ),
                        icon: const Icon(Icons.outbox_rounded, size: 13),
                        label: const Text('Dispatch Kits', style: TextStyle(fontSize: 11)),
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

  Widget _buildMetricTile(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
