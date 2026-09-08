import 'package:flutter/material.dart';
import '../../data/datasources/digital_twin_mock_datasource.dart';
import '../../domain/entities/digital_twin_entities.dart';
import '../providers/digital_twin_provider.dart';
import '../providers/digital_twin_state.dart';
import '../widgets/infrastructure_card.dart';
import '../widgets/digital_twin_empty_view.dart';

/// Monitoring and telemetry screen for 30 critical infrastructure assets.
class InfrastructureStatusScreen extends StatefulWidget {
  const InfrastructureStatusScreen({super.key});

  @override
  State<InfrastructureStatusScreen> createState() =>
      _InfrastructureStatusScreenState();
}

class _InfrastructureStatusScreenState
    extends State<InfrastructureStatusScreen> {
  final _notifier = DigitalTwinDependencies.notifier;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAssetDetails(BuildContext context, InfrastructureAsset asset) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final statusColor = asset.status.color;

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
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(asset.type.icon, color: colorScheme.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${asset.type.displayName} • ${asset.district}',
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
                        const Text('Operational Status:', style: TextStyle(fontSize: 12)),
                        Text(
                          asset.status.displayName,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Capacity Ratio:', style: TextStyle(fontSize: 12)),
                        Text(
                          '${asset.capacityPercent}%',
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
                          '${asset.latitude.toStringAsFixed(4)}° N, ${asset.longitude.toStringAsFixed(4)}° E',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Live Telemetry Notes:',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                asset.telemetryNotes,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close Asset View'),
                ),
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
        final filters = state.infrastructureFilters;
        final assets = state.filteredInfrastructureAssets;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Critical Infrastructure'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Search & District Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search asset name, address, notes...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  _notifier.searchInfrastructure('');
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
                      onChanged: (val) => _notifier.searchInfrastructure(val),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: colorScheme.primary,
                        ),
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
                                items: ['All', ...DigitalTwinMockDatasource.tamilNaduDistricts]
                                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _notifier.setInfrastructureDistrict(val);
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

              // Type Selector Bar
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ChoiceChip(
                      label: const Text('All Types'),
                      selected: filters.type == null,
                      onSelected: (_) => _notifier.setInfrastructureType(null),
                    ),
                    for (final type in InfrastructureType.values) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        avatar: Icon(type.icon, size: 14),
                        label: Text(type.displayName.split(' / ').first),
                        selected: filters.type == type,
                        onSelected: (_) => _notifier.setInfrastructureType(type),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Asset Cards List
              Expanded(
                child: assets.isEmpty
                    ? DigitalTwinEmptyView(
                        title: 'No Infrastructure Found',
                        message: 'No assets matched the current filters or query.',
                        onResetFilters: () {
                          _searchController.clear();
                          _notifier.updateInfrastructureFilters(
                            InfrastructureFilterOptions(),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: assets.length,
                        itemBuilder: (context, index) {
                          final asset = assets[index];
                          return InfrastructureCard(
                            asset: asset,
                            onTap: () => _showAssetDetails(context, asset),
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
