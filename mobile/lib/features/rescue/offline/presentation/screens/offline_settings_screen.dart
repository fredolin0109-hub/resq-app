import 'package:flutter/material.dart';
import '../../domain/entities/offline_entities.dart';
import '../providers/offline_provider.dart';
import '../widgets/offline_map_cache_card.dart';

/// Screen for configuring offline parameters, BLE mesh relays, storage limits, and caching.
class OfflineSettingsScreen extends StatefulWidget {
  const OfflineSettingsScreen({super.key});

  @override
  State<OfflineSettingsScreen> createState() => _OfflineSettingsScreenState();
}

class _OfflineSettingsScreenState extends State<OfflineSettingsScreen> {
  final _notifier = OfflineDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final settings = state.settings;
        final cachedMaps = state.cachedMapList;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Offline Configuration'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Radio & Mesh Protocols Section
              Text(
                'Mesh & Radio Hardware',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Bluetooth Low Energy (BLE) Mesh'),
                      subtitle: const Text('Enables local P2P mesh relaying and beacon discovery'),
                      value: settings.enableBle,
                      onChanged: (val) {
                        _notifier.updateSettings(settings.copyWith(enableBle: val));
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Continuous Mesh Relay'),
                      subtitle: const Text('Forward encrypted packets on behalf of nearby units'),
                      value: settings.meshRelayEnabled,
                      onChanged: (val) {
                        _notifier.updateSettings(settings.copyWith(meshRelayEnabled: val));
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Auto-Sync on Internet Restoration'),
                      subtitle: const Text('Upload queued messages as soon as Wi-Fi/Cellular is back'),
                      value: settings.autoSyncOnInternet,
                      onChanged: (val) {
                        _notifier.updateSettings(settings.copyWith(autoSyncOnInternet: val));
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Low Power Mode Optimization'),
                      subtitle: const Text('Throttle BLE scanning duty cycle to conserve officer battery'),
                      value: settings.lowPowerOptimization,
                      onChanged: (val) {
                        _notifier.updateSettings(settings.copyWith(lowPowerOptimization: val));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Queue & Storage Parameters
              Text(
                'Store & Forward Queue Rules',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Message Expiry (TTL):', style: TextStyle(fontWeight: FontWeight.w600)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: settings.messageExpiryHours,
                            isDense: true,
                            borderRadius: BorderRadius.circular(10),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('1 Hour')),
                              DropdownMenuItem(value: 6, child: Text('6 Hours')),
                              DropdownMenuItem(value: 24, child: Text('24 Hours')),
                              DropdownMenuItem(value: 168, child: Text('7 Days')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _notifier.updateSettings(settings.copyWith(messageExpiryHours: val));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Local Storage Limit:', style: TextStyle(fontWeight: FontWeight.w600)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: settings.storageLimitMb,
                            isDense: true,
                            borderRadius: BorderRadius.circular(10),
                            items: const [
                              DropdownMenuItem(value: 50, child: Text('50 MB')),
                              DropdownMenuItem(value: 100, child: Text('100 MB')),
                              DropdownMenuItem(value: 500, child: Text('500 MB')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _notifier.updateSettings(settings.copyWith(storageLimitMb: val));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Retry Interval:', style: TextStyle(fontWeight: FontWeight.w600)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: settings.retryIntervalSeconds,
                            isDense: true,
                            borderRadius: BorderRadius.circular(10),
                            items: const [
                              DropdownMenuItem(value: 15, child: Text('15 Seconds')),
                              DropdownMenuItem(value: 30, child: Text('30 Seconds')),
                              DropdownMenuItem(value: 60, child: Text('60 Seconds')),
                              DropdownMenuItem(value: 300, child: Text('5 Minutes')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _notifier.updateSettings(settings.copyWith(retryIntervalSeconds: val));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Future Protocol Plug & Play Architecture
              Text(
                'Future-Ready Radio Interfaces',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    _ProtocolTile(
                      protocol: ProtocolType.bleMesh,
                      status: 'ACTIVE HARDWARE',
                      isOnline: true,
                    ),
                    const Divider(height: 16),
                    _ProtocolTile(
                      protocol: ProtocolType.loraRadio,
                      status: 'READY FOR PLUG-IN',
                      isOnline: false,
                    ),
                    const Divider(height: 16),
                    _ProtocolTile(
                      protocol: ProtocolType.satellite,
                      status: 'READY FOR PLUG-IN',
                      isOnline: false,
                    ),
                    const Divider(height: 16),
                    _ProtocolTile(
                      protocol: ProtocolType.wifiDirect,
                      status: 'READY FOR PLUG-IN',
                      isOnline: false,
                    ),
                    const Divider(height: 16),
                    _ProtocolTile(
                      protocol: ProtocolType.nfc,
                      status: 'READY FOR PLUG-IN',
                      isOnline: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. Cached Offline Maps Intelligence
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Offline Map Cache (13 TN Districts)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    '${cachedMaps.length} Caches',
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (final map in cachedMaps) ...[
                OfflineMapCacheCard(cache: map),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ProtocolTile extends StatelessWidget {
  final ProtocolType protocol;
  final String status;
  final bool isOnline;

  const _ProtocolTile({
    required this.protocol,
    required this.status,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isOnline ? Colors.green : Colors.grey).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            protocol.icon,
            size: 18,
            color: isOnline ? Colors.green.shade700 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            protocol.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (isOnline ? Colors.green : Colors.grey).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: isOnline ? Colors.green.shade700 : Colors.grey.shade700,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
