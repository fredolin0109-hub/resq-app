import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';
import 'team_status_badge.dart';

/// Filter sheet for querying squads by District, Status, and Vehicle Type.
class TeamFilterSheet extends StatefulWidget {
  final TeamFilterOptions currentFilters;
  final ValueChanged<TeamFilterOptions> onApply;

  const TeamFilterSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<TeamFilterSheet> createState() => _TeamFilterSheetState();
}

class _TeamFilterSheetState extends State<TeamFilterSheet> {
  late String? _selectedDistrict;
  late TeamStatus? _selectedStatus;
  late VehicleType? _selectedVehicleType;

  final List<String> _districts = [
    'Tirunelveli',
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Dindigul',
    'Salem',
    'Thoothukudi',
    'Tiruchirappalli',
    'Erode',
    'Vellore',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDistrict = widget.currentFilters.district;
    _selectedStatus = widget.currentFilters.status;
    _selectedVehicleType = widget.currentFilters.vehicleType;
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
                Text('Filter Teams & Fleet', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDistrict = null;
                      _selectedStatus = null;
                      _selectedVehicleType = null;
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),

            // Status Filter
            Text('SQUAD STATUS', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TeamStatus.values.map((s) {
                final isSelected = _selectedStatus == s;
                return ChoiceChip(
                  label: Text(TeamStatusBadge.getStatusLabel(s)),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _selectedStatus = selected ? s : null),
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
                  onSelected: (selected) => setState(() => _selectedDistrict = selected ? d : null),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Vehicle Type Filter
            Text('VEHICLE TYPE', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: VehicleType.values.map((v) {
                final isSelected = _selectedVehicleType == v;
                return ChoiceChip(
                  label: Text(v.name.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _selectedVehicleType = selected ? v : null),
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
                    widget.currentFilters.copyWith(
                      district: _selectedDistrict,
                      clearDistrict: _selectedDistrict == null,
                      status: _selectedStatus,
                      clearStatus: _selectedStatus == null,
                      vehicleType: _selectedVehicleType,
                      clearVehicleType: _selectedVehicleType == null,
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
