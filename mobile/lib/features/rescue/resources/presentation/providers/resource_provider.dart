import 'package:flutter/foundation.dart';
import '../../data/datasources/resource_mock_datasource.dart';
import '../../data/repositories/resource_repository_impl.dart';
import '../../domain/entities/resource_entities.dart';
import '../../domain/repositories/resource_repository.dart';
import '../../domain/usecases/resource_usecases.dart';
import 'resource_state.dart';

/// Central state notifier managing resources, shelters, hospitals, warehouses, and allocations.
class ResourceNotifier extends ChangeNotifier {
  final GetResourceSummaryUseCase _getSummaryUseCase;
  final GetSheltersUseCase _getSheltersUseCase;
  final GetHospitalsUseCase _getHospitalsUseCase;
  final GetResourceInventoryUseCase _getInventoryUseCase;
  final GetWarehousesUseCase _getWarehousesUseCase;
  final GetAllocationsUseCase _getAllocationsUseCase;
  final CreateAllocationUseCase _createAllocationUseCase;
  final UpdateResourceStockUseCase _updateStockUseCase;

  ResourceManagementState _state = ResourceManagementState.initial();

  ResourceNotifier({
    required GetResourceSummaryUseCase getSummaryUseCase,
    required GetSheltersUseCase getSheltersUseCase,
    required GetHospitalsUseCase getHospitalsUseCase,
    required GetResourceInventoryUseCase getInventoryUseCase,
    required GetWarehousesUseCase getWarehousesUseCase,
    required GetAllocationsUseCase getAllocationsUseCase,
    required CreateAllocationUseCase createAllocationUseCase,
    required UpdateResourceStockUseCase updateStockUseCase,
  })  : _getSummaryUseCase = getSummaryUseCase,
        _getSheltersUseCase = getSheltersUseCase,
        _getHospitalsUseCase = getHospitalsUseCase,
        _getInventoryUseCase = getInventoryUseCase,
        _getWarehousesUseCase = getWarehousesUseCase,
        _getAllocationsUseCase = getAllocationsUseCase,
        _createAllocationUseCase = createAllocationUseCase,
        _updateStockUseCase = updateStockUseCase;

  ResourceManagementState get state => _state;

  /// Loads all domain data for the dashboard.
  Future<void> loadDashboard() async {
    _state = ResourceManagementState.loading();
    notifyListeners();

    try {
      final summary = await _getSummaryUseCase();
      final shelters = await _getSheltersUseCase();
      final hospitals = await _getHospitalsUseCase();
      final inventory = await _getInventoryUseCase();
      final warehouses = await _getWarehousesUseCase();
      final allocations = await _getAllocationsUseCase();

      final filteredShelters = _applyShelterFilters(shelters, _state.shelterFilters);
      final filteredHospitals = _applyHospitalFilters(hospitals, _state.hospitalFilters);
      final filteredInventory = _applyInventoryFilters(inventory, _state.inventoryFilters);
      final filteredAllocations = _applyAllocationFilters(allocations, _state.allocationFilters);

      _state = _state.copyWith(
        status: ResourceViewStatus.loaded,
        summary: summary,
        allShelters: shelters,
        filteredShelters: filteredShelters,
        allHospitals: hospitals,
        filteredHospitals: filteredHospitals,
        allInventory: inventory,
        filteredInventory: filteredInventory,
        allWarehouses: warehouses,
        allAllocations: allocations,
        filteredAllocations: filteredAllocations,
      );
      notifyListeners();
    } catch (e) {
      _state = ResourceManagementState.error(e.toString().replaceFirst('Exception: ', ''));
      notifyListeners();
    }
  }

  // ===========================================================================
  // SEARCH & FILTER HANDLERS
  // ===========================================================================

  void updateShelterFilters(ShelterFilterOptions options) {
    _state = _state.copyWith(shelterFilters: options);
    _reapplyShelterFilters();
  }

  void searchShelters(String query) {
    final opts = _state.shelterFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(shelterFilters: opts);
    _reapplyShelterFilters();
  }

  void updateHospitalFilters(HospitalFilterOptions options) {
    _state = _state.copyWith(hospitalFilters: options);
    _reapplyHospitalFilters();
  }

  void searchHospitals(String query) {
    final opts = _state.hospitalFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(hospitalFilters: opts);
    _reapplyHospitalFilters();
  }

  void updateInventoryFilters(InventoryFilterOptions options) {
    _state = _state.copyWith(inventoryFilters: options);
    _reapplyInventoryFilters();
  }

