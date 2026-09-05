import '../entities/rescue_dashboard_data.dart';
import '../repositories/rescue_dashboard_repository.dart';

/// UseCase to retrieve tactical rescue dashboard data.
class GetRescueDashboardDataUseCase {
  final RescueDashboardRepository repository;

  const GetRescueDashboardDataUseCase(this.repository);

  Future<RescueDashboardData> call({bool forceRefresh = false}) async {
    if (forceRefresh) {
      return await repository.refreshDashboardData();
    }
    return await repository.getDashboardData();
  }
}
