import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';
import '../providers/ai_commander_provider.dart';
import '../widgets/ai_empty_view.dart';
import '../widgets/ai_filter_sheet.dart';
import '../widgets/incident_analysis_card.dart';
import 'ai_chat_screen.dart';

/// Screen managing searchable AI intelligence history, past analyses, and sessions (`/rescue/ai/history`).
class AIHistoryScreen extends StatefulWidget {
  final AICommanderNotifier? notifier;

  const AIHistoryScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/ai/history';

  @override
  State<AIHistoryScreen> createState() => _AIHistoryScreenState();
}

class _AIHistoryScreenState extends State<AIHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final AICommanderNotifier _notifier;
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDistrict = 'All';

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? AICommanderDependencies.notifier;
    _tabController = TabController(length: 2, vsync: this);
    _notifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter historical incidents
    var incidentLogs = state.allIncidents.where((i) {
      if (_selectedDistrict != 'All' && i.district.toLowerCase() != _selectedDistrict.toLowerCase()) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return i.title.toLowerCase().contains(q) || i.district.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    // Filter historical chat sessions
    var chatLogs = state.allChatSessions.where((s) {
      if (_selectedDistrict != 'All' && s.district.toLowerCase() != _selectedDistrict.toLowerCase()) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return s.title.toLowerCase().contains(q) || s.district.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tactical Intelligence Logs', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Hazard Analyses (${incidentLogs.length})'),
            Tab(text: 'Chat Transcripts (${chatLogs.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search archive by keyword, district...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),
          ),

          // District Filter Chips
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: AIFilterSheet.districts.map((d) {
                final isSelected = _selectedDistrict.toLowerCase() == d.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(d),
                    selected: isSelected,
                    onSelected: (sel) {
                      if (sel) setState(() => _selectedDistrict = d);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Tabs Body
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Incident Analyses History
                incidentLogs.isEmpty
                    ? const AIEmptyView(
                        title: 'No Historical Analyses Found',
                        description: 'No archived hazard records match your search filter.',
                        icon: Icons.history_rounded,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: incidentLogs.length,
                        itemBuilder: (_, idx) {
                          final inc = incidentLogs[idx];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: IncidentAnalysisCard(
                              analysis: inc,
                              onToggleAction: (actId, val) {
                                _notifier.toggleActionItem(incidentId: inc.id, actionItemId: actId, isCompleted: val);
                              },
                            ),
                          );
                        },
                      ),

                // Tab 2: Chat Sessions History
                chatLogs.isEmpty
                    ? const AIEmptyView(
                        title: 'No Chat Transcripts Found',
                        description: 'No archived dialogues match your search filter.',
                        icon: Icons.forum_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: chatLogs.length,
                        itemBuilder: (_, idx) {
                          final session = chatLogs[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.chat_bubble_outline_rounded, color: theme.colorScheme.primary),
                              ),
                              title: Text(session.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Text('${session.district} • ${_formatDate(session.createdAt)}\n${session.messages.length} tactical exchanges'),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                              onTap: () {
                                _notifier.selectChatSession(session);
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => AIChatScreen(notifier: _notifier)),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
