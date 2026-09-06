import '../../domain/entities/ai_commander_entities.dart';
import '../models/ai_commander_models.dart';

/// Realistic mock datasource powering AI Commander tactical intelligence.
/// Contains:
/// - 20+ Tactical AI Recommendations
/// - 10+ Multi-sensor Incident Analyses
/// - 15+ Interactive Chat Sessions & Pre-loaded Dialogues
class AICommanderMockDatasource {
  static final AICommanderMockDatasource _instance = AICommanderMockDatasource._internal();
  factory AICommanderMockDatasource() => _instance;
  AICommanderMockDatasource._internal() {
    _initializeData();
  }

  final List<AIRecommendationModel> _recommendations = [];
  final List<IncidentAnalysisModel> _incidentAnalyses = [];
  final List<AIChatSessionModel> _chatSessions = [];

  void _initializeData() {
    _initIncidentAnalyses();
    _initRecommendations();
    _initChatSessions();
  }

  // ===========================================================================
  // 10 INCIDENT ANALYSES
  // ===========================================================================
  void _initIncidentAnalyses() {
    _incidentAnalyses.addAll([
      IncidentAnalysisModel(
        id: 'INC-2026-001',
        title: 'Thamirabarani River Basin Surge Inundation',
        incidentType: IncidentType.flood,
        severity: IncidentSeverity.catastrophic,
        district: 'Tirunelveli',
        affectedArea: 'Vannarpettai & Sindupoondurai Lowlands (6.4 sq km)',
        estimatedPopulation: 14200,
        riskScore: 94,
        aiConfidence: 0.96,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-01', action: 'Deploy Inflatable Rescue Boats to Sindupoondurai bridge junction', responsibleUnit: 'Coastal Water Rescue Alpha', isCompleted: true),
          ActionItemModel(id: 'ACT-02', action: 'Cut main low-tension electrical feeders in submerged zone', responsibleUnit: 'TNEB Emergency Cell', isCompleted: true),
          ActionItemModel(id: 'ACT-03', action: 'Air-drop 500 ration packs to marooned terrace clusters', responsibleUnit: 'SkyWatch Aerial Drone Wing', isCompleted: false),
          ActionItemModel(id: 'ACT-04', action: 'Establish forward triage post at High Ground Hospital', responsibleUnit: 'TVMCH Medical Squad', isCompleted: false),
        ],
        environmentalFactors: const [
          'Rainfall: 240mm in past 6 hours',
          'Dam discharge: 45,000 cusecs from Manimuthar',
          'Current flow speed: 4.8 knots',
          'Water level rising 12cm/hour',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(minutes: 18)),
        summaryNotes: 'Critical flash flood surge breaching river embankments. 85% probability of low-lying home submergence within next 90 minutes. Evacuation of ground-floor residents is urgent.',
        latitude: 8.7280,
        longitude: 77.7320,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-002',
        title: 'Velachery Lake Overflow & Residential Waterlogging',
        incidentType: IncidentType.flood,
        severity: IncidentSeverity.critical,
        district: 'Chennai',
        affectedArea: 'Velachery 100ft Road & AGS Colony (4.2 sq km)',
        estimatedPopulation: 22000,
        riskScore: 88,
        aiConfidence: 0.93,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-05', action: 'Position 4 high-capacity dewatering trash pumps at bypass canal', responsibleUnit: 'Chennai Corporation PWD', isCompleted: true),
          ActionItemModel(id: 'ACT-06', action: 'Establish green evacuation corridor via Velachery MRTS flyover', responsibleUnit: 'Traffic Police Command', isCompleted: true),
          ActionItemModel(id: 'ACT-07', action: 'Distribute drinking water canisters to isolated residential towers', responsibleUnit: 'Logistics Unit Bravo', isCompleted: false),
        ],
        environmentalFactors: const [
          'Precipitation rate: 45mm/hr',
          'SWM canal backflow detected at 1.2m depth',
          'Storm drain siltation at 40%',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(minutes: 42)),
        summaryNotes: 'Lake catchment overflow threatening 350 ground-floor apartment complexes. MRTS elevated track recommended as primary staging area.',
        latitude: 12.9815,
        longitude: 80.2180,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-003',
        title: 'Severe Cyclone Wind Shear & Tidal Inundation',
        incidentType: IncidentType.cyclone,
        severity: IncidentSeverity.catastrophic,
        district: 'Cuddalore',
        affectedArea: 'Silver Beach & Devanampattinam Coastal Belt',
        estimatedPopulation: 18500,
        riskScore: 96,
        aiConfidence: 0.98,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-08', action: 'Issue mandatory evacuation within 500m high-tide line', responsibleUnit: 'District Disaster Cell', isCompleted: true),
          ActionItemModel(id: 'ACT-09', action: 'Anchor marine rescue craft inside sheltered harbour basin', responsibleUnit: 'Marine Police Squad', isCompleted: true),
          ActionItemModel(id: 'ACT-10', action: 'Pre-position 3 backup diesel generators at Cyclone Shelter', responsibleUnit: 'State Logistics Depot WH-02', isCompleted: false),
        ],
        environmentalFactors: const [
          'Sustained wind gusts: 115 km/h',
          'Tidal surge: +2.8m above astronomical tide',
          'Barometric pressure dropping to 982 hPa',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(hours: 1)),
        summaryNotes: 'Eyewall landfall predicted in 2.5 hours. Structural vulnerability of thatched & asbestos coastal housing is 92%. Immediate zero-casualty evacuation underway.',
        latitude: 11.7450,
        longitude: 79.7790,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-004',
        title: 'Valparai Ghat Road Landslide & Road Blockade',
        incidentType: IncidentType.landslide,
        severity: IncidentSeverity.high,
        district: 'Coimbatore',
        affectedArea: 'Hairpin Bends 24-28 on Pollachi-Valparai Highway',
        estimatedPopulation: 3200,
        riskScore: 78,
        aiConfidence: 0.91,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-11', action: 'Deploy Earth Movers & Hydraulic Breachers to bend 26', responsibleUnit: 'Highways Heavy Engineering', isCompleted: false),
          ActionItemModel(id: 'ACT-12', action: 'Conduct aerial thermal scan for stranded tea estate buses', responsibleUnit: 'SkyWatch Aerial Recon Team', isCompleted: true),
          ActionItemModel(id: 'ACT-13', action: 'Dispatch medical oxygen to Valparai Town Clinic via UAV', responsibleUnit: 'Medical Drone Payload 01', isCompleted: false),
        ],
        environmentalFactors: const [
          'Soil saturation index: 98%',
          'Hill slope angle: 42 degrees',
          'Active rockfall hazard on upper ridge',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(hours: 2)),
        summaryNotes: 'Massive mudslide severed sole transit artery. Approximately 12 tourist vehicles and 3 state transport buses trapped between bends 24 and 27.',
        latitude: 10.3250,
        longitude: 76.9550,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-005',
        title: 'Old Town Commercial Complex Structural Breach',
        incidentType: IncidentType.buildingCollapse,
        severity: IncidentSeverity.critical,
        district: 'Madurai',
        affectedArea: 'South Masi Street Heritage Precinct',
        estimatedPopulation: 450,
        riskScore: 84,
        aiConfidence: 0.89,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-14', action: 'Insert acoustic seismic listening probes into basement debris', responsibleUnit: 'Urban Search & Rescue Squad', isCompleted: true),
          ActionItemModel(id: 'ACT-15', action: 'Shore up adjacent 3-story masonry structures', responsibleUnit: 'Fire & Rescue Engineering', isCompleted: false),
          ActionItemModel(id: 'ACT-16', action: 'Mobilize hydraulic spreaders (Jaws of Life)', responsibleUnit: 'Delta Heavy Rescue Team', isCompleted: true),
        ],
        environmentalFactors: const [
          'Debris depth: 4.5 meters',
          'Heavy pedestrian density in narrow 12ft lanes',
          'Gas pipeline leakage ruled out',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(hours: 3)),
        summaryNotes: '3-story commercial structure collapsed during monsoon downpour. AI seismic sensor detected 4 distinct micro-vibrations indicative of trapped survivors in stairwell pocket.',
        latitude: 9.9180,
        longitude: 78.1190,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-006',
        title: 'Nagapattinam Coastal Multi-Point Storm Surge',
        incidentType: IncidentType.stormSurge,
        severity: IncidentSeverity.high,
        district: 'Nagapattinam',
        affectedArea: 'Keechankuppam Fishing Hamlet & Harbour Canal',
        estimatedPopulation: 9800,
        riskScore: 81,
        aiConfidence: 0.94,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-17', action: 'Evacuate 350 families to Multi-Hazard Shelter Block B', responsibleUnit: 'Civil Defense Volunteers', isCompleted: true),
          ActionItemModel(id: 'ACT-18', action: 'Sandbag canal mouth to prevent saltwater inundation of farms', responsibleUnit: 'PWD Irrigation Wing', isCompleted: false),
        ],
        environmentalFactors: const [
          'Wave height: 4.2 meters',
          'Wind speed: 75 km/h easterly',
          'Spring tide alignment',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(hours: 4)),
        summaryNotes: 'Saltwater intrusion reaching 400m inland. Drinking water borewells at risk of salinity contamination.',
        latitude: 10.7656,
        longitude: 79.8428,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-007',
        title: 'Bhavani River Delta Industrial Chemical Storage Threat',
        incidentType: IncidentType.damOverflow,
        severity: IncidentSeverity.moderate,
        district: 'Erode',
        affectedArea: 'SIPCOT Industrial Belt Lowland Sector',
        estimatedPopulation: 6500,
        riskScore: 68,
        aiConfidence: 0.88,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-19', action: 'Inspect chemical storage bund walls at 6 textile processing units', responsibleUnit: 'Pollution Control Board & Hazmat Unit', isCompleted: true),
          ActionItemModel(id: 'ACT-20', action: 'Divert canal discharge into peripheral balancing reservoir', responsibleUnit: 'Water Resources Dept', isCompleted: true),
        ],
        environmentalFactors: const [
          'Bhavanisagar Dam outflow: 22,000 cusecs',
          'River stage: 0.4m below danger mark',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(hours: 5)),
        summaryNotes: 'Controlled spillway discharge currently being managed. Risk elevated if upstream catchment receives additional 50mm rain.',
        latitude: 11.4450,
        longitude: 77.6820,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-008',
        title: 'Srirangam Island Causeway Submergence',
        incidentType: IncidentType.flood,
        severity: IncidentSeverity.high,
        district: 'Tiruchirappalli',
        affectedArea: 'Cauvery-Kollidam Island North Corridor',
        estimatedPopulation: 11200,
        riskScore: 76,
        aiConfidence: 0.92,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-21', action: 'Close pedestrian causeway and redirect traffic to bypass bridge', responsibleUnit: 'City Traffic Division', isCompleted: true),
          ActionItemModel(id: 'ACT-22', action: 'Stage 6 IRB rescue boats at Grand Anicut staging depot', responsibleUnit: 'Central Fire & Rescue Squad', isCompleted: false),
        ],
        environmentalFactors: const [
          'Mettur Dam total discharge: 85,000 cusecs',
          'Flow velocity: 5.2 knots at Mukkombu regulator',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(hours: 6)),
        summaryNotes: 'Heavy surplus discharge in Cauvery basin submerging low-level causeways. Island core remains safe on high elevation ground.',
        latitude: 10.8620,
        longitude: 78.6920,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-009',
        title: 'Yercaud Ghat Road Hairpin 18 Rockslide',
        incidentType: IncidentType.landslide,
        severity: IncidentSeverity.moderate,
        district: 'Salem',
        affectedArea: 'Shevaroys Hill Ascent Km 14',
        estimatedPopulation: 1400,
        riskScore: 62,
        aiConfidence: 0.87,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-23', action: 'Operate hydraulic rock splitters to clear 40-ton boulder', responsibleUnit: 'Highways Rapid Response', isCompleted: true),
          ActionItemModel(id: 'ACT-24', action: 'Erect temporary safety wire netting over unstable slope', responsibleUnit: 'Geological Survey Team', isCompleted: false),
        ],
        environmentalFactors: const [
          'Intermittent hill fog reducing visibility to 20m',
          'Continuous drizzle (15mm in 12hr)',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(hours: 8)),
        summaryNotes: 'Single lane opened under convoy escort. Heavy tourist commercial traffic restricted until slope stabilization.',
        latitude: 11.7750,
        longitude: 78.2090,
      ),
      IncidentAnalysisModel(
        id: 'INC-2026-010',
        title: 'Colachel Harbour Coastal Breaker Overtopping',
        incidentType: IncidentType.coastalErosion,
        severity: IncidentSeverity.high,
        district: 'Kanyakumari',
        affectedArea: 'Colachel Seawall & Fish Auction Hall',
        estimatedPopulation: 7600,
        riskScore: 79,
        aiConfidence: 0.95,
        recommendedActions: const [
          ActionItemModel(id: 'ACT-25', action: 'Anchor mechanized fishing fleet in inner breakwater', responsibleUnit: 'Fisheries Department Patrol', isCompleted: true),
          ActionItemModel(id: 'ACT-26', action: 'Deploy tetra-pod reinforcements along 200m exposed seawall', responsibleUnit: 'Harbour Engineering Div', isCompleted: false),
        ],
        environmentalFactors: const [
          'High swells: 3.8m swell height at 16s period',
          'South-westerly monsoon sea swell active',
        ],
        analyzedAt: DateTime.now().subtract(const Duration(hours: 10)),
        summaryNotes: 'Sea surge overtopping breakwater during peak afternoon high tide. Harbour wharf operations suspended.',
        latitude: 8.1750,
        longitude: 77.2550,
      ),
    ]);
  }

  // ===========================================================================
  // 20+ AI RECOMMENDATIONS
  // ===========================================================================
  void _initRecommendations() {
    _recommendations.addAll([
      AIRecommendationModel(
        id: 'REC-001',
        incidentId: 'INC-2026-001',
        title: 'Pre-position Inflatable Rescue Boats (IRB) at Vannarpettai Bridge',
        recommendation: 'Deploy 6 Inflatable Rubber Boats with 40HP outboards at Vannarpettai Bridge quadrant before water level reaches 4.5m crest.',
        reasoning: 'Hydrological predictive modeling indicates bridge approach will become isolated in 40 minutes, cutting off access for terrestrial wheeled vehicles.',
        estimatedImpact: 'Enables rapid extraction of ~650 senior citizens and children from inundated ground floors.',
        priority: RecommendationPriority.immediate,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['6x Inflatable Boats', '24x Life Vests', '1x 4x4 Support Truck'],
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-002',
        incidentId: 'INC-2026-001',
        title: 'Immediate De-energization of Substation 04 Feeders',
        recommendation: 'Transmit emergency shutdown signal to TNEB Sindupoondurai 33kV Substation to eliminate electrocution hazards in standing floodwaters.',
        reasoning: 'Sensor telemetry confirms floodwater has reached 0.8m inside feeder yard with active 415V distribution transformers.',
        estimatedImpact: 'Eliminates fatal electrocution risk across 14,000 residents in flooded sector.',
        priority: RecommendationPriority.immediate,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['SCADA Remote Breaker Signal', '1x Electrical Safety Officer'],
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-003',
        incidentId: 'INC-2026-001',
        title: 'Thermal Drone Reconnaissance for Marooned Terrace Clusters',
        recommendation: 'Launch 2 FLIR thermal hexacopters over Sindupoondurai Ward 12 to pinpoint trapped survivors on rooftops.',
        reasoning: 'Nightfall and power outages impair visual ground search. Thermal sensors detect human heat signatures through rain.',
        estimatedImpact: 'Maps exact GPS coordinates of ~120 marooned individuals for boat squads.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['2x FLIR Thermal Drones', '4x High-Capacity Flight Batteries'],
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isExecuted: false,
      ),
      AIRecommendationModel(
        id: 'REC-004',
        incidentId: 'INC-2026-002',
        title: 'Establish Reverse Flow Sump System at Velachery 100ft Road',
        recommendation: 'Position four 150HP submersible trash pumps to discharge stormwater into Buckingham canal feeder.',
        reasoning: 'Gravity drainage blocked due to high downstream canal stage; mechanical pumping reduces street waterlevel by 15cm/hour.',
        estimatedImpact: 'Reclaims primary ambulance transit artery connecting Velachery to Apollo Hospital.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['4x 150HP Dewatering Pumps', '2x 45kVA Diesel Generators'],
        timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
        isExecuted: false,
      ),
      AIRecommendationModel(
        id: 'REC-005',
        incidentId: 'INC-2026-002',
        title: 'Activate MRTS Station Elevated Emergency Shelter Staging',
        recommendation: 'Open Velachery elevated railway concourse as forward staging point for medical triage and hot ration distribution.',
        reasoning: 'Elevated station platform is 10m above street level with functional generator power and direct dry stairway access.',
        estimatedImpact: 'Provides immediate high-and-dry refuge for 2,500 displaced ground-floor tenants.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['100x Camp Cots', '500x Food Packs', '1x First Aid Station'],
        timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-006',
        incidentId: 'INC-2026-003',
        title: 'Enforce 500-Meter Coastal Evacuation Corridor in Cuddalore',
        recommendation: 'Execute compulsory relocation of 4,200 residents within 500m of Silver Beach to inland Cyclone Shelter SH-03.',
        reasoning: 'Tidal forecast predicts 2.8m storm surge coinciding with 115 km/h eyewall winds in 2 hours.',
        estimatedImpact: 'Mitigates 100% of drowning and structural collapse casualties in beachfront sector.',
        priority: RecommendationPriority.immediate,
        difficulty: ExecutionDifficulty.high,
        requiredResources: const ['15x State Transport Buses', '40x Civil Defense Volunteers', 'Police Escort'],
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-007',
        incidentId: 'INC-2026-003',
        title: 'Pre-allocate Critical Antivenom & Suture Stock to District Hospital',
        recommendation: 'Dispatch 50 vials of polyvalent snake antivenom and 20 trauma packs from WH-02 to Cuddalore District Hospital (HOSP-04).',
        reasoning: 'Post-cyclone water displacement consistently causes sharp rise in snake encounters and puncture injuries from flying debris.',
        estimatedImpact: 'Guarantees zero stock-out mortality for emergency hospital admissions.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['50x Antivenom Vials', '20x Trauma Packs', '1x Courier Van'],
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-008',
        incidentId: 'INC-2026-004',
        title: 'Aerial Medical Supply Airdrop to Valparai Tea Estate Clinic',
        recommendation: 'Dispatch heavy-lift payload drone carrying 15kg of insulin, antibiotics, and pediatric drops to cut-off Valparai hill outpost.',
        reasoning: 'Road blockage at hairpin bend 26 will take at least 14 hours to clear; local dispensary is at zero insulin reserve.',
        estimatedImpact: 'Prevents medical emergency for 45 diabetic patients and 20 infants in isolated hill town.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['1x Heavy Lift Drone', '15kg Temperature-Controlled Medical Pack'],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isExecuted: false,
      ),
      AIRecommendationModel(
        id: 'REC-009',
        incidentId: 'INC-2026-004',
        title: 'Mobilize Heavy Crawler Excavator from Pollachi Base',
        recommendation: 'Dispatch 30-ton tracked excavator and diamond rock saw to clear 400 cubic meters of mud and tree debris.',
        reasoning: 'Soil stability analysis confirms upper slope has stabilized; mechanical clearing can proceed safely.',
        estimatedImpact: 'Reopens arterial lifeline road within 6 hours of machine arrival.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.high,
        requiredResources: const ['1x 30-Ton Crawler Excavator', '1x Low-Bed Transporter', '2x Heavy Chainsaws'],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-010',
        incidentId: 'INC-2026-005',
        title: 'Deploy Acoustic Seismic Sensors for Trapped Void Detection',
        recommendation: 'Position 4-channel geophone probe array in triangular pattern over South Masi collapsed building mound.',
        reasoning: 'Acoustic triangulation calculates depth and coordinates of tapping survivors with 0.5m precision.',
        estimatedImpact: 'Prevents blind digging that could trigger secondary collapse onto survivor void.',
        priority: RecommendationPriority.immediate,
        difficulty: ExecutionDifficulty.complex,
        requiredResources: const ['1x Seismic Listening Kit', '2x USAR Specialists'],
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-011',
        incidentId: 'INC-2026-005',
        title: 'Erect Pneumatic Shoring Posts along North Masonry Wall',
        recommendation: 'Install heavy aluminum rescue struts to brace leaning 3-story load-bearing brick wall adjacent to collapse pit.',
        reasoning: 'Vibrations from rescue equipment could cause catastrophic wall collapse onto rescue personnel.',
        estimatedImpact: 'Guarantees 100% structural safety for 18 on-site rescue personnel.',
        priority: RecommendationPriority.immediate,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['4x Heavy Rescue Shoring Struts', 'Air Compressor'],
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isExecuted: false,
      ),
      AIRecommendationModel(
        id: 'REC-012',
        incidentId: 'INC-2026-006',
        title: 'Deploy High-Density Geotextile Sandbag Barrier at Nagore Canal',
        recommendation: 'Stack 2,500 polypropylene sandbags in double-pyramid profile across 120m breach point of Nagore tidal canal.',
        reasoning: 'High tide peak at 17:30 will push 1.2m of seawater into paddy fields if breach remains open.',
        estimatedImpact: 'Protects 650 acres of agricultural land and 800 rural dwellings from saltwater ruin.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['2,500x Sandbags', '2x Sand Loading Trucks', '30x Field Laborers'],
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isExecuted: false,
      ),
      AIRecommendationModel(
        id: 'REC-013',
        incidentId: 'INC-2026-007',
        title: 'Precautionary Hazmat Containment Boom Deployment in Bhavani Canal',
        recommendation: 'Deploy 200m oil and chemical absorbent containment booms downstream of SIPCOT industrial dye storage tanks.',
        reasoning: 'Floodwaters nearing storage plinth level; containment boom prevents downstream drinking water poisoning.',
        estimatedImpact: 'Secures drinking water intake for 35,000 residents in Bhavani municipality.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['200m Absorbent Booms', '1x Chemical Rapid Test Kit'],
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-014',
        incidentId: 'INC-2026-008',
        title: 'Dynamic Traffic Diversion via Yatri Nivas Elevated Bypass',
        recommendation: 'Implement automated digital signage routing all Srirangam pilgrim and civilian traffic away from low causeway.',
        reasoning: 'Kollidam river flow velocity exceeding safe vehicle crossing thresholds by 2.4x.',
        estimatedImpact: 'Zero vehicle washaway incidents during 85,000 cusecs peak discharge.',
        priority: RecommendationPriority.medium,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['4x Variable Message Signs', '6x Traffic Police Marshals'],
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-015',
        incidentId: 'INC-2026-009',
        title: 'Continuous Drone Slope Stability Monitoring on Yercaud Ghat',
        recommendation: 'Deploy autonomous quadcopter flying 30-minute periodic LiDAR scans along hairpin 18 rock face.',
        reasoning: 'Identifies micro-fracture widening in rock formation prior to secondary boulder dislodgement.',
        estimatedImpact: 'Provides 15-minute advance alert for road clearance teams before rock falls occur.',
        priority: RecommendationPriority.advisory,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['1x LiDAR Drone System', '1x Edge AI Processing Tablet'],
        timestamp: DateTime.now().subtract(const Duration(hours: 7)),
        isExecuted: false,
      ),
      AIRecommendationModel(
        id: 'REC-016',
        incidentId: 'INC-2026-010',
        title: 'Activate Colachel Harbour Automated Siren Warning System',
        recommendation: 'Broadcast 120dB coastal surge siren every 30 minutes in Tamil and Malayalam advising fishermen against wharf access.',
        reasoning: 'High swell period (16s) produces rogue breaking waves capable of sweeping bystanders off concrete jetty.',
        estimatedImpact: 'Eliminates sightseer and fisherman casualty risks during storm swell.',
        priority: RecommendationPriority.medium,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['Harbour Warning Siren Network', 'VHF Marine Channel 16 Broadcast'],
        timestamp: DateTime.now().subtract(const Duration(hours: 9)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-017',
        incidentId: 'INC-2026-001',
        title: 'Establish Mobile Water Filtration Post at Palayamkottai High School',
        recommendation: 'Deploy reverse-osmosis mobile water filtration unit capable of delivering 2,000 liters/hr from flooded river water.',
        reasoning: 'Municipal water mains severed at river crossing; camp population requires 8,000 liters/day for drinking and cooking.',
        estimatedImpact: 'Prevents acute cholera and gastroenteritis outbreak in 750-person shelter camp.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['1x RO Trailer Unit', '1x 5000L Storage Bladder'],
        timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
        isExecuted: false,
      ),
      AIRecommendationModel(
        id: 'REC-018',
        incidentId: 'INC-2026-002',
        title: 'Deploy Satellite Comms Terminal at Velachery Command Post',
        recommendation: 'Activate portable Starlink / GSAT satellite terminal to restore broadband data telemetry for rescue squads.',
        reasoning: 'Cellular base towers in Velachery running on failing 4-hour battery backup after grid power cut.',
        estimatedImpact: 'Maintains unbroken real-time GPS tracking and SOS dispatch for 12 rescue squads.',
        priority: RecommendationPriority.high,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['1x SatCom Terminal', '1x Portable Inverter Generator'],
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-019',
        incidentId: 'INC-2026-003',
        title: 'Strategic Pre-positioning of Tree Clearing Squads along NH-45A',
        recommendation: 'Deploy 4 rapid chainsaw squads with winches every 10km along Cuddalore-Puducherry highway.',
        reasoning: 'Wind gusts over 100 km/h will uproot large roadside banyan and eucalyptus trees, blocking emergency ambulances.',
        estimatedImpact: 'Reduces arterial road clearance time from 4 hours to under 25 minutes per fallen tree.',
        priority: RecommendationPriority.medium,
        difficulty: ExecutionDifficulty.moderate,
        requiredResources: const ['8x Stihl Heavy Chainsaws', '4x Recovery Winch Trucks'],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isExecuted: true,
      ),
      AIRecommendationModel(
        id: 'REC-020',
        incidentId: 'INC-2026-004',
        title: 'Establish Heli-Evacuation Staging Grid at Valparai Tea Factory Flat',
        recommendation: 'Clear factory drying yard (100x100m) and mark white H landing zone for Indian Air Force Mi-17 helicopters.',
        reasoning: 'If monsoon cloud base lifts above 3,000ft, air evacuation of critical trauma victims becomes optimal.',
        estimatedImpact: 'Enables rapid 20-minute airlift of polytrauma patients directly to Coimbatore Medical College.',
        priority: RecommendationPriority.advisory,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['4x Smoke Grenades', '1x Ground-to-Air VHF Radio'],
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isExecuted: false,
      ),
      AIRecommendationModel(
        id: 'REC-021',
        incidentId: 'INC-2026-001',
        title: 'Equip Night Boat Crews with High-Intensity Laser Beacons',
        recommendation: 'Issue green 532nm search laser pointers and 10,000 lumen spotlights to all night-shift boat pilots.',
        reasoning: 'Navigating submerged fences and barbed wire in pitch dark river waters requires high contrast beam illumination.',
        estimatedImpact: 'Prevents propeller entanglement and hull punctures during night rescue sweeps.',
        priority: RecommendationPriority.medium,
        difficulty: ExecutionDifficulty.low,
        requiredResources: const ['12x High-Lumen Marine Spotlights', '6x Laser Beacons'],
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isExecuted: false,
      ),
    ]);
  }

  // ===========================================================================
  // 15 CHAT SESSIONS & CONVERSATION HISTORY
  // ===========================================================================
  void _initChatSessions() {
    _chatSessions.addAll([
      AIChatSessionModel(
        id: 'CHAT-01',
        title: 'Thamirabarani Flood Evacuation Strategy',
        district: 'Tirunelveli',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        messages: [
          AIChatMessageModel(
            id: 'M-01',
            text: 'Analyze flood risk for Tirunelveli district right now.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          ),
          AIChatMessageModel(
            id: 'M-02',
            text: '### **AI Tactical Assessment: Tirunelveli Basin**\n\n'
                '• **Current Threat Level:** **CRITICAL (Risk Score 94/100)**\n'
                '• **Dam Outflow:** Manimuthar dam is discharging **45,000 cusecs** into the Thamirabarani basin.\n'
                '• **Inundation Window:** Low-lying wards in **Sindupoondurai** and **Vannarpettai** will experience +1.5m river crest in **35 minutes**.\n\n'
                '**Immediate Recommended Actions:**\n'
                '1. Dispatch 6 Inflatable Rescue Boats to Vannarpettai bridge staging point.\n'
                '2. Cut electrical power to Substation 04 to prevent underwater electrocution.\n'
                '3. Air-drop thermal drones for rooftop survivor mapping.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(minutes: 24)),
            actionSuggestions: const [
              'Suggest evacuation plan',
              'Allocate rescue teams',
              'Find safest rescue route',
            ],
            relatedIncidentId: 'INC-2026-001',
          ),
          AIChatMessageModel(
            id: 'M-03',
            text: 'Suggest evacuation plan for Sindupoondurai residents.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          ),
          AIChatMessageModel(
            id: 'M-04',
            text: '### **Evacuation Blueprint: Sindupoondurai Sector**\n\n'
                '• **Primary Evacuation Axis:** Westbound via **Palayamkottai Elevated Bypass** -> VOC Grounds Pavilion (SH-07).\n'
                '• **Secondary Escape Route:** Northward pedestrian corridor via **Railway Overbridge**.\n'
                '• **Staging Capacity:** SH-07 currently has **330 available beds**, functional solar power, and on-site paramedic team.\n'
                '• **Transit Allocation:** Deploy **3 high-clearance Ashok Leyland 4x4 trucks** from Southern Reserve WH-06.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(minutes: 19)),
            actionSuggestions: const [
              'Dispatch 4x4 trucks now',
              'Check shelter bed capacity',
              'Notify Field Commander',
            ],
            relatedIncidentId: 'INC-2026-001',
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-02',
        title: 'Velachery Urban Lake Surge Analysis',
        district: 'Chennai',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        messages: [
          AIChatMessageModel(
            id: 'M-05',
            text: 'Resource optimization for Velachery flood rescue.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          AIChatMessageModel(
            id: 'M-06',
            text: '### **Supply & Resource Optimization Plan**\n\n'
                '• **Water Pumps:** Transfer 4x 150HP trash pumps from Madhavaram Depot (WH-01) to 100ft Road.\n'
                '• **Food Packs:** Allocate 1,500 ready-to-eat ration packs to Velachery MRTS Shelter.\n'
                '• **Boat Fleet:** 4 shallow flat-bottom punt boats are recommended over deep-keel craft due to submerged road barriers.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(minutes: 58)),
            actionSuggestions: const ['Approve allocation', 'View Warehouse WH-01 stock'],
            relatedIncidentId: 'INC-2026-002',
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-03',
        title: 'Cuddalore Cyclone Coastline Relocation',
        district: 'Cuddalore',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        messages: [
          AIChatMessageModel(
            id: 'M-07',
            text: 'Find safest rescue route from Silver Beach to High School Shelter.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          AIChatMessageModel(
            id: 'M-08',
            text: '### **Optimal Transit Route (Zero Inundation Risk)**\n\n'
                '• **Recommended Corridor:** Take **Beach Road North** -> Turn Left at **Old Collectorate Cross Road** -> Proceed 1.4km to **Cyclone Shelter SH-03**.\n'
                '• **Avoid:** South Beach approach road (submerged under 0.9m surge with high cross-currents).\n'
                '• **Transit Time:** 8 minutes for buses with police escort.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 59)),
            actionSuggestions: const ['Broadcast route to patrol units', 'Update map overlay'],
            relatedIncidentId: 'INC-2026-003',
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-04',
        title: 'Valparai Landslide Rescue Operations',
        district: 'Coimbatore',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        messages: [
          AIChatMessageModel(
            id: 'M-09',
            text: 'Allocate rescue teams for Valparai ghat road blockage.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          AIChatMessageModel(
            id: 'M-10',
            text: '### **Squad Dispatch Recommendation**\n\n'
                '• **Assigned Team:** Western Ghats Special Rescue Unit (Coimbatore).\n'
                '• **Heavy Machinery:** 1x Crawler Excavator from Pollachi base + 2x heavy winch recovery trucks.\n'
                '• **Aerial Support:** SkyWatch Drone Team for aerial mapping of trapped vehicles.\n'
                '• **ETA to Site:** 45 minutes to Hairpin 24.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 58)),
            actionSuggestions: const ['Confirm dispatch', 'Check drone battery levels'],
            relatedIncidentId: 'INC-2026-004',
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-05',
        title: 'Madurai Structural Collapse Assessment',
        district: 'Madurai',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        messages: [
          AIChatMessageModel(
            id: 'M-11',
            text: 'Status on Madurai building collapse acoustic probes.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
          AIChatMessageModel(
            id: 'M-12',
            text: '### **Acoustic Geophone Telemetry**\n\n'
                '• **Sensors:** 4-channel array active.\n'
                '• **Signal Detection:** Confirmed rhythmic tapping detected at **depth 3.2m** under northern stairwell slab.\n'
                '• **Estimated Survivors:** 3 to 4 individuals.\n'
                '• **Directive:** Restrict heavy pneumatic hammer use to avoid debris shift. Use hand hydraulic spreaders.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 58)),
            actionSuggestions: const ['Send Jaws of Life', 'Alert GRH Trauma Ward'],
            relatedIncidentId: 'INC-2026-005',
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-06',
        title: 'Nagapattinam Storm Surge Triage',
        district: 'Nagapattinam',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        messages: [
          AIChatMessageModel(
            id: 'M-13',
            text: 'Analyze storm surge at Keechankuppam.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          AIChatMessageModel(
            id: 'M-14',
            text: 'Surge height measured at 4.2m with 75 km/h gale force winds. Saltwater intrusion extends 400m inland. 350 families relocated to Shelter SH-05. Sandbagging of canal mouth in progress.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-07',
        title: 'Erode Bhavani Dam Discharge Monitoring',
        district: 'Erode',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        messages: [
          AIChatMessageModel(
            id: 'M-15',
            text: 'What is the overflow risk at Bhavani SIPCOT?',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          ),
          AIChatMessageModel(
            id: 'M-16',
            text: 'Current outflow is 22,000 cusecs, 0.4m below critical embankment level. Chemical storage units have been inspected and secured with hazmat booms. Situation is under control.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-08',
        title: 'Srirangam Island Causeway Safeguards',
        district: 'Tiruchirappalli',
        createdAt: DateTime.now().subtract(const Duration(hours: 7)),
        messages: [
          AIChatMessageModel(
            id: 'M-17',
            text: 'Is Srirangam temple accessible?',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 7)),
          ),
          AIChatMessageModel(
            id: 'M-18',
            text: 'Low causeway is submerged by 85,000 cusecs Cauvery flow. Main traffic is smoothly routed over elevated highway bridge. Temple core is dry and safe on high ground.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 6, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-09',
        title: 'Yercaud Ghat Road Rockfall Clearance',
        district: 'Salem',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        messages: [
          AIChatMessageModel(
            id: 'M-19',
            text: 'Provide update on Yercaud Hairpin 18 rockfall.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          ),
          AIChatMessageModel(
            id: 'M-20',
            text: '40-ton boulder split and cleared to shoulder. Single lane transit operational. Intermittent fog requires caution.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 7, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-10',
        title: 'Colachel Marine Swell Safety Directives',
        district: 'Kanyakumari',
        createdAt: DateTime.now().subtract(const Duration(hours: 9)),
        messages: [
          AIChatMessageModel(
            id: 'M-21',
            text: 'Is Colachel harbour safe for boat deployment?',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 9)),
          ),
          AIChatMessageModel(
            id: 'M-22',
            text: 'Negative. Swells at 3.8m with 16s period. All boats must remain inside sheltered breakwater basin.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 8, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-11',
        title: 'Medical Supplies Dispatch Plan',
        district: 'Chennai',
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
        messages: [
          AIChatMessageModel(
            id: 'M-23',
            text: 'Check antivenom availability across state depots.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 10)),
          ),
          AIChatMessageModel(
            id: 'M-24',
            text: 'Statewide stockpile: 120 vials across 4 coastal warehouses. Cuddalore and Nagapattinam have immediate supply available.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 9, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-12',
        title: 'Dewatering Pump Fleet Optimization',
        district: 'Chennai',
        createdAt: DateTime.now().subtract(const Duration(hours: 11)),
        messages: [
          AIChatMessageModel(
            id: 'M-25',
            text: 'Where are the 4-inch trash pumps deployed?',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 11)),
          ),
          AIChatMessageModel(
            id: 'M-26',
            text: '48 total pumps: 22 deployed in Chennai lowlands, 14 in Cuddalore, 12 in reserve at Madurai central depot.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 10, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-13',
        title: 'Aerial Drone Patrol Scheduling',
        district: 'Coimbatore',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        messages: [
          AIChatMessageModel(
            id: 'M-27',
            text: 'Schedule nighttime thermal drone sweep over Western Ghats.',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          ),
          AIChatMessageModel(
            id: 'M-28',
            text: 'Flight scheduled for 21:00 with Hexacopter 01 and 02. Battery hubs pre-charged.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 11, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-14',
        title: 'Emergency Fuel Logistics Allocation',
        district: 'Tirunelveli',
        createdAt: DateTime.now().subtract(const Duration(hours: 13)),
        messages: [
          AIChatMessageModel(
            id: 'M-29',
            text: 'How much diesel is allocated for rescue boats in Tirunelveli?',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 13)),
          ),
          AIChatMessageModel(
            id: 'M-30',
            text: '180 drums (36,000 Liters) in Southern Reserve WH-06. 800 liters dispatched to boat fueling station at High Ground.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 12, minutes: 58)),
          ),
        ],
      ),
      AIChatSessionModel(
        id: 'CHAT-15',
        title: 'Shelter Capacity Telemetry Status',
        district: 'Chennai',
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
        messages: [
          AIChatMessageModel(
            id: 'M-31',
            text: 'What is overall shelter occupancy in Chennai?',
            sender: ChatSender.user,
            timestamp: DateTime.now().subtract(const Duration(hours: 14)),
          ),
          AIChatMessageModel(
            id: 'M-32',
            text: 'Total capacity: 1,850. Current occupancy: 1,450 (78%). 400 beds available across Nehru Indoor Stadium and Velachery Hall.',
            sender: ChatSender.aiCommander,
            timestamp: DateTime.now().subtract(const Duration(hours: 13, minutes: 58)),
          ),
        ],
      ),
    ]);
  }

  // ===========================================================================
  // PUBLIC ACCESSORS & MUTATORS
  // ===========================================================================

  List<AIRecommendationModel> get recommendations => List.unmodifiable(_recommendations);
  List<IncidentAnalysisModel> get incidentAnalyses => List.unmodifiable(_incidentAnalyses);
  List<AIChatSessionModel> get chatSessions => List.unmodifiable(_chatSessions);

  AICommanderSummary getSummary() {
    final activeSessions = _chatSessions.length;
    final incidentsCount = _incidentAnalyses.length;
    final recommendationsCount = _recommendations.length;
    final highRiskCount = _incidentAnalyses.where((i) => i.riskScore >= 80).length;
    final executedRecs = _recommendations.where((r) => r.isExecuted).length;

    final avgConf = _incidentAnalyses.isNotEmpty
        ? _incidentAnalyses.fold(0.0, (sum, i) => sum + i.aiConfidence) / _incidentAnalyses.length
        : 0.90;

    return AICommanderSummary(
      activeAISessions: activeSessions,
      incidentsAnalyzed: incidentsCount,
      recommendationsGenerated: recommendationsCount,
      highRiskAlerts: highRiskCount,
      averageConfidence: avgConf,
      executedRecommendations: executedRecs,
    );
  }

  SituationSummary getSituationSummary({String? district}) {
    final targetDistrict = district != null && district != 'All' ? district : 'Statewide Disaster Zone';
    final activeIncidents = _incidentAnalyses.where((i) =>
        district == null || district == 'All' || i.district.toLowerCase() == district.toLowerCase()).toList();

    final totalPop = activeIncidents.fold(0, (sum, i) => sum + i.estimatedPopulation);

    return SituationSummary(
      id: 'SITREP-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      headline: 'State Disaster Response: Multi-Sector Monsoon & Flood Coordination',
      incidentOverview: 'Multiple emergency incidents active across ${activeIncidents.length} priority sectors. Peak river discharge and storm surge currently affecting ${targetDistrict}. High-risk urban flooding detected with $totalPop civilians in impacted floodplains.',
      resourcesDeployed: const [
        '36 Inflatable Rubber Boats (IRB) deployed across 4 coastal river deltas',
        '28 Emergency Ambulances operational with Level-1 trauma links',
        '14 Tactical UAV reconnaissance drones providing persistent aerial video',
        '45,000 ready-to-eat ration packs and 85,000 liters purified water distributed',
      ],
      emergingRisks: const [
        'Hydrological surge in Thamirabarani and Cauvery basins cresting in 2 to 4 hours',
        'Secondary rockfall risk on Valparai and Yercaud ghat transit corridors',
        'Localized power substation submergence requiring remote de-energization',
      ],
      suggestedNextActions: const [
        'Accelerate zero-casualty evacuation in Sindupoondurai and Cuddalore beach corridors',
        'Air-drop satellite broadband terminals to isolated rescue staging posts',
        'Replenish antivenom and trauma suture inventory at district headquarters hospitals',
      ],
      generatedAt: DateTime.now(),
      primaryDistrict: targetDistrict,
      totalEvacuees: (totalPop * 0.45).toInt(),
      activeMissions: 18,
    );
  }

  AIRecommendationModel executeRecommendation(String id) {
    final idx = _recommendations.indexWhere((r) => r.id == id);
    if (idx == -1) throw Exception('Recommendation $id not found');

    final old = _recommendations[idx];
    final updated = AIRecommendationModel(
      id: old.id,
      incidentId: old.incidentId,
      title: old.title,
      recommendation: old.recommendation,
      reasoning: old.reasoning,
      estimatedImpact: old.estimatedImpact,
      priority: old.priority,
      difficulty: old.difficulty,
      requiredResources: old.requiredResources,
      timestamp: old.timestamp,
      isExecuted: true,
    );

    _recommendations[idx] = updated;
    return updated;
  }

  IncidentAnalysisModel toggleActionItem({
    required String incidentId,
    required String actionItemId,
    required bool isCompleted,
  }) {
    final idx = _incidentAnalyses.indexWhere((i) => i.id == incidentId);
    if (idx == -1) throw Exception('Incident $incidentId not found');

    final old = _incidentAnalyses[idx];
    final updatedActions = old.recommendedActions.map((a) {
      if (a.id == actionItemId) {
        return ActionItemModel(
          id: a.id,
          action: a.action,
          responsibleUnit: a.responsibleUnit,
          isCompleted: isCompleted,
        );
      }
      return a is ActionItemModel ? a : ActionItemModel(id: a.id, action: a.action, responsibleUnit: a.responsibleUnit, isCompleted: a.isCompleted);
    }).toList();

    final updated = IncidentAnalysisModel(
      id: old.id,
      title: old.title,
      incidentType: old.incidentType,
      severity: old.severity,
      district: old.district,
      affectedArea: old.affectedArea,
      estimatedPopulation: old.estimatedPopulation,
      riskScore: old.riskScore,
      aiConfidence: old.aiConfidence,
      recommendedActions: updatedActions,
      environmentalFactors: old.environmentalFactors,
      analyzedAt: old.analyzedAt,
      summaryNotes: old.summaryNotes,
      latitude: old.latitude,
      longitude: old.longitude,
    );

    _incidentAnalyses[idx] = updated;
    return updated;
  }

  AIChatMessageModel generateAIResponse({
    required String sessionId,
    required String promptText,
    String? relatedIncidentId,
  }) {
    final prompt = promptText.toLowerCase().trim();
    String responseText;
    List<String> suggestions = ['Analyze flood risk', 'Suggest evacuation plan', 'Find safest rescue route'];

    if (prompt.contains('flood') || prompt.contains('water') || prompt.contains('river')) {
      responseText = '### **AI Flood Risk Analysis & Tactical Guidance**\n\n'
          '• **Threat Index:** Elevated (**Risk Score 92/100**)\n'
          '• **Hydrology Forecast:** Upstream catchment inflow cresting in ~45 minutes.\n'
          '• **Immediate Directive:** Pre-position Inflatable Rescue Boats (IRBs) at river quadrant bridges and establish elevated dry staging corridors.\n'
          '• **Power Grid:** Advise immediate remote feeder cut to avoid underwater electrocution.';
      suggestions = ['Suggest evacuation plan', 'Allocate rescue teams', 'Find safest rescue route'];
    } else if (prompt.contains('evacuat') || prompt.contains('plan') || prompt.contains('shelter')) {
      responseText = '### **AI Evacuation Action Blueprint**\n\n'
          '• **Primary Exit Corridor:** High-elevation bypass arterial road -> Multi-Hazard Shelter.\n'
          '• **Transport Dispatch:** 3x high-clearance 4x4 trucks pre-allocated from nearest regional depot.\n'
          '• **Vulnerable Demographics:** Priority evacuation for 450 elderly and infant residents located on ground-floor dwellings.';
      suggestions = ['Dispatch transport vehicles', 'Check hospital ICU capacity', 'Resource optimization'];
    } else if (prompt.contains('route') || prompt.contains('safe') || prompt.contains('path')) {
      responseText = '### **Safest Tactical Rescue Navigation**\n\n'
          '• **Optimal Path:** Follow Elevated MRTS Corridor / Northern Bypass (Zero flood risk).\n'
          '• **Hazard Zone Avoidance:** Avoid South River Road (1.2m standing water with high debris velocity).\n'
          '• **Speed & Clearance:** 20-ton rescue trucks cleared for travel with convoy escort.';
      suggestions = ['Broadcast route to patrol units', 'Analyze flood risk'];
    } else if (prompt.contains('team') || prompt.contains('squad') || prompt.contains('dispatch')) {
      responseText = '### **Squad & Personnel Optimization**\n\n'
          '• **Recommended Squad:** Alpha Coastal Rescue Squad & Paramedic Unit.\n'
          '• **Equipment Loadout:** 4x IRBs, 50x SOLAS Life Vests, 2x Medical Trauma Packs, 1x Satellite Comms Terminal.\n'
          '• **Estimated Deployment Time:** 15 minutes to sector zero.';
      suggestions = ['Confirm team dispatch', 'Review available fleet'];
    } else if (prompt.contains('resource') || prompt.contains('inventory') || prompt.contains('stock')) {
      responseText = '### **Logistics Stockpile Optimization**\n\n'
          '• **Ration Supply:** 12,000 ready-to-eat packs ready at central warehouse.\n'
          '• **Potable Water:** 35,000 bottled liters staged for rapid distribution.\n'
          '• **Reorder Warning:** Polyvalent snake antivenom is at critical threshold (reorder triggered).';
      suggestions = ['Open Inventory Screen', 'Create Dispatch Order'];
    } else {
      responseText = '### **AI Commander Tactical Response**\n\n'
          'Telemetry processed for "$promptText". All disaster sensors are active and streaming real-time situational telemetry. Ready to generate tactical mission plans, route optimizations, or squad allocations.';
    }

    final aiMsg = AIChatMessageModel(
      id: 'MSG-${DateTime.now().millisecondsSinceEpoch}',
      text: responseText,
      sender: ChatSender.aiCommander,
      timestamp: DateTime.now(),
      actionSuggestions: suggestions,
      relatedIncidentId: relatedIncidentId,
    );

    final sessionIdx = _chatSessions.indexWhere((s) => s.id == sessionId);
    if (sessionIdx != -1) {
      final oldSession = _chatSessions[sessionIdx];
      final userMsg = AIChatMessageModel(
        id: 'MSG-U-${DateTime.now().millisecondsSinceEpoch}',
        text: promptText,
        sender: ChatSender.user,
        timestamp: DateTime.now().subtract(const Duration(milliseconds: 500)),
      );

      final updatedMsgs = [...oldSession.messages, userMsg, aiMsg];
      _chatSessions[sessionIdx] = AIChatSessionModel(
        id: oldSession.id,
        title: oldSession.title,
        district: oldSession.district,
        createdAt: oldSession.createdAt,
        messages: updatedMsgs,
      );
    }

    return aiMsg;
  }

  AIChatSessionModel createSession({required String title, required String district}) {
    final session = AIChatSessionModel(
      id: 'CHAT-${DateTime.now().millisecondsSinceEpoch}',
      title: title.isEmpty ? 'Mission Intelligence Session' : title,
      district: district.isEmpty ? 'General' : district,
      createdAt: DateTime.now(),
      messages: [
        AIChatMessageModel(
          id: 'MSG-INIT-${DateTime.now().millisecondsSinceEpoch}',
          text: 'AI Commander online. Real-time disaster sensor feeds and tactical recommendation engines are synchronized. How can I assist with mission command?',
          sender: ChatSender.aiCommander,
          timestamp: DateTime.now(),
          actionSuggestions: const [
            'Analyze flood risk',
            'Suggest evacuation plan',
            'Find safest rescue route',
            'Allocate rescue teams',
            'Resource optimization',
          ],
        ),
      ],
    );

    _chatSessions.insert(0, session);
    return session;
  }

  bool clearSession(String sessionId) {
    final idx = _chatSessions.indexWhere((s) => s.id == sessionId);
    if (idx != -1) {
      final s = _chatSessions[idx];
      _chatSessions[idx] = AIChatSessionModel(
        id: s.id,
        title: s.title,
        district: s.district,
        createdAt: s.createdAt,
        messages: [],
      );
      return true;
    }
    return false;
  }
}
