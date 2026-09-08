import '../entities/resource_entities.dart';

/// Abstract repository contract defining resource, shelter, hospital, warehouse, and allocation workflows.
abstract class ResourceRepository {
  /// Fetch aggregated summary statistics for the dashboard.
  Future<ResourceSummary> getResourceSummary();

  /// Retrieve all disaster relief shelters, optionally filtered by district or operational status.
  Future<List<Shelter>> getShelters({
    String? district,
    ShelterStatus? status,
    String? searchQuery,
  });

  /// Retrieve detailed information for a single shelter.
  Future<Shelter?> getShelterById(String id);

  /// Update shelter occupancy or essential supply availability.
  Future<Shelter> updateShelterStatus({
    required String id,
    int? currentOccupancy,
    StockLevel? foodAvailability,
    StockLevel? waterAvailability,
    bool? medicalSupport,
    ShelterStatus? status,
  });

  /// Retrieve all emergency hospitals, optionally filtered by district or operational status.
  Future<List<Hospital>> getHospitals({
    String? district,
    HospitalStatus? status,
    String? searchQuery,
  });

  /// Retrieve detailed information for a single hospital.
  Future<Hospital?> getHospitalById(String id);

  /// Update hospital emergency capacity metrics.
  Future<Hospital> updateHospitalMetrics({
    required String id,
    int? availableBeds,
    int? icuBeds,
    int? emergencyDoctors,
    int? ambulances,
    HospitalStatus? status,
  });

  /// Retrieve all resource inventory items across all categories and warehouses.
  Future<List<ResourceItem>> getResourceItems({
    ResourceCategory? category,
    ResourceStatus? status,
    String? district,
    String? warehouseId,
    String? searchQuery,
  });

  /// Retrieve a specific resource item by its unique ID.
  Future<ResourceItem?> getResourceItemById(String id);

  /// Update stock quantity or add usage logs for a specific resource.
  Future<ResourceItem> updateResourceStock({
    required String resourceId,
    required int quantityChange,
    required String reason,
    required String performedBy,
    required String destinationName,
  });

  /// Retrieve all regional logistics warehouses.
  Future<List<Warehouse>> getWarehouses({
    String? district,
    String? searchQuery,
  });

  /// Retrieve a specific warehouse by its ID.
  Future<Warehouse?> getWarehouseById(String id);

  /// Retrieve resource allocations/dispatches.
  Future<List<ResourceAllocation>> getAllocations({
    DeliveryStatus? deliveryStatus,
    AllocationPriority? priority,
    String? searchQuery,
  });

  /// Create a new resource allocation mission.
  Future<ResourceAllocation> createAllocation(ResourceAllocation allocation);

  /// Update the status of an ongoing allocation mission.
  Future<ResourceAllocation> updateAllocationStatus({
    required String allocationId,
    required DeliveryStatus newStatus,
  });
}
