import '../entities/city_risk_entity.dart';
import '../repositories/rescue_map_repository.dart';

/// UseCase retrieving all monitored Tamil Nadu cities and disaster risk levels.
class GetTamilNaduCitiesUseCase {
  final RescueMapRepository repository;

  const GetTamilNaduCitiesUseCase(this.repository);

  Future<List<CityRiskEntity>> call() async {
    return await repository.getTamilNaduCities();
  }

  Future<List<CityRiskEntity>> search(String query) async {
    if (query.trim().isEmpty) {
      return await repository.getTamilNaduCities();
    }
    return await repository.searchCities(query.trim());
  }
}
