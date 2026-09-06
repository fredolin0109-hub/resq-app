import 'package:flutter/material.dart';
import '../../domain/entities/resource_entities.dart';

/// Modal bottom sheet allowing users to filter by District, Category, Availability, and Priority.
class ResourceFilterSheet extends StatefulWidget {
  final String selectedDistrict;
  final ResourceCategory? selectedCategory;
  final ResourceStatus? selectedStatus;
  final ShelterStatus? selectedShelterStatus;
  final HospitalStatus? selectedHospitalStatus;
  final AllocationPriority? selectedPriority;
  final bool showCategoryFilter;
  final bool showStatusFilter;
  final bool showPriorityFilter;
  final Function({
    required String district,
    ResourceCategory? category,
    ResourceStatus? status,
    ShelterStatus? shelterStatus,
    HospitalStatus? hospitalStatus,
    AllocationPriority? priority,
  }) onApply;

  const ResourceFilterSheet({
    super.key,
    required this.selectedDistrict,
    this.selectedCategory,
    this.selectedStatus,
    this.selectedShelterStatus,
    this.selectedHospitalStatus,
    this.selectedPriority,
    this.showCategoryFilter = false,
    this.showStatusFilter = true,
    this.showPriorityFilter = false,
    required this.onApply,
  });

  static const List<String> districts = [
    'All',
    'Chennai',
    'Cuddalore',
    'Nagapattinam',
    'Tirunelveli',
    'Thoothukudi',
    'Madurai',
    'Coimbatore',
    'Salem',
    'Tiruchirappalli',
    'Vellore',
    'Thanjavur',
    'Erode',
    'Dindigul',
    'Kanyakumari',
    'Villupuram',
  ];

  @override
  State<ResourceFilterSheet> createState() => _ResourceFilterSheetState();
}

class _ResourceFilterSheetState extends State<ResourceFilterSheet> {
  late String _district;
  ResourceCategory? _category;
  ResourceStatus? _status;
  ShelterStatus? _shelterStatus;
  HospitalStatus? _hospitalStatus;
  AllocationPriority? _priority;

  @override
  void initState() {
    super.initState();
    _district = widget.selectedDistrict;
    _category = widget.selectedCategory;
    _status = widget.selectedStatus;
    _shelterStatus = widget.selectedShelterStatus;
    _hospitalStatus = widget.selectedHospitalStatus;
    _priority = widget.selectedPriority;
  }

  void _reset() {
    setState(() {
      _district = 'All';
      _category = null;
      _status = null;
      _shelterStatus = null;
      _hospitalStatus = null;
      _priority = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle & Title
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
                Text(
                  'Filter Resources & Logistics',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // District Filter
            _buildSectionHeader('Disaster District / Region'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ResourceFilterSheet.districts.map((d) {
                final isSelected = _district.toLowerCase() == d.toLowerCase();
                return ChoiceChip(
                  label: Text(d),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _district = d);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Category Filter (for Inventory)
            if (widget.showCategoryFilter) ...[
              _buildSectionHeader('Resource Category'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All Categories'),
                    selected: _category == null,
                    onSelected: (selected) {
                      if (selected) setState(() => _category = null);
                    },
                  ),
                  ...ResourceCategory.values.map((cat) {
                    final isSelected = _category == cat;
                    return ChoiceChip(
                      avatar: Icon(cat.icon, size: 16),
                      label: Text(cat.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _category = selected ? cat : null);
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Resource Stock Status Filter
            if (widget.showStatusFilter) ...[
              _buildSectionHeader('Availability Status'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All Statuses'),
                    selected: _status == null,
                    onSelected: (selected) {
                      if (selected) setState(() => _status = null);
                    },
                  ),
                  ...ResourceStatus.values.map((st) {
                    final isSelected = _status == st;
                    return ChoiceChip(
                      label: Text(st.displayName),
                      selected: isSelected,
                      selectedColor: st.color.withValues(alpha: 0.2),
                      onSelected: (selected) {
                        setState(() => _status = selected ? st : null);
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Priority Filter (for Allocations)
            if (widget.showPriorityFilter) ...[
              _buildSectionHeader('Deployment Priority'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All Priorities'),
                    selected: _priority == null,
                    onSelected: (selected) {
                      if (selected) setState(() => _priority = null);
                    },
                  ),
                  ...AllocationPriority.values.map((p) {
                    final isSelected = _priority == p;
                    return ChoiceChip(
                      label: Text(p.displayName),
                      selected: isSelected,
                      selectedColor: p.color.withValues(alpha: 0.2),
                      onSelected: (selected) {
                        setState(() => _priority = selected ? p : null);
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    district: _district,
                    category: _category,
                    status: _status,
                    shelterStatus: _shelterStatus,
                    hospitalStatus: _hospitalStatus,
                    priority: _priority,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }
}
