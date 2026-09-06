/// ResQLink AI Disaster Analytics & Reporting Module.
///
/// Provides operational insights, disaster statistics across 500 incidents,
/// resource utilization telemetry, team performance scorecards for 50 squads,
/// district profiles across 13 Tamil Nadu districts, AI operational alerts,
/// and SitRep export in PDF, CSV, and JSON formats.
library analytics;

// Domain Entities
export 'domain/entities/analytics_entities.dart';

// Domain Repositories
export 'domain/repositories/analytics_repository.dart';

// Domain Use Cases
export 'domain/usecases/analytics_usecases.dart';

// Data Models
export 'data/models/analytics_models.dart';

// Data Sources & Repositories
export 'data/datasources/analytics_mock_datasource.dart';
export 'data/repositories/analytics_repository_impl.dart';

// Services
export 'services/report_export_service.dart';

// Presentation Providers & State
export 'presentation/providers/analytics_state.dart';
export 'presentation/providers/analytics_provider.dart';

// Presentation Widgets
export 'presentation/widgets/analytics_summary_card.dart';
export 'presentation/widgets/incident_chart_card.dart';
export 'presentation/widgets/resource_utilization_card.dart';
export 'presentation/widgets/team_performance_card.dart';
export 'presentation/widgets/district_analytics_card.dart';
export 'presentation/widgets/ai_insight_card.dart';
export 'presentation/widgets/report_item_card.dart';
export 'presentation/widgets/analytics_skeleton_loader.dart';
export 'presentation/widgets/analytics_empty_view.dart';

// Presentation Screens
export 'presentation/screens/analytics_dashboard_screen.dart';
export 'presentation/screens/incident_statistics_screen.dart';
export 'presentation/screens/resource_utilization_screen.dart';
export 'presentation/screens/team_performance_screen.dart';
export 'presentation/screens/district_analytics_screen.dart';
export 'presentation/screens/ai_insights_screen.dart';
export 'presentation/screens/reports_center_screen.dart';
