import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';

/// Card showing a generated report record with download, preview, and format indicators.
class ReportItemCard extends StatelessWidget {
  final GeneratedReport report;
  final VoidCallback? onDownload;
  final VoidCallback? onPreview;

  const ReportItemCard({
    super.key,
    required this.report,
    this.onDownload,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color fmtColor;
    switch (report.format) {
      case ReportFormat.pdf:
        fmtColor = Colors.redAccent;
        break;
      case ReportFormat.csv:
        fmtColor = Colors.green;
        break;
      case ReportFormat.json:
        fmtColor = Colors.amber.shade800;
        break;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Format icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: fmtColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: fmtColor.withValues(alpha: 0.4)),
              ),
              child: Icon(
                report.format.icon,
                color: fmtColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Report Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          report.timeframe.displayName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        report.dateRangeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${report.dataItemsCount} records • ${report.fileSizeKb} KB',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            // Actions
            IconButton(
              icon: const Icon(Icons.visibility_outlined, size: 20),
              tooltip: 'Preview Report',
              onPressed: onPreview,
            ),
            IconButton(
              icon: const Icon(Icons.download_rounded, size: 20),
              tooltip: 'Download Report',
              color: colorScheme.primary,
              onPressed: onDownload,
            ),
          ],
        ),
      ),
    );
  }
}