  void searchInventory(String query) {
    final opts = _state.inventoryFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(inventoryFilters: opts);
    _reapplyInventoryFilters();
  }

  void updateAllocationFilters(AllocationFilterOptions options) {
    _state = _state.copyWith(allocationFilters: options);
    _reapplyAllocationFilters();
  }

  void searchAllocations(String query) {
    final opts = _state.allocationFilters.copyWith(searchQuery: query);
    _state = _state.copyWith(allocationFilters: opts);
    _reapplyAllocationFilters();
  }

  // ===========================================================================
  // SELECTION HANDLERS
  // ===========================================================================

  void selectResource(ResourceItem item) {
    _state = _state.copyWith(selectedResource: item);
    notifyListeners();
  }

  void selectResourceById(String id) {
    try {
      final item = _state.allInventory.firstWhere((r) => r.id == id);
      _state = _state.copyWith(selectedResource: item);
      notifyListeners();
    } catch (_) {}
  }

  void selectShelter(Shelter shelter) {
    _state = _state.copyWith(selectedShelter: shelter);
    notifyListeners();
  }

  void selectShelterById(String id) {
    try {
      final s = _state.allShelters.firstWhere((item) => item.id == id);
      _state = _state.copyWith(selectedShelter: s);
      notifyListeners();
    } catch (_) {}
  }

  void selectHospital(Hospital hospital) {
    _state = _state.copyWith(selectedHospital: hospital);
    notifyListeners();
  }

  void selectHospitalById(String id) {
    try {
      final h = _state.allHospitals.firstWhere((item) => item.id == id);
      _state = _state.copyWith(selectedHospital: h);
      notifyListeners();
    } catch (_) {}
  }

  void selectWarehouse(Warehouse warehouse) {
    _state = _state.copyWith(selectedWarehouse: warehouse);
    notifyListeners();
  }

  // ===========================================================================
  // MUTATION ACTIONS
  // ===========================================================================

