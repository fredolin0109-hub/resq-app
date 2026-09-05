import 'package:flutter/foundation.dart';

/// Abstraction supporting OpenStreetMap online tiles and future offline MBTiles caching.
class MapTileService {
  final String onlineTileUrlTemplate;
  final String? offlineMbtilesPath;
  final bool preferOffline;

  const MapTileService({
    this.onlineTileUrlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    this.offlineMbtilesPath,
    this.preferOffline = false,
  });

  /// True if offline MBTiles cache has been loaded.
  bool get hasOfflineCache => offlineMbtilesPath != null && offlineMbtilesPath!.isNotEmpty;

  /// Retrieves the active tile source URL or local file path for flutter_map.
  String get activeTileUrl => (preferOffline && hasOfflineCache)
      ? offlineMbtilesPath!
      : onlineTileUrlTemplate;

  /// Prepares offline tile cache directories.
  Future<void> initializeOfflineStorage() async {
    // Placeholder for SQLite/MBTiles package initialization
    if (kDebugMode) {
      debugPrint('[MapTileService] Initializing offline MBTiles repository integration point.');
    }
  }
}
