import 'package:flutter/material.dart';
import '../../domain/entities/rescue_dashboard_data.dart';
import '../controllers/rescue_dashboard_controller.dart';
import '../providers/rescue_dashboard_provider.dart';
import '../providers/rescue_dashboard_state.dart';
import '../widgets/dashboard_empty_view.dart';
import '../widgets/dashboard_error_view.dart';
import '../widgets/dashboard_skeleton_loader.dart';
import '../widgets/greeting_card.dart';
import '../widgets/live_feed_card.dart';
import '../widgets/mission_summary_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/system_status_card.dart';
import '../widgets/weather_card.dart';
import 'rescue_subpage_placeholder_screens.dart';

/// Production-ready Rescue Mission Command Dashboard for ResQLink AI platform.
class RescueDashboardScreen extends StatefulWidget {
  final RescueDashboardNotifier? notifier;

  const RescueDashboardScreen({
    super.key,
    this.notifier,
  });

  static const String routeName = '/rescue/dashboard';

  @override
  State<RescueDashboardScreen> createState() => _RescueDashboardScreenState();
}

class _RescueDashboardScreenState extends State<RescueDashboardScreen> {
  late final RescueDashboardNotifier _notifier;
  late final RescueDashboardController _controller;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? RescueDashboardDependencies.notifier;
    _controller = RescueDashboardController();
    _notifier.addListener(_onStateChanged);
    _controller.addListener(_onStateChanged);

