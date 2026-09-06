import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';
import '../providers/ai_commander_provider.dart';
import '../providers/ai_commander_state.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/ai_summary_card.dart';
import '../widgets/incident_analysis_card.dart';
import '../widgets/recommendation_card.dart';
import 'ai_chat_screen.dart';
import 'ai_history_screen.dart';
import 'ai_recommendations_screen.dart';
import 'incident_analysis_screen.dart';
import 'situation_summary_screen.dart';

/// Central AI Commander Dashboard (`/rescue/ai`).
class AICommanderDashboardScreen extends StatefulWidget {
  final AICommanderNotifier? notifier;

  const AICommanderDashboardScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/ai';

  @override
  State<AICommanderDashboardScreen> createState() => _AICommanderDashboardScreenState();
}

class _AICommanderDashboardScreenState extends State<AICommanderDashboardScreen> {
  late final AICommanderNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? AICommanderDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_notifier.state.status == AICommanderViewStatus.initial) {
        _notifier.loadDashboard();
      }
    });
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _triggerPrompt(String prompt) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AIChatScreen(
          notifier: _notifier,
          initialPrompt: prompt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome_rounded, size: 20, color: Color(0xFF6366F1)),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Mission Commander',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  'Autonomous Tactical Intelligence',
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Live SitRep',
            icon: const Icon(Icons.description_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SituationSummaryScreen(notifier: _notifier)),
            ),
          ),
          IconButton(
            tooltip: 'Open Tactical AI Chat',
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AIChatScreen(notifier: _notifier)),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.status == AICommanderViewStatus.loading) {
            return const AISkeletonLoader(itemCount: 5);
          }

          if (state.status == AICommanderViewStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.errorMessage ?? 'Failed to load AI Intelligence', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => _notifier.loadDashboard(), child: const Text('Retry')),
                ],
              ),
            );
          }

          final sum = state.summary;
          final topRecs = state.allRecommendations.take(3).toList();
          final topIncidents = state.allIncidents.take(2).toList();

          return RefreshIndicator(
            onRefresh: () => _notifier.loadDashboard(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Prompt Command Chips
                  Text(
                    'Direct Tactical Prompts',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPromptChip('Analyze flood risk', Icons.flood_rounded, const Color(0xFF3B82F6)),
                        const SizedBox(width: 8),
                        _buildPromptChip('Suggest evacuation plan', Icons.directions_run_rounded, const Color(0xFF10B981)),
                        const SizedBox(width: 8),
                        _buildPromptChip('Find safest rescue route', Icons.navigation_rounded, const Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        _buildPromptChip('Allocate rescue teams', Icons.groups_rounded, const Color(0xFF8B5CF6)),
                        const SizedBox(width: 8),
                        _buildPromptChip('Resource optimization', Icons.inventory_rounded, const Color(0xFFEC4899)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4 Summary Metrics Cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      AISummaryCard(
                        title: 'Active AI Sessions',
                        value: '${sum.activeAISessions} Active',
                        subtitle: 'Real-time Dialogues',
                        icon: Icons.chat_rounded,
                        color: const Color(0xFF6366F1),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AIChatScreen(notifier: _notifier)),
                        ),
                      ),
                      AISummaryCard(
                        title: 'Incidents Analyzed',
                        value: '${sum.incidentsAnalyzed} Sectors',
                        subtitle: '${(sum.averageConfidence * 100).toInt()}% Avg Confidence',
                        icon: Icons.analytics_rounded,
                        color: const Color(0xFF3B82F6),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => IncidentAnalysisScreen(notifier: _notifier)),
                        ),
                      ),
                      AISummaryCard(
                        title: 'Recommendations',
                        value: '${sum.recommendationsGenerated} Tactics',
                        subtitle: '${sum.executedRecommendations} Executed',
                        icon: Icons.lightbulb_rounded,
                        color: const Color(0xFF10B981),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AIRecommendationsScreen(notifier: _notifier)),
                        ),
                      ),
                      AISummaryCard(
                        title: 'High-Risk Alerts',
                        value: '${sum.highRiskAlerts} Critical',
                        subtitle: 'Risk Score > 80',
                        icon: Icons.warning_amber_rounded,
                        color: const Color(0xFFEF4444),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => IncidentAnalysisScreen(
                              notifier: _notifier,
                              initialSeverity: IncidentSeverity.critical,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Situation Summary Banner Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                            : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.flash_on_rounded, color: Color(0xFF6366F1), size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'LIVE SITREP BRIEFING',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => SituationSummaryScreen(notifier: _notifier)),
                              ),
                              child: const Text('View Full SitRep', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.situationSummary.headline,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.situationSummary.incidentOverview,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : const Color(0xFF374151),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Priority AI Recommendations Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Priority AI Directives (${state.allRecommendations.length})',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AIRecommendationsScreen(notifier: _notifier)),
                        ),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topRecs.length,
                    itemBuilder: (_, idx) {
                      final rec = topRecs[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: RecommendationCard(
                          recommendation: rec,
                          onExecute: () async {
                            final ok = await _notifier.executeRecommendation(rec.id);
                            if (mounted && ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Executed recommendation: ${rec.title}')),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Critical Incident Analyses Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Multi-Sensor Incident Analyses (${state.allIncidents.length})',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => IncidentAnalysisScreen(notifier: _notifier)),
                        ),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topIncidents.length,
                    itemBuilder: (_, idx) {
                      final inc = topIncidents[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: IncidentAnalysisCard(
                          analysis: inc,
                          onToggleAction: (actId, val) {
                            _notifier.toggleActionItem(
                              incidentId: inc.id,
                              actionItemId: actId,
                              isCompleted: val,
                            );
                          },
                          onChatAbout: () {
                            _triggerPrompt('Analyze incident ${inc.title} in ${inc.district} with risk score ${inc.riskScore}');
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          if (idx == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AIChatScreen(notifier: _notifier)));
          } else if (idx == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => IncidentAnalysisScreen(notifier: _notifier)));
          } else if (idx == 3) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AIRecommendationsScreen(notifier: _notifier)));
          } else if (idx == 4) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AIHistoryScreen(notifier: _notifier)));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'AI Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_rounded), label: 'Directives'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String prompt, IconData icon, Color color) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: color),
      label: Text(prompt, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      onPressed: () => _triggerPrompt(prompt),
    );
  }
}
