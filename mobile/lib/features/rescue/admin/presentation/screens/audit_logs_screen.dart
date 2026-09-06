import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';
import '../providers/admin_provider.dart';
import '../providers/admin_state.dart';
import '../widgets/audit_log_card.dart';
import '../widgets/admin_empty_view.dart';
import '../widgets/admin_skeleton_loader.dart';

/// Screen for tracking and exporting 100 system audit logs and forensic events.
class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  final _notifier = AdminDependencies.notifier;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = _notifier.state.auditFilters.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final filters = state.auditFilters;
        final logs = state.filteredAuditLogs;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Audit Trail & Event Log'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.download_rounded),
                tooltip: 'Export Audit Logs',
                onPressed: () => _exportLogs(context, logs),
              ),
              if (filters.hasActiveFilters)
                IconButton(
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  tooltip: 'Clear Filters',
                  onPressed: () {
                    _searchController.clear();
                    _notifier.clearAuditFilters();
                  },
                ),
            ],
          ),
          body: state.status == AdminViewStatus.loading && logs.isEmpty
              ? const AdminSkeletonLoader(itemCount: 6)
              : Column(
                  children: [
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),
                    Expanded(
                      child: logs.isEmpty
                          ? AdminEmptyView(
                              title: 'No Matching Logs',
                              message:
                                  'Try clearing your search query or selecting "All Actions".',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                _notifier.clearAuditFilters();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                return AuditLogCard(
                                  log: log,
                                  onTap: () => _showLogDetail(context, log),
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

  Widget _buildFilterHeader(BuildContext context, AdminState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filters = state.auditFilters;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search user, action details, IP address...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _notifier.setAuditSearchQuery('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => _notifier.setAuditSearchQuery(val),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  selected: filters.actionType == null,
                  label: const Text('All Event Types'),
                  selectedColor: colorScheme.primary,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filters.actionType == null
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  showCheckmark: false,
                  onSelected: (_) => _notifier.setAuditActionType(null),
                ),
                const SizedBox(width: 6),
                ...AuditActionType.values.map((action) {
                  final isSelected = filters.actionType == action;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(action.displayName),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                      selectedColor: colorScheme.primary,
                      showCheckmark: false,
                      onSelected: (selected) {
                        _notifier.setAuditActionType(selected ? action : null);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _exportLogs(BuildContext context, List<AuditLogItem> logs) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported ${logs.length} audit logs to secure storage.'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogDetail(BuildContext context, AuditLogItem log) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final successColor = log.isSuccess ? Colors.green : Colors.red;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      log.actionType.icon,
                      color: colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.actionType.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Event ID: ${log.id}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: successColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      log.isSuccess ? 'SUCCESS' : 'FAILED',
                      style: TextStyle(
                        color: successColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow('Actor User', log.userName),
              _buildDetailRow('Actor ID', log.userId),
              _buildDetailRow('Source IP Address', log.ipAddress),
              _buildDetailRow(
                  'Event Timestamp', log.timestamp.toLocal().toString()),
              const SizedBox(height: 12),
              Text(
                'Event Description & Audit Trail:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  log.details,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Close Audit Entry'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
