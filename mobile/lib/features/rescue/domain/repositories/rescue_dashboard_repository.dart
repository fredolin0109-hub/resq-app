import '../entities/rescue_dashboard_data.dart';

/// Contract for fetching rescue dashboard operational data.
abstract class RescueDashboardRepository {
  Future<RescueDashboardData> getDashboardData();
  Future<RescueDashboardData> refreshDashboardData();
}
