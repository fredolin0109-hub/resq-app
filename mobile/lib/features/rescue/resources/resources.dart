// Domain Layer
export 'domain/entities/resource_entities.dart';
export 'domain/repositories/resource_repository.dart';
export 'domain/usecases/resource_usecases.dart';

// Data Layer
export 'data/datasources/resource_mock_datasource.dart';
export 'data/models/resource_models.dart';
export 'data/repositories/resource_repository_impl.dart';

// Presentation Layer (Providers & State)
export 'presentation/providers/resource_provider.dart';
export 'presentation/providers/resource_state.dart';

// Presentation Layer (Widgets)
export 'presentation/widgets/allocation_card.dart';
export 'presentation/widgets/hospital_card.dart';
export 'presentation/widgets/resource_empty_view.dart';
export 'presentation/widgets/resource_filter_sheet.dart';
export 'presentation/widgets/resource_item_card.dart';
export 'presentation/widgets/resource_skeleton_loader.dart';
export 'presentation/widgets/resource_status_badge.dart';
export 'presentation/widgets/resource_summary_card.dart';
export 'presentation/widgets/shelter_card.dart';
export 'presentation/widgets/warehouse_card.dart';

// Presentation Layer (Screens)
export 'presentation/screens/equipment_inventory_screen.dart';
export 'presentation/screens/hospital_management_screen.dart';
export 'presentation/screens/resource_allocation_screen.dart';
export 'presentation/screens/resource_dashboard_screen.dart';
export 'presentation/screens/resource_details_screen.dart';
export 'presentation/screens/shelter_management_screen.dart';
export 'presentation/screens/warehouse_inventory_screen.dart';
