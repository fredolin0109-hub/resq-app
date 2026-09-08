import '../../domain/entities/resource_entities.dart';

enum ResourceViewStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

/// Filter criteria for Shelters.
class ShelterFilterOptions {
  final String district;
  final ShelterStatus? status;
  final bool? requiresMedical;
  final String searchQuery;

  const ShelterFilterOptions({
    this.district = 'All',
    this.status,
    this.requiresMedical,
    this.searchQuery = '',
  });

  bool get hasActiveFilters => district != 'All' || status != null || requiresMedical != null || searchQuery.isNotEmpty;

  ShelterFilterOptions copyWith({
    String? district,
    ShelterStatus? status,
    bool? requiresMedical,
    String? searchQuery,
    bool clearStatus = false,
    bool clearMedical = false,
  }) {
    return ShelterFilterOptions(
      district: district ?? this.district,
      status: clearStatus ? null : (status ?? this.status),
      requiresMedical: clearMedical ? null : (requiresMedical ?? this.requiresMedical),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Filter criteria for Hospitals.
class HospitalFilterOptions {
  final String district;
  final HospitalStatus? status;
  final bool? requiresTrauma;
  final String searchQuery;

  const HospitalFilterOptions({
    this.district = 'All',
    this.status,
    this.requiresTrauma,
    this.searchQuery = '',
  });

  bool get hasActiveFilters => district != 'All' || status != null || requiresTrauma != null || searchQuery.isNotEmpty;

  HospitalFilterOptions copyWith({
    String? district,
    HospitalStatus? status,
    bool? requiresTrauma,
    String? searchQuery,
    bool clearStatus = false,
    bool clearTrauma = false,
  }) {
    return HospitalFilterOptions(
      district: district ?? this.district,
      status: clearStatus ? null : (status ?? this.status),
      requiresTrauma: clearTrauma ? null : (requiresTrauma ?? this.requiresTrauma),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Filter criteria for Equipment and Logistics Inventory.
class InventoryFilterOptions {
  final String district;
  final ResourceCategory? category;
  final ResourceStatus? status;
  final String warehouseId;
  final String searchQuery;

  const InventoryFilterOptions({
    this.district = 'All',
    this.category,
    this.status,
    this.warehouseId = 'All',
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      district != 'All' || category != null || status != null || warehouseId != 'All' || searchQuery.isNotEmpty;

  InventoryFilterOptions copyWith({
    String? district,
    ResourceCategory? category,
    ResourceStatus? status,
    String? warehouseId,
    String? searchQuery,
    bool clearCategory = false,
    bool clearStatus = false,
  }) {
    return InventoryFilterOptions(
      district: district ?? this.district,
      category: clearCategory ? null : (category ?? this.category),
      status: clearStatus ? null : (status ?? this.status),
      warehouseId: warehouseId ?? this.warehouseId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Filter criteria for Allocations.
class AllocationFilterOptions {
  final DeliveryStatus? status;
  final AllocationPriority? priority;
  final String searchQuery;

  const AllocationFilterOptions({
    this.status,
    this.priority,
    this.searchQuery = '',
  });

  bool get hasActiveFilters => status != null || priority != null || searchQuery.isNotEmpty;

  AllocationFilterOptions copyWith({
    DeliveryStatus? status,
    AllocationPriority? priority,
    String? searchQuery,
    bool clearStatus = false,
    bool clearPriority = false,
  }) {
    return AllocationFilterOptions(
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Master presentation state combining all resource sub-domains.
class ResourceManagementState {
  final ResourceViewStatus status;
  final String? errorMessage;
  final ResourceSummary summary;

  // Raw collections
  final List<Shelter> allShelters;
  final List<Hospital> allHospitals;
  final List<ResourceItem> allInventory;
  final List<Warehouse> allWarehouses;
  final List<ResourceAllocation> allAllocations;

  // Filtered views
  final List<Shelter> filteredShelters;
  final List<Hospital> filteredHospitals;
  final List<ResourceItem> filteredInventory;
  final List<ResourceAllocation> filteredAllocations;

  // Active filters
  final ShelterFilterOptions shelterFilters;
  final HospitalFilterOptions hospitalFilters;
  final InventoryFilterOptions inventoryFilters;
  final AllocationFilterOptions allocationFilters;

  // Selected item details
  final ResourceItem? selectedResource;
  final Shelter? selectedShelter;
  final Hospital? selectedHospital;
  final Warehouse? selectedWarehouse;

  // In-flight operation flags
  final bool isAllocating;
  final bool isUpdatingStock;

  const ResourceManagementState({
    required this.status,
    this.errorMessage,
    required this.summary,
    required this.allShelters,
    required this.allHospitals,
    required this.allInventory,
    required this.allWarehouses,
    required this.allAllocations,
    required this.filteredShelters,
    required this.filteredHospitals,
    required this.filteredInventory,
    required this.filteredAllocations,
    required this.shelterFilters,
    required this.hospitalFilters,
    required this.inventoryFilters,
    required this.allocationFilters,
    this.selectedResource,
    this.selectedShelter,
    this.selectedHospital,
    this.selectedWarehouse,
    this.isAllocating = false,
    this.isUpdatingStock = false,
  });

  factory ResourceManagementState.initial() => const ResourceManagementState(
        status: ResourceViewStatus.initial,
        errorMessage: null,
        summary: ResourceSummary.empty,
        allShelters: [],
        allHospitals: [],
        allInventory: [],
        allWarehouses: [],
        allAllocations: [],
        filteredShelters: [],
        filteredHospitals: [],
        filteredInventory: [],
        filteredAllocations: [],
        shelterFilters: ShelterFilterOptions(),
        hospitalFilters: HospitalFilterOptions(),
        inventoryFilters: InventoryFilterOptions(),
        allocationFilters: AllocationFilterOptions(),
      );

  factory ResourceManagementState.loading() => ResourceManagementState.initial().copyWith(
        status: ResourceViewStatus.loading,
      );

  factory ResourceManagementState.error(String message) => ResourceManagementState.initial().copyWith(
        status: ResourceViewStatus.error,
        errorMessage: message,
      );

  ResourceManagementState copyWith({
    ResourceViewStatus? status,
    String? errorMessage,
    ResourceSummary? summary,
    List<Shelter>? allShelters,
    List<Hospital>? allHospitals,
    List<ResourceItem>? allInventory,
    List<Warehouse>? allWarehouses,
    List<ResourceAllocation>? allAllocations,
    List<Shelter>? filteredShelters,
    List<Hospital>? filteredHospitals,
    List<ResourceItem>? filteredInventory,
    List<ResourceAllocation>? filteredAllocations,
    ShelterFilterOptions? shelterFilters,
    HospitalFilterOptions? hospitalFilters,
    InventoryFilterOptions? inventoryFilters,
    AllocationFilterOptions? allocationFilters,
    ResourceItem? selectedResource,
    Shelter? selectedShelter,
    Hospital? selectedHospital,
    Warehouse? selectedWarehouse,
    bool? isAllocating,
    bool? isUpdatingStock,
  }) {
    return ResourceManagementState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      summary: summary ?? this.summary,
      allShelters: allShelters ?? this.allShelters,
      allHospitals: allHospitals ?? this.allHospitals,
      allInventory: allInventory ?? this.allInventory,
      allWarehouses: allWarehouses ?? this.allWarehouses,
      allAllocations: allAllocations ?? this.allAllocations,
      filteredShelters: filteredShelters ?? this.filteredShelters,
      filteredHospitals: filteredHospitals ?? this.filteredHospitals,
      filteredInventory: filteredInventory ?? this.filteredInventory,
      filteredAllocations: filteredAllocations ?? this.filteredAllocations,
      shelterFilters: shelterFilters ?? this.shelterFilters,
      hospitalFilters: hospitalFilters ?? this.hospitalFilters,
      inventoryFilters: inventoryFilters ?? this.inventoryFilters,
      allocationFilters: allocationFilters ?? this.allocationFilters,
      selectedResource: selectedResource ?? this.selectedResource,
      selectedShelter: selectedShelter ?? this.selectedShelter,
      selectedHospital: selectedHospital ?? this.selectedHospital,
      selectedWarehouse: selectedWarehouse ?? this.selectedWarehouse,
      isAllocating: isAllocating ?? this.isAllocating,
      isUpdatingStock: isUpdatingStock ?? this.isUpdatingStock,
    );
  }
}
