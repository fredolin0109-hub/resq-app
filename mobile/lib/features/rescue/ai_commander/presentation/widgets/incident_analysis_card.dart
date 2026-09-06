import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';

/// Incident analysis card displaying hazard metrics, risk score gauge, and actionable checklist.
class IncidentAnalysisCard extends StatelessWidget {
  final IncidentAnalysis analysis;
  final VoidCallback? onTap;
  final Function(String actionItemId, bool isCompleted)? onToggleAction;
  final VoidCallback? onChatAbout;

  const IncidentAnalysisCard({
    super.key,
    required this.analysis,
    this.onTap,
    this.onToggleAction,
    this.onChatAbout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sevColor = analysis.severity.color;
    final riskScore = analysis.riskScore;

    final riskColor = riskScore >= 80
        ? const Color(0xFFEF4444)
        : (riskScore >= 60 ? const Color(0xFFF97316) : const Color(0xFF10B981));

    return Semantics(
      label: 'Incident: ${analysis.title}, Type ${analysis.incidentType.displayName}, Severity ${analysis.severity.displayName}, Risk Score $riskScore out of 100',
      child: Material(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isDark ? 0 : 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Incident Type Icon, Severity, and AI Confidence
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: sevColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(analysis.incidentType.icon, color: sevColor, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            analysis.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                '${analysis.incidentType.displayName} • ${analysis.district}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Risk Score Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: riskColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: riskColor.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$riskScore',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: riskColor,
                            ),
                          ),
                          Text(
                            'RISK SCORE',
                            style: TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                              color: riskColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Area & Demographics Metric Tiles
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoPill(
                        Icons.map_outlined,
                        'Area Impact',
                        analysis.affectedArea,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoPill(
                        Icons.people_outline_rounded,
                        'Est. Population',
                        '~${analysis.estimatedPopulation} Civilians',
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoPill(
                        Icons.auto_awesome_rounded,
                        'AI Confidence',
                        '${analysis.confidencePercent}% Certain',
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Environmental Factor Chips
                if (analysis.environmentalFactors.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: analysis.environmentalFactors.map((fact) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          fact,
                          style: TextStyle(fontSize: 10, color: isDark ? Colors.white70 : const Color(0xFF475569)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                // Actionable Checklist Preview
                Text(
                  'Recommended Action Checklist (${analysis.recommendedActions.where((a) => a.isCompleted).length}/${analysis.recommendedActions.length} completed):',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 4),
                ...analysis.recommendedActions.take(3).map((act) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: act.isCompleted,
                            visualDensity: VisualDensity.compact,
                            onChanged: (val) {
                              if (onToggleAction != null && val != null) {
                                onToggleAction!(act.id, val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            act.action,
                            style: TextStyle(
                              fontSize: 11,
                              color: act.isCompleted ? (isDark ? Colors.white38 : Colors.grey) : (isDark ? Colors.white : const Color(0xFF1E293B)),
                              decoration: act.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                if (onChatAbout != null) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AI Sensor Link Active',
                        style: TextStyle(fontSize: 10, color: const Color(0xFF10B981), fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: onChatAbout,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                        label: const Text('Consult AI Commander', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPill(IconData icon, String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 11, color: isDark ? Colors.white60 : const Color(0xFF64748B)),
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(fontSize: 8, color: isDark ? Colors.white60 : const Color(0xFF64748B), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
