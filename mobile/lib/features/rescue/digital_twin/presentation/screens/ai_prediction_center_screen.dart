import 'package:flutter/material.dart';
import '../../data/datasources/digital_twin_mock_datasource.dart';
import '../../domain/entities/digital_twin_entities.dart';
import '../providers/digital_twin_provider.dart';
import '../widgets/prediction_card.dart';
import '../widgets/digital_twin_empty_view.dart';
import 'twin_resource_allocation_screen.dart';

/// Screen displaying 40 AI Predictive Disaster Forecasts, Impact Horizons, and Actions.
class AIPredictionCenterScreen extends StatefulWidget {
  const AIPredictionCenterScreen({super.key});

  @override
  State<AIPredictionCenterScreen> createState() =>
      _AIPredictionCenterScreenState();
}

class _AIPredictionCenterScreenState extends State<AIPredictionCenterScreen> {
  final _notifier = DigitalTwinDependencies.notifier;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showPredictionDetails(
      BuildContext context, DigitalTwinPrediction prediction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

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
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(prediction.type.icon, color: Colors.amber.shade900, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prediction.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${prediction.district} • ${prediction.affectedZone}',
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
                        const Text('AI Risk Score:', style: TextStyle(fontSize: 12)),
                        Text(
                          '${prediction.riskScore} / 100',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Confidence Level:', style: TextStyle(fontSize: 12)),
                        Text(
                          '${prediction.confidencePercent}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Forecasting Horizon:', style: TextStyle(fontSize: 12)),
                        Text(
                          prediction.timeHorizon,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Projected Impact Outcome:',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                prediction.projectedOutcome,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
              ),
              const SizedBox(height: 12),
              Text(
                'AI Preventive Action Recommendation:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                prediction.preventiveAction,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Dismiss'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TwinResourceAllocationScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.hub_rounded, size: 16),
                      label: const Text('Dispatch Assets'),
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
        final filters = state.predictionFilters;
        final predictions = state.filteredPredictions;

        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Predictive Forecasting'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Search & District
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search prediction, zone, impact...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  _notifier.searchPredictions('');
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
                      onChanged: (val) => _notifier.searchPredictions(val),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.radar_rounded,
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
                                    _notifier.setPredictionDistrict(val);
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
                      label: const Text('All Forecasts'),
                      selected: filters.type == null,
                      onSelected: (_) => _notifier.setPredictionType(null),
                    ),
                    for (final type in PredictionType.values) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        avatar: Icon(type.icon, size: 14),
                        label: Text(type.displayName.split(' ').first),
                        selected: filters.type == type,
                        onSelected: (_) => _notifier.setPredictionType(type),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Predictions List
              Expanded(
                child: predictions.isEmpty
                    ? DigitalTwinEmptyView(
                        title: 'No Predictions Found',
                        message: 'Try clearing the search query or selecting All types.',
                        onResetFilters: () {
                          _searchController.clear();
                          _notifier.updatePredictionFilters(
                            const PredictionFilterOptions(),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          final prediction = predictions[index];
                          return PredictionCard(
                            prediction: prediction,
                            onTap: () => _showPredictionDetails(context, prediction),
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
