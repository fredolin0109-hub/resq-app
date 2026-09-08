import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/rescue/resources/data/datasources/resource_mock_datasource.dart';
import '../../../../lib/features/rescue/resources/data/models/resource_models.dart';
import '../../../../lib/features/rescue/resources/data/repositories/resource_repository_impl.dart';
import '../../../../lib/features/rescue/resources/domain/entities/resource_entities.dart';
import '../../../../lib/features/rescue/resources/domain/usecases/resource_usecases.dart';
import '../../../../lib/features/rescue/resources/presentation/providers/resource_provider.dart';
import '../../../../lib/features/rescue/resources/presentation/providers/resource_state.dart';
import '../../../../lib/features/rescue/resources/presentation/screens/equipment_inventory_screen.dart';
import '../../../../lib/features/rescue/resources/presentation/screens/hospital_management_screen.dart';
import '../../../../lib/features/rescue/resources/presentation/screens/resource_allocation_screen.dart';
import '../../../../lib/features/rescue/resources/presentation/screens/resource_dashboard_screen.dart';
import '../../../../lib/features/rescue/resources/presentation/screens/resource_details_screen.dart';
import '../../../../lib/features/rescue/resources/presentation/screens/shelter_management_screen.dart';
import '../../../../lib/features/rescue/resources/presentation/screens/warehouse_inventory_screen.dart';
import '../../../../lib/features/rescue/resources/presentation/widgets/allocation_card.dart';
import '../../../../lib/features/rescue/resources/presentation/widgets/hospital_card.dart';
import '../../../../lib/features/rescue/resources/presentation/widgets/resource_item_card.dart';
import '../../../../lib/features/rescue/resources/presentation/widgets/resource_status_badge.dart';
import '../../../../lib/features/rescue/resources/presentation/widgets/resource_summary_card.dart';
import '../../../../lib/features/rescue/resources/presentation/widgets/shelter_card.dart';
import '../../../../lib/features/rescue/resources/presentation/widgets/warehouse_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Resource & Shelter Domain & Model Tests', () {
    test('ResourceStatus enum returns appropriate color codes and labels', () {
      expect(ResourceStatus.available.displayName, 'Available');
      expect(ResourceStatus.available.color, const Color(0xFF10B981));

      expect(ResourceStatus.limited.displayName, 'Limited');
      expect(ResourceStatus.limited.color, const Color(0xFFF59E0B));

      expect(ResourceStatus.critical.displayName, 'Critical');
      expect(ResourceStatus.critical.color, const Color(0xFFF97316));

      expect(ResourceStatus.outOfStock.displayName, 'Out of Stock');
      expect(ResourceStatus.outOfStock.color, const Color(0xFFEF4444));
    });

    test('ResourceCategory enums map to icons and display names correctly', () {
      expect(ResourceCategory.foodPacks.displayName, 'Food Packs');
      expect(ResourceCategory.waterBottles.displayName, 'Water Bottles');
      expect(ResourceCategory.boats.displayName, 'Boats');
      expect(ResourceCategory.drones.displayName, 'Drones');
      expect(ResourceCategory.generators.displayName, 'Generators');
    });

    test('ResourceItemModel serializes and deserializes accurately', () {
      final now = DateTime.now();
      final model = ResourceItemModel(
        id: 'TEST-01',
        name: 'Test Emergency Food',
        category: ResourceCategory.foodPacks,
        warehouseId: 'WH-01',
        warehouseName: 'Chennai Depot',
        district: 'Chennai',
        currentQuantity: 500,
        minimumThreshold: 200,
        unit: 'packs',
        status: ResourceStatus.available,
        lastUpdated: now,
        autoWarning: false,
        description: 'Test description',
      );

      final json = model.toJson();
      final reconstituted = ResourceItemModel.fromJson(json);

      expect(reconstituted.id, 'TEST-01');
      expect(reconstituted.name, 'Test Emergency Food');
      expect(reconstituted.category, ResourceCategory.foodPacks);
      expect(reconstituted.currentQuantity, 500);
      expect(reconstituted.status, ResourceStatus.available);
    });

    test('ShelterModel serializes and deserializes accurately', () {
      final now = DateTime.now();
      final model = ShelterModel(
        id: 'SH-TEST',
        name: 'Test Shelter',
        district: 'Cuddalore',
        address: 'Main Beach Road',
        capacity: 1000,
        currentOccupancy: 800,
        availableBeds: 200,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.medium,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: now,
        latitude: 11.75,
        longitude: 79.77,
        contactPerson: 'Officer Test',
        contactPhone: '+91 99999 88888',
      );

      final json = model.toJson();
      final reconstituted = ShelterModel.fromJson(json);

      expect(reconstituted.id, 'SH-TEST');
      expect(reconstituted.capacity, 1000);
      expect(reconstituted.currentOccupancy, 800);
      expect(reconstituted.occupancyRate, 0.8);
      expect(reconstituted.status, ShelterStatus.operational);
    });
  });

  group('Mock Datasource Full Inventory & Facility Counts', () {
    final ds = ResourceMockDatasource();

    test('Contains exactly 25 realistic disaster relief shelters', () {
      expect(ds.shelters.length, 25);
      final hasChennai = ds.shelters.any((s) => s.district == 'Chennai');
      final hasCuddalore = ds.shelters.any((s) => s.district == 'Cuddalore');
      expect(hasChennai, isTrue);
      expect(hasCuddalore, isTrue);
    });

    test('Contains exactly 20 realistic medical hospitals with emergency telemetry', () {
      expect(ds.hospitals.length, 20);
      final traumaCenters = ds.hospitals.where((h) => h.traumaCenter).toList();
      expect(traumaCenters.isNotEmpty, isTrue);
    });

    test('Contains exactly 100 resource items across all 12 disaster categories', () {
      expect(ds.resourceItems.length, 100);
      final foodCount = ds.resourceItems.where((r) => r.category == ResourceCategory.foodPacks).length;
      final waterCount = ds.resourceItems.where((r) => r.category == ResourceCategory.waterBottles).length;
      final boatCount = ds.resourceItems.where((r) => r.category == ResourceCategory.boats).length;
      final droneCount = ds.resourceItems.where((r) => r.category == ResourceCategory.drones).length;

      expect(foodCount, greaterThanOrEqualTo(5));
      expect(waterCount, greaterThanOrEqualTo(5));
      expect(boatCount, greaterThanOrEqualTo(5));
      expect(droneCount, greaterThanOrEqualTo(5));
    });

    test('Contains exactly 15 logistics warehouses across Tamil Nadu hubs', () {
      expect(ds.warehouses.length, 15);
    });

    test('Calculates summary metrics accurately', () {
      final sum = ds.getSummary();
      expect(sum.totalResources, 100);
      expect(sum.totalShelters, 25);
      expect(sum.totalHospitals, 20);
      expect(sum.foodStockPacks, greaterThan(0));
      expect(sum.waterStockBottles, greaterThan(0));
      expect(sum.availableHospitalBeds, greaterThan(0));
    });
  });

  group('Repository and Use Cases Tests', () {
    late ResourceRepository repository;

    setUp(() {
      repository = ResourceRepositoryImpl(ResourceMockDatasource());
    });

    test('GetSheltersUseCase filters by district and search query', () async {
      final usecase = GetSheltersUseCase(repository);
      final chennaiShelters = await usecase(district: 'Chennai');
      expect(chennaiShelters.every((s) => s.district == 'Chennai'), isTrue);

      final searchResults = await usecase(searchQuery: 'Cyclone');
      expect(searchResults.isNotEmpty, isTrue);
    });

    test('GetHospitalsUseCase filters by status and trauma capacity', () async {
      final usecase = GetHospitalsUseCase(repository);
      final hospitals = await usecase(district: 'Madurai');
      expect(hospitals.every((h) => h.district == 'Madurai'), isTrue);
    });

    test('GetResourceInventoryUseCase filters by category', () async {
      final usecase = GetResourceInventoryUseCase(repository);
      final drones = await usecase(category: ResourceCategory.drones);
      expect(drones.every((d) => d.category == ResourceCategory.drones), isTrue);
    });

    test('UpdateResourceStockUseCase updates quantity and records usage log', () async {
      final usecase = UpdateResourceStockUseCase(repository);
      final updated = await usecase(
        resourceId: 'RES-FP-01',
        quantityChange: 150,
        reason: 'Restock batch',
        performedBy: 'Test Officer',
        destinationName: 'Central Depot',
      );

      expect(updated.id, 'RES-FP-01');
      expect(updated.usageHistory.first.reason, 'Restock batch');
    });

    test('CreateAllocationUseCase adds new dispatch order and deducts inventory', () async {
      final usecase = CreateAllocationUseCase(repository);
      final newAlloc = ResourceAllocation(
        id: 'ALC-TEST-99',
        items: const [
          AllocatedItem(
            resourceItemId: 'RES-WB-01',
            resourceName: 'Packaged Drinking Water Bottles',
            category: ResourceCategory.waterBottles,
            quantity: 200,
            unit: 'bottles',
          ),
        ],
        destinationType: DestinationType.shelter,
        destinationId: 'SH-01',
        destinationName: 'Chennai Central Cyclone Relief Center',
        destinationDistrict: 'Chennai',
        priority: AllocationPriority.high,
        vehicleId: 'TN-01-V-1',
        vehicleName: 'Truck 1',
        assignedTeamId: 'T-1',
        assignedTeamName: 'Squad 1',
        estimatedArrival: '15 mins',
        deliveryStatus: DeliveryStatus.dispatched,
        createdAt: DateTime.now(),
      );

      final created = await usecase(newAlloc);
      expect(created.id, 'ALC-TEST-99');
      expect(created.totalQuantity, 200);
    });
  });

  group('ResourceNotifier Presentation Tests', () {
    late ResourceNotifier notifier;

    setUp(() {
      final ds = ResourceMockDatasource();
      final repo = ResourceRepositoryImpl(ds);
      notifier = ResourceNotifier(
        getSummaryUseCase: GetResourceSummaryUseCase(repo),
        getSheltersUseCase: GetSheltersUseCase(repo),
        getHospitalsUseCase: GetHospitalsUseCase(repo),
        getInventoryUseCase: GetResourceInventoryUseCase(repo),
        getWarehousesUseCase: GetWarehousesUseCase(repo),
        getAllocationsUseCase: GetAllocationsUseCase(repo),
        createAllocationUseCase: CreateAllocationUseCase(repo),
        updateStockUseCase: UpdateResourceStockUseCase(repo),
      );
    });

    test('loadDashboard populates all models into state', () async {
      await notifier.loadDashboard();
      expect(notifier.state.status, ResourceViewStatus.loaded);
      expect(notifier.state.allShelters.length, 25);
      expect(notifier.state.allHospitals.length, 20);
      expect(notifier.state.allInventory.length, 100);
      expect(notifier.state.allWarehouses.length, 15);
    });

    test('searchShelters filters the shelter list accordingly', () async {
      await notifier.loadDashboard();
      notifier.searchShelters('Velachery');
      expect(notifier.state.filteredShelters.length, 1);
      expect(notifier.state.filteredShelters.first.name.contains('Velachery'), isTrue);
    });

    test('updateInventoryFilters filters inventory by category', () async {
      await notifier.loadDashboard();
      notifier.updateInventoryFilters(
        const InventoryFilterOptions(category: ResourceCategory.lifeJackets),
      );
      expect(notifier.state.filteredInventory.every((r) => r.category == ResourceCategory.lifeJackets), isTrue);
    });
  });

  group('Widget and Screen Rendering Tests', () {
    testWidgets('ResourceStatusBadge renders label and color dot', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResourceStatusBadge(status: ResourceStatus.available),
          ),
        ),
      );

      expect(find.text('AVAILABLE'), findsOneWidget);
    });

    testWidgets('ResourceSummaryCard renders title, value and icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResourceSummaryCard(
              title: 'Total Stock',
              value: '100 Items',
              subtitle: 'Active Hubs',
              icon: Icons.inventory_2_rounded,
              color: Colors.blue,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Total Stock'), findsOneWidget);
      expect(find.text('100 Items'), findsOneWidget);
      expect(find.text('Active Hubs'), findsOneWidget);
    });

    testWidgets('ShelterCard renders shelter details and occupancy', (tester) async {
      final shelter = Shelter(
        id: 'SH-01',
        name: 'Chennai Central Relief',
        district: 'Chennai',
        address: 'Stadium Road',
        capacity: 1000,
        currentOccupancy: 600,
        availableBeds: 400,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now(),
        latitude: 13.08,
        longitude: 80.27,
        contactPerson: 'Officer K',
        contactPhone: '+91 90000 11111',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShelterCard(shelter: shelter),
          ),
        ),
      );

      expect(find.text('Chennai Central Relief'), findsOneWidget);
      expect(find.text('Occupancy: 600 / 1000'), findsOneWidget);
      expect(find.text('OPERATIONAL'), findsOneWidget);
    });

    testWidgets('HospitalCard renders beds, doctors, and trauma badge', (tester) async {
      final hospital = Hospital(
        id: 'HOSP-01',
        name: 'Rajiv Gandhi General Hospital',
        district: 'Chennai',
        address: 'Park Town',
        totalBeds: 1800,
        availableBeds: 340,
        icuBeds: 45,
        emergencyDoctors: 32,
        ambulances: 14,
        bloodAvailability: const {'A+': StockLevel.high, 'O+': StockLevel.medium},
        traumaCenter: true,
        contactNumber: '+91 44 2530 5000',
        status: HospitalStatus.operational,
        latitude: 13.08,
        longitude: 80.27,
        specialtyServices: const ['Trauma Unit', 'Burn Ward'],
        lastUpdated: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HospitalCard(hospital: hospital),
          ),
        ),
      );

      expect(find.text('Rajiv Gandhi General Hospital'), findsOneWidget);
      expect(find.text('TRAUMA CENTER'), findsOneWidget);
      expect(find.text('340 / 1800'), findsOneWidget);
    });

    testWidgets('ResourceDashboardScreen renders with loaded state', (tester) async {
      final ds = ResourceMockDatasource();
      final repo = ResourceRepositoryImpl(ds);
      final notifier = ResourceNotifier(
        getSummaryUseCase: GetResourceSummaryUseCase(repo),
        getSheltersUseCase: GetSheltersUseCase(repo),
        getHospitalsUseCase: GetHospitalsUseCase(repo),
        getInventoryUseCase: GetResourceInventoryUseCase(repo),
        getWarehousesUseCase: GetWarehousesUseCase(repo),
        getAllocationsUseCase: GetAllocationsUseCase(repo),
        createAllocationUseCase: CreateAllocationUseCase(repo),
        updateStockUseCase: UpdateResourceStockUseCase(repo),
      );

      await notifier.loadDashboard();

      await tester.pumpWidget(
        MaterialApp(
          home: ResourceDashboardScreen(notifier: notifier),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Resource & Logistics Hub'), findsOneWidget);
      expect(find.text('Operational Supply Summary'), findsOneWidget);
      expect(find.text('Total Resources'), findsOneWidget);
      expect(find.text('Active Shelters'), findsOneWidget);
    });
  });
}
