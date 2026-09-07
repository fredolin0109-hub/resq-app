import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';
import '../providers/ai_commander_provider.dart';

/// Screen displaying structured AI Disaster Situation Summary (SitRep) (`/rescue/ai/situation_summary`).
class SituationSummaryScreen extends StatefulWidget {
  final AICommanderNotifier? notifier;

  const SituationSummaryScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/ai/situation_summary';

  @override
  State<SituationSummaryScreen> createState() => _SituationSummaryScreenState();
}

class _SituationSummaryScreenState extends State<SituationSummaryScreen> {
  late final AICommanderNotifier _notifier;
  String _selectedDistrict = 'All';

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? AICommanderDependencies.notifier;
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

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Live Dynamic Feed';
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} IST';
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final report = state.situationSummary ?? SituationSummary.empty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Situation Briefing', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Share SitRep Briefing',
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('SitRep briefing exported and copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Card
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
                    border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'OFFICIAL SITUATION REPORT',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                          Text(
                            report.id,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        report.headline,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Target Sector: ${report.primaryDistrict} • Generated: ${_formatDateTime(report.generatedAt)}',
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Key Demographics Telemetry
                Row(
                  children: [
                    Expanded(
                      child: _buildTelemetryCard(
                        'Estimated Evacuees',
                        '~${report.totalEvacuees}',
                        Icons.people_alt_rounded,
                        const Color(0xFF3B82F6),
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTelemetryCard(
                        'Active Missions',
                        '${report.activeMissions} Deployments',
                        Icons.local_shipping_rounded,
                        const Color(0xFF10B981),
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 1. Incident Overview
                _buildSectionTitle('1. Incident Overview & Threat Dynamics', Icons.info_outline_rounded, const Color(0xFF3B82F6), theme, isDark),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    report.incidentOverview,
                    style: TextStyle(fontSize: 13, height: 1.4, color: isDark ? Colors.white70 : const Color(0xFF334155)),
                  ),
                ),
                const SizedBox(height: 18),

                // 2. Resources Deployed
                _buildSectionTitle('2. Resources & Logistics Deployed', Icons.check_circle_outline_rounded, const Color(0xFF10B981), theme, isDark),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: report.resourcesDeployed.map((res) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.shield_rounded, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(res, style: const TextStyle(fontSize: 12))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),

                // 3. Emerging Risks
                _buildSectionTitle('3. Emerging Risks & Secondary Hazards', Icons.warning_amber_rounded, const Color(0xFFEF4444), theme, isDark),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: report.emergingRisks.map((risk) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.arrow_right_rounded, size: 18, color: Color(0xFFEF4444)),
                            const SizedBox(width: 4),
                            Expanded(child: Text(risk, style: const TextStyle(fontSize: 12))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),

                // 4. Suggested Next Actions
                _buildSectionTitle('4. AI Recommended Next Actions', Icons.play_circle_outline_rounded, const Color(0xFF8B5CF6), theme, isDark),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: report.suggestedNextActions.map((act) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_box_outlined, size: 16, color: Color(0xFF8B5CF6)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(act, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color, ThemeData theme, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildTelemetryCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                Text(title, style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : const Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
