import '../entities/resource_entities.dart';
import '../repositories/resource_repository.dart';

/// Fetch dashboard high-level metric counts.
class GetResourceSummaryUseCase {
  final ResourceRepository repository;

  GetResourceSummaryUseCase(this.repository);

  Future<ResourceSummary> call() async {
    return await repository.getResourceSummary();
  }
}

/// Retrieve and filter shelters.
class GetSheltersUseCase {
  final ResourceRepository repository;

  GetSheltersUseCase(this.repository);

  Future<List<Shelter>> call({
    String? district,
    ShelterStatus? status,
    String? searchQuery,
  }) async {
    return await repository.getShelters(
      district: district,
      status: status,
      searchQuery: searchQuery,
    );
  }

  Future<Shelter?> getById(String id) async {
    return await repository.getShelterById(id);
  }
}

/// Retrieve and filter hospitals.
class GetHospitalsUseCase {
  final ResourceRepository repository;

  GetHospitalsUseCase(this.repository);

  Future<List<Hospital>> call({
    String? district,
    HospitalStatus? status,
    String? searchQuery,
  }) async {
    return await repository.getHospitals(
      district: district,
      status: status,
      searchQuery: searchQuery,
    );
  }

  Future<Hospital?> getById(String id) async {
    return await repository.getHospitalById(id);
  }
}

/// Retrieve and filter inventory resources across categories.
class GetResourceInventoryUseCase {
  final ResourceRepository repository;

  GetResourceInventoryUseCase(this.repository);

  Future<List<ResourceItem>> call({
    ResourceCategory? category,
    ResourceStatus? status,
    String? district,
    String? warehouseId,
    String? searchQuery,
  }) async {
    return await repository.getResourceItems(
      category: category,
      status: status,
      district: district,
      warehouseId: warehouseId,
      searchQuery: searchQuery,
    );
  }

  Future<ResourceItem?> getById(String id) async {
    return await repository.getResourceItemById(id);
  }
}

/// Update stock quantity and record usage.
class UpdateResourceStockUseCase {
  final ResourceRepository repository;

  UpdateResourceStockUseCase(this.repository);

  Future<ResourceItem> call({
    required String resourceId,
    required int quantityChange,
    required String reason,
    required String performedBy,
    required String destinationName,
  }) async {
    return await repository.updateResourceStock(
      resourceId: resourceId,
      quantityChange: quantityChange,
      reason: reason,
      performedBy: performedBy,
      destinationName: destinationName,
    );
  }
}

/// Retrieve logistics warehouses.
class GetWarehousesUseCase {
  final ResourceRepository repository;

  GetWarehousesUseCase(this.repository);

  Future<List<Warehouse>> call({
    String? district,
    String? searchQuery,
  }) async {
    return await repository.getWarehouses(
      district: district,
      searchQuery: searchQuery,
    );
  }

  Future<Warehouse?> getById(String id) async {
    return await repository.getWarehouseById(id);
  }
}

/// Retrieve and manage resource allocation orders.
class GetAllocationsUseCase {
  final ResourceRepository repository;

  GetAllocationsUseCase(this.repository);

  Future<List<ResourceAllocation>> call({
    DeliveryStatus? deliveryStatus,
    AllocationPriority? priority,
    String? searchQuery,
  }) async {
    return await repository.getAllocations(
      deliveryStatus: deliveryStatus,
      priority: priority,
      searchQuery: searchQuery,
    );
  }
}

/// Create a new resource allocation and dispatch mission.
class CreateAllocationUseCase {
  final ResourceRepository repository;

  CreateAllocationUseCase(this.repository);

  Future<ResourceAllocation> call(ResourceAllocation allocation) async {
    return await repository.createAllocation(allocation);
  }
}

/// Update delivery progress of an allocation.
class UpdateAllocationStatusUseCase {
  final ResourceRepository repository;

  UpdateAllocationStatusUseCase(this.repository);

  Future<ResourceAllocation> call({
    required String allocationId,
    required DeliveryStatus newStatus,
  }) async {
    return await repository.updateAllocationStatus(
      allocationId: allocationId,
      newStatus: newStatus,
    );
  }
}
