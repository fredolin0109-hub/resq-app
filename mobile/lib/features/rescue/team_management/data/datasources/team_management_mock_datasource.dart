import '../../domain/entities/team_management_entities.dart';
import '../models/team_management_models.dart';

/// Abstract contract for Team and Fleet telemetry data.
abstract class TeamManagementDataSource {
  Future<List<RescueTeamDetailModel>> fetchTeams();
  Future<RescueTeamDetailModel?> fetchTeamById(String id);
  Future<List<VehicleModel>> fetchVehicles();
  Future<VehicleModel?> fetchVehicleById(String id);
  Future<List<TeamMemberModel>> fetchPersonnel();
  Future<RescueTeamDetailModel> dispatchTeam({
    required String teamId,
    required String missionId,
    required String priority,
    required String targetLocation,
    VehicleEntity? vehicle,
    List<String>? equipment,
  });
}

/// In-memory data source containing 10 Rescue Teams, 25 Personnel, and 15 Fleet Vehicles.
class TeamManagementMockDataSource implements TeamManagementDataSource {
  final Duration latency;

  TeamManagementMockDataSource({
    this.latency = const Duration(milliseconds: 100),
  });

  // 15 Comprehensive Fleet Vehicles
  static final List<VehicleModel> _vehicles = [
    const VehicleModel(
      id: 'veh_01',
      vehicleNumber: 'TN-72-RSQ-01',
      type: VehicleType.rescueBoat,
      typeName: 'Amphibious All-Terrain Rescue Boat',
      capacity: 8,
      fuelPercentage: 88,
      batteryPercentage: 94,
      maintenanceStatus: 'Operational - Certified',
      currentDriver: 'Officer Selvam K',
      location: 'Thamirabarani Basin Base',
      district: 'Tirunelveli',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_02',
      vehicleNumber: 'TN-58-RSQ-04',
      type: VehicleType.fireTruck,
      typeName: 'Hydraulic Extrication Heavy Truck',
      capacity: 6,
      fuelPercentage: 72,
      batteryPercentage: 80,
      maintenanceStatus: 'Operational - Inspected',
      currentDriver: 'Commander Mani R',
      location: 'Central Industrial Station',
      district: 'Chennai',
      status: VehicleStatus.dispatched,
    ),
    const VehicleModel(
      id: 'veh_03',
      vehicleNumber: 'TN-43-RSQ-09',
      type: VehicleType.supportVehicle,
      typeName: 'Highland 4x4 Winch Cruiser',
      capacity: 5,
      fuelPercentage: 90,
      batteryPercentage: 98,
      maintenanceStatus: 'Operational - Certified',
      currentDriver: 'Sgt. Bala V',
      location: 'Western Foothills Depot',
      district: 'Coimbatore',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_04',
      vehicleNumber: 'TN-01-AMB-11',
      type: VehicleType.ambulance,
      typeName: 'ICU Critical Care Mobile Ambulance',
      capacity: 4,
      fuelPercentage: 95,
      batteryPercentage: 92,
      maintenanceStatus: 'Operational - Sanitized',
      currentDriver: 'EMT Priya N',
      location: 'General Medical Center',
      district: 'Chennai',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_05',
      vehicleNumber: 'TN-64-DRN-02',
      type: VehicleType.drone,
      typeName: 'Thermal Search & Mapping Quad-Drone',
      capacity: 1,
      fuelPercentage: 100,
      batteryPercentage: 86,
      maintenanceStatus: 'Operational - Calibrated',
      currentDriver: 'Pilot Dinesh G',
      location: 'Vaigai Flood Watch Post',
      district: 'Madurai',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_06',
      vehicleNumber: 'TN-57-EM-01',
      type: VehicleType.earthMover,
      typeName: 'Debris Clearance Heavy Bulldozer',
      capacity: 2,
      fuelPercentage: 64,
      batteryPercentage: 75,
      maintenanceStatus: 'Operational',
      currentDriver: 'Operator Murugan T',
      location: 'Dindigul Rock Fort Sector',
      district: 'Dindigul',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_07',
      vehicleNumber: 'TN-72-AMB-08',
      type: VehicleType.ambulance,
      typeName: 'Field Triage Evacuation Ambulance',
      capacity: 4,
      fuelPercentage: 82,
      batteryPercentage: 89,
      maintenanceStatus: 'Operational',
      currentDriver: 'EMT Kumar S',
      location: 'Palayamkottai Post',
      district: 'Tirunelveli',
      status: VehicleStatus.dispatched,
    ),
    const VehicleModel(
      id: 'veh_08',
      vehicleNumber: 'TN-69-BOAT-03',
      type: VehicleType.rescueBoat,
      typeName: 'Coastal Inflatable Zodiac Raider',
      capacity: 6,
      fuelPercentage: 78,
      batteryPercentage: 85,
      maintenanceStatus: 'Operational',
      currentDriver: 'Diver Alex J',
      location: 'Pearl City Harbor Port',
      district: 'Thoothukudi',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_09',
      vehicleNumber: 'TN-27-FT-02',
      type: VehicleType.fireTruck,
      typeName: 'High-Expansion Foam Tanker',
      capacity: 4,
      fuelPercentage: 60,
      batteryPercentage: 70,
      maintenanceStatus: 'Scheduled Maintenance',
      currentDriver: 'Driver Ganesan B',
      location: 'Salem Steel Yard Station',
      district: 'Salem',
      status: VehicleStatus.maintenance,
    ),
    const VehicleModel(
      id: 'veh_10',
      vehicleNumber: 'TN-45-SV-07',
      type: VehicleType.supportVehicle,
      typeName: 'Logistics Relief Transport Truck',
      capacity: 10,
      fuelPercentage: 84,
      batteryPercentage: 90,
      maintenanceStatus: 'Operational',
      currentDriver: 'Driver Ramanathan P',
      location: 'Kaveri Delta Warehouse',
      district: 'Trichy',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_11',
      vehicleNumber: 'TN-33-DRN-05',
      type: VehicleType.drone,
      typeName: 'Heavy-Lift Medical Supply Drone',
      capacity: 1,
      fuelPercentage: 100,
      batteryPercentage: 96,
      maintenanceStatus: 'Operational - Standby',
      currentDriver: 'Pilot Aakash R',
      location: 'SIPCOT Industrial Command',
      district: 'Erode',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_12',
      vehicleNumber: 'TN-49-EM-03',
      type: VehicleType.earthMover,
      typeName: 'Hydraulic Trench Excavator',
      capacity: 2,
      fuelPercentage: 55,
      batteryPercentage: 68,
      maintenanceStatus: 'Operational',
      currentDriver: 'Operator Suresh M',
      location: 'Cauvery Canal Sector',
      district: 'Thanjavur',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_13',
      vehicleNumber: 'TN-23-AMB-03',
      type: VehicleType.ambulance,
      typeName: 'Advanced Life Support Ambulance',
      capacity: 4,
      fuelPercentage: 92,
      batteryPercentage: 94,
      maintenanceStatus: 'Operational',
      currentDriver: 'EMT Anand V',
      location: 'CMC Hospital Base',
      district: 'Vellore',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_14',
      vehicleNumber: 'TN-58-BOAT-09',
      type: VehicleType.rescueBoat,
      typeName: 'Rigid Hull High-Speed Patrol Boat',
      capacity: 8,
      fuelPercentage: 86,
      batteryPercentage: 90,
      maintenanceStatus: 'Operational',
      currentDriver: 'Diver Charles M',
      location: 'Adyar Estuary Base',
      district: 'Chennai',
      status: VehicleStatus.available,
    ),
    const VehicleModel(
      id: 'veh_15',
      vehicleNumber: 'TN-43-FT-05',
      type: VehicleType.fireTruck,
      typeName: 'Urban Pumper & Aerial Ladder Firetruck',
      capacity: 6,
      fuelPercentage: 40,
      batteryPercentage: 50,
      maintenanceStatus: 'Offline - Engine Overhaul',
      currentDriver: 'Station Chief Velu',
      location: 'Singanallur Fire HQ',
      district: 'Coimbatore',
      status: VehicleStatus.offline,
    ),
  ];

