import '../../domain/entities/sos_incident_entity.dart';
import '../models/sos_incident_model.dart';

/// Abstract contract for SOS Distress Data Source.
abstract class SosDataSource {
  Future<List<SosIncidentModel>> fetchAllIncidents();
  Future<SosIncidentModel?> fetchIncidentById(String id);
  Future<List<RescueTeamModel>> fetchAvailableTeams();
  Future<SosIncidentModel> assignTeam(String incidentId, RescueTeamModel team);
  Future<SosIncidentModel> updateStatus(String incidentId, SosStatus status, String? note);
}

/// In-Memory Mock Data Source featuring 20+ realistic Tamil Nadu emergency incidents.
class SosMockDataSource implements SosDataSource {
  final Duration latency;

  SosMockDataSource({
    this.latency = const Duration(milliseconds: 100),
  });

  static final List<RescueTeamModel> _availableTeams = [
    const RescueTeamModel(
      id: 'team_alpha_1',
      name: 'Alpha Swiftwater Squadron 1',
      vehicle: 'Amphibious All-Terrain 4x4 (TN-72-RSQ-01)',
      members: '4 Responders (1 Lead Paramedic, 2 Scuba Divers, 1 Pilot)',
      equipment: ['Zodiac Inflatable Boat', 'Trauma Resuscitator', 'Life Jackets', 'Thermal Drone'],
      distanceKm: 1.8,
      estimatedArrivalMinutes: 6,
      isAvailable: true,
    ),
    const RescueTeamModel(
      id: 'team_bravo_2',
      name: 'Bravo Heavy Extrication Unit',
      vehicle: 'Hydraulic Rescue Carrier (TN-58-RSQ-04)',
      members: '5 Responders (2 Structural Engineers, 2 Heavy Cutters, 1 Medic)',
      equipment: ['Hydraulic Jaws of Life', 'Pneumatic Lifting Bags', 'Snake Eye Fiber Camera'],
      distanceKm: 3.4,
      estimatedArrivalMinutes: 11,
      isAvailable: true,
    ),
    const RescueTeamModel(
      id: 'team_charlie_3',
      name: 'Charlie Highland & Slope Rescue',
      vehicle: 'High-Altitude 4x4 Winch Cruiser (TN-43-RSQ-09)',
      members: '4 Responders (2 Mountaineers, 1 Wilderness EMT, 1 Drone Scout)',
      equipment: ['High-Angle Rope Rigging', 'Stokes Basket Stretcher', 'Satellite Messenger'],
      distanceKm: 5.2,
      estimatedArrivalMinutes: 15,
      isAvailable: true,
    ),
    const RescueTeamModel(
      id: 'team_delta_4',
      name: 'Delta NDRF Coastal Assault Battalion',
      vehicle: 'Rigid Inflatable Hull Boat (NDRF-TN-02)',
      members: '6 Responders (4 Coastal Divers, 2 Emergency Trauma Doctors)',
      equipment: ['Sonar Sounder', 'High-Output Bilge Pumps', 'Floating Trauma Pods'],
      distanceKm: 6.8,
      estimatedArrivalMinutes: 18,
      isAvailable: true,
    ),
    const RescueTeamModel(
      id: 'team_echo_5',
      name: 'Echo Airborne Medical Airlift',
      vehicle: 'Emergency Rescue Helicopter (RESQ-CH-01)',
      members: '3 Responders (1 Flight Surgeon, 1 Hoist Operator, 1 Pilot)',
      equipment: ['Helicopter Hoist Basket', 'ICU Portable Ventilator', 'AED Defibrillator'],
      distanceKm: 12.5,
      estimatedArrivalMinutes: 8,
      isAvailable: true,
    ),
  ];

