import 'package:flutter/material.dart';
import '../features/civilian/presentation/screens/civilian_portal_screen.dart';
import '../features/rescue/admin/presentation/screens/application_settings_screen.dart';
import '../features/rescue/admin/presentation/screens/monitoring_dashboard_screen.dart';
import '../features/rescue/admin/presentation/screens/notification_center_screen.dart';
import '../features/rescue/ai_commander/presentation/screens/ai_commander_dashboard_screen.dart';
import '../features/rescue/analytics/presentation/screens/analytics_dashboard_screen.dart';
import '../features/rescue/auth/presentation/screens/rescue_login_screen.dart';
import '../features/rescue/digital_twin/presentation/screens/digital_twin_dashboard_screen.dart';
import '../features/rescue/map/presentation/screens/rescue_map_screen.dart';
import '../features/rescue/offline/presentation/screens/offline_dashboard_screen.dart';
import '../features/rescue/presentation/screens/officer_profile_screen.dart';
import '../features/rescue/presentation/screens/rescue_dashboard_screen.dart';
import '../features/rescue/resources/presentation/screens/resource_dashboard_screen.dart';
import '../features/rescue/sos/presentation/screens/mission_history_screen.dart';
import '../features/rescue/sos/presentation/screens/sos_dashboard_screen.dart';
import '../features/rescue/team_management/presentation/screens/rescue_teams_dashboard_screen.dart';
import 'theme/theme.dart';

/// Main Application Widget for ResQLink AI Platform.
class ResQApp extends StatelessWidget {
  const ResQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQLink AI - Disaster Response',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: RescueLoginScreen.routeName,
      routes: {
        RescueLoginScreen.routeName: (_) => const RescueLoginScreen(),
        RescueDashboardScreen.routeName: (_) => const RescueDashboardScreen(),
        CivilianPortalScreen.routeName: (_) => const CivilianPortalScreen(),
        RescueMapScreen.routeName: (_) => const RescueMapScreen(),
        SosDashboardScreen.routeName: (_) => const SosDashboardScreen(),
        MissionHistoryScreen.routeName: (_) => const MissionHistoryScreen(),
        RescueTeamsDashboardScreen.routeName: (_) => const RescueTeamsDashboardScreen(),
        ResourceDashboardScreen.routeName: (_) => const ResourceDashboardScreen(),
        AICommanderDashboardScreen.routeName: (_) => const AICommanderDashboardScreen(),
        '/rescue/digital-twin': (_) => const DigitalTwinDashboardScreen(),
        '/rescue/reports': (_) => const AnalyticsDashboardScreen(),
        OfficerProfileScreen.routeName: (_) => const OfficerProfileScreen(),
        '/rescue/notifications': (_) => const NotificationCenterScreen(),
        '/rescue/settings': (_) => const ApplicationSettingsScreen(),
        '/rescue/offline': (_) => const OfflineDashboardScreen(),
        '/rescue/monitoring': (_) => const MonitoringDashboardScreen(),
      },
    );
  }
}
