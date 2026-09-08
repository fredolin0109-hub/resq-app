import '../../domain/entities/city_risk_entity.dart';
import '../../domain/repositories/rescue_map_repository.dart';
import '../datasources/rescue_map_mock_datasource.dart';

/// Concrete repository implementation for Tamil Nadu map operations.
class RescueMapRepositoryImpl implements RescueMapRepository {
  final RescueMapDataSource dataSource;

  RescueMapRepositoryImpl({RescueMapDataSource? dataSource})
      : dataSource = dataSource ?? const RescueMapMockDataSource();

  @override
  Future<List<CityRiskEntity>> getTamilNaduCities() async {
    return await dataSource.getTamilNaduCities();
  }

  @override
  Future<List<CityRiskEntity>> searchCities(String query) async {
    return await dataSource.searchCities(query);
  }

  @override
  Future<CityRiskEntity?> getCityById(String id) async {
    return await dataSource.getCityById(id);
  }
}
