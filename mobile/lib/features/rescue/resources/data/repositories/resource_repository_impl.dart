import '../../domain/entities/resource_entities.dart';
import '../../domain/repositories/resource_repository.dart';
import '../datasources/resource_mock_datasource.dart';

/// Concrete implementation of [ResourceRepository] backed by [ResourceMockDatasource].
class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceMockDatasource _datasource;

  ResourceRepositoryImpl([ResourceMockDatasource? datasource])
      : _datasource = datasource ?? ResourceMockDatasource();

  @override
  Future<ResourceSummary> getResourceSummary() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _datasource.getSummary();
  }

  @override
  Future<List<Shelter>> getShelters({
    String? district,
    ShelterStatus? status,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 180));
    var list = _datasource.shelters.map((m) => m.toEntity()).toList();

    if (district != null && district.isNotEmpty && district != 'All') {
      list = list.where((s) => s.district.toLowerCase() == district.toLowerCase()).toList();
    }

    if (status != null) {
      list = list.where((s) => s.status == status).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((s) =>
          s.name.toLowerCase().contains(q) ||
          s.district.toLowerCase().contains(q) ||
          s.address.toLowerCase().contains(q) ||
          s.contactPerson.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<Shelter?> getShelterById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _datasource.shelters.firstWhere((s) => s.id == id).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Shelter> updateShelterStatus({
    required String id,
    int? currentOccupancy,
    StockLevel? foodAvailability,
    StockLevel? waterAvailability,
    bool? medicalSupport,
    ShelterStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.updateShelter(
      id: id,
      currentOccupancy: currentOccupancy,
      foodAvailability: foodAvailability,
      waterAvailability: waterAvailability,
      medicalSupport: medicalSupport,
      status: status,
    ).toEntity();
  }

  @override
  Future<List<Hospital>> getHospitals({
    String? district,
    HospitalStatus? status,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 180));
    var list = _datasource.hospitals.map((m) => m.toEntity()).toList();

    if (district != null && district.isNotEmpty && district != 'All') {
      list = list.where((h) => h.district.toLowerCase() == district.toLowerCase()).toList();
    }

    if (status != null) {
      list = list.where((h) => h.status == status).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((h) =>
          h.name.toLowerCase().contains(q) ||
          h.district.toLowerCase().contains(q) ||
          h.address.toLowerCase().contains(q) ||
          h.specialtyServices.any((s) => s.toLowerCase().contains(q))).toList();
    }

    return list;
  }

  @override
  Future<Hospital?> getHospitalById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _datasource.hospitals.firstWhere((h) => h.id == id).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Hospital> updateHospitalMetrics({
    required String id,
    int? availableBeds,
    int? icuBeds,
    int? emergencyDoctors,
    int? ambulances,
    HospitalStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.updateHospital(
      id: id,
      availableBeds: availableBeds,
      icuBeds: icuBeds,
      emergencyDoctors: emergencyDoctors,
      ambulances: ambulances,
      status: status,
    ).toEntity();
  }

  @override
  Future<List<ResourceItem>> getResourceItems({
    ResourceCategory? category,
    ResourceStatus? status,
    String? district,
    String? warehouseId,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 180));
    var list = _datasource.resourceItems.map((m) => m.toEntity()).toList();

    if (category != null) {
      list = list.where((r) => r.category == category).toList();
    }

    if (status != null) {
      list = list.where((r) => r.status == status).toList();
    }

    if (district != null && district.isNotEmpty && district != 'All') {
      list = list.where((r) => r.district.toLowerCase() == district.toLowerCase()).toList();
    }

    if (warehouseId != null && warehouseId.isNotEmpty) {
      list = list.where((r) => r.warehouseId == warehouseId).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((r) =>
          r.name.toLowerCase().contains(q) ||
          r.category.displayName.toLowerCase().contains(q) ||
          r.warehouseName.toLowerCase().contains(q) ||
          r.district.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<ResourceItem?> getResourceItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _datasource.resourceItems.firstWhere((r) => r.id == id).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ResourceItem> updateResourceStock({
    required String resourceId,
    required int quantityChange,
    required String reason,
    required String performedBy,
    required String destinationName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.updateResourceQuantity(
      resourceId: resourceId,
      quantityChange: quantityChange,
      reason: reason,
      performedBy: performedBy,
      destinationName: destinationName,
    ).toEntity();
  }

  @override
  Future<List<Warehouse>> getWarehouses({
    String? district,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var list = _datasource.warehouses.map((m) => m.toEntity()).toList();

    if (district != null && district.isNotEmpty && district != 'All') {
      list = list.where((w) => w.district.toLowerCase() == district.toLowerCase()).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((w) =>
          w.name.toLowerCase().contains(q) ||
          w.district.toLowerCase().contains(q) ||
          w.managerName.toLowerCase().contains(q) ||
          w.address.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<Warehouse?> getWarehouseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _datasource.warehouses.firstWhere((w) => w.id == id).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ResourceAllocation>> getAllocations({
    DeliveryStatus? deliveryStatus,
    AllocationPriority? priority,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var list = _datasource.allocations.map((m) => m.toEntity()).toList();

    if (deliveryStatus != null) {
      list = list.where((a) => a.deliveryStatus == deliveryStatus).toList();
    }

    if (priority != null) {
      list = list.where((a) => a.priority == priority).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((a) =>
          a.destinationName.toLowerCase().contains(q) ||
          a.destinationDistrict.toLowerCase().contains(q) ||
          a.assignedTeamName.toLowerCase().contains(q) ||
          a.vehicleName.toLowerCase().contains(q) ||
          a.items.any((i) => i.resourceName.toLowerCase().contains(q))).toList();
    }

    return list;
  }

  @override
  Future<ResourceAllocation> createAllocation(ResourceAllocation allocation) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _datasource.addAllocation(allocation).toEntity();
  }

  @override
  Future<ResourceAllocation> updateAllocationStatus({
    required String allocationId,
    required DeliveryStatus newStatus,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.updateAllocationStatus(
      allocationId: allocationId,
      newStatus: newStatus,
    ).toEntity();
  }
}
