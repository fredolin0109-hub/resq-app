import 'package:flutter/material.dart';
import '../../domain/entities/sos_incident_entity.dart';
import 'sos_priority_badge.dart';
import 'sos_status_badge.dart';

/// Modal bottom sheet for filtering SOS incidents by Type, Priority, Status, and District.
class SosFilterSheet extends StatefulWidget {
  final SosFilterOptions currentFilters;
  final ValueChanged<SosFilterOptions> onApply;

  const SosFilterSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<SosFilterSheet> createState() => _SosFilterSheetState();
}

class _SosFilterSheetState extends State<SosFilterSheet> {
  late SosPriority? _selectedPriority;
  late SosStatus? _selectedStatus;
  late String? _selectedDistrict;
  late String? _selectedType;

  final List<String> _districts = [
    'Tirunelveli',
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Dindigul',
    'Salem',
    'Thoothukudi',
    'Tiruppur',
    'Tiruchirappalli',
    'Erode',
    'Thanjavur',
    'Vellore',
  ];

  final List<String> _types = [
    'Flood',
    'Structural Collapse',
    'Landslide',
    'Fire',
    'Medical',
    'Boat',
    'Canal',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.currentFilters.priority;
    _selectedStatus = widget.currentFilters.status;
    _selectedDistrict = widget.currentFilters.district;
    _selectedType = widget.currentFilters.emergencyType;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter SOS Alerts',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedPriority = null;
                      _selectedStatus = null;
                      _selectedDistrict = null;
                      _selectedType = null;
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),

            // Priority Filter
            Text('PRIORITY', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SosPriority.values.map((p) {
                final isSelected = _selectedPriority == p;
                final color = SosPriorityBadge.getPriorityColor(p);
                return ChoiceChip(
                  label: Text(p.name.toUpperCase()),
                  selected: isSelected,
                  selectedColor: color.withValues(alpha: 0.2),
                  onSelected: (selected) {
                    setState(() => _selectedPriority = selected ? p : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Status Filter
            Text('STATUS', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SosStatus.values.map((s) {
                final isSelected = _selectedStatus == s;
                return ChoiceChip(
                  label: Text(SosStatusBadge.getStatusLabel(s)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedStatus = selected ? s : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // District Filter
            Text('DISTRICT', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _districts.map((d) {
                final isSelected = _selectedDistrict == d;
                return ChoiceChip(
                  label: Text(d),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedDistrict = selected ? d : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Emergency Type Filter
            Text('EMERGENCY TYPE', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _types.map((t) {
                final isSelected = _selectedType == t;
                return ChoiceChip(
                  label: Text(t),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedType = selected ? t : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  widget.onApply(
                    SosFilterOptions(
                      priority: _selectedPriority,
                      status: _selectedStatus,
                      district: _selectedDistrict,
                      emergencyType: _selectedType,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
