import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/rescue/offline/data/datasources/offline_mock_datasource.dart';
import '../../../../lib/features/rescue/offline/data/models/offline_models.dart';
import '../../../../lib/features/rescue/offline/data/repositories/offline_repository_impl.dart';
import '../../../../lib/features/rescue/offline/domain/entities/offline_entities.dart';
import '../../../../lib/features/rescue/offline/domain/repositories/offline_repository.dart';
import '../../../../lib/features/rescue/offline/domain/usecases/offline_usecases.dart';
import '../../../../lib/features/rescue/offline/presentation/providers/offline_provider.dart';
import '../../../../lib/features/rescue/offline/presentation/providers/offline_state.dart';
import '../../../../lib/features/rescue/offline/presentation/screens/offline_dashboard_screen.dart';
import '../../../../lib/features/rescue/offline/presentation/widgets/mesh_device_card.dart';
import '../../../../lib/features/rescue/offline/presentation/widgets/message_queue_tile.dart';
import '../../../../lib/features/rescue/offline/presentation/widgets/offline_map_cache_card.dart';
import '../../../../lib/features/rescue/offline/presentation/widgets/offline_status_badge.dart';
import '../../../../lib/features/rescue/offline/presentation/widgets/sync_record_tile.dart';
import '../../../../lib/features/rescue/offline/services/ble_communication_service.dart';
import '../../../../lib/features/rescue/offline/services/connectivity_monitor_service.dart';
import '../../../../lib/features/rescue/offline/services/future_protocols_service.dart';
import '../../../../lib/features/rescue/offline/services/offline_cache_service.dart';
import '../../../../lib/features/rescue/offline/services/offline_notification_service.dart';
import '../../../../lib/features/rescue/offline/services/offline_sync_service.dart';
import '../../../../lib/features/rescue/offline/services/store_and_forward_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Offline Domain & Enums Tests', () {
    test('NetworkMode mappings and states', () {
      expect(NetworkMode.onlineWiFi.displayName, 'Online (Wi-Fi)');
      expect(NetworkMode.onlineWiFi.isOnline, isTrue);
      expect(NetworkMode.meshOnly.displayName, 'Mesh BLE Network Active');
      expect(NetworkMode.meshOnly.isOnline, isFalse);
      expect(NetworkMode.offlineAirgap.displayName, 'Air-Gapped Offline');
    });

    test('BleConnectionState colors and names', () {
      expect(BleConnectionState.connected.displayName, 'Mesh Linked');
      expect(BleConnectionState.connected.color, const Color(0xFF10B981));
      expect(BleConnectionState.scanning.displayName, 'Scanning Peers...');
    });

    test('DeviceType icons and colors', () {
      expect(DeviceType.rescueNode.displayName, 'Rescue Officer Node');
      expect(DeviceType.civilianDevice.displayName, 'Civilian SOS Beacon');
      expect(DeviceType.meshRepeater.displayName, 'Mesh Tactical Repeater');
      expect(DeviceType.baseGateway.displayName, 'Command Base Gateway');
    });

    test('MessageQueueStatus icons and colors', () {
      expect(MessageQueueStatus.queued.displayName, 'Queued Local');
      expect(MessageQueueStatus.delivered.displayName, 'Delivered Peer');
      expect(MessageQueueStatus.failed.displayName, 'Retry Exhausted');
      expect(MessageQueueStatus.synchronized.displayName, 'Synced Cloud');
    });

    test('MessagePriority colors', () {
      expect(MessagePriority.critical.color, const Color(0xFFEF4444));
      expect(MessagePriority.high.color, const Color(0xFFF97316));
      expect(MessagePriority.normal.color, const Color(0xFF3B82F6));
    });

    test('ProtocolType names and icons', () {
      expect(ProtocolType.bleMesh.displayName, 'BLE Mesh Network');
      expect(ProtocolType.loraRadio.displayName, 'LoRa Long-Range Radio');
      expect(ProtocolType.satellite.displayName, 'Satellite Iridium Relay');
      expect(ProtocolType.wifiDirect.displayName, 'Wi-Fi Direct P2P');
      expect(ProtocolType.nfc.displayName, 'NFC Tap Sync');
    });
  });

  group('Data Models & JSON Serialization Tests', () {
    test('MeshDeviceModel serializes and deserializes properly', () {
      final now = DateTime.now();
      final model = MeshDeviceModel(
        id: 'DEV-TEST-01',
        name: 'Test Officer Node',
        type: DeviceType.rescueNode,
        rssiDbm: -65,
        lastSeen: now,
        isConnected: true,
        hopsCount: 1,
        batteryPercent: 88,
        latitude: 13.0827,
        longitude: 80.2707,
        district: 'Chennai',
      );

      final json = model.toJson();
      final parsed = MeshDeviceModel.fromJson(json);

      expect(parsed.id, 'DEV-TEST-01');
      expect(parsed.name, 'Test Officer Node');
      expect(parsed.type, DeviceType.rescueNode);
      expect(parsed.rssiDbm, -65);
      expect(parsed.signalStrengthPercent, greaterThan(50));
      expect(parsed.isConnected, isTrue);
    });

    test('OfflineMessageModel serializes and deserializes properly', () {
      final now = DateTime.now();
      final model = OfflineMessageModel(
        id: 'MSG-TEST-01',
        type: OfflineMessageType.sosAlert,
        priority: MessagePriority.critical,
        status: MessageQueueStatus.queued,
        senderId: 'DEV-CIV-01',
        senderName: 'Civilian Beacon',
        recipientId: 'BROADCAST_ALL',
        payload: 'Flood water reached 2m depth',
        timestamp: now,
        retryCount: 0,
        maxRetries: 5,
        isRelayed: false,
        ttlSeconds: 86400,
        district: 'Chennai',
      );

      final json = model.toJson();
      final parsed = OfflineMessageModel.fromJson(json);

      expect(parsed.id, 'MSG-TEST-01');
      expect(parsed.priority, MessagePriority.critical);
      expect(parsed.status, MessageQueueStatus.queued);
      expect(parsed.payload, 'Flood water reached 2m depth');
    });

    test('SyncRecordModel serializes and deserializes properly', () {
      final now = DateTime.now();
      final model = SyncRecordModel(
        id: 'SYNC-01',
        syncType: OfflineMessageType.missionUpdate,
        itemCount: 12,
        startedAt: now,
        completedAt: now.add(const Duration(seconds: 2)),
        status: SyncStatus.completed,
        resolutionApplied: ConflictResolutionStrategy.latestTimestampWins,
        deduplicatedCount: 2,
      );

      final json = model.toJson();
      final parsed = SyncRecordModel.fromJson(json);

      expect(parsed.id, 'SYNC-01');
      expect(parsed.itemCount, 12);
      expect(parsed.status, SyncStatus.completed);
      expect(parsed.deduplicatedCount, 2);
    });
  });

  group('OfflineMockDatasource Completeness Tests', () {
    final ds = OfflineMockDatasource();

    test('Generates 15 nearby mesh devices', () {
      expect(ds.devices.length, 15);
      expect(ds.devices.any((d) => d.type == DeviceType.rescueNode), isTrue);
      expect(ds.devices.any((d) => d.type == DeviceType.civilianDevice), isTrue);
      expect(ds.devices.any((d) => d.type == DeviceType.meshRepeater), isTrue);
      expect(ds.devices.any((d) => d.type == DeviceType.baseGateway), isTrue);
    });

    test('Generates 100 queued store-and-forward messages', () {
      expect(ds.messages.length, 100);
      expect(ds.messages.any((m) => m.priority == MessagePriority.critical), isTrue);
      expect(ds.messages.any((m) => m.status == MessageQueueStatus.queued), isTrue);
      expect(ds.messages.any((m) => m.status == MessageQueueStatus.delivered), isTrue);
    });

    test('Generates 50 sync audit records', () {
      expect(ds.syncRecords.length, 50);
      expect(ds.syncRecords.any((s) => s.status == SyncStatus.completed), isTrue);
    });

    test('Computes realistic OfflineSystemStatus', () {
      final status = ds.getSystemStatus();
      expect(status.activeMeshNodesCount, 15);
      expect(status.queuedMessagesCount, greaterThan(0));
      expect(status.batteryPercent, greaterThan(50));
    });
  });

  group('Offline Services Unit Tests', () {
    test('ConnectivityMonitorService transitions modes and emits stream', () async {
      final service = ConnectivityMonitorService();
      expect(service.isMeshOnly, isTrue);

      service.simulateInternetRestored();
      expect(service.isOnline, isTrue);

      service.simulateInternetLoss();
      expect(service.isMeshOnly, isTrue);

      service.simulateTotalAirgap();
      expect(service.isAirgapped, isTrue);
      service.dispose();
    });

    test('BleCommunicationService connects and disconnects peers', () async {
      final service = BleCommunicationService();
      await service.connectToPeer('DEV-01');
      expect(service.connectedDeviceIds.contains('DEV-01'), isTrue);

      await service.disconnectFromPeer('DEV-01');
      expect(service.connectedDeviceIds.contains('DEV-01'), isFalse);
      service.dispose();
    });

    test('StoreAndForwardService enqueues and retries messages', () async {
      final service = StoreAndForwardService();
      final msg = OfflineMessage(
        id: 'MSG-TEMP-01',
        type: OfflineMessageType.chatMessage,
        priority: MessagePriority.normal,
        status: MessageQueueStatus.queued,
        senderId: 'DEV-01',
        senderName: 'Officer',
        recipientId: 'BROADCAST_ALL',
        payload: 'Radio check',
        timestamp: DateTime.now(),
        retryCount: 0,
        maxRetries: 3,
        isRelayed: false,
        ttlSeconds: 3600,
        district: 'Chennai',
      );

      await service.enqueueMessage(msg);
      expect(service.queue.length, 1);

      await service.retryMessage('MSG-TEMP-01');
      expect(service.queue.first.retryCount, 1);

      await service.markDelivered('MSG-TEMP-01');
      expect(service.queue.first.status, MessageQueueStatus.delivered);
      service.dispose();
    });

    test('OfflineSyncService performs batch upload with deduplication', () async {
      final service = OfflineSyncService();
      final msg1 = OfflineMessage(
        id: 'M1',
        type: OfflineMessageType.missionUpdate,
        priority: MessagePriority.normal,
        status: MessageQueueStatus.queued,
        senderId: 'D1',
        senderName: 'Officer',
        recipientId: 'CLOUD',
        payload: 'Update',
        timestamp: DateTime.now(),
        retryCount: 0,
        maxRetries: 3,
        isRelayed: false,
        ttlSeconds: 3600,
        district: 'Chennai',
      );

      final record = await service.syncAllCategories(
        pendingMessages: [msg1, msg1], // duplicate message
      );

      expect(record.status, SyncStatus.completed);
      expect(record.deduplicatedCount, 1);
      service.dispose();
    });

    test('OfflineCacheService returns cached map data for districts', () {
      final cache = OfflineCacheService();
      final chennai = cache.getCachedData(district: 'Chennai');
      expect(chennai.length, 1);
      expect(chennai.first.cachedRiskZonesCount, greaterThan(0));
      expect(cache.totalCacheSizeMb, greaterThan(5.0));
    });

    test('Future protocols interfaces initialize without errors', () async {
      final lora = MockLoRaRadioProtocol();
      final initialized = await lora.initializeRadio();
      expect(initialized, isTrue);

      final sat = MockSatelliteCommProtocol();
      final satConnected = await sat.connectToConstellation();
      expect(satConnected, isTrue);
    });
  });

  group('OfflineNotifier State Management Tests', () {
    late OfflineNotifier notifier;

    setUp(() {
      final ds = OfflineMockDatasource();
      final ble = BleCommunicationService();
      final conn = ConnectivityMonitorService();
      final queue = StoreAndForwardService(initialMessages: ds.messages);
      final sync = OfflineSyncService(initialHistory: ds.syncRecords);
      final cache = OfflineCacheService();

      final repo = OfflineRepositoryImpl(
        datasource: ds,
        bleService: ble,
        queueService: queue,
        syncService: sync,
        cacheService: cache,
      );

      notifier = OfflineNotifier(
        getStatusUseCase: GetOfflineSystemStatusUseCase(repo),
        getMeshDevicesUseCase: GetMeshDevicesUseCase(repo),
        manageBleConnectionUseCase: ManageBleConnectionUseCase(repo),
        getQueuedMessagesUseCase: GetQueuedMessagesUseCase(repo),
        enqueueMessageUseCase: EnqueueOfflineMessageUseCase(repo),
        retryMessageUseCase: RetryOfflineMessageUseCase(repo),
        performSyncUseCase: PerformOfflineSyncUseCase(repo),
        getCachedMapUseCase: GetOfflineCachedMapUseCase(repo),
        manageSettingsUseCase: ManageOfflineSettingsUseCase(repo),
        bleService: ble,
        connectivityService: conn,
      );
    });

    test('loadDashboard populates devices, queue, and sync records', () async {
      await notifier.loadDashboard();
      expect(notifier.state.status, OfflineViewStatus.loaded);
      expect(notifier.state.allDevices.length, 15);
      expect(notifier.state.allMessages.length, 100);
      expect(notifier.state.allSyncRecords.length, 50);
      expect(notifier.state.cachedMapList.length, 13);
    });

    test('searchMesh filters discovered nodes', () async {
      await notifier.loadDashboard();
      notifier.searchMesh('Repeater');
      expect(notifier.state.filteredDevices.every((d) => d.name.contains('Repeater') || d.id.contains('Repeater')), isTrue);
    });

    test('broadcastDistressBeacon inserts critical packet into queue', () async {
      await notifier.loadDashboard();
      final initialCount = notifier.state.allMessages.length;

      await notifier.broadcastDistressBeacon('Emergency boat required at jetty');
      expect(notifier.state.allMessages.length, initialCount + 1);
      expect(notifier.state.allMessages.first.priority, MessagePriority.critical);
    });

    test('triggerFullSync synchronizes pending messages', () async {
      await notifier.loadDashboard();
      final record = await notifier.triggerFullSync();
      expect(record, isNotNull);
      expect(record!.status, SyncStatus.completed);
    });
  });

  group('Widget and Screen Rendering Tests', () {
    testWidgets('OfflineStatusBadge renders connectivity telemetry', (tester) async {
      const status = OfflineSystemStatus(
        networkMode: NetworkMode.meshOnly,
        bleState: BleConnectionState.connected,
        isGpsFixed: true,
        gpsAccuracyMeters: 4.2,
        activeMeshNodesCount: 15,
        connectedPeersCount: 4,
        queuedMessagesCount: 12,
        deliveredMessagesCount: 88,
        pendingSyncCount: 24,
        batteryPercent: 82,
        signalDbm: -68,
        isLowPowerMode: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OfflineStatusBadge(status: status),
          ),
        ),
      );

      expect(find.text('Mesh BLE Network Active'), findsOneWidget);
      expect(find.text('82%'), findsOneWidget);
      expect(find.text('15 Mesh Nodes'), findsOneWidget);
      expect(find.text('12 Queued'), findsOneWidget);
    });

    testWidgets('MeshDeviceCard renders device details and battery', (tester) async {
      final device = MeshDevice(
        id: 'DEV-01',
        name: 'Rescue Alpha Squad Node',
        type: DeviceType.rescueNode,
        rssiDbm: -55,
        lastSeen: DateTime.now(),
        isConnected: true,
        hopsCount: 1,
        batteryPercent: 94,
        latitude: 13.0827,
        longitude: 80.2707,
        district: 'Chennai',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeshDeviceCard(device: device),
          ),
        ),
      );

      expect(find.text('Rescue Alpha Squad Node'), findsOneWidget);
      expect(find.text('LINKED'), findsOneWidget);
      expect(find.text('94%'), findsOneWidget);
    });

    testWidgets('MessageQueueTile renders message payload and priority', (tester) async {
      final msg = OfflineMessage(
        id: 'MSG-01',
        type: OfflineMessageType.sosAlert,
        priority: MessagePriority.critical,
        status: MessageQueueStatus.queued,
        senderId: 'DEV-01',
        senderName: 'Civilian Beacon',
        recipientId: 'BROADCAST_ALL',
        payload: 'Water entered 1st floor residence',
        timestamp: DateTime.now(),
        retryCount: 0,
        maxRetries: 5,
        isRelayed: false,
        ttlSeconds: 86400,
        district: 'Chennai',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageQueueTile(message: msg),
          ),
        ),
      );

      expect(find.text('SOS Distress Beacon'), findsOneWidget);
      expect(find.text('CRITICAL'), findsOneWidget);
      expect(find.text('Water entered 1st floor residence'), findsOneWidget);
    });

    testWidgets('SyncRecordTile renders synchronization status', (tester) async {
      final record = SyncRecord(
        id: 'SYNC-101',
        syncType: OfflineMessageType.missionUpdate,
        itemCount: 14,
        startedAt: DateTime.now(),
        completedAt: DateTime.now(),
        status: SyncStatus.completed,
        resolutionApplied: ConflictResolutionStrategy.latestTimestampWins,
        deduplicatedCount: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SyncRecordTile(record: record),
          ),
        ),
      );

      expect(find.text('SYNC-101'), findsOneWidget);
      expect(find.text('SYNCHRONIZED'), findsOneWidget);
      expect(find.text('14 items (Mission Waypoint Update)'), findsOneWidget);
    });

    testWidgets('OfflineDashboardScreen renders dashboard overview', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OfflineDashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Offline Command Center'), findsOneWidget);
      expect(find.text('Offline Communication Hub'), findsOneWidget);
      expect(find.text('Mesh Network'), findsOneWidget);
      expect(find.text('Connected Peers'), findsOneWidget);
      expect(find.text('Message Queue'), findsOneWidget);
      expect(find.text('Sync Center'), findsOneWidget);
      expect(find.text('Broadcast Beacon'), findsOneWidget);
    });
  });
}
