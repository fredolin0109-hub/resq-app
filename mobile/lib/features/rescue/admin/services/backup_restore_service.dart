import 'dart:convert';
import '../domain/entities/admin_entities.dart';

/// Service for handling system backups, setting imports/exports, and diagnostic telemetry dumping.
class BackupRestoreService {
  /// Export application settings to JSON format.
  String exportSettingsJson(ApplicationSettings settings) {
    final map = {
      'themeMode': settings.themeMode,
      'language': settings.language,
      'notificationsEnabled': settings.notificationsEnabled,
      'soundAlertsEnabled': settings.soundAlertsEnabled,
      'hapticFeedback': settings.hapticFeedback,
      'offlineModeForced': settings.offlineModeForced,
      'mapCacheLimitMb': settings.mapCacheLimitMb,
      'bleTxPowerDbm': settings.bleTxPowerDbm,
      'syncIntervalSeconds': settings.syncIntervalSeconds,
      'gpsAccuracy': settings.gpsAccuracy,
      'loggingLevel': settings.loggingLevel,
      'developerMode': settings.developerMode,
      'mockTelemetryEnabled': settings.mockTelemetryEnabled,
      'exportedAt': DateTime.now().toIso8601String(),
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  /// Parse and import settings from JSON string.
  ApplicationSettings importSettingsJson(String jsonStr) {
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    return ApplicationSettings(
      themeMode: map['themeMode'] as String? ?? 'dark',
      language: map['language'] as String? ?? 'en',
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      soundAlertsEnabled: map['soundAlertsEnabled'] as bool? ?? true,
      hapticFeedback: map['hapticFeedback'] as bool? ?? true,
      offlineModeForced: map['offlineModeForced'] as bool? ?? false,
      mapCacheLimitMb: (map['mapCacheLimitMb'] as num?)?.toInt() ?? 512,
      bleTxPowerDbm: (map['bleTxPowerDbm'] as num?)?.toInt() ?? 4,
      syncIntervalSeconds: (map['syncIntervalSeconds'] as num?)?.toInt() ?? 15,
      gpsAccuracy: map['gpsAccuracy'] as String? ?? 'High',
      loggingLevel: map['loggingLevel'] as String? ?? 'Info',
      developerMode: map['developerMode'] as bool? ?? false,
      mockTelemetryEnabled: map['mockTelemetryEnabled'] as bool? ?? true,
    );
  }

  /// Generate formatted system diagnostic dump.
  String generateSystemDiagnosticReport({
    required SystemHealthMetrics health,
    required ApplicationSettings settings,
    required int totalUsers,
    required int totalTeams,
    required int totalDevices,
    required int unreadAlerts,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('================================================================');
    buffer.writeln('             RESQLINK AI RESCUE SYSTEM DIAGNOSTIC DUMP          ');
    buffer.writeln('================================================================');
    buffer.writeln('Generated:     ${DateTime.now().toIso8601String()}');
    buffer.writeln('App Version:   ${health.appVersion} (Build ${health.buildNumber})');
    buffer.writeln('System Status: ${health.systemStatus.toUpperCase()}');
    buffer.writeln('----------------------------------------------------------------');
    buffer.writeln('1. HARDWARE & PERIPHERAL TELEMETRY');
    buffer.writeln('  * API Connectivity:     ${health.isApiHealthy ? "HEALTHY" : "OFFLINE"} (${health.apiLatencyMs} ms)');
    buffer.writeln('  * Local SQLite DB:      ${health.isDatabaseConnected ? "CONNECTED" : "DISCONNECTED"}');
    buffer.writeln('  * BLE Mesh Gateway:     ${health.isBleServiceActive ? "ACTIVE" : "INACTIVE"}');
    buffer.writeln('  * GNSS / GPS Lock:      ${health.isGpsLocked ? "LOCKED (3D FIX)" : "NO FIX"}');
    buffer.writeln('  * Internet Uplink:      ${health.isInternetConnected ? "ONLINE" : "OFFLINE"}');
    buffer.writeln('  * Storage Load:         ${health.storageUsedGb} GB / ${health.storageTotalGb} GB (${health.storagePercent.toStringAsFixed(1)}%)');
    buffer.writeln('  * Memory Usage:         ${health.memoryUsageMb.toInt()} MB / ${health.memoryTotalMb.toInt()} MB (${health.memoryPercent.toStringAsFixed(1)}%)');
    buffer.writeln('  * CPU Utilization:      ${health.cpuLoadPercent}%');
    buffer.writeln('  * Battery Charge:       ${health.batteryPercent}% (${health.isCharging ? "Charging" : "Discharging"})');
    buffer.writeln('  * Sync Queue Pending:   ${health.syncQueueLength} items');
    buffer.writeln('  * Recorded Crash Logs:  ${health.crashReportsCount}');
    buffer.writeln('----------------------------------------------------------------');
    buffer.writeln('2. REGISTERED ENTITY COUNTS');
    buffer.writeln('  * System Users:         $totalUsers users');
    buffer.writeln('  * Rescue Squads:        $totalTeams teams');
    buffer.writeln('  * Hardware Nodes:       $totalDevices units');
    buffer.writeln('  * Unread Alerts:        $unreadAlerts notifications');
    buffer.writeln('----------------------------------------------------------------');
    buffer.writeln('3. CONFIGURATION PREFERENCES');
    buffer.writeln('  * Theme Mode:           ${settings.themeMode}');
    buffer.writeln('  * Language:             ${settings.language}');
    buffer.writeln('  * Offline Forced:       ${settings.offlineModeForced}');
    buffer.writeln('  * Map Cache Limit:      ${settings.mapCacheLimitMb} MB');
    buffer.writeln('  * GPS Accuracy Mode:    ${settings.gpsAccuracy}');
    buffer.writeln('  * Logging Level:        ${settings.loggingLevel}');
    buffer.writeln('================================================================');
    return buffer.toString();
  }
}
