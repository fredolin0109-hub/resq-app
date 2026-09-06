import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';
import '../providers/team_management_provider.dart';

/// Screen coordinating team assignment, vehicle selection, and emergency dispatch.
class DispatchTeamScreen extends StatefulWidget {
  final RescueTeamDetailEntity? preselectedTeam;
  final TeamManagementNotifier? notifier;

  const DispatchTeamScreen({
    super.key,
    this.preselectedTeam,
    this.notifier,
  });

  static const String routeName = '/rescue/dispatch';

  @override
  State<DispatchTeamScreen> createState() => _DispatchTeamScreenState();
}

class _DispatchTeamScreenState extends State<DispatchTeamScreen> {
  late final TeamManagementNotifier _notifier;
  RescueTeamDetailEntity? _selectedTeam;
  VehicleEntity? _selectedVehicle;
  String _priority = 'High';
  final TextEditingController _missionIdController = TextEditingController(text: 'SOS-9401');
  final TextEditingController _locationController = TextEditingController(text: 'Causeway Bridge Lowland, Tirunelveli');
  final List<String> _selectedEquipment = ['Inflatable Boat', 'Trauma Resuscitator', 'Thermal Drone'];

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? TeamManagementDependencies.notifier;
    _selectedTeam = widget.preselectedTeam ?? (_notifier.state.allTeams.isNotEmpty ? _notifier.state.allTeams.first : null);
    _selectedVehicle = _selectedTeam?.assignedVehicle ?? (_notifier.state.allVehicles.isNotEmpty ? _notifier.state.allVehicles.first : null);
  }

  @override
  void dispose() {
    _missionIdController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final teams = _notifier.state.allTeams;
    final vehicles = _notifier.state.allVehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Squad Dispatch'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission ID & Target Location
              Text('1. Incident & Destination', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _missionIdController,
                decoration: const InputDecoration(
                  labelText: 'Mission / SOS ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Target Disaster Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),

              // Mission Priority
              Text('2. Mission Priority', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Critical', label: Text('Critical')),
                  ButtonSegment(value: 'High', label: Text('High')),
                  ButtonSegment(value: 'Medium', label: Text('Medium')),
                ],
                selected: {_priority},
                onSelectionChanged: (set) => setState(() => _priority = set.first),
              ),
              const SizedBox(height: 18),

              // Select Squad
              Text('3. Assign Rescue Squad', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<RescueTeamDetailEntity>(
                value: _selectedTeam,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: teams.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text('${t.name} (${t.district})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedTeam = val),
              ),
              const SizedBox(height: 18),

              // Select Vehicle
              Text('4. Assign Fleet Vehicle', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<VehicleEntity>(
                value: _selectedVehicle,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: vehicles.map((v) {
                  return DropdownMenuItem(
                    value: v,
                    child: Text('${v.typeName} (${v.vehicleNumber})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedVehicle = val),
              ),
              const SizedBox(height: 18),

              // ETA & Telemetry
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildEstimate('Distance', '2.8 km'),
                    _buildEstimate('Estimated ETA', '7 mins'),
                    _buildEstimate('Route Hazard', 'Clear Corridor'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Dispatch Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () async {
                    if (_selectedTeam != null) {
                      await _notifier.dispatchSquad(
                        teamId: _selectedTeam!.id,
                        missionId: _missionIdController.text,
                        priority: _priority,
                        targetLocation: _locationController.text,
                        vehicle: _selectedVehicle,
                        equipment: _selectedEquipment,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_selectedTeam!.name} successfully deployed to ${_locationController.text}!'),
                            backgroundColor: Colors.teal.shade700,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Confirm & Authorize Dispatch'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstimate(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
