import 'package:flutter/material.dart';
import '../../domain/entities/admin_entities.dart';
import '../providers/admin_provider.dart';
import '../providers/admin_state.dart';
import '../widgets/notification_item_card.dart';
import '../widgets/admin_empty_view.dart';
import '../widgets/admin_skeleton_loader.dart';

/// Screen displaying 200 system notifications, emergency broadcasts, and alert streams.
class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final _notifier = AdminDependencies.notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final state = _notifier.state;
        final filters = state.notificationFilters;
        final notifs = state.filteredNotifications;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Notification Alert Center'),
            centerTitle: true,
            actions: [
              if (state.unreadNotificationCount > 0)
                IconButton(
                  icon: const Icon(Icons.done_all_rounded),
                  tooltip: 'Mark All as Read',
                  onPressed: () {
                    _notifier.markAllNotificationsRead();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All notifications marked as read.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'clear') {
                    _notifier.clearAllNotifications();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_sweep_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Clear Notification History'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: state.status == AdminViewStatus.loading && notifs.isEmpty
              ? const AdminSkeletonLoader(itemCount: 6)
              : Column(
                  children: [
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),
                    Expanded(
                      child: notifs.isEmpty
                          ? AdminEmptyView(
                              title: 'No Notifications Available',
                              message:
                                  'You have caught up with all operational alerts.',
                              icon: Icons.notifications_none_rounded,
                              actionLabel: 'Reset Filters',
                              onAction: () =>
                                  _notifier.clearNotificationFilters(),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: notifs.length,
                              itemBuilder: (context, index) {
                                final n = notifs[index];
                                return NotificationItemCard(
                                  notification: n,
                                  onMarkRead: () =>
                                      _notifier.markNotificationRead(n.id),
                                  onTap: () => _showNotificationDetail(context, n),
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
    final filters = state.notificationFilters;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              selected: filters.unreadOnly,
              label: Text('Unread (${state.unreadNotificationCount})'),
              selectedColor: Colors.redAccent,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: filters.unreadOnly ? Colors.white : Colors.redAccent,
              ),
              backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
              showCheckmark: false,
              onSelected: (val) => _notifier.setNotificationUnreadOnly(val),
            ),
            const SizedBox(width: 8),
            FilterChip(
              selected: filters.category == null,
              label: const Text('All Categories'),
              selectedColor: colorScheme.primary,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: filters.category == null
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
              ),
              showCheckmark: false,
              onSelected: (_) => _notifier.setNotificationCategory(null),
            ),
            const SizedBox(width: 6),
            ...NotificationCategory.values.map((cat) {
              final isSelected = filters.category == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(cat.displayName),
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : cat.color,
                  ),
                  selectedColor: cat.color,
                  backgroundColor: cat.color.withValues(alpha: 0.1),
                  showCheckmark: false,
                  onSelected: (selected) {
                    _notifier.setNotificationCategory(selected ? cat : null);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, AdminNotification notif) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final catColor = notif.category.color;

    if (!notif.isRead) {
      _notifier.markNotificationRead(notif.id);
    }

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
                      color: catColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notif.category.icon,
                      color: catColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif.category.displayName.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: catColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          notif.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'Broadcast Message Payload:',
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
                  notif.message,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Notification ID', notif.id),
              if (notif.relatedEntityId != null)
                _buildDetailRow('Related Incident', notif.relatedEntityId!),
              _buildDetailRow(
                  'Timestamp', notif.timestamp.toLocal().toString()),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Dismiss Alert'),
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
