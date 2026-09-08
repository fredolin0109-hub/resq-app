import 'package:flutter/foundation.dart';

enum IncidentPriority {
  critical,
  high,
  medium,
  low,
}

enum IncidentStatus {
  dispatched,
  inProgress,
  enRoute,
  triaged,
  resolved,
}

enum SystemHealthStatus {
  operational,
  degraded,
  offline,
}

/// Officer profile for current session.
@immutable
class RescueOfficerProfile {
  final String name;
  final String role;
  final String badgeNumber;
  final bool isOnline;

  const RescueOfficerProfile({
    required this.name,
    required this.role,
    required this.badgeNumber,
    this.isOnline = true,
  });
}

/// Mission summary telemetry metrics.
@immutable
class MissionSummary {
  final int activeMissions;
  final String activeMissionsTrend;
  final int pendingSos;
  final String pendingSosTrend;
  final int rescueTeams;
  final String rescueTeamsTrend;
  final int availableResources;
  final String availableResourcesTrend;

  const MissionSummary({
    required this.activeMissions,
    required this.activeMissionsTrend,
    required this.pendingSos,
    required this.pendingSosTrend,
    required this.rescueTeams,
    required this.rescueTeamsTrend,
    required this.availableResources,
    required this.availableResourcesTrend,
  });
}

/// Real-time live emergency incident feed item.
@immutable
class EmergencyIncident {
  final String id;
  final String type;
  final String location;
  final IncidentPriority priority;
  final String timeAgo;
  final IncidentStatus status;
  final int victimsCount;

  const EmergencyIncident({
    required this.id,
    required this.type,
    required this.location,
    required this.priority,
    required this.timeAgo,
    required this.status,
    this.victimsCount = 1,
  });
}

/// Tactical weather and environmental forecast.
@immutable
class WeatherData {
  final String temperature;
  final String condition;
  final String rainProbability;
  final String wind;
  final String visibility;

  const WeatherData({
    required this.temperature,
    required this.condition,
    required this.rainProbability,
    required this.wind,
    required this.visibility,
  });
}

/// Infrastructure and network mesh health status.
@immutable
class SystemStatus {
  final SystemHealthStatus server;
  final SystemHealthStatus gps;
  final SystemHealthStatus internet;
  final SystemHealthStatus mesh;
  final SystemHealthStatus database;
  final int meshNodeCount;

  const SystemStatus({
    required this.server,
    required this.gps,
    required this.internet,
    required this.mesh,
    required this.database,
    required this.meshNodeCount,
  });
}

/// Aggregated dashboard data container.
@immutable
class RescueDashboardData {
  final RescueOfficerProfile officer;
  final MissionSummary summary;
  final List<EmergencyIncident> incidents;
  final WeatherData weather;
  final SystemStatus systemStatus;
  final DateTime lastUpdated;

  const RescueDashboardData({
    required this.officer,
    required this.summary,
    required this.incidents,
    required this.weather,
    required this.systemStatus,
    required this.lastUpdated,
  });
}