    // Initial load if not loaded yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_notifier.state.isInitial) {
        _notifier.loadDashboardData();
      }
    });
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _navigateToSubpage(String routeName, Widget placeholder) {
    Navigator.of(context).push(
      PageRouteBuilder(
        settings: RouteSettings(name: routeName),
        pageBuilder: (context, animation, secondaryAnimation) => placeholder,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    _controller.selectTab(index);
    switch (index) {
      case 0:
        // Already on Dashboard
        break;
      case 1:
        _navigateToSubpage('/rescue/map', RescueRoutePlaceholders.missionMap());
        break;
      case 2:
        _navigateToSubpage('/rescue/alerts', RescueRoutePlaceholders.sosDashboard());
        break;
      case 3:
        _navigateToSubpage('/rescue/ai', RescueRoutePlaceholders.aiCommander());
        break;
      case 4:
        _navigateToSubpage('/rescue/profile', RescueRoutePlaceholders.profile());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = _notifier.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rescue Mission Command',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 2,
        actions: [
          // Notification Icon with Badge
          Semantics(
            button: true,
            label: 'Notifications, 3 new alerts',
            child: IconButton(
              icon: Badge(
                label: const Text('3'),
                backgroundColor: colorScheme.error,
                child: const Icon(Icons.notifications_outlined),
              ),
              tooltip: 'Mission Notifications',
              onPressed: () => _navigateToSubpage(
                '/rescue/notifications',
                RescueRoutePlaceholders.notifications(),
              ),
            ),
          ),
          // Settings Icon
          Semantics(
            button: true,
            label: 'Command Settings',
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Command Settings',
              onPressed: () => _navigateToSubpage(
                '/rescue/settings',
                RescueRoutePlaceholders.settings(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Profile Avatar
          Semantics(
            button: true,
            label: 'Officer Profile',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _navigateToSubpage(
                '/rescue/profile',
                RescueRoutePlaceholders.profile(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Hero(
                  tag: 'appbar_profile_avatar',
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      'SC',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _buildBody(context, state),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _controller.currentTabIndex,
        onDestinationSelected: _onBottomNavTapped,
        elevation: 3,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
            tooltip: 'Mission Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Mission Map',
            tooltip: 'Live Mission Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.sos_outlined),
            selectedIcon: Icon(Icons.sos_rounded),
            label: 'SOS',
            tooltip: 'SOS Alerts & Triage',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology_rounded),
            label: 'AI',
            tooltip: 'AI Commander',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
            tooltip: 'Officer Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, RescueDashboardState state) {
    if (state.isLoading) {
      return const DashboardSkeletonLoader();
    }

    if (state.isError) {
      return DashboardErrorView(
        errorMessage: state.errorMessage ?? 'Unexpected connection error occurred',
        onRetry: () => _notifier.loadDashboardData(),
      );
    }

    if (state.isEmpty && state.data != null) {
      return RefreshIndicator(
        onRefresh: () => _notifier.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingCard(officer: state.data!.officer),
              const SizedBox(height: 20),
              _buildMissionSummarySection(context, state.data!.summary),
              const SizedBox(height: 24),
              _buildQuickActionsSection(context),
              const SizedBox(height: 28),
              DashboardEmptyView(onRefresh: () => _notifier.refresh()),
              const SizedBox(height: 24),
              WeatherCard(weather: state.data!.weather),
              const SizedBox(height: 16),
              SystemStatusCard(status: state.data!.systemStatus),
            ],
          ),
        ),
      );
    }

    if (state.isLoaded && state.data != null) {
      final data = state.data!;
      return RefreshIndicator(
        onRefresh: () => _notifier.refresh(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTabletOrLandscape = constraints.maxWidth >= 720;
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Greeting Card
                      GreetingCard(officer: data.officer),
                      const SizedBox(height: 20),

                      // 2. Mission Summary Cards
                      _buildMissionSummarySection(
                        context,
                        data.summary,
                        isWide: isTabletOrLandscape,
                      ),
                      const SizedBox(height: 24),

                      // 3. Quick Actions Grid
                      _buildQuickActionsSection(context, isWide: isTabletOrLandscape),
                      const SizedBox(height: 28),

                      // 4. Main Section Split: Live Feed & Telemetry (Side-by-side on wide screens)
                      if (isTabletOrLandscape) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildLiveFeedSection(context, data.incidents),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  WeatherCard(weather: data.weather),
                                  const SizedBox(height: 16),
                                  SystemStatusCard(status: data.systemStatus),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Mobile vertical flow
                        _buildLiveFeedSection(context, data.incidents),
                        const SizedBox(height: 24),
                        WeatherCard(weather: data.weather),
                        const SizedBox(height: 16),
                        SystemStatusCard(status: data.systemStatus),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return const DashboardSkeletonLoader();
  }

  Widget _buildMissionSummarySection(
    BuildContext context,
    MissionSummary summary, {
    bool isWide = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operational Overview',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isWide ? 1.45 : 1.35,
          children: [
            MissionSummaryCard(
              icon: Icons.flag_rounded,
              title: 'Active Missions',
              count: summary.activeMissions,
              trend: summary.activeMissionsTrend,
              accentColor: Colors.blue.shade700,
              onTap: () => _navigateToSubpage(
                '/rescue/history',
                RescueRoutePlaceholders.missionHistory(),
              ),
            ),
            MissionSummaryCard(
              icon: Icons.sos_rounded,
              title: 'Pending SOS',
              count: summary.pendingSos,
              trend: summary.pendingSosTrend,
              accentColor: Colors.red.shade700,
              onTap: () => _navigateToSubpage(
                '/rescue/alerts',
                RescueRoutePlaceholders.sosDashboard(),
              ),
            ),
            MissionSummaryCard(
              icon: Icons.groups_rounded,
              title: 'Rescue Teams',
              count: summary.rescueTeams,
              trend: summary.rescueTeamsTrend,
              accentColor: Colors.teal.shade700,
              onTap: () => _navigateToSubpage(
                '/rescue/teams',
                RescueRoutePlaceholders.teams(),
              ),
            ),
            MissionSummaryCard(
              icon: Icons.inventory_2_rounded,
              title: 'Available Resources',
              count: summary.availableResources,
              trend: summary.availableResourcesTrend,
              accentColor: Colors.orange.shade800,
              onTap: () => _navigateToSubpage(
                '/rescue/resources',
                RescueRoutePlaceholders.resources(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, {bool isWide = false}) {
    final theme = Theme.of(context);

    final actions = [
      (Icons.map_rounded, 'Mission Map', '/rescue/map', RescueRoutePlaceholders.missionMap()),
      (Icons.sos_rounded, 'SOS Dashboard', '/rescue/alerts', RescueRoutePlaceholders.sosDashboard()),
      (Icons.view_in_ar_rounded, 'Digital Twin', '/rescue/digital-twin', RescueRoutePlaceholders.digitalTwin()),
      (Icons.psychology_rounded, 'AI Commander', '/rescue/ai', RescueRoutePlaceholders.aiCommander()),
      (Icons.inventory_2_rounded, 'Resources', '/rescue/resources', RescueRoutePlaceholders.resources()),
      (Icons.groups_rounded, 'Teams', '/rescue/teams', RescueRoutePlaceholders.teams()),
      (Icons.history_rounded, 'Mission History', '/rescue/history', RescueRoutePlaceholders.missionHistory()),
      (Icons.assessment_rounded, 'Reports', '/rescue/reports', RescueRoutePlaceholders.reports()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 8 : 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isWide ? 1.0 : 0.95,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return QuickActionCard(
              icon: action.$1,
              label: action.$2,
              routeName: action.$3,
              onTap: () => _navigateToSubpage(action.$3, action.$4),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLiveFeedSection(
    BuildContext context,
    List<EmergencyIncident> incidents,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sensors_rounded,
                  color: colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Live Emergency Feed',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => _navigateToSubpage(
                '/rescue/alerts',
                RescueRoutePlaceholders.sosDashboard(),
              ),
              child: const Text('View All Alerts'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: incidents.length,
          itemBuilder: (context, index) {
            final incident = incidents[index];
            return LiveFeedCard(
              incident: incident,
              onTap: () => _navigateToSubpage(
                '/rescue/map',
                RescueRoutePlaceholders.missionMap(),
              ),
            );
          },
        ),
      ],
    );
  }
}
