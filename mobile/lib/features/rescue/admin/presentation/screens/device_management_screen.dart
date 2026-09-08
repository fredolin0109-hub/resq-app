import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';
import '../providers/admin_provider.dart';
import '../providers/admin_state.dart';
import '../widgets/device_card.dart';
import '../widgets/admin_empty_view.dart';
import '../widgets/admin_skeleton_loader.dart';

/// Screen for managing hardware nodes, BLE mesh gateways, GPS trackers, and offline storage.
class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final _notifier = AdminDependencies.notifier;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = _notifier.state.deviceFilters.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final filters = state.deviceFilters;
        final devices = state.filteredDevices;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Device & Mesh Node Fleet'),
            centerTitle: true,
            actions: [
              if (filters.hasActiveFilters)
                IconButton(
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  tooltip: 'Clear Filters',
                  onPressed: () {
                    _searchController.clear();
                    _notifier.clearDeviceFilters();
                  },
                ),
            ],
          ),
          body: state.status == AdminViewStatus.loading && devices.isEmpty
              ? const AdminSkeletonLoader(itemCount: 6)
              : Column(
                  children: [
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),
                    Expanded(
                      child: devices.isEmpty
                          ? AdminEmptyView(
                              title: 'No Matching Devices',
                              message:
                                  'Try adjusting your search query or device type filter.',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                _notifier.clearDeviceFilters();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: devices.length,
                              itemBuilder: (context, index) {
                                final dev = devices[index];
                                return DeviceCard(
                                  device: dev,
                                  onTap: () => _showDeviceDetail(context, dev),
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

  Widget _buildFilterHeader(BuildContext context, AdminState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filters = state.deviceFilters;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search device node, ID, paired squad...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _notifier.setDeviceSearchQuery('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => _notifier.setDeviceSearchQuery(val),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  selected: filters.type == null,
                  label: const Text('All Types'),
                  selectedColor: colorScheme.primary,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filters.type == null
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  showCheckmark: false,
                  onSelected: (_) => _notifier.setDeviceType(null),
                ),
                const SizedBox(width: 6),
                ...DeviceType.values.map((type) {
                  final isSelected = filters.type == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(type.displayName),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                      selectedColor: colorScheme.primary,
                      showCheckmark: false,
                      onSelected: (selected) {
                        _notifier.setDeviceType(selected ? type : null);
                      },
                    ),
                  );
                }),
                const SizedBox(width: 6),
                FilterChip(
                  selected: filters.connectedOnly == true,
                  label: const Text('Online Only'),
                  selectedColor: Colors.green,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filters.connectedOnly == true
                        ? Colors.white
                        : Colors.green,
                  ),
                  backgroundColor: Colors.green.withValues(alpha: 0.1),
                  showCheckmark: false,
                  onSelected: (val) =>
                      _notifier.setDeviceConnectedOnly(val ? true : null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeviceDetail(BuildContext context, ManagedDevice dev) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final connColor = dev.isConnected ? Colors.green : Colors.red;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      dev.type.icon,
                      color: colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dev.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${dev.id} • ${dev.type.displayName}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: connColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: connColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      dev.isConnected ? 'CONNECTED' : 'DISCONNECTED',
                      style: TextStyle(
                        color: connColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow('Paired Squad', dev.pairedTeam),
              _buildDetailRow('Battery Charge Level', '${dev.batteryPercent}%'),
              _buildDetailRow(
                  'Signal Quality (RSSI)', '${dev.signalStrengthDbm} dBm'),
              _buildDetailRow('Offline Map Cache Size',
                  '${dev.mapCacheMb.toStringAsFixed(1)} MB stored'),
              _buildDetailRow('Local Database Cache',
                  '${dev.offlineStorageMb.toStringAsFixed(1)} MB'),
              _buildDetailRow('Firmware Version', dev.firmwareVersion),
              _buildDetailRow(
                  'Last Synchronization', dev.lastSync.toLocal().toString()),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Sent synchronization handshake to ${dev.name}.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.sync_rounded),
                  label: const Text('Trigger Node Resynchronization'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