  // 25 Dedicated Personnel
  static final List<TeamMemberModel> _personnel = [
    // Alpha Squad (Tirunelveli)
    const TeamMemberModel(
      id: 'usr_01',
      name: 'Captain K. Natarajan',
      role: MemberRole.teamLeader,
      roleTitle: 'Swiftwater Rescue Commander',
      phone: '+91 98401 11223',
      badgeNumber: 'RSQ-LEAD-01',
      isLeader: true,
      bloodGroup: 'O+',
      certification: 'NDRF Level 4 Master Diver',
    ),
    const TeamMemberModel(
      id: 'usr_02',
      name: 'Dr. Sudha Chandran',
      role: MemberRole.paramedic,
      roleTitle: 'Lead Trauma Specialist',
      phone: '+91 98401 11224',
      badgeNumber: 'MED-041',
      bloodGroup: 'A+',
      certification: 'ACLS Wilderness Specialist',
    ),
    const TeamMemberModel(
      id: 'usr_03',
      name: 'R. Selvam',
      role: MemberRole.scubaDiver,
      roleTitle: 'Combat Diver & Boat Pilot',
      phone: '+91 98401 11225',
      badgeNumber: 'DVR-012',
      bloodGroup: 'B+',
      certification: 'PADI Master Scuba',
    ),
    const TeamMemberModel(
      id: 'usr_04',
      name: 'M. Vignesh',
      role: MemberRole.generalResponder,
      roleTitle: 'Swiftwater Rescue Tech',
      phone: '+91 98401 11226',
      badgeNumber: 'RES-088',
      bloodGroup: 'AB+',
      certification: 'NFPA 1670 Swiftwater',
    ),

    // Bravo Squad (Chennai)
    const TeamMemberModel(
      id: 'usr_05',
      name: 'Commander Mani Rajan',
      role: MemberRole.teamLeader,
      roleTitle: 'Heavy Urban SAR Lead',
      phone: '+91 97908 44551',
      badgeNumber: 'RSQ-LEAD-02',
      isLeader: true,
      bloodGroup: 'B+',
      certification: 'INSARAG Heavy SAR Lead',
    ),
    const TeamMemberModel(
      id: 'usr_06',
      name: 'Eng. Karthik S',
      role: MemberRole.heavyExtricationSpecialist,
      roleTitle: 'Structural Collapse Engineer',
      phone: '+91 97908 44552',
      badgeNumber: 'ENG-019',
      bloodGroup: 'O+',
      certification: 'Structural Integrity Specialist',
    ),
    const TeamMemberModel(
      id: 'usr_07',
      name: 'S. Aravind',
      role: MemberRole.heavyExtricationSpecialist,
      roleTitle: 'Hydraulic Tool Specialist',
      phone: '+91 97908 44553',
      badgeNumber: 'EXT-033',
      bloodGroup: 'A-',
      certification: 'Jaws of Life Certified',
    ),

    // Charlie Squad (Coimbatore)
    const TeamMemberModel(
      id: 'usr_08',
      name: 'Sgt. Bala Varma',
      role: MemberRole.teamLeader,
      roleTitle: 'Mountain & Slope Search Lead',
      phone: '+91 94432 77881',
      badgeNumber: 'RSQ-LEAD-03',
      isLeader: true,
      bloodGroup: 'A+',
      certification: 'High-Angle Rope Rigging Master',
    ),
    const TeamMemberModel(
      id: 'usr_09',
      name: 'Dinesh G',
      role: MemberRole.dronePilot,
      roleTitle: 'Thermal Aerial Recon Scout',
      phone: '+91 94432 77882',
      badgeNumber: 'DRN-005',
      bloodGroup: 'O-',
      certification: 'DGCA Certified Drone Pilot',
    ),
    const TeamMemberModel(
      id: 'usr_10',
      name: 'V. Prakash',
      role: MemberRole.generalResponder,
      roleTitle: 'High-Altitude EMT',
      phone: '+91 94432 77883',
      badgeNumber: 'MED-062',
      bloodGroup: 'B+',
      certification: 'Wilderness First Responder',
    ),

    // Delta Squad (Thoothukudi)
    const TeamMemberModel(
      id: 'usr_11',
      name: 'Capt. Alex Joseph',
      role: MemberRole.teamLeader,
      roleTitle: 'Marine Tactical Commander',
      phone: '+91 98433 99112',
      badgeNumber: 'RSQ-LEAD-04',
      isLeader: true,
      bloodGroup: 'O+',
      certification: 'Coast Guard Deep Water Lead',
    ),
    const TeamMemberModel(
      id: 'usr_12',
      name: 'Charles M',
      role: MemberRole.scubaDiver,
      roleTitle: 'Deep Sea Salvage Diver',
      phone: '+91 98433 99113',
      badgeNumber: 'DVR-031',
      bloodGroup: 'A+',
      certification: 'Commercial Diver Level 2',
    ),
    const TeamMemberModel(
      id: 'usr_13',
      name: 'S. Saravanan',
      role: MemberRole.paramedic,
      roleTitle: 'Drowning Resuscitation EMT',
      phone: '+91 98433 99114',
      badgeNumber: 'MED-078',
      bloodGroup: 'B-',
      certification: 'Hyperbaric Medicine Support',
    ),

    // Echo Air Squad (Madurai)
    const TeamMemberModel(
      id: 'usr_14',
      name: 'Maj. Vikramaditya',
      role: MemberRole.teamLeader,
      roleTitle: 'Flight Airlift Commander',
      phone: '+91 94880 33441',
      badgeNumber: 'RSQ-LEAD-05',
      isLeader: true,
      bloodGroup: 'AB+',
      certification: 'Commercial Helicopter Flight Lead',
    ),
    const TeamMemberModel(
      id: 'usr_15',
      name: 'Dr. Anitha Mohan',
      role: MemberRole.paramedic,
      roleTitle: 'Flight Trauma Surgeon',
      phone: '+91 94880 33442',
      badgeNumber: 'MED-009',
      bloodGroup: 'O+',
      certification: 'Critical Air Evacuation Specialist',
    ),
    const TeamMemberModel(
      id: 'usr_16',
      name: 'P. Murugan',
      role: MemberRole.generalResponder,
      roleTitle: 'Helicopter Hoist Operator',
      phone: '+91 94880 33443',
      badgeNumber: 'AIR-022',
      bloodGroup: 'A+',
      certification: 'Winch & Hoist Safety Tech',
    ),

    // Foxtrot HAZMAT Squad (Erode)
    const TeamMemberModel(
      id: 'usr_17',
      name: 'Chief Inspector Gopinath',
      role: MemberRole.teamLeader,
      roleTitle: 'Chemical & Industrial Hazard Lead',
      phone: '+91 97500 11994',
      badgeNumber: 'RSQ-LEAD-06',
      isLeader: true,
      bloodGroup: 'B+',
      certification: 'HAZMAT Incident Commander',
    ),
    const TeamMemberModel(
      id: 'usr_18',
      name: 'Aakash R',
      role: MemberRole.dronePilot,
      roleTitle: 'Gas Detection Drone Operator',
      phone: '+91 97500 11995',
      badgeNumber: 'DRN-018',
      bloodGroup: 'O+',
      certification: 'Industrial Reconnaissance Certified',
    ),

    // Golf Urban Squad (Salem)
    const TeamMemberModel(
      id: 'usr_19',
      name: 'Lt. Sundarraj M',
      role: MemberRole.teamLeader,
      roleTitle: 'Urban Search and Rescue Lead',
      phone: '+91 94433 55661',
      badgeNumber: 'RSQ-LEAD-07',
      isLeader: true,
      bloodGroup: 'O+',
      certification: 'Urban Search Canine Liaison',
    ),
    const TeamMemberModel(
      id: 'usr_20',
      name: 'Ganesan B',
      role: MemberRole.driverMechanic,
      roleTitle: 'Heavy Carrier Rig Driver',
      phone: '+91 94433 55662',
      badgeNumber: 'DRV-044',
      bloodGroup: 'A+',
      certification: 'Emergency Vehicle Ops Certified',
    ),

    // Hotel Dive Squad (Dindigul)
    const TeamMemberModel(
      id: 'usr_21',
      name: 'Sub-Inspector Murugan T',
      role: MemberRole.teamLeader,
      roleTitle: 'Lake & Well Rescue Specialist',
      phone: '+91 98421 22331',
      badgeNumber: 'RSQ-LEAD-08',
      isLeader: true,
      bloodGroup: 'B+',
      certification: 'Enclosed Space Rescue Master',
    ),
    const TeamMemberModel(
      id: 'usr_22',
      name: 'K. Prabhu',
      role: MemberRole.scubaDiver,
      roleTitle: 'Underwater Search Specialist',
      phone: '+91 98421 22332',
      badgeNumber: 'DVR-055',
      bloodGroup: 'O-',
      certification: 'Rescue Diver Level 3',
    ),

    // India Logistics Squad (Trichy)
    const TeamMemberModel(
      id: 'usr_23',
      name: 'Capt. Ramanathan P',
      role: MemberRole.teamLeader,
      roleTitle: 'Logistics & Supply Dispatch Chief',
      phone: '+91 98942 99881',
      badgeNumber: 'RSQ-LEAD-09',
      isLeader: true,
      bloodGroup: 'A+',
      certification: 'Disaster Supply Chain Master',
    ),
    const TeamMemberModel(
      id: 'usr_24',
      name: 'S. Deepa',
      role: MemberRole.generalResponder,
      roleTitle: 'Shelter Field Coordinator',
      phone: '+91 98942 99882',
      badgeNumber: 'LOG-014',
      bloodGroup: 'O+',
      certification: 'Emergency Food & Aid Logistics',
    ),

    // Juliet Medical Squad (Vellore)
    const TeamMemberModel(
      id: 'usr_25',
      name: 'Dr. Anand V',
      role: MemberRole.teamLeader,
      roleTitle: 'Field Hospital Medical Officer',
      phone: '+91 98409 66771',
      badgeNumber: 'RSQ-LEAD-10',
      isLeader: true,
      bloodGroup: 'AB-',
      certification: 'Advanced Disaster Medical Ops',
    ),
  ];

