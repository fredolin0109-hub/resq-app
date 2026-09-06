import '../domain/entities/offline_entities.dart';
import '../data/models/offline_models.dart';

/// Offline Map Cache Service storing spatial risk zones, shelters, hospitals, and teams locally.
class OfflineCacheService {
  final Map<String, CachedMapData> _cache = {};

  OfflineCacheService() {
    _initDefaultCaches();
  }

  void _initDefaultCaches() {
    final now = DateTime.now().subtract(const Duration(hours: 1));
    const districts = [
      'Chennai',
      'Cuddalore',
      'Nagapattinam',
      'Tirunelveli',
      'Thoothukudi',
      'Madurai',
      'Coimbatore',
      'Salem',
      'Tiruchirappalli',
      'Vellore',
      'Thanjavur',
      'Erode',
      'Kanyakumari',
    ];

    for (int i = 0; i < districts.length; i++) {
      final d = districts[i];
      _cache[d] = CachedMapDataModel(
        district: d,
        cachedRiskZonesCount: 8 + (i % 6),
        cachedSheltersCount: 6 + (i % 5),
        cachedHospitalsCount: 4 + (i % 4),
        cachedTeamsCount: 5 + (i % 3),
        lastCachedAt: now.subtract(Duration(minutes: i * 15)),
        cacheSizeKb: 1024 + (i * 128),
      );
    }
  }

  /// Retrieve cached spatial dataset for a specific district or all districts.
  List<CachedMapData> getCachedData({String? district}) {
    if (district != null && district != 'All' && _cache.containsKey(district)) {
      return [_cache[district]!];
    }
    return _cache.values.toList();
  }

  /// Total cached data footprint in megabytes.
  double get totalCacheSizeMb {
    final totalKb = _cache.values.fold(0, (sum, c) => sum + c.cacheSizeKb);
    return totalKb / 1024.0;
  }
}
