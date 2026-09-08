import 'package:flutter/material.dart';
import '../../data/datasources/analytics_mock_datasource.dart';
import '../../domain/entities/analytics_entities.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/report_item_card.dart';
import '../widgets/analytics_empty_view.dart';
import '../widgets/analytics_skeleton_loader.dart';

/// Screen for generating, downloading, and previewing Disaster Analytics reports in PDF, CSV, and JSON.
class ReportsCenterScreen extends StatefulWidget {
  const ReportsCenterScreen({super.key});

  @override
  State<ReportsCenterScreen> createState() => _ReportsCenterScreenState();
}

class _ReportsCenterScreenState extends State<ReportsCenterScreen> {
  final _notifier = AnalyticsDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final reports = state.reports;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Reports & SitRep Center'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: state.isGeneratingReport
                ? null
                : () => _showGenerateReportDialog(context),
            icon: state.isGeneratingReport
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.add_chart_rounded),
            label: Text(state.isGeneratingReport
                ? 'Generating...'
                : 'Generate SitRep'),
          ),
          body: state.status == AnalyticsViewStatus.loading && reports.isEmpty
              ? const AnalyticsSkeletonLoader(itemCount: 4)
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // Header card
                    _buildHeaderBanner(context),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exported SitRep Archive (${reports.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (reports.isEmpty)
                      AnalyticsEmptyView(
                        title: 'No Reports Generated Yet',
                        message:
                            'Tap "Generate SitRep" to compile an official disaster report in PDF, CSV, or JSON format.',
                        icon: Icons.description_outlined,
                        actionLabel: 'Generate First Report',
                        onAction: () => _showGenerateReportDialog(context),
                      )
                    else
                      ...reports.map(
                        (rep) => ReportItemCard(
                          report: rep,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Downloading ${rep.title} (${rep.format.displayName})...'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          onPreview: () => _previewReport(context, rep),
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildHeaderBanner(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assessment_rounded,
                color: colorScheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disaster Incident Reporting',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Export multi-district operational telemetry into PDF, CSV, or JSON formats.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGenerateReportDialog(BuildContext context) {
    ReportTimeframe selectedTimeframe = ReportTimeframe.daily;
    ReportFormat selectedFormat = ReportFormat.pdf;
    String selectedDistrict = 'All';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

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
                  Text(
                    'Generate Situation Report (SitRep)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Timeframe selection
                  Text(
                    'Select Timeframe',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ReportTimeframe.values.map((tf) {
                      final isSelected = selectedTimeframe == tf;
                      return ChoiceChip(
                        selected: isSelected,
                        label: Text(tf.displayName),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => selectedTimeframe = tf);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Format selection
                  Text(
                    'Select File Format',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ReportFormat.values.map((fmt) {
                      final isSelected = selectedFormat == fmt;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? colorScheme.primaryContainer
                                  : null,
                              side: BorderSide(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.outlineVariant,
                              ),
                            ),
                            onPressed: () {
                              setModalState(() => selectedFormat = fmt);
                            },
                            icon: Icon(fmt.icon, size: 16),
                            label: Text(fmt.displayName),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // District selection
                  Text(
                    'Jurisdiction / District',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colorScheme.outlineVariant
                            .withValues(alpha: 0.4),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedDistrict,
                        items: ['All', ...AnalyticsMockDataSource.tnDistricts]
                            .map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(d == 'All'
                                      ? 'All Tamil Nadu (Statewide)'
                                      : d),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedDistrict = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final rep = await _notifier.generateNewReport(
                          timeframe: selectedTimeframe,
                          format: selectedFormat,
                          district: selectedDistrict,
                        );
                        if (mounted && rep != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Generated report: ${rep.title} successfully!'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.download_done_rounded),
                      label: const Text('Generate & Compile Report'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _previewReport(BuildContext context, GeneratedReport report) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = await _notifier.exportReportPreview(
      timeframe: report.timeframe,
      format: report.format,
    );

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Report Preview (${report.format.displayName})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Text(
                          content,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Report ${report.title} exported to local storage.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Export & Share Report'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
