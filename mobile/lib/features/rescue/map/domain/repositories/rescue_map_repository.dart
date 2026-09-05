import '../entities/city_risk_entity.dart';

/// Contract for fetching Tamil Nadu map telemetry and risk intelligence.
abstract class RescueMapRepository {
  Future<List<CityRiskEntity>> getTamilNaduCities();
  Future<List<CityRiskEntity>> searchCities(String query);
  Future<CityRiskEntity?> getCityById(String id);
}
