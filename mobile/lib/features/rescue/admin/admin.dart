/// ResQLink AI Administration, Monitoring & Management Module.
///
/// Features:
/// 1. System Health Dashboard & Subsystem Telemetry
/// 2. User Management & Role-Based Access Control (50 Users)
/// 3. Rescue Squad & Fleet Telemetry (20 Teams)
/// 4. Hardware Node & BLE Device Management (25 Devices)
/// 5. Emergency Notification Alert Center (200 Notifications)
/// 6. Forensic Audit Trail Logging (100 Events)
/// 7. Application Configuration & Settings
/// 8. State Backup & Disaster Recovery Snapshots
/// 9. Live Monitoring Telemetry (Latency, Memory, CPU, DB, Sync Queue)
/// 10. System Information & Legal Specifications
library admin;

// Domain Entities
export 'domain/entities/admin_entities.dart';

// Domain Repositories
export 'domain/repositories/admin_repository.dart';

// Domain Use Cases
export 'domain/usecases/admin_usecases.dart';

// Data Models
export 'data/models/admin_models.dart';

// Data Sources & Repositories
export 'data/datasources/admin_mock_datasource.dart';
export 'data/repositories/admin_repository_impl.dart';

// Services
export 'services/backup_restore_service.dart';

// Presentation Providers & State
export 'presentation/providers/admin_state.dart';
export 'presentation/providers/admin_provider.dart';

// Presentation Widgets
export 'presentation/widgets/system_health_card.dart';
export 'presentation/widgets/admin_stat_tile.dart';
export 'presentation/widgets/user_card.dart';
export 'presentation/widgets/admin_team_card.dart';
export 'presentation/widgets/device_card.dart';
export 'presentation/widgets/notification_item_card.dart';
export 'presentation/widgets/audit_log_card.dart';
export 'presentation/widgets/metric_gauge_card.dart';
export 'presentation/widgets/admin_skeleton_loader.dart';
export 'presentation/widgets/admin_empty_view.dart';

// Presentation Screens
export 'presentation/screens/system_dashboard_screen.dart';
export 'presentation/screens/user_management_screen.dart';
export 'presentation/screens/admin_team_management_screen.dart';
export 'presentation/screens/device_management_screen.dart';
export 'presentation/screens/notification_center_screen.dart';
export 'presentation/screens/audit_logs_screen.dart';
export 'presentation/screens/application_settings_screen.dart';
export 'presentation/screens/backup_restore_screen.dart';
export 'presentation/screens/monitoring_dashboard_screen.dart';
export 'presentation/screens/about_system_screen.dart';