  // 10 Detailed Rescue Teams
  static final List<RescueTeamDetailModel> _teams = [
    // 1. Alpha Swiftwater Squadron (Tirunelveli)
    RescueTeamDetailModel(
      id: 'TEAM-ALPHA-1',
      name: 'Alpha Swiftwater Squadron',
      district: 'Tirunelveli',
      status: TeamStatus.available,
      leaderName: 'Captain K. Natarajan',
      leaderPhone: '+91 98401 11223',
      membersCount: 4,
      members: _personnel.sublist(0, 4),
      assignedVehicle: _vehicles[0],
      currentMission: null,
      equipment: ['Zodiac Inflatable Raft', 'Water Sonar', '4x Swiftwater Life Vests', 'Thermal Night Vision Scope'],
      medicalKits: ['Trauma Bag Alpha', 'Oxygen Resuscitator 5L', 'Burn & Hypothermia Kit'],
      communicationDevices: ['Satellite Mesh Radio 42', 'VHF Marine Channel 16', 'Encrypted Satellite Phone'],
      fuelLevel: 88,
      batteryLevel: 94,
      gpsCoordinates: '8.7139° N, 77.7567° E',
      missionHistoryCount: 42,
      pastMissions: ['Palayamkottai Flash Flood Relief', 'Thamirabarani Causeway Evacuation'],
    ),

    // 2. Bravo Heavy Extrication Unit (Chennai)
    RescueTeamDetailModel(
      id: 'TEAM-BRAVO-2',
      name: 'Bravo Heavy Extrication Unit',
      district: 'Chennai',
      status: TeamStatus.busy,
      leaderName: 'Commander Mani Rajan',
      leaderPhone: '+91 97908 44551',
      membersCount: 3,
      members: _personnel.sublist(4, 7),
      assignedVehicle: _vehicles[1],
      currentMission: 'SOS-9402 • Velachery Structural Collapse',
      equipment: ['Hydraulic Jaws of Life', 'Pneumatic Concrete Shoring Kit', 'Diamond Tip Rescue Cutters'],
      medicalKits: ['Crush Injury Trauma Kit', 'Field Amputation Kit', 'Spine Immobilizers'],
      communicationDevices: ['Digital UHF Mesh Transceiver', 'Fiber Optical Audio Cam'],
      fuelLevel: 72,
      batteryLevel: 80,
      gpsCoordinates: '12.9759° N, 80.2212° E',
      missionHistoryCount: 68,
      pastMissions: ['Velachery Apartment Collapse', 'Marina Cyclone Shoring Support'],
    ),

    // 3. Charlie Highland & Slope Squad (Coimbatore)
    RescueTeamDetailModel(
      id: 'TEAM-CHARLIE-3',
      name: 'Charlie Highland Rescue Squad',
      district: 'Coimbatore',
      status: TeamStatus.emergency,
      leaderName: 'Sgt. Bala Varma',
      leaderPhone: '+91 94432 77881',
      membersCount: 3,
      members: _personnel.sublist(7, 10),
      assignedVehicle: _vehicles[2],
      currentMission: 'SOS-9403 • Siruvani Landslide Mudflow',
      equipment: ['High-Angle Rigging Ropes (200m)', 'Stokes Basket Stretcher', 'Pneumatic Winch (5-Ton)'],
      medicalKits: ['High-Altitude Trauma Kit', 'Suture & Orthopedic Splint Kit'],
      communicationDevices: ['Satellite InReach Messenger', 'Long-Range VHF Radio'],
      fuelLevel: 90,
      batteryLevel: 98,
      gpsCoordinates: '10.9324° N, 76.7821° E',
      missionHistoryCount: 35,
      pastMissions: ['Marudhamalai Ghat Road Winch', 'Valparai Mountain Rescue'],
    ),

    // 4. Delta NDRF Coastal Assault (Thoothukudi)
    RescueTeamDetailModel(
      id: 'TEAM-DELTA-4',
      name: 'Delta NDRF Coastal Assault Unit',
      district: 'Thoothukudi',
      status: TeamStatus.available,
      leaderName: 'Capt. Alex Joseph',
      leaderPhone: '+91 98433 99112',
      membersCount: 3,
      members: _personnel.sublist(10, 13),
      assignedVehicle: _vehicles[7],
      currentMission: null,
      equipment: ['Rigid Inflatable Hull Boat', 'Marine Sonar Sounder', 'High-Output Bilge Pumps (2000 GPH)'],
      medicalKits: ['Drowning Critical Resuscitator', 'Thermal Foil Survival Blankets'],
      communicationDevices: ['Marine VHF Dual Channel', 'AIS Marine Transponder'],
      fuelLevel: 78,
      batteryLevel: 85,
      gpsCoordinates: '8.7642° N, 78.1348° E',
      missionHistoryCount: 54,
      pastMissions: ['Pearl City Trawler Salvage', 'Saltpan Lagoon Inundation Extraction'],
    ),

    // 5. Echo Air-Medical Airlift (Madurai)
    RescueTeamDetailModel(
      id: 'TEAM-ECHO-5',
      name: 'Echo Airborne Medical Airlift',
      district: 'Madurai',
      status: TeamStatus.available,
      leaderName: 'Maj. Vikramaditya',
      leaderPhone: '+91 94880 33441',
      membersCount: 3,
      members: _personnel.sublist(13, 16),
      assignedVehicle: _vehicles[4],
      currentMission: null,
      equipment: ['Helicopter Hoist Basket', 'Infrared Forward FLIR Camera', 'Heavy Rigging Harness'],
      medicalKits: ['Portable ICU Ventilator', 'Blood Transfusion Carrier Pod', 'AED Defibrillator'],
      communicationDevices: ['Aviation Band Radio 121.5 MHz', 'Live Telemetry Video Uplink'],
      fuelLevel: 95,
      batteryLevel: 92,
      gpsCoordinates: '9.9252° N, 78.1198° E',
      missionHistoryCount: 29,
      pastMissions: ['Vaigai Causeway Helicopter Hoist', 'Kodaikanal Valley Medical Airlift'],
    ),

    // 6. Foxtrot Industrial HAZMAT (Erode)
    RescueTeamDetailModel(
      id: 'TEAM-FOXTROT-6',
      name: 'Foxtrot Industrial HAZMAT Squad',
      district: 'Erode',
      status: TeamStatus.busy,
      leaderName: 'Chief Inspector Gopinath',
      leaderPhone: '+91 97500 11994',
      membersCount: 2,
      members: _personnel.sublist(16, 18),
      assignedVehicle: _vehicles[10],
      currentMission: 'SOS-9411 • SIPCOT Chemical Fire Smoke',
      equipment: ['Level-A Gas Encapsulating Suits', 'Multi-Gas Photoionization Detector', 'Decontamination Shower Station'],
      medicalKits: ['Cyanide & Toxic Inhalation Antidote Kit', 'Chemical Burn Treatment Packs'],
      communicationDevices: ['Intrinsically Safe Radios (ATEX)', 'Mesh Perimeter Air Monitors'],
      fuelLevel: 100,
      batteryLevel: 96,
      gpsCoordinates: '11.3410° N, 77.7172° E',
      missionHistoryCount: 19,
      pastMissions: ['Perundurai Industrial Smoke Evacuation', 'Textile Dye Plant Spill Containment'],
    ),

    // 7. Golf Urban SAR Unit (Salem)
    RescueTeamDetailModel(
      id: 'TEAM-GOLF-7',
      name: 'Golf Urban Search Squad',
      district: 'Salem',
      status: TeamStatus.available,
      leaderName: 'Lt. Sundarraj M',
      leaderPhone: '+91 94433 55661',
      membersCount: 2,
      members: _personnel.sublist(18, 20),
      assignedVehicle: _vehicles[8],
      currentMission: null,
      equipment: ['Ground Penetrating Radar', 'Acoustic Life Detector Probes', 'Pneumatic Breakers'],
      medicalKits: ['First Aid Trauma Station', 'Burn Dressing Packs'],
      communicationDevices: ['Local Tactical Mesh Radio', 'Handheld GPS Survey Units'],
      fuelLevel: 60,
      batteryLevel: 70,
      gpsCoordinates: '11.6643° N, 78.1460° E',
      missionHistoryCount: 31,
      pastMissions: ['Yercaud Foothill Mudslide Survey', 'Hasthampatti Building Crack Evacuation'],
    ),

    // 8. Hotel Enclosed Dive Squad (Dindigul)
    RescueTeamDetailModel(
      id: 'TEAM-HOTEL-8',
      name: 'Hotel Lake & Enclosed Dive Squad',
      district: 'Dindigul',
      status: TeamStatus.available,
      leaderName: 'Sub-Inspector Murugan T',
      leaderPhone: '+91 98421 22331',
      membersCount: 2,
      members: _personnel.sublist(20, 22),
      assignedVehicle: _vehicles[5],
      currentMission: null,
      equipment: ['Deep Well Winch Tripod', 'Full Face Nitrox Diving Mask', 'Underwater Search Light 10k Lumens'],
      medicalKits: ['Hyperbaric Oxygen Mask', 'Trauma Splinting Kit'],
      communicationDevices: ['Underwater Hardwire Intercom', 'VHF Transceiver'],
      fuelLevel: 64,
      batteryLevel: 75,
      gpsCoordinates: '10.3673° N, 77.9803° E',
      missionHistoryCount: 24,
      pastMissions: ['Palani Foothill Well Rescue', 'Dindigul Tank Extraction'],
    ),

    // 9. India Logistics & Supply Squad (Trichy)
    RescueTeamDetailModel(
      id: 'TEAM-INDIA-9',
      name: 'India Logistics & Relief Fleet',
      district: 'Tiruchirappalli',
      status: TeamStatus.available,
      leaderName: 'Capt. Ramanathan P',
      leaderPhone: '+91 98942 99881',
      membersCount: 2,
      members: _personnel.sublist(22, 24),
      assignedVehicle: _vehicles[9],
      currentMission: null,
      equipment: ['Mobile Water Purification Plant (500L/hr)', 'Portable Diesel Generators (15kVA)', 'High-Capacity Tents (50 units)'],
      medicalKits: ['Mass Casualty Medical Supplies', 'Sanitation & Disinfection Kits'],
      communicationDevices: ['Satellite Broadband Dish', 'Mesh Base Node 01'],
      fuelLevel: 84,
      batteryLevel: 90,
      gpsCoordinates: '10.7905° N, 78.7047° E',
      missionHistoryCount: 51,
      pastMissions: ['Srirangam Island Relief Supply', 'Kaveri Delta Flood Camp Provisioning'],
    ),

    // 10. Juliet Medical Field Triage (Vellore)
    RescueTeamDetailModel(
      id: 'TEAM-JULIET-10',
      name: 'Juliet Rapid Field Hospital',
      district: 'Vellore',
      status: TeamStatus.offline,
      leaderName: 'Dr. Anand V',
      leaderPhone: '+91 98409 66771',
      membersCount: 1,
      members: [_personnel[24]],
      assignedVehicle: _vehicles[12],
      currentMission: null,
      equipment: ['Inflatable Field Surgical Tent', 'Mobile X-Ray & Ultrasound', 'Sterile Autoclave Station'],
      medicalKits: ['Emergency Surgical Suite', 'Universal Plasma & IV Fluids (100 units)'],
      communicationDevices: ['Hospital Telemedicine Uplink', 'Tactical VoIP Satellite Phone'],
      fuelLevel: 92,
      batteryLevel: 94,
      gpsCoordinates: '12.9165° N, 79.1325° E',
      missionHistoryCount: 18,
      pastMissions: ['Palar Riverbed Evacuation Triage', 'Katpadi Mass Casualty Drill'],
    ),
  ];

