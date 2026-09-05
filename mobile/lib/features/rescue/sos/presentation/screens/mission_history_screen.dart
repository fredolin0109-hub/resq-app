import 'package:flutter/material.dart';
import '../../domain/entities/sos_incident_entity.dart';
import '../providers/sos_provider.dart';
import '../widgets/sos_incident_card.dart';
import 'sos_details_screen.dart';

/// Screen listing resolved and archived rescue missions with search and filter support.
class MissionHistoryScreen extends StatefulWidget {
  final SosNotifier? notifier;

  const MissionHistoryScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/history';

  @override
  State<MissionHistoryScreen> createState() => _MissionHistoryScreenState();
}

class _MissionHistoryScreenState extends State<MissionHistoryScreen> {
  late final SosNotifier _notifier;
  String _searchQuery = '';
  String? _selectedDistrict;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? SosDependencies.notifier;
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
    final all = _notifier.state.allIncidents;

    // Filter resolved / closed
    final completedMissions = all.where((inc) {
      final isResolvedOrClosed = inc.status == SosStatus.rescueCompleted || inc.status == SosStatus.closed;
      if (!isResolvedOrClosed) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final matches = inc.id.toLowerCase().contains(q) ||
            inc.civilianName.toLowerCase().contains(q) ||
            inc.district.toLowerCase().contains(q) ||
            inc.emergencyType.toLowerCase().contains(q);
        if (!matches) return false;
      }

      if (_selectedDistrict != null && inc.district != _selectedDistrict) {
        return false;
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission History & Archives'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search past missions by ID, civilian, district...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),

            // District Filter Chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ChoiceChip(
                    label: const Text('All Districts'),
                    selected: _selectedDistrict == null,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedDistrict = null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ...['Dindigul', 'Salem', 'Madurai', 'Tirunelveli', 'Chennai', 'Coimbatore'].map((d) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(d),
                        selected: _selectedDistrict == d,
                        onSelected: (selected) {
                          setState(() => _selectedDistrict = selected ? d : null);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Completed Missions List
            Expanded(
              child: completedMissions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_toggle_off_rounded, size: 54, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text('No archived missions matching criteria', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: completedMissions.length,
                      itemBuilder: (context, index) {
                        final inc = completedMissions[index];
                        return SosIncidentCard(
                          incident: inc,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                settings: const RouteSettings(name: SosDetailsScreen.routeName),
                                builder: (_) => SosDetailsScreen(
                                  incident: inc,
                                  notifier: _notifier,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
