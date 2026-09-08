import 'package:flutter/material.dart';
import '../../data/datasources/admin_mock_datasource.dart';
import '../../domain/entities/admin_entities.dart';
import '../providers/admin_provider.dart';
import '../providers/admin_state.dart';
import '../widgets/user_card.dart';
import '../widgets/admin_empty_view.dart';
import '../widgets/admin_skeleton_loader.dart';

/// Screen for managing 50 users, RBAC permissions, and operational duties.
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _notifier = AdminDependencies.notifier;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = _notifier.state.userFilters.searchQuery;
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
        final filters = state.userFilters;
        final users = state.filteredUsers;

        return Scaffold(
          appBar: AppBar(
            title: const Text('User Management & RBAC'),
            centerTitle: true,
            actions: [
              if (filters.hasActiveFilters)
                IconButton(
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  tooltip: 'Clear Filters',
                  onPressed: () {
                    _searchController.clear();
                    _notifier.clearUserFilters();
                  },
                ),
            ],
          ),
          body: state.status == AdminViewStatus.loading && users.isEmpty
              ? const AdminSkeletonLoader(itemCount: 6)
              : Column(
                  children: [
                    _buildFilterHeader(context, state),
                    const Divider(height: 1),
                    Expanded(
                      child: users.isEmpty
                          ? AdminEmptyView(
                              title: 'No Matching Users',
                              message:
                                  'Try adjusting your search query, role, or district filter.',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                _notifier.clearUserFilters();
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return UserCard(
                                  user: user,
                                  onStatusChanged: (newStatus) {
                                    _notifier.updateUserStatus(
                                        user.id, newStatus);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Updated ${user.name} status to ${newStatus.displayName}'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  onTap: () => _showUserDetail(context, user),
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
    final filters = state.userFilters;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search user name, email, department, ID...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _notifier.setUserSearchQuery('');
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
            onChanged: (val) => _notifier.setUserSearchQuery(val),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // District Dropdown Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filters.district,
                      isDense: true,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                      items: ['All', ...AdminMockDataSource.tnDistricts]
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text(d == 'All' ? 'All Districts' : d),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) _notifier.setUserDistrict(val);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Role filter chips
                FilterChip(
                  selected: filters.role == null,
                  label: const Text('All Roles'),
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filters.role == null
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  selectedColor: colorScheme.primary,
                  showCheckmark: false,
                  onSelected: (_) => _notifier.setUserRole(null),
                ),
                const SizedBox(width: 6),
                ...UserRole.values.map((role) {
                  final isSelected = filters.role == role;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(role.displayName),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white : role.color,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedColor: role.color,
                      backgroundColor: role.color.withValues(alpha: 0.1),
                      showCheckmark: false,
                      onSelected: (selected) {
                        _notifier.setUserRole(selected ? role : null);
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

  void _showUserDetail(BuildContext context, AdminUser user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  CircleAvatar(
                    backgroundColor: user.role.color.withValues(alpha: 0.15),
                    radius: 24,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0] : 'U',
                      style: TextStyle(
                        color: user.role.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${user.id} • ${user.role.displayName}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: user.role.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow('Department', user.department),
              _buildDetailRow('District', user.district),
              _buildDetailRow('Phone Number', user.phone),
              _buildDetailRow('Official Email', user.email),
              _buildDetailRow('Duty Status', user.status.displayName),
              _buildDetailRow(
                  'Last Authenticated', user.lastLogin.toLocal().toString()),
              const SizedBox(height: 12),
              Text(
                'Granted RBAC Permissions (${user.permissions.length})',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: user.permissions.map((p) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Close User Details'),
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
