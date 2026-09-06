import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';
import '../providers/team_management_provider.dart';
import '../widgets/fleet_summary_widget.dart';
import '../widgets/vehicle_card.dart';
import 'vehicle_details_screen.dart';

/// Screen managing all fleet assets, ambulances, boats, drones, and heavy equipment.
class FleetManagementScreen extends StatefulWidget {
  final TeamManagementNotifier? notifier;

  const FleetManagementScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/fleet';

  @override
  State<FleetManagementScreen> createState() => _FleetManagementScreenState();
}

class _FleetManagementScreenState extends State<FleetManagementScreen> {
  late final TeamManagementNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? TeamManagementDependencies.notifier;
    _notifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = _notifier.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fleet & Heavy Assets'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fleet Summary Widget
              if (state.fleetSummary != null)
                FleetSummaryWidget(
                  fleet: state.fleetSummary!,
                  onTypeSelected: (type) {
                    _notifier.updateFilters(state.filterOptions.copyWith(vehicleType: type));
                  },
                ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Registered Vehicles (${state.filteredVehicles.length})',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (state.filterOptions.vehicleType != null)
                    TextButton(
                      onPressed: () => _notifier.updateFilters(state.filterOptions.copyWith(clearVehicleType: true)),
                      child: const Text('Show All Types'),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Vehicle Cards List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.filteredVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = state.filteredVehicles[index];
                  return VehicleCard(
                    vehicle: vehicle,
                    onTap: () {
                      _notifier.selectVehicle(vehicle);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: const RouteSettings(name: VehicleDetailsScreen.routeName),
                          builder: (_) => VehicleDetailsScreen(vehicle: vehicle),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