  static final List<SosIncidentModel> _mockIncidents = [
    // 1. Critical Flash Flood in Tirunelveli
    SosIncidentModel(
      id: 'SOS-9401',
      emergencyType: 'Flash Flood Submersion',
      priority: SosPriority.critical,
      status: SosStatus.received,
      civilianName: 'Ramesh Sundaram',
      civilianPhone: '+91 98401 22345',
      district: 'Tirunelveli',
      locationAddress: 'No. 42, Thamirabarani River Bank Causeway, Palayamkottai',
      latitude: 8.7139,
      longitude: 77.7567,
      distanceKm: 2.1,
      peopleCount: 5,
      riskLevel: 'Severe Flood Surge (Water Level > 6ft)',
      nearbyHospitals: ['Tirunelveli Govt Medical College', 'Galaxy Hospital'],
      nearbyShelters: ['Palayamkottai Relief Camp 1', 'Collectorate Indoor Shelter'],
      imagePlaceholders: ['flood_water_surge.jpg', 'rooftop_distress.jpg'],
      notes: 'Water rising rapidly. Family trapped on terrace with elderly grandmother and 1 infant.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Distress Beacon Received',
          description: 'Automatic GPS SOS distress broadcast triggered via mobile satellite mesh.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          isCompleted: true,
        ),
      ],
    ),

    // 2. Critical Building Collapse in Chennai
    SosIncidentModel(
      id: 'SOS-9402',
      emergencyType: 'Structural Building Collapse',
      priority: SosPriority.critical,
      status: SosStatus.assigned,
      civilianName: 'Ananya Krishnan',
      civilianPhone: '+91 97908 11442',
      district: 'Chennai',
      locationAddress: 'Block 4, Velachery Lake View Apartments, Velachery',
      latitude: 12.9759,
      longitude: 80.2212,
      distanceKm: 3.5,
      peopleCount: 4,
      riskLevel: 'Critical Structural Instability',
      nearbyHospitals: ['Rajiv Gandhi Govt General Hospital', 'Apollo Hospital'],
      nearbyShelters: ['Velachery Evacuation Depot', 'Marina Tsunami Shelter Base'],
      assignedTeam: _availableTeams[1],
      imagePlaceholders: ['rubble_collapse.jpg'],
      notes: 'Second floor slab partially collapsed. Two adults and two children trapped in rear room.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Distress Beacon Received',
          description: 'Emergency civilian call routed to Command Center.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Rescue Squad Assigned',
          description: 'Assigned to Bravo Heavy Extrication Unit.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
          isCompleted: true,
        ),
      ],
    ),

    // 3. High Risk Landslide in Coimbatore
    SosIncidentModel(
      id: 'SOS-9403',
      emergencyType: 'Landslide Mudflow Trapped',
      priority: SosPriority.high,
      status: SosStatus.enRoute,
      civilianName: 'Vigneshwaran P',
      civilianPhone: '+91 94432 99881',
      district: 'Coimbatore',
      locationAddress: 'Siruvani Foothills Road Mile 8, Alandurai',
      latitude: 10.9324,
      longitude: 76.7821,
      distanceKm: 5.8,
      peopleCount: 3,
      riskLevel: 'High Slope Mudflow',
      nearbyHospitals: ['Coimbatore Medical College', 'PSG Hospitals'],
      nearbyShelters: ['VOC Ground Evacuation Base'],
      assignedTeam: _availableTeams[2],
      imagePlaceholders: ['mudslide_road_block.jpg'],
      notes: 'Vehicle swept off road into soft mud embankment. Driver conscious with minor leg injury.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Distress Signal Logged',
          description: 'Mesh network beacon detected.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Team Assigned',
          description: 'Charlie Highland Squad dispatched.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.enRoute,
          title: 'Team En Route',
          description: 'Rescue 4x4 Cruiser moving with siren and winch rig.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
          isCompleted: true,
        ),
      ],
    ),

    // 4. Critical River Surge in Madurai
    SosIncidentModel(
      id: 'SOS-9404',
      emergencyType: 'River Surge & Canal Breach',
      priority: SosPriority.critical,
      status: SosStatus.onScene,
      civilianName: 'Meenakshi Sundaram',
      civilianPhone: '+91 94880 77123',
      district: 'Madurai',
      locationAddress: 'Goripalayam CauseWay Bridge Lowland, Madurai',
      latitude: 9.9320,
      longitude: 78.1285,
      distanceKm: 1.4,
      peopleCount: 6,
      riskLevel: 'Extreme Water Current (14 knots)',
      nearbyHospitals: ['Madurai Govt Rajaji Hospital', 'Meenakshi Mission'],
      nearbyShelters: ['Vaigai Relief Base Depot'],
      assignedTeam: _availableTeams[0],
      imagePlaceholders: ['river_surging_causeway.jpg'],
      notes: '6 pedestrians clinging to concrete pillar under bridge. Alpha Squadron deployed boat.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Distress Logged',
          description: 'Bridge watch alert verified.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 32)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Assigned to Alpha Squadron',
          description: 'Rapid boat squad designated.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.enRoute,
          title: 'En Route',
          description: 'Trailer launched at Vaigai gate.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.onScene,
          title: 'Team Arrived on Scene',
          description: 'Zodiac boat entering current. Rescue harness lowered.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
          isCompleted: true,
        ),
      ],
    ),

    // 5. Resolved Flash Flood Evacuation in Dindigul
    SosIncidentModel(
      id: 'SOS-9405',
      emergencyType: 'Flash Flood House Inundation',
      priority: SosPriority.medium,
      status: SosStatus.rescueCompleted,
      civilianName: 'Karthik Raja',
      civilianPhone: '+91 98421 55667',
      district: 'Dindigul',
      locationAddress: 'Palani Road Extension, Dindigul Town',
      latitude: 10.3673,
      longitude: 77.9803,
      distanceKm: 4.1,
      peopleCount: 2,
      riskLevel: 'Receding Flood Waters',
      nearbyHospitals: ['Dindigul Medical College Hospital'],
      nearbyShelters: ['Rotary Shelter Camp'],
      assignedTeam: _availableTeams[0],
      imagePlaceholders: ['rescued_family.jpg'],
      notes: 'Both victims successfully evacuated to Rotary Relief Camp. Medical triage verified clear.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Incident Received',
          description: 'Emergency alert logged.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Team Assigned',
          description: 'Alpha Squadron assigned.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.enRoute,
          title: 'En Route',
          description: 'Vehicles departed.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.onScene,
          title: 'Arrived',
          description: 'Reached residence.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.rescueCompleted,
          title: 'Rescue Completed',
          description: 'Victims escorted safely to shelter.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isCompleted: true,
        ),
      ],
    ),

    // 6. Closed Mission in Salem
    SosIncidentModel(
      id: 'SOS-9406',
      emergencyType: 'Medical Trauma Transport',
      priority: SosPriority.low,
      status: SosStatus.closed,
      civilianName: 'Revathi S',
      civilianPhone: '+91 93610 88231',
      district: 'Salem',
      locationAddress: 'Hasthampatti Main Road, Salem',
      latitude: 11.6643,
      longitude: 78.1460,
      distanceKm: 8.2,
      peopleCount: 1,
      riskLevel: 'Low',
      nearbyHospitals: ['Mohan Kumaramangalam Govt Hospital'],
      nearbyShelters: ['Hasthampatti Relief Center'],
      imagePlaceholders: [],
      notes: 'Patient admitted to Mohan Kumaramangalam General Hospital. Mission closed by Control Officer.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Alert Logged',
          description: 'Medical call logged.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.closed,
          title: 'Mission Closed',
          description: 'Hospital confirmation logged.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isCompleted: true,
        ),
      ],
    ),

    // 7. Coastal Cyclone in Thoothukudi
    SosIncidentModel(
      id: 'SOS-9407',
      emergencyType: 'Fishing Boat Engine Stall',
      priority: SosPriority.high,
      status: SosStatus.assigned,
      civilianName: 'Antony Cruz',
      civilianPhone: '+91 98433 11778',
      district: 'Thoothukudi',
      locationAddress: '2 Nautical Miles Off Pearl City Harbor',
      latitude: 8.7642,
      longitude: 78.1348,
      distanceKm: 4.8,
      peopleCount: 4,
      riskLevel: 'Rough Sea State (Waves > 3.5m)',
      nearbyHospitals: ['Thoothukudi Medical College'],
      nearbyShelters: ['Pearl City Relief Base'],
      assignedTeam: _availableTeams[3],
      imagePlaceholders: ['boat_in_high_seas.jpg'],
      notes: 'Trawler adrift without engine in gale winds. NDRF Coast unit en route with tow line.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Coastguard Signal Received',
          description: 'Marine VHF Channel 16 relay.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Assigned to Delta Coast Squadron',
          description: 'High power rigid boat dispatched.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isCompleted: true,
        ),
      ],
    ),

    // 8. Palani Temple Stairway Hazard
    SosIncidentModel(
      id: 'SOS-9408',
      emergencyType: 'Mountain Stairway Structural Crack',
      priority: SosPriority.medium,
      status: SosStatus.received,
      civilianName: 'Senthil Kumar',
      civilianPhone: '+91 94441 33221',
      district: 'Dindigul',
      locationAddress: 'Palani Hill Temple Stairway Steps 420-450, Palani',
      latitude: 10.4500,
      longitude: 77.5167,
      distanceKm: 0.9,
      peopleCount: 12,
      riskLevel: 'Crowd Congestion Risk',
      nearbyHospitals: ['Palani Govt Hospital'],
      nearbyShelters: ['Hillview Relief Center'],
      imagePlaceholders: [],
      notes: 'Heavy rainwater overflowing mountain steps. Pilgrims stranded on mid-tier pavilion.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 11)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Distress Logged',
          description: 'Temple security SOS triggered.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 11)),
          isCompleted: true,
        ),
      ],
    ),

    // 9. Udumalpet Canal Overflow
    SosIncidentModel(
      id: 'SOS-9409',
      emergencyType: 'Amaravathi Canal Inundation',
      priority: SosPriority.high,
      status: SosStatus.received,
      civilianName: 'Bala Murugan',
      civilianPhone: '+91 99420 88712',
      district: 'Tiruppur',
      locationAddress: 'Amaravathi Nagar Village, Udumalpet',
      latitude: 10.5847,
      longitude: 77.2475,
      distanceKm: 3.2,
      peopleCount: 7,
      riskLevel: 'Canal Overflow Water Surge',
      nearbyHospitals: ['Udumalpet Govt Hospital'],
      nearbyShelters: ['Town Hall Relief Base'],
      imagePlaceholders: [],
      notes: 'Canal breached banks. Water entering 3 households in lowland colony.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Distress Logged',
          description: 'Villagers group SOS sent.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
          isCompleted: true,
        ),
      ],
    ),

    // 10. Trichy Srirangam River Island Evacuation
    SosIncidentModel(
      id: 'SOS-9410',
      emergencyType: 'River Island Cutoff Evacuation',
      priority: SosPriority.high,
      status: SosStatus.assigned,
      civilianName: 'Deepa Natarajan',
      civilianPhone: '+91 98942 66778',
      district: 'Tiruchirappalli',
      locationAddress: 'Kollidam River Causeway Bank, Srirangam, Trichy',
      latitude: 10.7905,
      longitude: 78.7047,
      distanceKm: 3.6,
      peopleCount: 8,
      riskLevel: 'Kollidam Water Discharge Surge',
      nearbyHospitals: ['Trichy Mahatma Gandhi Govt Hospital'],
      nearbyShelters: ['Srirangam Evacuation Camp'],
      assignedTeam: _availableTeams[0],
      imagePlaceholders: [],
      notes: 'Causeway submerged by 4 feet. Evacuation boat required for 8 farm workers.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 36)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Received',
          description: 'Call from Srirangam ward.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 36)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Team Assigned',
          description: 'Alpha Boat squad designated.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          isCompleted: true,
        ),
      ],
    ),

    // 11. Erode Industrial Fire Hazard
    SosIncidentModel(
      id: 'SOS-9411',
      emergencyType: 'Textile Warehouse Chemical Smoke',
      priority: SosPriority.critical,
      status: SosStatus.enRoute,
      civilianName: 'Gopinath E',
      civilianPhone: '+91 97500 44332',
      district: 'Erode',
      locationAddress: 'SIPCOT Industrial Area Phase 2, Perundurai Road, Erode',
      latitude: 11.3410,
      longitude: 77.7172,
      distanceKm: 6.1,
      peopleCount: 15,
      riskLevel: 'Toxic Smoke & Fire Hazard',
      nearbyHospitals: ['Erode Govt Headquarters Hospital'],
      nearbyShelters: ['Erode Central Camp'],
      assignedTeam: _availableTeams[1],
      imagePlaceholders: [],
      notes: 'Dense chemical smoke. 15 workers in assembly area needing oxygen masks and triage.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 22)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Fire Sensor Beacon Received',
          description: 'Industrial smoke alarm automated distress.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 22)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Heavy Squad Assigned',
          description: 'Breathing apparatus team dispatched.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 16)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.enRoute,
          title: 'En Route',
          description: 'Rescue truck approaching via Highway 47.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          isCompleted: true,
        ),
      ],
    ),

    // 12. Thanjavur Paddy Lowland Flooding
    SosIncidentModel(
      id: 'SOS-9412',
      emergencyType: 'Agricultural Flood Inundation',
      priority: SosPriority.medium,
      status: SosStatus.received,
      civilianName: 'Manickam V',
      civilianPhone: '+91 94420 11994',
      district: 'Thanjavur',
      locationAddress: 'Kallanai Canal Feeder, Thiruvaiyaru, Thanjavur',
      latitude: 10.7870,
      longitude: 79.1378,
      distanceKm: 5.0,
      peopleCount: 3,
      riskLevel: 'Medium Water Level',
      nearbyHospitals: ['Thanjavur Medical College'],
      nearbyShelters: ['Big Temple Relief Grounds'],
      imagePlaceholders: [],
      notes: 'Farm house surrounded by canal runoff. Cattle and 3 family members safe on higher mound.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 19)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Alert Received',
          description: 'Civilian mobile distress ping.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 19)),
          isCompleted: true,
        ),
      ],
    ),

    // 13. Vellore Palar River Sandbar Trapped
    SosIncidentModel(
      id: 'SOS-9413',
      emergencyType: 'Palar River Sandbar Isolation',
      priority: SosPriority.high,
      status: SosStatus.assigned,
      civilianName: 'Saravanan B',
      civilianPhone: '+91 98409 33227',
      district: 'Vellore',
      locationAddress: 'Palar Riverbed Underpass, Katpadi, Vellore',
      latitude: 12.9165,
      longitude: 79.1325,
      distanceKm: 3.9,
      peopleCount: 4,
      riskLevel: 'Water Surge',
      nearbyHospitals: ['Christian Medical College (CMC)'],
      nearbyShelters: ['Fort Grounds Relief Camp'],
      assignedTeam: _availableTeams[0],
      imagePlaceholders: [],
      notes: '4 youngsters stranded on river sandbar as upstream gates opened.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 29)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Alert Logged',
          description: 'Emergency beacon received.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Team Assigned',
          description: 'Alpha team assigned.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isCompleted: true,
        ),
      ],
    ),

    // 14. Chennai Marina High Surf Incident
    SosIncidentModel(
      id: 'SOS-9414',
      emergencyType: 'Coastal Tidal Inundation',
      priority: SosPriority.critical,
      status: SosStatus.onScene,
      civilianName: 'Kavitha R',
      civilianPhone: '+91 97890 22119',
      district: 'Chennai',
      locationAddress: 'Marina Beach Service Lane near Light House, Chennai',
      latitude: 13.0400,
      longitude: 80.2800,
      distanceKm: 2.0,
      peopleCount: 8,
      riskLevel: 'Tidal Wave Surge',
      nearbyHospitals: ['Stanley Medical College', 'Apollo Greams Road'],
      nearbyShelters: ['Marina Tsunami Base'],
      assignedTeam: _availableTeams[3],
      imagePlaceholders: [],
      notes: 'High tidal surge flooded beachfront shanties. Delta Coast Squad on scene assisting elderly residents.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Alert Received',
          description: 'Lifeguard tower SOS.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Assigned',
          description: 'Delta Coast Battalion assigned.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 38)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.enRoute,
          title: 'En Route',
          description: 'Boats moving.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.onScene,
          title: 'On Scene',
          description: 'Evacuation in progress.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isCompleted: true,
        ),
      ],
    ),

    // 15. Dindigul Farm Electrical Hazard
    SosIncidentModel(
      id: 'SOS-9415',
      emergencyType: 'Submerged Transformer Electrical Spark',
      priority: SosPriority.high,
      status: SosStatus.received,
      civilianName: 'Naveen Prakash',
      civilianPhone: '+91 98428 99110',
      district: 'Dindigul',
      locationAddress: 'Chettinaickenpatti Village, Dindigul',
      latitude: 10.3500,
      longitude: 77.9600,
      distanceKm: 3.8,
      peopleCount: 6,
      riskLevel: 'Electrocution Risk',
      nearbyHospitals: ['Dindigul Medical College'],
      nearbyShelters: ['Dindigul Indoor Stadium'],
      imagePlaceholders: [],
      notes: 'Flooded street with downed live electrical wire near school gate. Grid shutdown requested.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 7)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Distress Beacon Received',
          description: 'Smart pole alert received.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
          isCompleted: true,
        ),
      ],
    ),

    // 16. Tirunelveli Hospital Power Failure
    SosIncidentModel(
      id: 'SOS-9416',
      emergencyType: 'Critical Care Oxygen Supply Shortage',
      priority: SosPriority.critical,
      status: SosStatus.assigned,
      civilianName: 'Dr. Aravind Swamy',
      civilianPhone: '+91 94431 88770',
      district: 'Tirunelveli',
      locationAddress: 'Riverside Community Clinic, Palayamkottai, Tirunelveli',
      latitude: 8.7200,
      longitude: 77.7400,
      distanceKm: 2.8,
      peopleCount: 9,
      riskLevel: 'Life Support Failure',
      nearbyHospitals: ['Tirunelveli Govt Medical College'],
      nearbyShelters: ['Palayamkottai Camp 1'],
      assignedTeam: _availableTeams[4],
      imagePlaceholders: [],
      notes: 'Back-up generator flooded. 9 patients on supplemental oxygen need airlift / mobile generator.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Medical Priority Beacon',
          description: 'Clinic SOS received.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Echo Airlift Assigned',
          description: 'Rescue Helicopter assigned with portable generators.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
          isCompleted: true,
        ),
      ],
    ),

    // 17. Coimbatore Hill Station Tourist Bus Stranded
    SosIncidentModel(
      id: 'SOS-9417',
      emergencyType: 'Hill Slope Road Washout',
      priority: SosPriority.high,
      status: SosStatus.enRoute,
      civilianName: 'Chandran T',
      civilianPhone: '+91 98402 77884',
      district: 'Coimbatore',
      locationAddress: 'Marudhamalai Ghat Road Mile 4, Coimbatore',
      latitude: 11.0450,
      longitude: 76.9000,
      distanceKm: 7.4,
      peopleCount: 22,
      riskLevel: 'Steep Slope Washout',
      nearbyHospitals: ['PSG Hospitals', 'Ganga Medical Centre'],
      nearbyShelters: ['Marudhamalai Camp Base'],
      assignedTeam: _availableTeams[2],
      imagePlaceholders: [],
      notes: 'Mini-bus with 22 passengers stuck before road washout. Charlie Highland team approaching with winch.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 38)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Distress Received',
          description: 'Bus driver satellite beacon.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 38)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Team Assigned',
          description: 'Charlie team assigned.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.enRoute,
          title: 'En Route',
          description: 'Climbing ghat road.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isCompleted: true,
        ),
      ],
    ),

    // 18. Madurai Substation Flooding
    SosIncidentModel(
      id: 'SOS-9418',
      emergencyType: 'Substation Waterlogging',
      priority: SosPriority.low,
      status: SosStatus.rescueCompleted,
      civilianName: 'Prabhu K',
      civilianPhone: '+91 93601 44558',
      district: 'Madurai',
      locationAddress: 'K.Pudur TNEB Yard, Madurai',
      latitude: 9.9400,
      longitude: 78.1400,
      distanceKm: 3.1,
      peopleCount: 2,
      riskLevel: 'Low (Controlled)',
      nearbyHospitals: ['Apollo Speciality Madurai'],
      nearbyShelters: ['Racecourse Shelter Base'],
      assignedTeam: _availableTeams[1],
      imagePlaceholders: [],
      notes: 'Pumps cleared substation basement water. Technicians safe.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Alert Received',
          description: 'Substation call.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.rescueCompleted,
          title: 'Rescue Completed',
          description: 'Water pumped out.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isCompleted: true,
        ),
      ],
    ),

    // 19. Chennai Adyar River Basin Stranded
    SosIncidentModel(
      id: 'SOS-9419',
      emergencyType: 'Riverfront House Flash Flood',
      priority: SosPriority.critical,
      status: SosStatus.assigned,
      civilianName: 'Lakshmi Narayanan',
      civilianPhone: '+91 98404 11223',
      district: 'Chennai',
      locationAddress: 'Kotturpuram Riverbank Hutments, Chennai',
      latitude: 13.0150,
      longitude: 80.2400,
      distanceKm: 3.8,
      peopleCount: 7,
      riskLevel: 'High Current Flood',
      nearbyHospitals: ['MGM Healthcare', 'Apollo Greams Road'],
      nearbyShelters: ['Adyar Evacuation Center'],
      assignedTeam: _availableTeams[0],
      imagePlaceholders: [],
      notes: '7 members including 3 elderly persons on terrace. Inflatable raft dispatched.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 16)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Alert Received',
          description: 'SOS beacon.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 16)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Alpha Team Assigned',
          description: 'Boat team assigned.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isCompleted: true,
        ),
      ],
    ),

    // 20. Salem Yercaud Foothill Flash Mudflow
    SosIncidentModel(
      id: 'SOS-9420',
      emergencyType: 'Foothill Mudflow Road Block',
      priority: SosPriority.medium,
      status: SosStatus.closed,
      civilianName: 'Sundarraj M',
      civilianPhone: '+91 94433 22118',
      district: 'Salem',
      locationAddress: 'Gorimedu Foothills Road, Salem',
      latitude: 11.6900,
      longitude: 78.1600,
      distanceKm: 5.6,
      peopleCount: 3,
      riskLevel: 'Cleared',
      nearbyHospitals: ['Manipal Hospital Salem'],
      nearbyShelters: ['Yercaud Foothill Camp'],
      imagePlaceholders: [],
      notes: 'Rubble cleared by municipal bulldozer. Mission closed.',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      timeline: [
        SosTimelineEventModel(
          status: SosStatus.received,
          title: 'Alert Received',
          description: 'Distress ping.',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          isCompleted: true,
        ),
        SosTimelineEventModel(
          status: SosStatus.closed,
          title: 'Mission Closed',
          description: 'Road cleared and verified.',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isCompleted: true,
        ),
      ],
    ),
  ];

  @override
  Future<List<SosIncidentModel>> fetchAllIncidents() async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    return List.unmodifiable(_mockIncidents);
  }

  @override
  Future<SosIncidentModel?> fetchIncidentById(String id) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    try {
      return _mockIncidents.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<RescueTeamModel>> fetchAvailableTeams() async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    return List.unmodifiable(_availableTeams);
  }

  @override
  Future<SosIncidentModel> assignTeam(String incidentId, RescueTeamModel team) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    final index = _mockIncidents.indexWhere((i) => i.id == incidentId);
    if (index == -1) {
      throw Exception('SOS incident $incidentId not found');
    }

    final current = _mockIncidents[index];
    final updatedTimeline = List<SosTimelineEvent>.from(current.timeline)
      ..add(
        SosTimelineEventModel(
          status: SosStatus.assigned,
          title: 'Team Assigned: ${team.name}',
          description: 'Assigned squad vehicle ${team.vehicle}. Estimated arrival: ${team.estimatedArrivalMinutes} mins.',
          timestamp: DateTime.now(),
          isCompleted: true,
        ),
      );

    final updated = current.copyWith(
      status: SosStatus.assigned,
      assignedTeam: team,
      timeline: updatedTimeline,
    ) as SosIncidentModel;

    _mockIncidents[index] = updated;
    return updated;
  }

  @override
  Future<SosIncidentModel> updateStatus(String incidentId, SosStatus status, String? note) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    final index = _mockIncidents.indexWhere((i) => i.id == incidentId);
    if (index == -1) {
      throw Exception('SOS incident $incidentId not found');
    }

    final current = _mockIncidents[index];
    final updatedTimeline = List<SosTimelineEvent>.from(current.timeline)
      ..add(
        SosTimelineEventModel(
          status: status,
          title: 'Status Updated: ${status.name.toUpperCase()}',
          description: note ?? 'Operational status progressed by Incident Commander.',
          timestamp: DateTime.now(),
          isCompleted: true,
        ),
      );

    final updated = current.copyWith(
      status: status,
      notes: note != null ? '${current.notes}\n• $note' : current.notes,
      timeline: updatedTimeline,
    ) as SosIncidentModel;

    _mockIncidents[index] = updated;
    return updated;
  }
}
