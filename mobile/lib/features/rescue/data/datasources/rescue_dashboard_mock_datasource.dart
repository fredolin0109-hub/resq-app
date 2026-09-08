import '../../domain/entities/rescue_dashboard_data.dart';
import '../models/rescue_dashboard_model.dart';

/// Abstract contract for Dashboard data sources.
abstract class RescueDashboardDataSource {
  Future<RescueDashboardModel> fetchDashboardData();
  Future<RescueDashboardModel> refreshDashboardData();
}

/// Mock implementation providing realistic emergency response telemetry.
class RescueDashboardMockDataSource implements RescueDashboardDataSource {
  final Duration simulatedDelay;
  final bool simulateEmpty;
  final bool simulateError;

  const RescueDashboardMockDataSource({
    this.simulatedDelay = const Duration(milliseconds: 600),
    this.simulateEmpty = false,
    this.simulateError = false,
  });

  @override
  Future<RescueDashboardModel> fetchDashboardData() async {
    if (simulatedDelay > Duration.zero) {
      await Future.delayed(simulatedDelay);
    }

    if (simulateError) {
      throw Exception('Failed to connect to Rescue Command telemetry server');
    }

    return RescueDashboardModel(
      officer: const RescueOfficerProfile(
        name: 'Commander Sarah Connor',
        role: 'District Control Officer',
        badgeNumber: 'CMD-802',
        isOnline: true,
      ),
      summary: const MissionSummary(
        activeMissions: 14,
        activeMissionsTrend: '+2 from last hour',
        pendingSos: 7,
        pendingSosTrend: 'High Priority',
        rescueTeams: 9,
        rescueTeamsTrend: '6 Deployed / 3 Standby',
        availableResources: 38,
        availableResourcesTrend: '94% Operational',
      ),
      incidents: simulateEmpty
          ? []
          : const [
              EmergencyIncident(
                id: 'INC-2041',
                type: 'Flash Flood Evacuation',
                location: 'Sector 4-B Riverside Causeway',
                priority: IncidentPriority.critical,
                timeAgo: '3m ago',
                status: IncidentStatus.inProgress,
                victimsCount: 6,
              ),
              EmergencyIncident(
                id: 'INC-2042',
                type: 'Structural Collapse Triage',
                location: 'Northern Heights Block 2',
                priority: IncidentPriority.critical,
                timeAgo: '11m ago',
                status: IncidentStatus.dispatched,
                victimsCount: 4,
              ),
              EmergencyIncident(
                id: 'INC-2043',
                type: 'Medical Evacuation / Airlift',
                location: 'Valley Ridge Road Mile 14',
                priority: IncidentPriority.high,
                timeAgo: '24m ago',
                status: IncidentStatus.enRoute,
                victimsCount: 2,
              ),
              EmergencyIncident(
                id: 'INC-2044',
                type: 'Wildfire Perimeter Breach',
                location: 'Hillside Pine Ridge Reserve',
                priority: IncidentPriority.high,
                timeAgo: '42m ago',
                status: IncidentStatus.inProgress,
                victimsCount: 1,
              ),
              EmergencyIncident(
                id: 'INC-2045',
                type: 'Power Grid Failure Support',
                location: 'City Substation Alpha-9',
                priority: IncidentPriority.medium,
                timeAgo: '1h ago',
                status: IncidentStatus.triaged,
                victimsCount: 0,
              ),
            ],
      weather: const WeatherData(
        temperature: '28°C',
        condition: 'Heavy Rain / Thunderstorm',
        rainProbability: '85%',
        wind: '32 km/h NE',
        visibility: '4.2 km',
      ),
      systemStatus: const SystemStatus(
        server: SystemHealthStatus.operational,
        gps: SystemHealthStatus.operational,
        internet: SystemHealthStatus.operational,
        mesh: SystemHealthStatus.operational,
        database: SystemHealthStatus.operational,
        meshNodeCount: 42,
      ),
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<RescueDashboardModel> refreshDashboardData() async {
    return fetchDashboardData();
  }
}
