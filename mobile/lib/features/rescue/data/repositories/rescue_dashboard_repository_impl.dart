import '../../domain/entities/rescue_dashboard_data.dart';
import '../../domain/repositories/rescue_dashboard_repository.dart';
import '../datasources/rescue_dashboard_mock_datasource.dart';

/// Concrete repository implementation for Rescue Dashboard.
class RescueDashboardRepositoryImpl implements RescueDashboardRepository {
  final RescueDashboardDataSource dataSource;

  RescueDashboardRepositoryImpl({RescueDashboardDataSource? dataSource})
      : dataSource = dataSource ?? const RescueDashboardMockDataSource();

  @override
  Future<RescueDashboardData> getDashboardData() async {
    return await dataSource.fetchDashboardData();
  }

  @override
  Future<RescueDashboardData> refreshDashboardData() async {
    return await dataSource.refreshDashboardData();
  }
}