  @override
  Future<List<RescueTeamDetailModel>> fetchTeams() async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    return List.unmodifiable(_teams);
  }

  @override
  Future<RescueTeamDetailModel?> fetchTeamById(String id) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    try {
      return _teams.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<VehicleModel>> fetchVehicles() async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    return List.unmodifiable(_vehicles);
  }

  @override
  Future<VehicleModel?> fetchVehicleById(String id) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<TeamMemberModel>> fetchPersonnel() async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    return List.unmodifiable(_personnel);
  }

  @override
  Future<RescueTeamDetailModel> dispatchTeam({
    required String teamId,
    required String missionId,
    required String priority,
    required String targetLocation,
    VehicleEntity? vehicle,
    List<String>? equipment,
  }) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    final index = _teams.indexWhere((t) => t.id == teamId);
    if (index == -1) {
      throw Exception('Rescue squad $teamId not found.');
    }

    final current = _teams[index];
    final updatedVehicle = vehicle != null
        ? VehicleModel(
            id: vehicle.id,
            vehicleNumber: vehicle.vehicleNumber,
            type: vehicle.type,
            typeName: vehicle.typeName,
            capacity: vehicle.capacity,
            fuelPercentage: vehicle.fuelPercentage,
            batteryPercentage: vehicle.batteryPercentage,
            maintenanceStatus: vehicle.maintenanceStatus,
            currentDriver: vehicle.currentDriver,
            location: targetLocation,
            district: current.district,
            status: VehicleStatus.dispatched,
          )
        : current.assignedVehicle;

    final updated = current.copyWith(
      status: TeamStatus.busy,
      currentMission: '$missionId • $targetLocation ($priority Priority)',
      assignedVehicle: updatedVehicle,
      equipment: equipment ?? current.equipment,
      pastMissions: List<String>.from(current.pastMissions)..insert(0, '$missionId at $targetLocation'),
      missionHistoryCount: current.missionHistoryCount + 1,
    ) as RescueTeamDetailModel;

    _teams[index] = updated;
    return updated;
  }
}
