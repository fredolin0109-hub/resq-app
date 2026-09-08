import '../../domain/entities/rescue_dashboard_data.dart';

/// DTO Model for [RescueDashboardData].
class RescueDashboardModel extends RescueDashboardData {
  const RescueDashboardModel({
    required super.officer,
    required super.summary,
    required super.incidents,
    required super.weather,
    required super.systemStatus,
    required super.lastUpdated,
  });

  factory RescueDashboardModel.fromJson(Map<String, dynamic> json) {
    return RescueDashboardModel(
      officer: RescueOfficerProfile(
        name: json['officer']?['name'] as String? ?? 'Commander Sarah Connor',
        role: json['officer']?['role'] as String? ?? 'District Control Officer',
        badgeNumber: json['officer']?['badge_number'] as String? ?? 'CMD-802',
        isOnline: json['officer']?['is_online'] as bool? ?? true,
      ),
      summary: MissionSummary(
        activeMissions: json['summary']?['active_missions'] as int? ?? 14,
        activeMissionsTrend: json['summary']?['active_missions_trend'] as String? ?? '+2 from last hour',
        pendingSos: json['summary']?['pending_sos'] as int? ?? 7,
        pendingSosTrend: json['summary']?['pending_sos_trend'] as String? ?? 'High Priority',
        rescueTeams: json['summary']?['rescue_teams'] as int? ?? 9,
        rescueTeamsTrend: json['summary']?['rescue_teams_trend'] as String? ?? '6 Deployed / 3 Standby',
        availableResources: json['summary']?['available_resources'] as int? ?? 38,
        availableResourcesTrend: json['summary']?['available_resources_trend'] as String? ?? '94% Operational',
      ),
      incidents: (json['incidents'] as List<dynamic>?)?.map((item) {
            final m = item as Map<String, dynamic>;
            return EmergencyIncident(
              id: m['id'] as String? ?? 'inc_1',
              type: m['type'] as String? ?? 'Flash Flood Rescue',
              location: m['location'] as String? ?? 'Sector 4-B Riverside',
              priority: _parsePriority(m['priority'] as String?),
              timeAgo: m['time_ago'] as String? ?? '5m ago',
              status: _parseStatus(m['status'] as String?),
              victimsCount: m['victims_count'] as int? ?? 3,
            );
          }).toList() ??
          [],
      weather: WeatherData(
        temperature: json['weather']?['temperature'] as String? ?? '28°C',
        condition: json['weather']?['condition'] as String? ?? 'Heavy Rain',
        rainProbability: json['weather']?['rain_probability'] as String? ?? '85%',
        wind: json['weather']?['wind'] as String? ?? '32 km/h NE',
        visibility: json['weather']?['visibility'] as String? ?? '4.2 km',
      ),
      systemStatus: SystemStatus(
        server: _parseHealth(json['system_status']?['server'] as String?),
        gps: _parseHealth(json['system_status']?['gps'] as String?),
        internet: _parseHealth(json['system_status']?['internet'] as String?),
        mesh: _parseHealth(json['system_status']?['mesh'] as String?),
        database: _parseHealth(json['system_status']?['database'] as String?),
        meshNodeCount: json['system_status']?['mesh_node_count'] as int? ?? 42,
      ),
      lastUpdated: DateTime.now(),
    );
  }

  static IncidentPriority _parsePriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'critical':
        return IncidentPriority.critical;
      case 'high':
        return IncidentPriority.high;
      case 'medium':
        return IncidentPriority.medium;
      case 'low':
      default:
        return IncidentPriority.low;
    }
  }

  static IncidentStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'dispatched':
        return IncidentStatus.dispatched;
      case 'in_progress':
      case 'inprogress':
        return IncidentStatus.inProgress;
      case 'en_route':
      case 'enroute':
        return IncidentStatus.enRoute;
      case 'triaged':
        return IncidentStatus.triaged;
      case 'resolved':
      default:
        return IncidentStatus.resolved;
    }
  }

  static SystemHealthStatus _parseHealth(String? health) {
    switch (health?.toLowerCase()) {
      case 'operational':
        return SystemHealthStatus.operational;
      case 'degraded':
        return SystemHealthStatus.degraded;
      case 'offline':
      default:
        return SystemHealthStatus.operational;
    }
  }
}
