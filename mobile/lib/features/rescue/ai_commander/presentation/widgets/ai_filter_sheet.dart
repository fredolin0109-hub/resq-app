import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';

/// Modal bottom sheet for filtering incident analyses and AI history.
class AIFilterSheet extends StatefulWidget {
  final String selectedDistrict;
  final IncidentType? selectedIncidentType;
  final IncidentSeverity? selectedSeverity;
  final RecommendationPriority? selectedPriority;
  final bool showPriorityFilter;
  final Function({
    required String district,
    IncidentType? incidentType,
    IncidentSeverity? severity,
    RecommendationPriority? priority,
  }) onApply;

  const AIFilterSheet({
    super.key,
    required this.selectedDistrict,
    this.selectedIncidentType,
    this.selectedSeverity,
    this.selectedPriority,
    this.showPriorityFilter = false,
    required this.onApply,
  });

  static const List<String> districts = [
    'All',
    'Tirunelveli',
    'Chennai',
    'Cuddalore',
    'Coimbatore',
    'Madurai',
    'Nagapattinam',
    'Erode',
    'Tiruchirappalli',
    'Salem',
    'Kanyakumari',
  ];

  @override
  State<AIFilterSheet> createState() => _AIFilterSheetState();
}

class _AIFilterSheetState extends State<AIFilterSheet> {
  late String _district;
  IncidentType? _incidentType;
  IncidentSeverity? _severity;
  RecommendationPriority? _priority;

  @override
  void initState() {
    super.initState();
    _district = widget.selectedDistrict;
    _incidentType = widget.selectedIncidentType;
    _severity = widget.selectedSeverity;
    _priority = widget.selectedPriority;
  }

  void _reset() {
    setState(() {
      _district = 'All';
      _incidentType = null;
      _severity = null;
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
                  'Filter AI Intelligence',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // District Filter
            const Text('Disaster District', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AIFilterSheet.districts.map((d) {
                final isSelected = _district.toLowerCase() == d.toLowerCase();
                return ChoiceChip(
                  label: Text(d),
                  selected: isSelected,
                  onSelected: (sel) {
                    if (sel) setState(() => _district = d);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Incident Type Filter
            const Text('Incident Hazard Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All Types'),
                  selected: _incidentType == null,
                  onSelected: (_) => setState(() => _incidentType = null),
                ),
                ...IncidentType.values.map((type) {
                  final isSelected = _incidentType == type;
                  return ChoiceChip(
                    avatar: Icon(type.icon, size: 16),
                    label: Text(type.displayName),
                    selected: isSelected,
                    onSelected: (sel) => setState(() => _incidentType = sel ? type : null),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Priority or Severity Filter
            if (widget.showPriorityFilter) ...[
              const Text('Recommendation Priority', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All Priorities'),
                    selected: _priority == null,
                    onSelected: (_) => setState(() => _priority = null),
                  ),
                  ...RecommendationPriority.values.map((p) {
                    final isSelected = _priority == p;
                    return ChoiceChip(
                      label: Text(p.displayName),
                      selected: isSelected,
                      selectedColor: p.color.withValues(alpha: 0.2),
                      onSelected: (sel) => setState(() => _priority = sel ? p : null),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ] else ...[
              const Text('Incident Severity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All Severities'),
                    selected: _severity == null,
                    onSelected: (_) => setState(() => _severity = null),
                  ),
                  ...IncidentSeverity.values.map((s) {
                    final isSelected = _severity == s;
                    return ChoiceChip(
                      label: Text(s.displayName),
                      selected: isSelected,
                      selectedColor: s.color.withValues(alpha: 0.2),
                      onSelected: (sel) => setState(() => _severity = sel ? s : null),
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
                    incidentType: _incidentType,
                    severity: _severity,
                    priority: _priority,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Apply Filter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
