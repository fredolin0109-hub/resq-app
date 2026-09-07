import 'package:flutter/material.dart';
import '../../data/datasources/offline_mock_datasource.dart';
import '../../domain/entities/offline_entities.dart';
import '../providers/offline_provider.dart';
import '../widgets/mesh_device_card.dart';
import '../widgets/offline_empty_view.dart';

/// Monitoring screen for BLE and LoRa mesh devices, civilian beacons, and tactical repeaters.
class MeshNetworkMonitorScreen extends StatefulWidget {
  const MeshNetworkMonitorScreen({super.key});

  @override
  State<MeshNetworkMonitorScreen> createState() =>
      _MeshNetworkMonitorScreenState();
}

class _MeshNetworkMonitorScreenState extends State<MeshNetworkMonitorScreen> {
  final _notifier = OfflineDependencies.notifier;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeviceDetails(BuildContext context, MeshDevice device) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final typeColor = device.type.color;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(device.type.icon, color: typeColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${device.id} • ${device.type.displayName}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Signal Quality (RSSI):', style: TextStyle(fontSize: 12)),
                        Text(
                          '${device.rssiDbm} dBm (${device.signalBarLabel})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Battery Level:', style: TextStyle(fontSize: 12)),
                        Text(
                          '${device.batteryPercent}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: device.batteryPercent > 20 ? Colors.green.shade700 : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mesh Hops to Node:', style: TextStyle(fontSize: 12)),
                        Text(
                          '${device.hopsCount} Hop(s)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('GPS Coordinates:', style: TextStyle(fontSize: 12)),
                        Text(
                          '${device.latitude.toStringAsFixed(4)}° N, ${device.longitude.toStringAsFixed(4)}° E',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (device.isConnected) {
                          _notifier.disconnectDevice(device.id);
                        } else {
                          _notifier.connectDevice(device.id);
                        }
                      },
                      child: Text(device.isConnected ? 'Disconnect' : 'Connect Link'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final filters = state.meshFilters;
        final devices = state.filteredDevices;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mesh Network Monitor'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: state.isScanning
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.radar_rounded),
                tooltip: 'Scan for BLE Peers',
                onPressed: state.isScanning ? null : () => _notifier.startBleScan(),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search & District Selector
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search node name, ID, or district...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  _notifier.searchMesh('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (val) => _notifier.searchMesh(val),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          'District:',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                                value: filters.district,
                                isDense: true,
                                borderRadius: BorderRadius.circular(12),
                                items: ['All', ...OfflineMockDatasource.tamilNaduDistricts]
                                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _notifier.setMeshDistrict(val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Category Selector Bar
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ChoiceChip(
                      label: const Text('All Nodes'),
                      selected: filters.type == null,
                      onSelected: (_) => _notifier.setMeshType(null),
                    ),
                    for (final type in DeviceType.values) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        avatar: Icon(type.icon, size: 14),
                        label: Text(type.displayName.split(' ').first),
                        selected: filters.type == type,
                        onSelected: (_) => _notifier.setMeshType(type),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Device Cards List
              Expanded(
                child: devices.isEmpty
                    ? OfflineEmptyView(
                        title: 'No Mesh Nodes Found',
                        message: 'No peer rescue nodes or civilian beacons match your filters.',
                        icon: Icons.radar_rounded,
                        onResetFilters: () {
                          _searchController.clear();
                          _notifier.updateMeshFilters(MeshFilterOptions());
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          final device = devices[index];
                          return MeshDeviceCard(
                            device: device,
                            onConnect: () => _notifier.connectDevice(device.id),
                            onDisconnect: () => _notifier.disconnectDevice(device.id),
                            onTap: () => _showDeviceDetails(context, device),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
