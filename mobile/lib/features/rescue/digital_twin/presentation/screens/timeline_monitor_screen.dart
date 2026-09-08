import 'package:flutter/material.dart';
import '../../data/datasources/digital_twin_mock_datasource.dart';
import '../../domain/entities/digital_twin_entities.dart';
import '../providers/digital_twin_provider.dart';
import '../providers/digital_twin_state.dart';
import '../widgets/timeline_event_tile.dart';
import '../widgets/digital_twin_empty_view.dart';

/// Chronological disaster response audit stream and incident timeline monitor.
class TimelineMonitorScreen extends StatefulWidget {
  const TimelineMonitorScreen({super.key});

  @override
  State<TimelineMonitorScreen> createState() => _TimelineMonitorScreenState();
}

class _TimelineMonitorScreenState extends State<TimelineMonitorScreen> {
  final _notifier = DigitalTwinDependencies.notifier;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEventDetails(BuildContext context, TimelineEvent event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final eventColor = event.eventType.color;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: eventColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(event.eventType.icon, color: eventColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${event.eventType.displayName} • ${event.district}',
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
              Text(
                'Incident Details:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                event.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Incident Reference:', style: TextStyle(fontSize: 12)),
                        Text(
                          event.incidentId,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Logged By Officer:', style: TextStyle(fontSize: 12)),
                        Text(
                          event.loggedBy,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Impacted Casualties/Evacuees:', style: TextStyle(fontSize: 12)),
                        Text(
                          '${event.affectedCount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: event.affectedCount > 0 ? Colors.orange.shade800 : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close Details'),
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
        final filters = state.timelineFilters;
        final events = state.filteredTimelineEvents;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Disaster Timeline Monitor'),
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
                        hintText: 'Search incident, description, dispatcher...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  _notifier.searchTimeline('');
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
                      onChanged: (val) => _notifier.searchTimeline(val),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.place_rounded,
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
                                    _notifier.setTimelineDistrict(val);
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

              // Category Filter Chips
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ChoiceChip(
                      label: const Text('All Events'),
                      selected: filters.eventType == null,
                      onSelected: (_) => _notifier.setTimelineType(null),
                    ),
                    for (final type in TimelineEventType.values) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        avatar: Icon(type.icon, size: 14),
                        label: Text(type.displayName),
                        selected: filters.eventType == type,
                        onSelected: (_) => _notifier.setTimelineType(type),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Chronological Events List
              Expanded(
                child: events.isEmpty
                    ? DigitalTwinEmptyView(
                        title: 'No Timeline Events Found',
                        message: 'Try adjusting search keywords or selecting All categories.',
                        onResetFilters: () {
                          _searchController.clear();
                          _notifier.updateTimelineFilters(
                            TimelineFilterOptions(),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return TimelineEventTile(
                            event: event,
                            isLast: index == events.length - 1,
                            onTap: () => _showEventDetails(context, event),
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
