import 'package:flutter/material.dart';
import '../../data/datasources/digital_twin_mock_datasource.dart';
import '../providers/digital_twin_provider.dart';

/// Screen for AI-guided Predictive Resource Allocation based on Digital Twin hotspots.
class TwinResourceAllocationScreen extends StatefulWidget {
  const TwinResourceAllocationScreen({super.key});

  @override
  State<TwinResourceAllocationScreen> createState() =>
      _TwinResourceAllocationScreenState();
}

class _TwinResourceAllocationScreenState
    extends State<TwinResourceAllocationScreen> {
  final _notifier = DigitalTwinDependencies.notifier;
  String _selectedDistrict = 'All';

  final List<_AllocationPlanItem> _plans = [
    _AllocationPlanItem(
      id: 'ALC-01',
      hotspotZone: 'Chennai Adyar River Basin',
      district: 'Chennai',
      hazardType: 'Flash Flood Inundation',
      recommendedAsset: '10 Motorized Gemini Boats + NDRF Unit',
      units: '10 Boats, 45 Responders',
      priority: 'URGENT',
      isDispatched: false,
    ),
    _AllocationPlanItem(
      id: 'ALC-02',
      hotspotZone: 'Cuddalore Port Seawall Parapet',
      district: 'Cuddalore',
      hazardType: 'Storm Surge & Harbor Breach',
      recommendedAsset: '5,000 Geotextile Sandbags + Heavy Dozers',
      units: '5,000 Bags, 4 Earthmovers',
      priority: 'HIGH',
      isDispatched: false,
    ),
    _AllocationPlanItem(
      id: 'ALC-03',
      hotspotZone: 'Nagapattinam Coastal Beachside',
      district: 'Nagapattinam',
      hazardType: 'Tidal Wave Surge Swell',
      recommendedAsset: '6 Evacuation Transit Buses + SDRF Squad',
      units: '6 Buses, 20 Officers',
      priority: 'HIGH',
      isDispatched: true,
    ),
    _AllocationPlanItem(
      id: 'ALC-04',
      hotspotZone: 'Tirunelveli Thamirabarani Basin',
      district: 'Tirunelveli',
      hazardType: 'Dam Discharge River Overflow',
      recommendedAsset: '8 High-Capacity 50HP Dewatering Pumps',
      units: '8 Diesel Pumps',
      priority: 'CRITICAL',
      isDispatched: false,
    ),
    _AllocationPlanItem(
      id: 'ALC-05',
      hotspotZone: 'Coimbatore Valparai Ghat Sector 4',
      district: 'Coimbatore',
      hazardType: 'Debris Avalanche Rockfall',
      recommendedAsset: 'High-Altitude Mountain Rescue Squad + Cranes',
      units: '2 Hydraulic Cranes, 15 Climbers',
      priority: 'CRITICAL',
      isDispatched: true,
    ),
    _AllocationPlanItem(
      id: 'ALC-06',
      hotspotZone: 'Madurai Fabric Market District',
      district: 'Madurai',
      hazardType: 'Commercial Flash Fire',
      recommendedAsset: '4 Heavy Foam Tenders + Mist Skylift',
      units: '4 Foam Trucks, 35 Firefighters',
      priority: 'HIGH',
      isDispatched: false,
    ),
    _AllocationPlanItem(
      id: 'ALC-07',
      hotspotZone: 'Thoothukudi Industrial Salt Corridor',
      district: 'Thoothukudi',
      hazardType: 'Chemical Contamination Runoff',
      recommendedAsset: '600m Absorbent Booms + Hazmat Team',
      units: '600m Booms, 12 Hazmat Staff',
      priority: 'HIGH',
      isDispatched: false,
    ),
  ];

  void _dispatchAsset(int index) {
    setState(() {
      _plans[index].isDispatched = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Dispatched ${_plans[index].recommendedAsset} to ${_plans[index].hotspotZone}',
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredPlans = _plans.where((p) {
      if (_selectedDistrict != 'All' &&
          p.district.toLowerCase() != _selectedDistrict.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Predictive Resource Dispatch'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'AI matches high-risk prediction hotspots with nearest available rescue inventory and fleet assets.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // District Filter
          Row(
            children: [
              Icon(Icons.location_city_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Filter District:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDistrict,
                      isDense: true,
                      borderRadius: BorderRadius.circular(12),
                      items: ['All', ...DigitalTwinMockDatasource.tamilNaduDistricts]
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedDistrict = val);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Allocation Cards
          for (int i = 0; i < filteredPlans.length; i++) ...[
            _buildPlanCard(context, filteredPlans[i], i),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, _AllocationPlanItem item, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCritical = item.priority == 'CRITICAL';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.hotspotZone,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hazard: ${item.hazardType} • ${item.district}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCritical
                      ? Colors.red.withValues(alpha: 0.12)
                      : Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.priority,
                  style: TextStyle(
                    color: isCritical ? Colors.red.shade700 : Colors.orange.shade800,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Optimal Asset: ${item.recommendedAsset}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Units: ${item.units}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              if (item.isDispatched)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 14, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'DISPATCHED',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                FilledButton.icon(
                  onPressed: () => _dispatchAsset(index),
                  icon: const Icon(Icons.send_rounded, size: 14),
                  label: const Text('Authorize Dispatch'),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationPlanItem {
  final String id;
  final String hotspotZone;
  final String district;
  final String hazardType;
  final String recommendedAsset;
  final String units;
  final String priority;
  bool isDispatched;

  _AllocationPlanItem({
    required this.id,
    required this.hotspotZone,
    required this.district,
    required this.hazardType,
    required this.recommendedAsset,
    required this.units,
    required this.priority,
    required this.isDispatched,
  });
}
