import '../../domain/entities/resource_entities.dart';

/// DTO Model for ResourceUsageRecord.
class ResourceUsageRecordModel extends ResourceUsageRecord {
  const ResourceUsageRecordModel({
    required super.id,
    required super.timestamp,
    required super.changeAmount,
    required super.remainingQuantity,
    required super.reason,
    required super.performedBy,
    required super.destinationName,
  });

  factory ResourceUsageRecordModel.fromJson(Map<String, dynamic> json) {
    return ResourceUsageRecordModel(
      id: json['id'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      changeAmount: (json['changeAmount'] as num?)?.toInt() ?? 0,
      remainingQuantity: (json['remainingQuantity'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String? ?? '',
      performedBy: json['performedBy'] as String? ?? '',
      destinationName: json['destinationName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'changeAmount': changeAmount,
        'remainingQuantity': remainingQuantity,
        'reason': reason,
        'performedBy': performedBy,
        'destinationName': destinationName,
      };
}

/// DTO Model for ResourceItem.
class ResourceItemModel extends ResourceItem {
  const ResourceItemModel({
    required super.id,
    required super.name,
    required super.category,
    required super.warehouseId,
    required super.warehouseName,
    required super.district,
    required super.currentQuantity,
    required super.minimumThreshold,
    required super.unit,
    required super.status,
    required super.lastUpdated,
    super.usageHistory,
    super.autoWarning,
    super.description,
  });

  factory ResourceItemModel.fromJson(Map<String, dynamic> json) {
    final catIndex = (json['category'] as num?)?.toInt() ?? 0;
    final statIndex = (json['status'] as num?)?.toInt() ?? 0;

    final historyList = (json['usageHistory'] as List<dynamic>?)
            ?.map((e) => ResourceUsageRecordModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final qty = (json['currentQuantity'] as num?)?.toInt() ?? 0;
    final thresh = (json['minimumThreshold'] as num?)?.toInt() ?? 0;

    return ResourceItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: catIndex >= 0 && catIndex < ResourceCategory.values.length
          ? ResourceCategory.values[catIndex]
          : ResourceCategory.rescueEquipment,
      warehouseId: json['warehouseId'] as String? ?? '',
      warehouseName: json['warehouseName'] as String? ?? '',
      district: json['district'] as String? ?? '',
      currentQuantity: qty,
      minimumThreshold: thresh,
      unit: json['unit'] as String? ?? 'units',
      status: statIndex >= 0 && statIndex < ResourceStatus.values.length
          ? ResourceStatus.values[statIndex]
          : ResourceItem.calculateStatus(qty, thresh),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now(),
      usageHistory: historyList,
      autoWarning: json['autoWarning'] as bool? ?? (qty <= thresh),
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.index,
        'warehouseId': warehouseId,
        'warehouseName': warehouseName,
        'district': district,
        'currentQuantity': currentQuantity,
        'minimumThreshold': minimumThreshold,
        'unit': unit,
        'status': status.index,
        'lastUpdated': lastUpdated.toIso8601String(),
        'usageHistory': usageHistory.map((e) {
          if (e is ResourceUsageRecordModel) return e.toJson();
          return {
            'id': e.id,
            'timestamp': e.timestamp.toIso8601String(),
            'changeAmount': e.changeAmount,
            'remainingQuantity': e.remainingQuantity,
            'reason': e.reason,
            'performedBy': e.performedBy,
            'destinationName': e.destinationName,
          };
        }).toList(),
        'autoWarning': autoWarning,
        'description': description,
      };

  ResourceItem toEntity() => this;
}

/// DTO Model for Shelter.
class ShelterModel extends Shelter {
  const ShelterModel({
    required super.id,
    required super.name,
    required super.district,
    required super.address,
    required super.capacity,
    required super.currentOccupancy,
    required super.availableBeds,
    required super.medicalSupport,
    required super.foodAvailability,
    required super.waterAvailability,
    required super.electricity,
    required super.internet,
    required super.status,
    required super.lastUpdated,
    required super.latitude,
    required super.longitude,
    required super.contactPerson,
    required super.contactPhone,
  });

  factory ShelterModel.fromJson(Map<String, dynamic> json) {
    final foodIndex = (json['foodAvailability'] as num?)?.toInt() ?? 0;
    final waterIndex = (json['waterAvailability'] as num?)?.toInt() ?? 0;
    final statusIndex = (json['status'] as num?)?.toInt() ?? 0;

    return ShelterModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      district: json['district'] as String? ?? '',
      address: json['address'] as String? ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      currentOccupancy: (json['currentOccupancy'] as num?)?.toInt() ?? 0,
      availableBeds: (json['availableBeds'] as num?)?.toInt() ?? 0,
      medicalSupport: json['medicalSupport'] as bool? ?? false,
      foodAvailability: foodIndex >= 0 && foodIndex < StockLevel.values.length
          ? StockLevel.values[foodIndex]
          : StockLevel.medium,
      waterAvailability: waterIndex >= 0 && waterIndex < StockLevel.values.length
          ? StockLevel.values[waterIndex]
          : StockLevel.medium,
      electricity: json['electricity'] as bool? ?? true,
      internet: json['internet'] as bool? ?? true,
      status: statusIndex >= 0 && statusIndex < ShelterStatus.values.length
          ? ShelterStatus.values[statusIndex]
          : ShelterStatus.operational,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now(),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      contactPerson: json['contactPerson'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'district': district,
        'address': address,
        'capacity': capacity,
        'currentOccupancy': currentOccupancy,
        'availableBeds': availableBeds,
        'medicalSupport': medicalSupport,
        'foodAvailability': foodAvailability.index,
        'waterAvailability': waterAvailability.index,
        'electricity': electricity,
        'internet': internet,
        'status': status.index,
        'lastUpdated': lastUpdated.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'contactPerson': contactPerson,
        'contactPhone': contactPhone,
      };

  Shelter toEntity() => this;
}

/// DTO Model for Hospital.
class HospitalModel extends Hospital {
  const HospitalModel({
    required super.id,
    required super.name,
    required super.district,
    required super.address,
    required super.totalBeds,
    required super.availableBeds,
    required super.icuBeds,
    required super.emergencyDoctors,
    required super.ambulances,
    required super.bloodAvailability,
    required super.traumaCenter,
    required super.contactNumber,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.specialtyServices,
    required super.lastUpdated,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    final statusIndex = (json['status'] as num?)?.toInt() ?? 0;
    final bloodMapRaw = json['bloodAvailability'] as Map<String, dynamic>? ?? {};
    final bloodMap = <String, StockLevel>{};
    bloodMapRaw.forEach((k, v) {
      final idx = (v as num?)?.toInt() ?? 0;
      bloodMap[k] = idx >= 0 && idx < StockLevel.values.length
          ? StockLevel.values[idx]
          : StockLevel.medium;
    });

    final specialties = (json['specialtyServices'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return HospitalModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      district: json['district'] as String? ?? '',
      address: json['address'] as String? ?? '',
      totalBeds: (json['totalBeds'] as num?)?.toInt() ?? 0,
      availableBeds: (json['availableBeds'] as num?)?.toInt() ?? 0,
      icuBeds: (json['icuBeds'] as num?)?.toInt() ?? 0,
      emergencyDoctors: (json['emergencyDoctors'] as num?)?.toInt() ?? 0,
      ambulances: (json['ambulances'] as num?)?.toInt() ?? 0,
      bloodAvailability: bloodMap,
      traumaCenter: json['traumaCenter'] as bool? ?? false,
      contactNumber: json['contactNumber'] as String? ?? '',
      status: statusIndex >= 0 && statusIndex < HospitalStatus.values.length
          ? HospitalStatus.values[statusIndex]
          : HospitalStatus.operational,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      specialtyServices: specialties,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'district': district,
        'address': address,
        'totalBeds': totalBeds,
        'availableBeds': availableBeds,
        'icuBeds': icuBeds,
        'emergencyDoctors': emergencyDoctors,
        'ambulances': ambulances,
        'bloodAvailability': bloodAvailability.map((k, v) => MapEntry(k, v.index)),
        'traumaCenter': traumaCenter,
        'contactNumber': contactNumber,
        'status': status.index,
        'latitude': latitude,
        'longitude': longitude,
        'specialtyServices': specialtyServices,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  Hospital toEntity() => this;
}

/// DTO Model for Warehouse.
class WarehouseModel extends Warehouse {
  const WarehouseModel({
    required super.id,
    required super.name,
    required super.district,
    required super.address,
    required super.managerName,
    required super.contactPhone,
    required super.latitude,
    required super.longitude,
    required super.totalCapacity,
    required super.utilizedCapacity,
    required super.status,
    required super.itemCount,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    final statusIndex = (json['status'] as num?)?.toInt() ?? 0;
    return WarehouseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      district: json['district'] as String? ?? '',
      address: json['address'] as String? ?? '',
      managerName: json['managerName'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      totalCapacity: (json['totalCapacity'] as num?)?.toInt() ?? 0,
      utilizedCapacity: (json['utilizedCapacity'] as num?)?.toInt() ?? 0,
      status: statusIndex >= 0 && statusIndex < WarehouseStatus.values.length
          ? WarehouseStatus.values[statusIndex]
          : WarehouseStatus.operational,
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'district': district,
        'address': address,
        'managerName': managerName,
        'contactPhone': contactPhone,
        'latitude': latitude,
        'longitude': longitude,
        'totalCapacity': totalCapacity,
        'utilizedCapacity': utilizedCapacity,
        'status': status.index,
        'itemCount': itemCount,
      };

  Warehouse toEntity() => this;
}

/// DTO Model for AllocatedItem.
class AllocatedItemModel extends AllocatedItem {
  const AllocatedItemModel({
    required super.resourceItemId,
    required super.resourceName,
    required super.category,
    required super.quantity,
    required super.unit,
  });

  factory AllocatedItemModel.fromJson(Map<String, dynamic> json) {
    final catIndex = (json['category'] as num?)?.toInt() ?? 0;
    return AllocatedItemModel(
      resourceItemId: json['resourceItemId'] as String? ?? '',
      resourceName: json['resourceName'] as String? ?? '',
      category: catIndex >= 0 && catIndex < ResourceCategory.values.length
          ? ResourceCategory.values[catIndex]
          : ResourceCategory.rescueEquipment,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unit: json['unit'] as String? ?? 'units',
    );
  }

  Map<String, dynamic> toJson() => {
        'resourceItemId': resourceItemId,
        'resourceName': resourceName,
        'category': category.index,
        'quantity': quantity,
        'unit': unit,
      };
}

/// DTO Model for ResourceAllocation.
class ResourceAllocationModel extends ResourceAllocation {
  const ResourceAllocationModel({
    required super.id,
    required super.items,
    required super.destinationType,
    required super.destinationId,
    required super.destinationName,
    required super.destinationDistrict,
    required super.priority,
    required super.vehicleId,
    required super.vehicleName,
    required super.assignedTeamId,
    required super.assignedTeamName,
    required super.estimatedArrival,
    required super.deliveryStatus,
    required super.createdAt,
    super.notes,
  });

  factory ResourceAllocationModel.fromJson(Map<String, dynamic> json) {
    final destTypeIdx = (json['destinationType'] as num?)?.toInt() ?? 0;
    final prioIdx = (json['priority'] as num?)?.toInt() ?? 0;
    final statusIdx = (json['deliveryStatus'] as num?)?.toInt() ?? 0;

    final itemsList = (json['items'] as List<dynamic>?)
            ?.map((e) => AllocatedItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ResourceAllocationModel(
      id: json['id'] as String? ?? '',
      items: itemsList,
      destinationType: destTypeIdx >= 0 && destTypeIdx < DestinationType.values.length
          ? DestinationType.values[destTypeIdx]
          : DestinationType.shelter,
      destinationId: json['destinationId'] as String? ?? '',
      destinationName: json['destinationName'] as String? ?? '',
      destinationDistrict: json['destinationDistrict'] as String? ?? '',
      priority: prioIdx >= 0 && prioIdx < AllocationPriority.values.length
          ? AllocationPriority.values[prioIdx]
          : AllocationPriority.high,
      vehicleId: json['vehicleId'] as String? ?? '',
      vehicleName: json['vehicleName'] as String? ?? '',
      assignedTeamId: json['assignedTeamId'] as String? ?? '',
      assignedTeamName: json['assignedTeamName'] as String? ?? '',
      estimatedArrival: json['estimatedArrival'] as String? ?? '30 mins',
      deliveryStatus: statusIdx >= 0 && statusIdx < DeliveryStatus.values.length
          ? DeliveryStatus.values[statusIdx]
          : DeliveryStatus.pending,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) {
          if (e is AllocatedItemModel) return e.toJson();
          return {
            'resourceItemId': e.resourceItemId,
            'resourceName': e.resourceName,
            'category': e.category.index,
            'quantity': e.quantity,
            'unit': e.unit,
          };
        }).toList(),
        'destinationType': destinationType.index,
        'destinationId': destinationId,
        'destinationName': destinationName,
        'destinationDistrict': destinationDistrict,
        'priority': priority.index,
        'vehicleId': vehicleId,
        'vehicleName': vehicleName,
        'assignedTeamId': assignedTeamId,
        'assignedTeamName': assignedTeamName,
        'estimatedArrival': estimatedArrival,
        'deliveryStatus': deliveryStatus.index,
        'createdAt': createdAt.toIso8601String(),
        'notes': notes,
      };

  ResourceAllocation toEntity() => this;
}
