/// Master Umbrella Library for ResQLink AI Rescue Command Module.
///
/// Integrates all 11 core rescue subsystems:
/// 1. Rescue Authentication & Biometrics
/// 2. Central Mission Dashboard & Telemetry
/// 3. Mission Command Spatial Map & Tactical Layers
/// 4. Live SOS Command Center & Victim Triage
/// 5. Rescue Squad & Fleet Management
/// 6. Resource, Warehouse, Shelter & Hospital Management
/// 7. AI Commander Decision Intelligence & NLP Chat
/// 8. Digital Twin Command Center & Disaster Simulation
/// 9. Offline Mesh & BLE Peer-to-Peer Communication
/// 10. Disaster Analytics & Reporting (PDF/CSV/JSON SitRep)
/// 11. System Administration, RBAC, Monitoring & Diagnostics
library rescue;

// 1. Auth Module
export 'auth/rescue_auth.dart';

// 2. Rescue Mission Dashboard & Core Presentation
export 'domain/entities/rescue_dashboard_data.dart';
export 'domain/repositories/rescue_dashboard_repository.dart';
export 'domain/usecases/get_rescue_dashboard_data_usecase.dart';
export 'data/datasources/rescue_dashboard_mock_datasource.dart';
export 'data/models/rescue_dashboard_model.dart';
export 'data/repositories/rescue_dashboard_repository_impl.dart';
export 'presentation/controllers/rescue_dashboard_controller.dart';
export 'presentation/providers/rescue_dashboard_provider.dart';
export 'presentation/providers/rescue_dashboard_state.dart';
export 'presentation/screens/rescue_dashboard_screen.dart';
export 'presentation/screens/officer_profile_screen.dart';
export 'presentation/screens/rescue_subpage_placeholder_screens.dart';
export 'presentation/widgets/dashboard_empty_view.dart';
export 'presentation/widgets/dashboard_error_view.dart';
export 'presentation/widgets/dashboard_skeleton_loader.dart';
export 'presentation/widgets/greeting_card.dart';
export 'presentation/widgets/live_feed_card.dart';
export 'presentation/widgets/mission_summary_card.dart';
export 'presentation/widgets/quick_action_card.dart';
export 'presentation/widgets/system_status_card.dart';
export 'presentation/widgets/weather_card.dart';

// 3. Mission Command Map
export 'map/rescue_map.dart';

// 4. Live SOS Command Center
export 'sos/rescue_sos.dart';

// 5. Team & Fleet Management
export 'team_management/team_management.dart';

// 6. Resource, Shelter & Hospital Management
export 'resources/resources.dart';

// 7. AI Commander
export 'ai_commander/ai_commander.dart';

// 8. Digital Twin Command Center
export 'digital_twin/digital_twin.dart';

// 9. Offline Communication
export 'offline/offline.dart';

// 10. Disaster Analytics & Reporting
export 'analytics/analytics.dart';

// 11. System Administration & Monitoring
export 'admin/admin.dart';
