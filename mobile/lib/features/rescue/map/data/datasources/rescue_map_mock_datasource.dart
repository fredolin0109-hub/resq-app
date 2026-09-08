import '../../domain/entities/city_risk_entity.dart';
import '../models/city_risk_model.dart';

/// Interface for fetching Tamil Nadu rescue map data.
abstract class RescueMapDataSource {
  Future<List<CityRiskModel>> getTamilNaduCities();
  Future<List<CityRiskModel>> searchCities(String query);
  Future<CityRiskModel?> getCityById(String id);
}

/// Production-ready mock data source with high-precision Tamil Nadu telemetry.
class RescueMapMockDataSource implements RescueMapDataSource {
  final Duration latency;

  const RescueMapMockDataSource({
    this.latency = const Duration(milliseconds: 100),
  });

  static final List<CityRiskModel> _cities = [
    // 1. Palani
    CityRiskModel(
      id: 'tn_palani',
      name: 'Palani',
      district: 'Dindigul',
      area: 'Palani Town & Foothills',
      latitude: 10.4500,
      longitude: 77.5167,
      population: '70,467',
      riskLevel: RiskLevel.safe,
      riskPercentage: 12,
      severityRadiusKm: 6.0,
      hospitalsCount: 2,
      hospitalNames: ['Palani Govt General Hospital', 'Subramaniam Care Centre'],
      sheltersCount: 3,
      shelterNames: ['Hillview Relief Center', 'Palani Community Hall', 'Municipal School Shelter'],
      availableRescueTeams: 2,
      assignedTeams: ['Team Delta-1'],
      weather: '27°C Light Breeze',
      roadStatus: RoadStatus.open,
      activeHazards: [],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 6)),
    ),

    // 2. Dindigul
    CityRiskModel(
      id: 'tn_dindigul',
      name: 'Dindigul',
      district: 'Dindigul',
      area: 'Dindigul Central',
      latitude: 10.3673,
      longitude: 77.9803,
      population: '207,462',
      riskLevel: RiskLevel.moderate,
      riskPercentage: 45,
      severityRadiusKm: 14.0,
      hospitalsCount: 5,
      hospitalNames: ['Dindigul Medical College Hospital', 'St. Joseph Hospital', 'City Critical Care'],
      sheltersCount: 6,
      shelterNames: ['Rock Fort Relief Camp', 'Rotary Shelter Hall', 'Dindigul Indoor Stadium'],
      availableRescueTeams: 4,
      assignedTeams: ['Team Alpha-3', 'Team Bravo-1'],
      weather: '29°C Overcast / Rain Imminent',
      roadStatus: RoadStatus.passableWithCaution,
      activeHazards: [HazardType.flood],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 12)),
    ),

    // 3. Madurai
    CityRiskModel(
      id: 'tn_madurai',
      name: 'Madurai',
      district: 'Madurai',
      area: 'Vaigai Riverfront & Central',
      latitude: 9.9252,
      longitude: 78.1198,
      population: '1,465,000',
      riskLevel: RiskLevel.moderate,
      riskPercentage: 58,
      severityRadiusKm: 18.0,
      hospitalsCount: 10,
      hospitalNames: ['Madurai Govt Rajaji Hospital', 'Apollo Speciality', 'Meenakshi Mission'],
      sheltersCount: 12,
      shelterNames: ['Vaigai Relief Base', 'Racecourse Shelter Depot', 'Thiruparankundram Community Camp'],
      availableRescueTeams: 6,
      assignedTeams: ['Team Echo-1', 'Team Echo-2', 'River Rescue Squad'],
      weather: '30°C Vaigai River Surge Alert',
      roadStatus: RoadStatus.passableWithCaution,
      activeHazards: [HazardType.flood],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 4)),
    ),

    // 4. Trichy
    CityRiskModel(
      id: 'tn_trichy',
      name: 'Trichy',
      district: 'Tiruchirappalli',
      area: 'Kaveri Basin / Cantonment',
      latitude: 10.7905,
      longitude: 78.7047,
      population: '1,022,000',
      riskLevel: RiskLevel.safe,
      riskPercentage: 20,
      severityRadiusKm: 10.0,
      hospitalsCount: 7,
      hospitalNames: ['Trichy Mahatma Gandhi Govt Hospital', 'Kauvery Hospital'],
      sheltersCount: 9,
      shelterNames: ['Srirangam Evacuation Camp', 'St. Joseph Relief Shelter'],
      availableRescueTeams: 5,
      assignedTeams: ['Team Gamma-2', 'Team Gamma-3'],
      weather: '31°C Partly Cloudy',
      roadStatus: RoadStatus.open,
      activeHazards: [],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 18)),
    ),

    // 5. Tirunelveli
    CityRiskModel(
      id: 'tn_tirunelveli',
      name: 'Tirunelveli',
      district: 'Tirunelveli',
      area: 'Thamirabarani Lowlands',
      latitude: 8.7139,
      longitude: 77.7567,
      population: '473,637',
      riskLevel: RiskLevel.highRisk,
      riskPercentage: 86,
      severityRadiusKm: 26.0,
      hospitalsCount: 6,
      hospitalNames: ['Tirunelveli Medical College Hospital', 'Galaxy Multi-speciality'],
      sheltersCount: 14,
      shelterNames: ['Thamirabarani Emergency Relief', 'Palayamkottai Camp 1', 'Collectorate Relief Center'],
      availableRescueTeams: 8,
      assignedTeams: ['Rescue Fleet Alpha', 'Swift Water Unit 9', 'NDRF Squad 4'],
      weather: '26°C Flash Flood Warning / Torrential Downpour',
      roadStatus: RoadStatus.blockedFlooded,
      activeHazards: [HazardType.flood],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
    ),

    // 6. Udumalpet
    CityRiskModel(
      id: 'tn_udumalpet',
      name: 'Udumalpet',
      district: 'Tiruppur',
      area: 'Western Ghats Border',
      latitude: 10.5847,
      longitude: 77.2475,
      population: '61,133',
      riskLevel: RiskLevel.safe,
      riskPercentage: 15,
      severityRadiusKm: 7.0,
      hospitalsCount: 2,
      hospitalNames: ['Udumalpet Govt Hospital', 'Sri Ram Hospital'],
      sheltersCount: 3,
      shelterNames: ['Town Hall Relief Base', 'Amaravathi Shelter Depot'],
      availableRescueTeams: 2,
      assignedTeams: ['Team Sierra-1'],
      weather: '25°C Pleasant / Mountain Mist',
      roadStatus: RoadStatus.open,
      activeHazards: [],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
    ),

    // 7. Coimbatore
    CityRiskModel(
      id: 'tn_coimbatore',
      name: 'Coimbatore',
      district: 'Coimbatore',
      area: 'Siruvani / Western Foothills',
      latitude: 11.0168,
      longitude: 76.9558,
      population: '2,136,000',
      riskLevel: RiskLevel.moderate,
      riskPercentage: 48,
      severityRadiusKm: 20.0,
      hospitalsCount: 14,
      hospitalNames: ['Coimbatore Medical College Hospital', 'PSG Hospitals', 'Ganga Medical Centre'],
      sheltersCount: 15,
      shelterNames: ['VOC Ground Shelter Base', 'Singanallur Evacuation Depot', 'Marudhamalai Camp'],
      availableRescueTeams: 7,
      assignedTeams: ['Team Victor-1', 'Team Victor-2', 'Highland Rescue Squad'],
      weather: '26°C Heavy Showers in Foothills',
      roadStatus: RoadStatus.passableWithCaution,
      activeHazards: [HazardType.landslide],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 9)),
    ),

    // 8. Salem
    CityRiskModel(
      id: 'tn_salem',
      name: 'Salem',
      district: 'Salem',
      area: 'Shevaroy Foothills & Central',
      latitude: 11.6643,
      longitude: 78.1460,
      population: '918,000',
      riskLevel: RiskLevel.safe,
      riskPercentage: 18,
      severityRadiusKm: 12.0,
      hospitalsCount: 8,
      hospitalNames: ['Mohan Kumaramangalam Govt Hospital', 'Manipal Hospital Salem'],
      sheltersCount: 8,
      shelterNames: ['Yercaud Foothill Camp', 'Hasthampatti Relief Center'],
      availableRescueTeams: 4,
      assignedTeams: ['Team Tango-1'],
      weather: '30°C Clear Skies',
      roadStatus: RoadStatus.open,
      activeHazards: [],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 22)),
    ),

    // 9. Erode
    CityRiskModel(
      id: 'tn_erode',
      name: 'Erode',
      district: 'Erode',
      area: 'Bhavani River Confluence',
      latitude: 11.3410,
      longitude: 77.7172,
      population: '521,000',
      riskLevel: RiskLevel.moderate,
      riskPercentage: 42,
      severityRadiusKm: 15.0,
      hospitalsCount: 5,
      hospitalNames: ['Erode Govt Headquarters Hospital', 'Lotus Hospital'],
      sheltersCount: 7,
      shelterNames: ['Bhavani Relief Post', 'Erode Central Camp'],
      availableRescueTeams: 3,
      assignedTeams: ['Team Bravo-4'],
      weather: '29°C Moderate Rain',
      roadStatus: RoadStatus.passableWithCaution,
      activeHazards: [HazardType.flood],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
    ),

    // 10. Chennai
    CityRiskModel(
      id: 'tn_chennai',
      name: 'Chennai',
      district: 'Chennai',
      area: 'Adyar / Cooum & Coastal Lowlands',
      latitude: 13.0827,
      longitude: 80.2707,
      population: '11,500,000',
      riskLevel: RiskLevel.highRisk,
      riskPercentage: 92,
      severityRadiusKm: 35.0,
      hospitalsCount: 24,
      hospitalNames: ['Rajiv Gandhi Govt General Hospital', 'Apollo Greams Road', 'MGM Healthcare', 'Stanley Medical College'],
      sheltersCount: 45,
      shelterNames: ['Marina Tsunami Base', 'Velachery Relief Depot', 'Tambaram Air Base Shelter', 'Adyar Evacuation Center'],
      availableRescueTeams: 16,
      assignedTeams: ['Coastal Guard Unit 1', 'NDRF Battalion 10', 'Amphibious Fleet Red', 'Helicopter Air-Rescue 1'],
      weather: '28°C Severe Cyclone Alert / Coastal Inundation',
      roadStatus: RoadStatus.blockedFlooded,
      activeHazards: [HazardType.flood, HazardType.cyclone],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 1)),
    ),

    // 11. Thanjavur
    CityRiskModel(
      id: 'tn_thanjavur',
      name: 'Thanjavur',
      district: 'Thanjavur',
      area: 'Cauvery Delta Lowlands',
      latitude: 10.7870,
      longitude: 79.1378,
      population: '222,943',
      riskLevel: RiskLevel.moderate,
      riskPercentage: 50,
      severityRadiusKm: 16.0,
      hospitalsCount: 4,
      hospitalNames: ['Thanjavur Medical College Hospital', 'Vinodhagan Memorial'],
      sheltersCount: 8,
      shelterNames: ['Delta Relief Station 1', 'Big Temple Grounds Camp', 'Karanthai Shelter'],
      availableRescueTeams: 4,
      assignedTeams: ['Team Delta-3', 'Team Delta-4'],
      weather: '29°C Canal Overflow Warning',
      roadStatus: RoadStatus.passableWithCaution,
      activeHazards: [HazardType.flood],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 8)),
    ),

    // 12. Thoothukudi
    CityRiskModel(
      id: 'tn_thoothukudi',
      name: 'Thoothukudi',
      district: 'Thoothukudi',
      area: 'Harbor Coastal & Salt Pan Zone',
      latitude: 8.7642,
      longitude: 78.1348,
      population: '410,760',
      riskLevel: RiskLevel.highRisk,
      riskPercentage: 82,
      severityRadiusKm: 24.0,
      hospitalsCount: 6,
      hospitalNames: ['Thoothukudi Govt Medical College', 'Sacred Heart Hospital'],
      sheltersCount: 16,
      shelterNames: ['Pearl City Relief Base', 'Harbor Emergency Depot', 'Spic Nagar Shelter'],
      availableRescueTeams: 9,
      assignedTeams: ['Marine Rescue Unit 2', 'NDRF Coastal Squad', 'Amphibious Unit 4'],
      weather: '27°C Heavy Torrential Storm / Saltpan Inundation',
      roadStatus: RoadStatus.blockedFlooded,
      activeHazards: [HazardType.flood],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
    ),

    // 13. Vellore
    CityRiskModel(
      id: 'tn_vellore',
      name: 'Vellore',
      district: 'Vellore',
      area: 'Palar River Basin',
      latitude: 12.9165,
      longitude: 79.1325,
      population: '504,079',
      riskLevel: RiskLevel.safe,
      riskPercentage: 22,
      severityRadiusKm: 11.0,
      hospitalsCount: 6,
      hospitalNames: ['Christian Medical College (CMC)', 'Govt Vellore Medical College'],
      sheltersCount: 8,
      shelterNames: ['Fort Grounds Relief Camp', 'Katpadi Station Base'],
      availableRescueTeams: 3,
      assignedTeams: ['Team Alpha-7'],
      weather: '32°C Sunny / Moderate Heat',
      roadStatus: RoadStatus.open,
      activeHazards: [],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 19)),
    ),
  ];

  @override
  Future<List<CityRiskModel>> getTamilNaduCities() async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    return List.unmodifiable(_cities);
  }

  @override
  Future<List<CityRiskModel>> searchCities(String query) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return List.unmodifiable(_cities);

    return _cities.where((city) {
      return city.name.toLowerCase().contains(q) ||
          city.district.toLowerCase().contains(q) ||
          city.area.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<CityRiskModel?> getCityById(String id) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    try {
      return _cities.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