  Future<bool> createResourceAllocation(ResourceAllocation allocation) async {
    _state = _state.copyWith(isAllocating: true);
    notifyListeners();

    try {
      final created = await _createAllocationUseCase(allocation);
      final updatedAllocations = [created, ..._state.allAllocations];
      final filteredAllocs = _applyAllocationFilters(updatedAllocations, _state.allocationFilters);

      // Refresh inventory and summary after deduction
      final updatedInventory = await _getInventoryUseCase();
      final filteredInv = _applyInventoryFilters(updatedInventory, _state.inventoryFilters);
      final summary = await _getSummaryUseCase();

      _state = _state.copyWith(
        isAllocating: false,
        allAllocations: updatedAllocations,
        filteredAllocations: filteredAllocs,
        allInventory: updatedInventory,
        filteredInventory: filteredInv,
        summary: summary,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(isAllocating: false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStock({
    required String resourceId,
    required int quantityChange,
    required String reason,
    required String performedBy,
    required String destinationName,
  }) async {
    _state = _state.copyWith(isUpdatingStock: true);
    notifyListeners();

    try {
      final updatedItem = await _updateStockUseCase(
        resourceId: resourceId,
        quantityChange: quantityChange,
        reason: reason,
        performedBy: performedBy,
        destinationName: destinationName,
      );

      final updatedInventory = _state.allInventory.map((i) => i.id == updatedItem.id ? updatedItem : i).toList();
      final filteredInv = _applyInventoryFilters(updatedInventory, _state.inventoryFilters);
      final summary = await _getSummaryUseCase();

      _state = _state.copyWith(
        isUpdatingStock: false,
        allInventory: updatedInventory,
        filteredInventory: filteredInv,
        selectedResource: updatedItem,
        summary: summary,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(isUpdatingStock: false);
      notifyListeners();
      return false;
    }
  }

  // ===========================================================================
  // INTERNAL FILTER IMPLEMENTATIONS
  // ===========================================================================

  void _reapplyShelterFilters() {
    final filtered = _applyShelterFilters(_state.allShelters, _state.shelterFilters);
    _state = _state.copyWith(filteredShelters: filtered);
    notifyListeners();
  }

  void _reapplyHospitalFilters() {
    final filtered = _applyHospitalFilters(_state.allHospitals, _state.hospitalFilters);
    _state = _state.copyWith(filteredHospitals: filtered);
    notifyListeners();
  }

  void _reapplyInventoryFilters() {
    final filtered = _applyInventoryFilters(_state.allInventory, _state.inventoryFilters);
    _state = _state.copyWith(filteredInventory: filtered);
    notifyListeners();
  }

  void _reapplyAllocationFilters() {
    final filtered = _applyAllocationFilters(_state.allAllocations, _state.allocationFilters);
    _state = _state.copyWith(filteredAllocations: filtered);
    notifyListeners();
  }

  List<Shelter> _applyShelterFilters(List<Shelter> list, ShelterFilterOptions opts) {
    return list.where((s) {
      if (opts.district != 'All' && s.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.status != null && s.status != opts.status) {
        return false;
      }
      if (opts.requiresMedical != null && s.medicalSupport != opts.requiresMedical) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = s.name.toLowerCase().contains(q) ||
            s.district.toLowerCase().contains(q) ||
            s.address.toLowerCase().contains(q) ||
            s.contactPerson.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<Hospital> _applyHospitalFilters(List<Hospital> list, HospitalFilterOptions opts) {
    return list.where((h) {
      if (opts.district != 'All' && h.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.status != null && h.status != opts.status) {
        return false;
      }
      if (opts.requiresTrauma != null && h.traumaCenter != opts.requiresTrauma) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = h.name.toLowerCase().contains(q) ||
            h.district.toLowerCase().contains(q) ||
            h.address.toLowerCase().contains(q) ||
            h.specialtyServices.any((s) => s.toLowerCase().contains(q));
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<ResourceItem> _applyInventoryFilters(List<ResourceItem> list, InventoryFilterOptions opts) {
    return list.where((r) {
      if (opts.district != 'All' && r.district.toLowerCase() != opts.district.toLowerCase()) {
        return false;
      }
      if (opts.category != null && r.category != opts.category) {
        return false;
      }
      if (opts.status != null && r.status != opts.status) {
        return false;
      }
      if (opts.warehouseId != 'All' && r.warehouseId != opts.warehouseId) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = r.name.toLowerCase().contains(q) ||
            r.category.displayName.toLowerCase().contains(q) ||
            r.warehouseName.toLowerCase().contains(q) ||
            r.district.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<ResourceAllocation> _applyAllocationFilters(List<ResourceAllocation> list, AllocationFilterOptions opts) {
    return list.where((a) {
      if (opts.status != null && a.deliveryStatus != opts.status) {
        return false;
      }
      if (opts.priority != null && a.priority != opts.priority) {
        return false;
      }
      if (opts.searchQuery.trim().isNotEmpty) {
        final q = opts.searchQuery.toLowerCase().trim();
        final match = a.destinationName.toLowerCase().contains(q) ||
            a.destinationDistrict.toLowerCase().contains(q) ||
            a.assignedTeamName.toLowerCase().contains(q) ||
            a.vehicleName.toLowerCase().contains(q) ||
            a.items.any((i) => i.resourceName.toLowerCase().contains(q));
        if (!match) return false;
      }
      return true;
    }).toList();
  }
}

/// Global dependency injection and singleton container for Resource Module.
class ResourceDependencies {
  static final ResourceMockDatasource datasource = ResourceMockDatasource();
  static final ResourceRepository repository = ResourceRepositoryImpl(datasource);

  static final GetResourceSummaryUseCase getSummaryUseCase = GetResourceSummaryUseCase(repository);
  static final GetSheltersUseCase getSheltersUseCase = GetSheltersUseCase(repository);
  static final GetHospitalsUseCase getHospitalsUseCase = GetHospitalsUseCase(repository);
  static final GetResourceInventoryUseCase getInventoryUseCase = GetResourceInventoryUseCase(repository);
  static final GetWarehousesUseCase getWarehousesUseCase = GetWarehousesUseCase(repository);
  static final GetAllocationsUseCase getAllocationsUseCase = GetAllocationsUseCase(repository);
  static final CreateAllocationUseCase createAllocationUseCase = CreateAllocationUseCase(repository);
  static final UpdateResourceStockUseCase updateStockUseCase = UpdateResourceStockUseCase(repository);

  static final ResourceNotifier notifier = ResourceNotifier(
    getSummaryUseCase: getSummaryUseCase,
    getSheltersUseCase: getSheltersUseCase,
    getHospitalsUseCase: getHospitalsUseCase,
    getInventoryUseCase: getInventoryUseCase,
    getWarehousesUseCase: getWarehousesUseCase,
    getAllocationsUseCase: getAllocationsUseCase,
    createAllocationUseCase: createAllocationUseCase,
    updateStockUseCase: updateStockUseCase,
  );
}
