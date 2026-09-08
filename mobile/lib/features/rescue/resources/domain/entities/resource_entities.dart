import 'package:flutter/material.dart';

/// Stock availability status with standardized disaster-response color coding.
enum ResourceStatus {
  available,
  limited,
  critical,
  outOfStock,
}

extension ResourceStatusX on ResourceStatus {
  String get displayName {
    switch (this) {
      case ResourceStatus.available:
        return 'Available';
      case ResourceStatus.limited:
        return 'Limited';
      case ResourceStatus.critical:
        return 'Critical';
      case ResourceStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  Color get color {
    switch (this) {
      case ResourceStatus.available:
        return const Color(0xFF10B981); // Green
      case ResourceStatus.limited:
        return const Color(0xFFF59E0B); // Yellow/Amber
      case ResourceStatus.critical:
        return const Color(0xFFF97316); // Orange
      case ResourceStatus.outOfStock:
        return const Color(0xFFEF4444); // Red
    }
  }
}

/// Resource item category enum.
enum ResourceCategory {
  foodPacks,
  waterBottles,
  blankets,
  medicines,
  medicalKits,
  rescueEquipment,
  lifeJackets,
  ropes,
  generators,
  fuel,
  boats,
  drones,
}

extension ResourceCategoryX on ResourceCategory {
  String get displayName {
    switch (this) {
      case ResourceCategory.foodPacks:
        return 'Food Packs';
      case ResourceCategory.waterBottles:
        return 'Water Bottles';
      case ResourceCategory.blankets:
        return 'Blankets';
      case ResourceCategory.medicines:
        return 'Medicines';
      case ResourceCategory.medicalKits:
        return 'Medical Kits';
      case ResourceCategory.rescueEquipment:
        return 'Rescue Equipment';
      case ResourceCategory.lifeJackets:
        return 'Life Jackets';
      case ResourceCategory.ropes:
        return 'Ropes';
      case ResourceCategory.generators:
        return 'Generators';
      case ResourceCategory.fuel:
        return 'Fuel';
      case ResourceCategory.boats:
        return 'Boats';
      case ResourceCategory.drones:
        return 'Drones';
    }
  }

  IconData get icon {
    switch (this) {
      case ResourceCategory.foodPacks:
        return Icons.fastfood_rounded;
      case ResourceCategory.waterBottles:
        return Icons.water_drop_rounded;
      case ResourceCategory.blankets:
        return Icons.bed_rounded;
      case ResourceCategory.medicines:
        return Icons.medication_rounded;
      case ResourceCategory.medicalKits:
        return Icons.medical_services_rounded;
      case ResourceCategory.rescueEquipment:
        return Icons.handyman_rounded;
      case ResourceCategory.lifeJackets:
        return Icons.safety_check_rounded;
      case ResourceCategory.ropes:
        return Icons.line_weight_rounded;
      case ResourceCategory.generators:
        return Icons.power_rounded;
      case ResourceCategory.fuel:
        return Icons.local_gas_station_rounded;
      case ResourceCategory.boats:
        return Icons.directions_boat_rounded;
      case ResourceCategory.drones:
        return Icons.flight_takeoff_rounded;
    }
  }
}

/// Shelter operational status.
enum ShelterStatus {
  operational,
  nearCapacity,
  full,
  closed,
}

extension ShelterStatusX on ShelterStatus {
  String get displayName {
    switch (this) {
      case ShelterStatus.operational:
        return 'Operational';
      case ShelterStatus.nearCapacity:
        return 'Near Capacity';
      case ShelterStatus.full:
        return 'Full';
      case ShelterStatus.closed:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case ShelterStatus.operational:
        return const Color(0xFF10B981);
      case ShelterStatus.nearCapacity:
        return const Color(0xFFF59E0B);
      case ShelterStatus.full:
        return const Color(0xFFEF4444);
      case ShelterStatus.closed:
        return Colors.blueGrey;
    }
  }
}

/// Stock availability level for essentials in shelters.
enum StockLevel {
  high,
  medium,
  low,
  critical,
}

extension StockLevelX on StockLevel {
  String get displayName {
    switch (this) {
      case StockLevel.high:
        return 'High';
      case StockLevel.medium:
        return 'Medium';
      case StockLevel.low:
        return 'Low';
      case StockLevel.critical:
        return 'Critical';
    }
  }

  Color get color {
    switch (this) {
      case StockLevel.high:
        return const Color(0xFF10B981);
      case StockLevel.medium:
        return const Color(0xFF3B82F6);
      case StockLevel.low:
        return const Color(0xFFF59E0B);
      case StockLevel.critical:
        return const Color(0xFFEF4444);
    }
  }
}

/// Hospital operational status.
enum HospitalStatus {
  operational,
  overwhelmed,
  limited,
}

extension HospitalStatusX on HospitalStatus {
  String get displayName {
    switch (this) {
      case HospitalStatus.operational:
        return 'Operational';
      case HospitalStatus.overwhelmed:
        return 'Overwhelmed';
      case HospitalStatus.limited:
        return 'Limited';
    }
  }

  Color get color {
    switch (this) {
      case HospitalStatus.operational:
        return const Color(0xFF10B981);
      case HospitalStatus.limited:
        return const Color(0xFFF59E0B);
      case HospitalStatus.overwhelmed:
        return const Color(0xFFEF4444);
    }
  }
}

/// Warehouse operational status.
enum WarehouseStatus {
  operational,
  maintenance,
  full,
}

extension WarehouseStatusX on WarehouseStatus {
  String get displayName {
    switch (this) {
      case WarehouseStatus.operational:
        return 'Operational';
      case WarehouseStatus.maintenance:
        return 'Maintenance';
      case WarehouseStatus.full:
        return 'Full';
    }
  }

  Color get color {
    switch (this) {
      case WarehouseStatus.operational:
        return const Color(0xFF10B981);
      case WarehouseStatus.maintenance:
        return const Color(0xFFF59E0B);
      case WarehouseStatus.full:
        return const Color(0xFF6B7280);
    }
  }
}

/// Priority level for resource allocations.
enum AllocationPriority {
  low,
  medium,
  high,
  critical,
}

extension AllocationPriorityX on AllocationPriority {
  String get displayName {
    switch (this) {
      case AllocationPriority.low:
        return 'Low';
      case AllocationPriority.medium:
        return 'Medium';
      case AllocationPriority.high:
        return 'High';
      case AllocationPriority.critical:
        return 'Critical';
    }
  }

  Color get color {
    switch (this) {
      case AllocationPriority.low:
        return const Color(0xFF3B82F6);
      case AllocationPriority.medium:
        return const Color(0xFFF59E0B);
      case AllocationPriority.high:
        return const Color(0xFFF97316);
      case AllocationPriority.critical:
        return const Color(0xFFEF4444);
    }
  }
}

/// Delivery/dispatch status of resource allocations.
enum DeliveryStatus {
  pending,
  dispatched,
  inTransit,
  delivered,
  cancelled,
}

extension DeliveryStatusX on DeliveryStatus {
  String get displayName {
    switch (this) {
      case DeliveryStatus.pending:
        return 'Pending';
      case DeliveryStatus.dispatched:
        return 'Dispatched';
      case DeliveryStatus.inTransit:
        return 'In Transit';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case DeliveryStatus.pending:
        return const Color(0xFF6B7280);
      case DeliveryStatus.dispatched:
        return const Color(0xFF3B82F6);
      case DeliveryStatus.inTransit:
        return const Color(0xFF8B5CF6);
      case DeliveryStatus.delivered:
        return const Color(0xFF10B981);
      case DeliveryStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

/// Destination classification for resource allocation.
enum DestinationType {
  shelter,
  hospital,
  fieldCamp,
  evacuationPoint,
  communityCenter,
}

extension DestinationTypeX on DestinationType {
  String get displayName {
    switch (this) {
      case DestinationType.shelter:
        return 'Emergency Shelter';
      case DestinationType.hospital:
        return 'Hospital / Trauma Center';
      case DestinationType.fieldCamp:
        return 'Rescue Field Camp';
      case DestinationType.evacuationPoint:
        return 'Evacuation Point';
      case DestinationType.communityCenter:
        return 'Community Relief Center';
    }
  }
}

/// Record of inventory movement / usage history.
class ResourceUsageRecord {
  final String id;
  final DateTime timestamp;
  final int changeAmount; // Negative for consumption/dispatch, positive for restock
  final int remainingQuantity;
  final String reason;
  final String performedBy;
  final String destinationName;

  const ResourceUsageRecord({
    required this.id,
    required this.timestamp,
    required this.changeAmount,
    required this.remainingQuantity,
    required this.reason,
    required this.performedBy,
    required this.destinationName,
  });
}

/// Domain entity representing a physical or logistics resource item.
class ResourceItem {
  final String id;
  final String name;
  final ResourceCategory category;
  final String warehouseId;
  final String warehouseName;
  final String district;
  final int currentQuantity;
  final int minimumThreshold;
  final String unit;
  final ResourceStatus status;
  final DateTime lastUpdated;
  final List<ResourceUsageRecord> usageHistory;
  final bool autoWarning;
  final String description;

  const ResourceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.warehouseId,
    required this.warehouseName,
    required this.district,
    required this.currentQuantity,
    required this.minimumThreshold,
    required this.unit,
    required this.status,
    required this.lastUpdated,
    this.usageHistory = const [],
    this.autoWarning = false,
    this.description = '',
  });

  /// Ratio of current stock relative to threshold.
  double get stockRatio {
    if (minimumThreshold <= 0) return 1.0;
    return (currentQuantity / (minimumThreshold * 2)).clamp(0.0, 1.0);
  }

  /// Calculates status automatically if not manually overridden.
  static ResourceStatus calculateStatus(int current, int threshold) {
    if (current <= 0) return ResourceStatus.outOfStock;
    if (current <= threshold * 0.4) return ResourceStatus.critical;
    if (current <= threshold) return ResourceStatus.limited;
    return ResourceStatus.available;
  }

  ResourceItem copyWith({
    String? id,
    String? name,
    ResourceCategory? category,
    String? warehouseId,
    String? warehouseName,
    String? district,
    int? currentQuantity,
    int? minimumThreshold,
    String? unit,
    ResourceStatus? status,
    DateTime? lastUpdated,
    List<ResourceUsageRecord>? usageHistory,
    bool? autoWarning,
    String? description,
  }) {
    final qty = currentQuantity ?? this.currentQuantity;
    final thresh = minimumThreshold ?? this.minimumThreshold;
    return ResourceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      warehouseId: warehouseId ?? this.warehouseId,
      warehouseName: warehouseName ?? this.warehouseName,
      district: district ?? this.district,
      currentQuantity: qty,
      minimumThreshold: thresh,
      unit: unit ?? this.unit,
      status: status ?? calculateStatus(qty, thresh),
      lastUpdated: lastUpdated ?? this.lastUpdated,
      usageHistory: usageHistory ?? this.usageHistory,
      autoWarning: autoWarning ?? (qty <= thresh),
      description: description ?? this.description,
    );
  }
}

/// Domain entity representing a Disaster Relief Shelter.
class Shelter {
  final String id;
  final String name;
  final String district;
  final String address;
  final int capacity;
  final int currentOccupancy;
  final int availableBeds;
  final bool medicalSupport;
  final StockLevel foodAvailability;
  final StockLevel waterAvailability;
  final bool electricity;
  final bool internet;
  final ShelterStatus status;
  final DateTime lastUpdated;
  final double latitude;
  final double longitude;
  final String contactPerson;
  final String contactPhone;

  const Shelter({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.capacity,
    required this.currentOccupancy,
    required this.availableBeds,
    required this.medicalSupport,
    required this.foodAvailability,
    required this.waterAvailability,
    required this.electricity,
    required this.internet,
    required this.status,
    required this.lastUpdated,
    required this.latitude,
    required this.longitude,
    required this.contactPerson,
    required this.contactPhone,
  });

  double get occupancyRate => capacity > 0 ? (currentOccupancy / capacity).clamp(0.0, 1.0) : 0.0;

  Shelter copyWith({
    String? id,
    String? name,
    String? district,
    String? address,
    int? capacity,
    int? currentOccupancy,
    int? availableBeds,
    bool? medicalSupport,
    StockLevel? foodAvailability,
    StockLevel? waterAvailability,
    bool? electricity,
    bool? internet,
    ShelterStatus? status,
    DateTime? lastUpdated,
    double? latitude,
    double? longitude,
    String? contactPerson,
    String? contactPhone,
  }) {
    return Shelter(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      address: address ?? this.address,
      capacity: capacity ?? this.capacity,
      currentOccupancy: currentOccupancy ?? this.currentOccupancy,
      availableBeds: availableBeds ?? this.availableBeds,
      medicalSupport: medicalSupport ?? this.medicalSupport,
      foodAvailability: foodAvailability ?? this.foodAvailability,
      waterAvailability: waterAvailability ?? this.waterAvailability,
      electricity: electricity ?? this.electricity,
      internet: internet ?? this.internet,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }
}

/// Domain entity representing a Hospital / Emergency Medical Facility.
class Hospital {
  final String id;
  final String name;
  final String district;
  final String address;
  final int totalBeds;
  final int availableBeds;
  final int icuBeds;
  final int emergencyDoctors;
  final int ambulances;
  final Map<String, StockLevel> bloodAvailability; // e.g. {"A+": high, "O+": medium, "B-": critical}
  final bool traumaCenter;
  final String contactNumber;
  final HospitalStatus status;
  final double latitude;
  final double longitude;
  final List<String> specialtyServices;
  final DateTime lastUpdated;

  const Hospital({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.totalBeds,
    required this.availableBeds,
    required this.icuBeds,
    required this.emergencyDoctors,
    required this.ambulances,
    required this.bloodAvailability,
    required this.traumaCenter,
    required this.contactNumber,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.specialtyServices,
    required this.lastUpdated,
  });

  double get bedAvailabilityRate => totalBeds > 0 ? (availableBeds / totalBeds).clamp(0.0, 1.0) : 0.0;
}

/// Domain entity representing a regional Disaster Supply Warehouse.
class Warehouse {
  final String id;
  final String name;
  final String district;
  final String address;
  final String managerName;
  final String contactPhone;
  final double latitude;
  final double longitude;
  final int totalCapacity; // in metric tonnes or units
  final int utilizedCapacity;
  final WarehouseStatus status;
  final int itemCount;

  const Warehouse({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.managerName,
    required this.contactPhone,
    required this.latitude,
    required this.longitude,
    required this.totalCapacity,
    required this.utilizedCapacity,
    required this.status,
    required this.itemCount,
  });

  double get utilizationRate => totalCapacity > 0 ? (utilizedCapacity / totalCapacity).clamp(0.0, 1.0) : 0.0;
}

/// An item allocated in a dispatch order.
class AllocatedItem {
  final String resourceItemId;
  final String resourceName;
  final ResourceCategory category;
  final int quantity;
  final String unit;

  const AllocatedItem({
    required this.resourceItemId,
    required this.resourceName,
    required this.category,
    required this.quantity,
    required this.unit,
  });
}

/// Domain entity representing a Resource Allocation / Dispatch Mission.
class ResourceAllocation {
  final String id;
  final List<AllocatedItem> items;
  final DestinationType destinationType;
  final String destinationId;
  final String destinationName;
  final String destinationDistrict;
  final AllocationPriority priority;
  final String vehicleId;
  final String vehicleName;
  final String assignedTeamId;
  final String assignedTeamName;
  final String estimatedArrival;
  final DeliveryStatus deliveryStatus;
  final DateTime createdAt;
  final String notes;

  const ResourceAllocation({
    required this.id,
    required this.items,
    required this.destinationType,
    required this.destinationId,
    required this.destinationName,
    required this.destinationDistrict,
    required this.priority,
    required this.vehicleId,
    required this.vehicleName,
    required this.assignedTeamId,
    required this.assignedTeamName,
    required this.estimatedArrival,
    required this.deliveryStatus,
    required this.createdAt,
    this.notes = '',
  });

  int get totalQuantity => items.fold(0, (sum, i) => sum + i.quantity);
}

/// Aggregated system-wide resource metrics for the command dashboard.
class ResourceSummary {
  final int totalResources;
  final int availableResources;
  final int limitedResources;
  final int criticalResources;
  final int activeShelters;
  final int totalShelters;
  final int totalHospitals;
  final int availableHospitalBeds;
  final int availableIcuBeds;
  final int foodStockPacks;
  final int waterStockBottles;
  final int medicalKitsCount;
  final int fuelAvailableLiters;
  final int activeAllocations;
  final int criticalAlerts;

  const ResourceSummary({
    required this.totalResources,
    required this.availableResources,
    required this.limitedResources,
    required this.criticalResources,
    required this.activeShelters,
    required this.totalShelters,
    required this.totalHospitals,
    required this.availableHospitalBeds,
    required this.availableIcuBeds,
    required this.foodStockPacks,
    required this.waterStockBottles,
    required this.medicalKitsCount,
    required this.fuelAvailableLiters,
    required this.activeAllocations,
    required this.criticalAlerts,
  });

  static const ResourceSummary empty = ResourceSummary(
    totalResources: 0,
    availableResources: 0,
    limitedResources: 0,
    criticalResources: 0,
    activeShelters: 0,
    totalShelters: 0,
    totalHospitals: 0,
    availableHospitalBeds: 0,
    availableIcuBeds: 0,
    foodStockPacks: 0,
    waterStockBottles: 0,
    medicalKitsCount: 0,
    fuelAvailableLiters: 0,
    activeAllocations: 0,
    criticalAlerts: 0,
  );
}
