import '../models/offline_models.dart';
import '../../domain/entities/offline_entities.dart';

/// Comprehensive mock data source for the Offline Communication Module.
/// Generates 15 nearby mesh devices, 100 queued messages, 50 sync audit records,
/// cached map telemetry, and operational settings.
class OfflineMockDatasource {
  static const List<String> tamilNaduDistricts = [
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

  late final List<MeshDeviceModel> _devices;
  late final List<OfflineMessageModel> _messages;
  late final List<SyncRecordModel> _syncRecords;
  OfflineSettings _settings = const OfflineSettings();

  OfflineMockDatasource() {
    _devices = _generateDevices();
    _messages = _generateMessages();
    _syncRecords = _generateSyncRecords();
  }

  List<MeshDeviceModel> get devices => _devices;
  List<OfflineMessageModel> get messages => _messages;
  List<SyncRecordModel> get syncRecords => _syncRecords;
  OfflineSettings get settings => _settings;

  OfflineSystemStatus getSystemStatus() {
    final queued = _messages.where((m) => m.status == MessageQueueStatus.queued).length;
    final delivered = _messages.where((m) => m.status == MessageQueueStatus.delivered).length;
    final pendingSync = _messages.where((m) => m.status != MessageQueueStatus.synchronized).length;
    final connected = _devices.where((d) => d.isConnected).length;

    return OfflineSystemStatus(
      networkMode: NetworkMode.meshOnly,
      bleState: BleConnectionState.connected,
      isGpsFixed: true,
      gpsAccuracyMeters: 3.8,
      activeMeshNodesCount: _devices.length,
      connectedPeersCount: connected,
      queuedMessagesCount: queued,
      deliveredMessagesCount: delivered,
      pendingSyncCount: pendingSync,
      batteryPercent: 84,
      signalDbm: -65,
      isLowPowerMode: _settings.lowPowerOptimization,
    );
  }

  void updateSettings(OfflineSettings newSettings) {
    _settings = newSettings;
  }

  // ===========================================================================
  // PRIVATE GENERATORS (15 DEVICES, 100 MESSAGES, 50 SYNC RECORDS)
  // ===========================================================================

  List<MeshDeviceModel> _generateDevices() {
    final now = DateTime.now();
    return [
      MeshDeviceModel(
        id: 'DEV-RESQ-001',
        name: 'Commander Alpha Node (TN-SDRF)',
        type: DeviceType.rescueNode,
        rssiDbm: -52,
        lastSeen: now.subtract(const Duration(seconds: 4)),
        isConnected: true,
        hopsCount: 1,
        batteryPercent: 92,
        latitude: 13.0827,
        longitude: 80.2707,
        district: 'Chennai',
      ),
      MeshDeviceModel(
        id: 'DEV-RESQ-002',
        name: 'Tactical Repeater Mast Beta',
        type: DeviceType.meshRepeater,
        rssiDbm: -64,
        lastSeen: now.subtract(const Duration(seconds: 12)),
        isConnected: true,
        hopsCount: 1,
        batteryPercent: 88,
        latitude: 13.0850,
        longitude: 80.2680,
        district: 'Chennai',
      ),
      MeshDeviceModel(
        id: 'DEV-CIV-003',
        name: 'Civilian SOS Beacon #104 (Stranded)',
        type: DeviceType.civilianDevice,
        rssiDbm: -78,
        lastSeen: now.subtract(const Duration(seconds: 35)),
        isConnected: false,
        hopsCount: 2,
        batteryPercent: 45,
        latitude: 13.0790,
        longitude: 80.2750,
        district: 'Chennai',
      ),
      MeshDeviceModel(
        id: 'DEV-CIV-004',
        name: 'Civilian Medical Request #212',
        type: DeviceType.civilianDevice,
        rssiDbm: -82,
        lastSeen: now.subtract(const Duration(minutes: 1)),
        isConnected: false,
        hopsCount: 2,
        batteryPercent: 30,
        latitude: 13.0810,
        longitude: 80.2720,
        district: 'Chennai',
      ),
      MeshDeviceModel(
        id: 'DEV-BASE-005',
        name: 'Central EOC Base Gateway',
        type: DeviceType.baseGateway,
        rssiDbm: -58,
        lastSeen: now.subtract(const Duration(seconds: 8)),
        isConnected: true,
        hopsCount: 1,
        batteryPercent: 100,
        latitude: 13.0800,
        longitude: 80.2700,
        district: 'Chennai',
      ),
      MeshDeviceModel(
        id: 'DEV-RESQ-006',
        name: 'NDRF Swiftwater Boat Unit 04',
        type: DeviceType.rescueNode,
        rssiDbm: -70,
        lastSeen: now.subtract(const Duration(seconds: 18)),
        isConnected: true,
        hopsCount: 1,
        batteryPercent: 78,
        latitude: 11.7480,
        longitude: 79.7714,
        district: 'Cuddalore',
      ),
      MeshDeviceModel(
        id: 'DEV-REP-007',
        name: 'Harbor Coastal Mesh Relay C-1',
        type: DeviceType.meshRepeater,
        rssiDbm: -74,
        lastSeen: now.subtract(const Duration(seconds: 40)),
        isConnected: false,
        hopsCount: 2,
        batteryPercent: 65,
        latitude: 11.7510,
        longitude: 79.7680,
        district: 'Cuddalore',
      ),
      MeshDeviceModel(
        id: 'DEV-CIV-008',
        name: 'Fisherman Boat VHF-BLE Bridge',
        type: DeviceType.civilianDevice,
        rssiDbm: -86,
        lastSeen: now.subtract(const Duration(minutes: 2)),
        isConnected: false,
        hopsCount: 3,
        batteryPercent: 50,
        latitude: 10.7654,
        longitude: 79.8424,
        district: 'Nagapattinam',
      ),
      MeshDeviceModel(
        id: 'DEV-RESQ-009',
        name: 'Tirunelveli Fire & Rescue Delta',
        type: DeviceType.rescueNode,
        rssiDbm: -68,
        lastSeen: now.subtract(const Duration(seconds: 22)),
        isConnected: false,
        hopsCount: 1,
        batteryPercent: 85,
        latitude: 8.7139,
        longitude: 77.7567,
        district: 'Tirunelveli',
      ),
      MeshDeviceModel(
        id: 'DEV-CIV-010',
        name: 'Elderly Home Emergency Beacon',
        type: DeviceType.civilianDevice,
        rssiDbm: -89,
        lastSeen: now.subtract(const Duration(minutes: 3)),
        isConnected: false,
        hopsCount: 3,
        batteryPercent: 20,
        latitude: 8.7180,
        longitude: 77.7520,
        district: 'Tirunelveli',
      ),
      MeshDeviceModel(
        id: 'DEV-REP-011',
        name: 'Madurai Hilltop Solar Relay Node',
        type: DeviceType.meshRepeater,
        rssiDbm: -62,
        lastSeen: now.subtract(const Duration(seconds: 15)),
        isConnected: false,
        hopsCount: 1,
        batteryPercent: 95,
        latitude: 9.9252,
        longitude: 78.1198,
        district: 'Madurai',
      ),
      MeshDeviceModel(
        id: 'DEV-RESQ-012',
        name: 'Mountain Squad High-Altitude Node',
        type: DeviceType.rescueNode,
        rssiDbm: -72,
        lastSeen: now.subtract(const Duration(seconds: 28)),
        isConnected: false,
        hopsCount: 2,
        batteryPercent: 74,
        latitude: 11.0168,
        longitude: 76.9558,
        district: 'Coimbatore',
      ),
      MeshDeviceModel(
        id: 'DEV-BASE-013',
        name: 'Salem Regional Command Hub',
        type: DeviceType.baseGateway,
        rssiDbm: -55,
        lastSeen: now.subtract(const Duration(seconds: 6)),
        isConnected: false,
        hopsCount: 1,
        batteryPercent: 100,
        latitude: 11.6643,
        longitude: 78.1460,
        district: 'Salem',
      ),
      MeshDeviceModel(
        id: 'DEV-CIV-014',
        name: 'Trichy Island Resident Distress Beacon',
        type: DeviceType.civilianDevice,
        rssiDbm: -92,
        lastSeen: now.subtract(const Duration(minutes: 5)),
        isConnected: false,
        hopsCount: 3,
        batteryPercent: 35,
        latitude: 10.7905,
        longitude: 78.7047,
        district: 'Tiruchirappalli',
      ),
      MeshDeviceModel(
        id: 'DEV-RESQ-015',
        name: 'Kanyakumari Marine Lifeguard Node',
        type: DeviceType.rescueNode,
        rssiDbm: -66,
        lastSeen: now.subtract(const Duration(seconds: 14)),
        isConnected: false,
        hopsCount: 1,
        batteryPercent: 88,
        latitude: 8.0883,
        longitude: 77.5385,
        district: 'Kanyakumari',
      ),
    ]; // 15 Devices!
  }

  List<OfflineMessageModel> _generateMessages() {
    final now = DateTime.now();
    final messages = <OfflineMessageModel>[];

    final rawTemplates = [
      (
        OfflineMessageType.sosAlert,
        MessagePriority.critical,
        MessageQueueStatus.queued,
        'DEV-CIV-003',
        'Civilian SOS Beacon #104',
        'BROADCAST_ALL',
        'Water level rising above 2.5 meters. 4 persons stranded on rooftop terrace.',
        0,
        'Chennai',
      ),
      (
        OfflineMessageType.missionUpdate,
        MessagePriority.high,
        MessageQueueStatus.sending,
        'DEV-RESQ-001',
        'Commander Alpha Node',
        'DEV-BASE-005',
        'Waypoint Bravo-3 cleared. Extracted 12 victims to secondary dry platform.',
        1,
        'Chennai',
      ),
      (
        OfflineMessageType.resourceUpdate,
        MessagePriority.normal,
        MessageQueueStatus.delivered,
        'DEV-RESQ-001',
        'Commander Alpha Node',
        'DEV-BASE-005',
        'Inflatable boat 02 fuel level at 40%. Requesting 20L diesel fuel canister at next depot.',
        0,
        'Chennai',
      ),
      (
        OfflineMessageType.teamStatus,
        MessagePriority.normal,
        MessageQueueStatus.delivered,
        'DEV-RESQ-002',
        'Tactical Repeater Mast Beta',
        'DEV-BASE-005',
        'Officer vitals normal. Heart rate 78 bpm, battery 88%, mesh link relaying 14 packets/sec.',
        0,
        'Chennai',
      ),
      (
        OfflineMessageType.chatMessage,
        MessagePriority.high,
        MessageQueueStatus.queued,
        'DEV-RESQ-001',
        'Commander Alpha Node',
        'DEV-RESQ-006',
        'Proceed with boat convoy through Saidapet canal sector. Water velocity 4.2 km/h.',
        0,
        'Chennai',
      ),
      (
        OfflineMessageType.analyticsTelemetry,
        MessagePriority.low,
        MessageQueueStatus.synchronized,
        'DEV-BASE-005',
        'Central EOC Base Gateway',
        'CLOUD_SYNC',
        'Sensor telemetry: River gauge Adyar at 4.65m (+15cm/hr). Precipitation 65mm/hr.',
        0,
        'Chennai',
      ),
      (
        OfflineMessageType.sosAlert,
        MessagePriority.critical,
        MessageQueueStatus.failed,
        'DEV-CIV-004',
        'Civilian Medical Request #212',
        'BROADCAST_ALL',
        'Elderly diabetic patient in insulin shock. Urgent ambulance or paramedic needed.',
        5,
        'Chennai',
      ),
      (
        OfflineMessageType.missionUpdate,
        MessagePriority.high,
        MessageQueueStatus.delivered,
        'DEV-RESQ-006',
        'NDRF Swiftwater Boat Unit 04',
        'DEV-BASE-005',
        'Cuddalore harbor jetty breach contained with sandbags. 36 fishermen escorted.',
        0,
        'Cuddalore',
      ),
      (
        OfflineMessageType.resourceUpdate,
        MessagePriority.normal,
        MessageQueueStatus.queued,
        'DEV-RESQ-006',
        'NDRF Swiftwater Boat Unit 04',
        'DEV-BASE-005',
        '5,000 geotextile bags deployed. Requesting 2,000 additional units from Panruti depot.',
        0,
        'Cuddalore',
      ),
      (
        OfflineMessageType.chatMessage,
        MessagePriority.normal,
        MessageQueueStatus.delivered,
        'DEV-RESQ-006',
        'NDRF Swiftwater Boat Unit 04',
        'DEV-REP-007',
        'Harbor relay signal stable at -74 dBm. Mesh forwarding active.',
        0,
        'Cuddalore',
      ),
    ];

    // Multiply and generate 100 queued messages across 13 districts
    int idCounter = 1;
    for (int cycle = 0; cycle < 10; cycle++) {
      for (int i = 0; i < rawTemplates.length; i++) {
        final t = rawTemplates[i];
        final district = tamilNaduDistricts[(idCounter + cycle) % tamilNaduDistricts.length];
        final isDelivered = (idCounter % 3 == 0);
        final isQueued = (idCounter % 3 == 1);
        final isFailed = (idCounter % 15 == 0);
        final status = isFailed
            ? MessageQueueStatus.failed
            : (isDelivered
                ? MessageQueueStatus.delivered
                : (isQueued ? MessageQueueStatus.queued : MessageQueueStatus.sending));

        messages.add(
          OfflineMessageModel(
            id: 'MSG-${idCounter.toString().padLeft(4, '0')}',
            type: t.$1,
            priority: t.$2,
            status: status,
            senderId: t.$4,
            senderName: t.$5,
            recipientId: t.$6,
            payload: '${t.$7} [Packet #$idCounter in $district]',
            timestamp: now.subtract(Duration(minutes: idCounter * 8)),
            retryCount: isFailed ? 5 : (status == MessageQueueStatus.sending ? 1 : 0),
            maxRetries: 5,
            acknowledgedAt: isDelivered ? now.subtract(Duration(minutes: idCounter * 4)) : null,
            isRelayed: idCounter % 2 == 0,
            ttlSeconds: 86400,
            district: district,
          ),
        );
        idCounter++;
        if (messages.length >= 100) break;
      }
      if (messages.length >= 100) break;
    }

    return messages; // Exactly 100 Messages!
  }

  List<SyncRecordModel> _generateSyncRecords() {
    final now = DateTime.now();
    final records = <SyncRecordModel>[];

    for (int i = 1; i <= 50; i++) {
      final type = OfflineMessageType.values[i % OfflineMessageType.values.length];
      final isFailed = (i % 12 == 0);
      records.add(
        SyncRecordModel(
          id: 'SYNC-${(50 - i + 1).toString().padLeft(4, '0')}',
          syncType: type,
          itemCount: 4 + (i % 15),
          startedAt: now.subtract(Duration(hours: i * 2)),
          completedAt: isFailed ? null : now.subtract(Duration(hours: i * 2, minutes: -2)),
          status: isFailed ? SyncStatus.failed : SyncStatus.completed,
          failureReason: isFailed ? 'Connection timeout during upstream socket handshake' : null,
          resolutionApplied: ConflictResolutionStrategy.latestTimestampWins,
          deduplicatedCount: (i % 4),
        ),
      );
    }

    return records; // Exactly 50 Sync Records!
  }
}
