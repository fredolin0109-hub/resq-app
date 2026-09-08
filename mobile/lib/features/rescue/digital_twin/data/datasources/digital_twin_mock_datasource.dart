import '../models/digital_twin_models.dart';
import '../../domain/entities/digital_twin_entities.dart';

/// Comprehensive mock data source for the Digital Twin Command Center.
/// Covers 13 Tamil Nadu disaster-prone districts with realistic spatial,
/// telemetry, chronological, predictive, and simulation telemetry.
class DigitalTwinMockDatasource {
  static const List<String> tamilNaduDistricts = [
    'Chennai',
    'Cuddalore',
    'Nagapattinam',
    'Tirunelveli',
    'Thoothukudi',
    'Madurai',
    'Coimbatore',
    'Salem',
    'Tiruchirappalli',
    'Vellore',
    'Thanjavur',
    'Erode',
    'Kanyakumari',
  ];

  /// Realistic base GPS coordinates for 13 key Tamil Nadu districts.
  static const Map<String, (double lat, double lng)> districtCoordinates = {
    'Chennai': (13.0827, 80.2707),
    'Cuddalore': (11.7480, 79.7714),
    'Nagapattinam': (10.7654, 79.8424),
    'Tirunelveli': (8.7139, 77.7567),
    'Thoothukudi': (8.7642, 78.1348),
    'Madurai': (9.9252, 78.1198),
    'Coimbatore': (11.0168, 76.9558),
    'Salem': (11.6643, 78.1460),
    'Tiruchirappalli': (10.7905, 78.7047),
    'Vellore': (12.9165, 79.1325),
    'Thanjavur': (10.7870, 79.1378),
    'Erode': (11.3410, 77.7172),
    'Kanyakumari': (8.0883, 77.5385),
  };

  /// High-level summary of active disaster twin state.
  DigitalTwinSummary getSummary() {
    return const DigitalTwinSummary(
      activeIncidents: 42,
      highRiskDistricts: 5,
      activeRescueTeams: 38,
      availableResourcesCount: 1240,
      sheltersOccupied: 46,
      totalShelters: 80,
      hospitalsAvailable: 34,
      totalHospitals: 42,
      populationAtRisk: 185200,
      aiPredictionAccuracy: 0.942,
    );
  }

  /// Real-time live analytics telemetry.
  LiveAnalyticsData getLiveAnalytics({String? district}) {
    final isCoastal = district == 'Chennai' ||
        district == 'Cuddalore' ||
        district == 'Nagapattinam' ||
        district == 'Thoothukudi' ||
        district == 'Kanyakumari';

    return LiveAnalyticsData(
      incidentCount: district == null ? 42 : 12,
      riskTrend: isCoastal
          ? [55.0, 62.0, 74.0, 86.5, 93.0, 89.0, 84.5]
          : [40.0, 48.0, 56.0, 68.0, 72.0, 65.0, 60.0],
      precipitationTrend: isCoastal
          ? [24.0, 48.0, 75.0, 110.0, 95.0, 62.0, 35.0]
          : [10.0, 18.0, 32.0, 45.0, 30.0, 20.0, 12.0],
      populationImpacted: district == null ? 185200 : 34500,
      roadAvailabilityRatio: 0.72,
      waterLevelMeters: isCoastal ? 4.85 : 2.10,
      waterLevelDangerThreshold: 4.50,
      powerGridStable: !isCoastal,
      communicationTowerUptime: 0.945,
    );
  }

  /// 100+ Spatial Heatmap Points distributed across 13 Tamil Nadu districts and 10 layers.
  List<HeatmapPointModel> getHeatmapPoints({
    Set<HeatmapLayerType>? activeLayers,
    String? district,
  }) {
    final allPoints = _generateHeatmapPoints();
    return allPoints.where((p) {
      if (activeLayers != null &&
          activeLayers.isNotEmpty &&
          !activeLayers.contains(p.layerType)) {
        return false;
      }
      if (district != null &&
          district != 'All' &&
          p.district.toLowerCase() != district.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  /// 50 Chronological Timeline Events.
  List<TimelineEventModel> getTimelineEvents({
    String? district,
    TimelineEventType? eventType,
    String? incidentId,
    String? searchQuery,
  }) {
    final allEvents = _generateTimelineEvents();
    return allEvents.where((e) {
      if (district != null &&
          district != 'All' &&
          e.district.toLowerCase() != district.toLowerCase()) {
        return false;
      }
      if (eventType != null && e.eventType != eventType) {
        return false;
      }
      if (incidentId != null &&
          incidentId.isNotEmpty &&
          e.incidentId != incidentId) {
        return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.toLowerCase().trim();
        final match = e.title.toLowerCase().contains(query) ||
            e.description.toLowerCase().contains(query) ||
            e.district.toLowerCase().contains(query) ||
            e.loggedBy.toLowerCase().contains(query);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  /// 30 Infrastructure Assets.
  List<InfrastructureAssetModel> getInfrastructureAssets({
    String? district,
    InfrastructureType? type,
    InfrastructureStatus? status,
    String? searchQuery,
  }) {
    final allAssets = _generateInfrastructureAssets();
    return allAssets.where((a) {
      if (district != null &&
          district != 'All' &&
          a.district.toLowerCase() != district.toLowerCase()) {
        return false;
      }
      if (type != null && a.type != type) {
        return false;
      }
      if (status != null && a.status != status) {
        return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.toLowerCase().trim();
        final match = a.name.toLowerCase().contains(query) ||
            a.district.toLowerCase().contains(query) ||
            a.locationAddress.toLowerCase().contains(query) ||
            a.telemetryNotes.toLowerCase().contains(query);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  /// 40 AI Predictions.
  List<DigitalTwinPredictionModel> getAIPredictions({
    String? district,
    PredictionType? type,
    String? searchQuery,
  }) {
    final allPredictions = _generatePredictions();
    return allPredictions.where((p) {
      if (district != null &&
          district != 'All' &&
          p.district.toLowerCase() != district.toLowerCase()) {
        return false;
      }
      if (type != null && p.type != type) {
        return false;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.toLowerCase().trim();
        final match = p.title.toLowerCase().contains(query) ||
            p.district.toLowerCase().contains(query) ||
            p.affectedZone.toLowerCase().contains(query) ||
            p.projectedOutcome.toLowerCase().contains(query) ||
            p.preventiveAction.toLowerCase().contains(query);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  /// 5 Preset Disaster Simulations.
  List<DisasterSimulation> getSimulations() {
    return [
      const DisasterSimulation(
        type: SimulationType.flood,
        title: 'Cyclone Michaung Adyar Basin Inundation Surge',
        district: 'Chennai',
        progress: 0.65,
        isPlaying: false,
        speedMultiplier: 1.0,
        simulatedCasualtiesPrevented: 1420,
        estimatedEvacuated: 8500,
        statusDescription:
            'Peak surge in 45 mins. Chembarambakkam outflow regulated to 8,000 cusecs.',
      ),
      const DisasterSimulation(
        type: SimulationType.cyclone,
        title: 'Severe Cyclonic Storm Gaja Coastal Landfall',
        district: 'Nagapattinam',
        progress: 0.40,
        isPlaying: false,
        speedMultiplier: 2.0,
        simulatedCasualtiesPrevented: 2890,
        estimatedEvacuated: 14200,
        statusDescription:
            'Sustained winds 130 km/h. Coastal seawall breached at Point Calimere.',
      ),
      const DisasterSimulation(
        type: SimulationType.earthquake,
        title: 'Richter 5.8 Structural Tremor Fault Simulation',
        district: 'Salem',
        progress: 0.20,
        isPlaying: false,
        speedMultiplier: 1.0,
        simulatedCasualtiesPrevented: 640,
        estimatedEvacuated: 3100,
        statusDescription:
            'Subsurface fault rupture. Yercaud Foothill bridge structure integrity at risk.',
      ),
      const DisasterSimulation(
        type: SimulationType.fire,
        title: 'Sivakasi Fireworks Industrial Zone Thermal Runaway',
        district: 'Madurai',
        progress: 0.85,
        isPlaying: false,
        speedMultiplier: 5.0,
        simulatedCasualtiesPrevented: 1150,
        estimatedEvacuated: 5400,
        statusDescription:
            'Perimeter contained 85%. Industrial hazard corridor evacuated.',
      ),
      const DisasterSimulation(
        type: SimulationType.landslide,
        title: 'Western Ghats Monsoon Debris Avalanche',
        district: 'Coimbatore',
        progress: 0.50,
        isPlaying: false,
        speedMultiplier: 1.0,
        simulatedCasualtiesPrevented: 480,
        estimatedEvacuated: 2200,
        statusDescription:
            'Valparai ghat road sector 4 blocked by 12,000 tons of boulder silt.',
      ),
    ];
  }

  // ===========================================================================
  // PRIVATE GENERATORS WITH 100+ HEATMAPS, 50 TIMELINES, 40 PREDICTIONS, 30 ASSETS
  // ===========================================================================

  List<HeatmapPointModel> _generateHeatmapPoints() {
    final points = <HeatmapPointModel>[];
    int idCounter = 1;

    for (int d = 0; d < tamilNaduDistricts.length; d++) {
      final district = tamilNaduDistricts[d];
      final coords = districtCoordinates[district] ?? (13.0827, 80.2707);
      final baseLat = coords.$1;
      final baseLng = coords.$2;

      for (int l = 0; l < HeatmapLayerType.values.length; l++) {
        final layer = HeatmapLayerType.values[l];
        final offsetLat = ((l * 7 + d * 13) % 20 - 10) * 0.007;
        final offsetLng = ((l * 11 + d * 17) % 20 - 10) * 0.007;
        final intensity = (((d * 7 + l * 13) % 80) + 20) / 100.0;
        final radius = 350.0 + ((d + l) % 6) * 200.0;

        points.add(
          HeatmapPointModel(
            id: 'HP-${idCounter.toString().padLeft(4, '0')}',
            latitude: baseLat + offsetLat,
            longitude: baseLng + offsetLng,
            intensity: double.parse(intensity.toStringAsFixed(2)),
            radiusMeters: radius,
            layerType: layer,
            district: district,
            description: '${layer.displayName} Hotspot Zone #$idCounter in $district',
          ),
        );
        idCounter++;
      }
    }

    return points;
  }

  List<TimelineEventModel> _generateTimelineEvents() {
    final now = DateTime.now();
    final events = <TimelineEventModel>[];

    final rawTemplates = [
      (
        'Severe Flash Flood Inundation Reported',
        'Water level crossed 3.2m in residential lowlands. 120 families stranded.',
        TimelineEventType.incidentReported,
        'Chennai',
        'INC-CHN-101',
        120,
        'Velachery Command Unit',
        15,
      ),
      (
        'AI Predictive Inundation Simulation Generated',
        'AI model anticipates 45cm rise along Adyar River within 90 minutes.',
        TimelineEventType.aiAnalysis,
        'Chennai',
        'INC-CHN-101',
        350,
        'ResQLink AI Core Engine',
        22,
      ),
      (
        'Emergency Inflatable Boats & Drones Dispatched',
        '10 motorized Gemini boats and 4 aerial reconnaissance drones mobilized.',
        TimelineEventType.resourcesAssigned,
        'Chennai',
        'INC-CHN-101',
        0,
        'Central Logistics Depot',
        30,
      ),
      (
        'NDRF Alpha Battalion Dispatched to Ward 172',
        'Specialized swift water rescue team underway with heavy amphibious gear.',
        TimelineEventType.teamsDispatched,
        'Chennai',
        'INC-CHN-101',
        0,
        'State Disaster Dispatcher',
        38,
      ),
      (
        '84 High-Risk Civilians Rescued and Stabilized',
        'Responders extracted elderly and children to temporary raised platforms.',
        TimelineEventType.victimsRescued,
        'Chennai',
        'INC-CHN-101',
        84,
        'NDRF Alpha Team Leader',
        45,
      ),
      (
        'Community Hall Relief Shelter 04 Activated',
        'Shelter equipped with 400 cots, hot meals, water purification units.',
        TimelineEventType.sheltersActivated,
        'Chennai',
        'INC-CHN-101',
        150,
        'District Relief Officer',
        55,
      ),
      (
        'Adyar Sector 4 Evacuation Mission Completed',
        'All designated red-zone residents safely relocated with zero casualties.',
        TimelineEventType.missionCompleted,
        'Chennai',
        'INC-CHN-101',
        180,
        'Incident Commander',
        68,
      ),
      (
        'Coastal Storm Surge Warning Triggered',
        'Gale force winds of 95 km/h recorded with 2.8m tidal wave surge.',
        TimelineEventType.incidentReported,
        'Cuddalore',
        'INC-CUD-204',
        450,
        'IMD Coastal Radar Station',
        75,
      ),
      (
        'AI Storm Vector Predicts Harbor Sea Wall Breach',
        'Digital Twin simulation highlights vulnerable 300m parapet barrier.',
        TimelineEventType.aiAnalysis,
        'Cuddalore',
        'INC-CUD-204',
        900,
        'AI GeoSpatial Sensor Grid',
        82,
      ),
      (
        'Heavy Sandbag Reinforcements Allocated',
        '5,000 geotextile bags and heavy earthmovers routed to harbor mouth.',
        TimelineEventType.resourcesAssigned,
        'Cuddalore',
        'INC-CUD-204',
        0,
        'PWD Supply Coordinator',
        90,
      ),
      (
        'Coast Guard Tactical Hovercraft Dispatched',
        'ICG Unit 03 patrolling estuaries to guide fishing vessels back.',
        TimelineEventType.teamsDispatched,
        'Cuddalore',
        'INC-CUD-204',
        0,
        'Maritime Rescue Center',
        105,
      ),
      (
        '36 Fishermen Escorted to Safety Harbor',
        'Vessels escorted past rough surf line into sheltered breakwater basin.',
        TimelineEventType.victimsRescued,
        'Cuddalore',
        'INC-CUD-204',
        36,
        'Coast Guard Ops',
        120,
      ),
      (
        'Coastal Cyclone Shelter C-12 Activated',
        'Reinforced multi-purpose cyclone shelter opened for 800 coastal residents.',
        TimelineEventType.sheltersActivated,
        'Cuddalore',
        'INC-CUD-204',
        420,
        'TNDRMF Coordinator',
        135,
      ),
      (
        'Harbor Embankment Stabilization Complete',
        'Breach averted; floodwaters routed into diversion channels.',
        TimelineEventType.missionCompleted,
        'Cuddalore',
        'INC-CUD-204',
        600,
        'Joint Task Force Lead',
        150,
      ),
      (
        'Tsunami Warning Buoy Anomaly Detected',
        'Deep ocean pressure recorder triggered minor seismic sea wave alert.',
        TimelineEventType.incidentReported,
        'Nagapattinam',
        'INC-NGP-302',
        2200,
        'INCOIS Early Warning',
        160,
      ),
      (
        'AI Bathymetry Wave Height Analysis Completed',
        'Predicted wave amplitude downgraded to non-destructive 0.8m swell.',
        TimelineEventType.aiAnalysis,
        'Nagapattinam',
        'INC-NGP-302',
        0,
        'Digital Twin DeepOcean Model',
        170,
      ),
      (
        'Precautionary Megaphone Sirens Activated',
        'Coastal siren network sounded yellow precautionary advisory.',
        TimelineEventType.resourcesAssigned,
        'Nagapattinam',
        'INC-NGP-302',
        0,
        'District Disaster Control',
        185,
      ),
      (
        'SDRF Coastal Patrol Units Deployed',
        'Mobile units clearing beachgoers and tourist profiles.',
        TimelineEventType.teamsDispatched,
        'Nagapattinam',
        'INC-NGP-302',
        0,
        'Nagapattinam Police Control',
        195,
      ),
      (
        '18 Beach Tourists Safely Cleared from Shore',
        'Responders guided families to high ground assembly points.',
        TimelineEventType.victimsRescued,
        'Nagapattinam',
        'INC-NGP-302',
        18,
        'SDRF Shore Patrol',
        210,
      ),
      (
        'Velankanni Pilgrim Relief Center Opened',
        'Safe sanctuary established with drinking water & first-aid booths.',
        TimelineEventType.sheltersActivated,
        'Nagapattinam',
        'INC-NGP-302',
        120,
        'Municipal Commissioner',
        225,
      ),
      (
        'Seismic Wave Advisory Normalization Declared',
        'All oceanographic sensors reporting calm baseline tides.',
        TimelineEventType.missionCompleted,
        'Nagapattinam',
        'INC-NGP-302',
        0,
        'State Disaster Management',
        240,
      ),
      (
        'Thamirabarani River Overflow Alarm',
        'Water release from Manimuthar Dam reached 45,000 cusecs.',
        TimelineEventType.incidentReported,
        'Tirunelveli',
        'INC-TIR-401',
        650,
        'Irrigation Control Desk',
        255,
      ),
      (
        'AI Hydraulic Drainage Routing Model Active',
        'Recommended secondary sluice gates opening at Palayamkottai channel.',
        TimelineEventType.aiAnalysis,
        'Tirunelveli',
        'INC-TIR-401',
        1200,
        'Twin Hydro Engine',
        270,
      ),
      (
        'Mobile Dewatering Pumps Assigned',
        '8 high-capacity 50HP diesel dewatering pumps dispatched.',
        TimelineEventType.resourcesAssigned,
        'Tirunelveli',
        'INC-TIR-401',
        0,
        'City Municipal Depot',
        285,
      ),
      (
        'Fire & Rescue Swiftwater Unit Bravo Dispatched',
        'Trained divers deploying rescue kayaks along riverside ghats.',
        TimelineEventType.teamsDispatched,
        'Tirunelveli',
        'INC-TIR-401',
        0,
        'Tirunelveli Fire HQ',
        300,
      ),
      (
        '52 Trapped Villagers Evacuated by Raft',
        'Families marooned on riverbank islet brought safely to shore.',
        TimelineEventType.victimsRescued,
        'Tirunelveli',
        'INC-TIR-401',
        52,
        'Swiftwater Unit Bravo',
        315,
      ),
      (
        'Palayamkottai Higher Secondary Shelter Opened',
        'Equipped with bedding, baby food formula, medical triage kit.',
        TimelineEventType.sheltersActivated,
        'Tirunelveli',
        'INC-TIR-401',
        210,
        'Revenue Divisional Officer',
        330,
      ),
      (
        'River Basin Drainage Successfully Controlled',
        'Water receded below danger mark by 65cm. Roads reopened.',
        TimelineEventType.missionCompleted,
        'Tirunelveli',
        'INC-TIR-401',
        350,
        'Command Control Desk',
        345,
      ),
      (
        'Industrial Salt Pan Flooding Emergency',
        'Seawater breached 2km barrier into coastal industrial complexes.',
        TimelineEventType.incidentReported,
        'Thoothukudi',
        'INC-THO-501',
        310,
        'Port Authority Ops',
        360,
      ),
      (
        'AI Chemical Runoff Hazard Assessment',
        'Identified potential brine & sulfur contamination perimeter.',
        TimelineEventType.aiAnalysis,
        'Thoothukudi',
        'INC-THO-501',
        800,
        'AI Environmental Sensor',
        375,
      ),
      (
        'Chemical Spill Containment Booms Allocated',
        '600 meters of floating absorbent booms and neutralizer trucks.',
        TimelineEventType.resourcesAssigned,
        'Thoothukudi',
        'INC-THO-501',
        0,
        'Hazmat Logistics Unit',
        390,
      ),
      (
        'Hazmat Emergency Response Team Dispatched',
        'Specialized NBC-protective responders onsite with air samplers.',
        TimelineEventType.teamsDispatched,
        'Thoothukudi',
        'INC-THO-501',
        0,
        'State Hazmat Command',
        405,
      ),
      (
        '28 Factory Workers Evacuated from Complex',
        'Staff escorted through decontamination corridor with oxygen masks.',
        TimelineEventType.victimsRescued,
        'Thoothukudi',
        'INC-THO-501',
        28,
        'Hazmat Response Team',
        420,
      ),
      (
        'SIPCOT Relief Camp Alpha Activated',
        'Sanitized emergency accommodations for 300 industrial staff.',
        TimelineEventType.sheltersActivated,
        'Thoothukudi',
        'INC-THO-501',
        110,
        'Industrial Safety Board',
        435,
      ),
      (
        'Chemical Containment Successful',
        'Air and soil toxicity sensors returned to baseline zero risk.',
        TimelineEventType.missionCompleted,
        'Thoothukudi',
        'INC-THO-501',
        220,
        'Hazmat Chief Inspector',
        450,
      ),
      (
        'Urban Flash Fire in Commercial Market',
        'Multi-story warehouse fire with high wind hazard.',
        TimelineEventType.incidentReported,
        'Madurai',
        'INC-MDU-601',
        180,
        'City 101 Fire Dispatch',
        465,
      ),
      (
        'AI Thermal Plume & Wind Vector Simulation',
        'Projected thermal radiation cone toward adjacent textile stalls.',
        TimelineEventType.aiAnalysis,
        'Madurai',
        'INC-MDU-601',
        450,
        'ResQLink Thermal Engine',
        480,
      ),
      (
        'Foam Tender Units and Water Bowsers Assigned',
        '4 heavy foam tenders and 12 water tankers routed to market perimeter.',
        TimelineEventType.resourcesAssigned,
        'Madurai',
        'INC-MDU-601',
        0,
        'Madurai Fire Logistics',
        495,
      ),
      (
        'Fire Brigade Delta & Echo Deployed',
        '65 firefighters deploying aerial ladder platforms and mist nozzles.',
        TimelineEventType.teamsDispatched,
        'Madurai',
        'INC-MDU-601',
        0,
        'Regional Fire Officer',
        510,
      ),
      (
        '41 Trapped Shopkeepers Rescued via Skylift',
        'Responders extracted victims from 3rd floor rooftop terrace.',
        TimelineEventType.victimsRescued,
        'Madurai',
        'INC-MDU-601',
        41,
        'Fire Brigade Delta',
        525,
      ),
      (
        'Meenakshi Community Hall Shelter Activated',
        'Temporary refuge offering medical burn treatment and dry rations.',
        TimelineEventType.sheltersActivated,
        'Madurai',
        'INC-MDU-601',
        85,
        'City Relief Team',
        540,
      ),
      (
        'Commercial Fire Fully Extinguished & Cooled',
        'Thermal scans confirm zero smoldering hotspots across all 4 storeys.',
        TimelineEventType.missionCompleted,
        'Madurai',
        'INC-MDU-601',
        180,
        'Madurai Fire Marshal',
        555,
      ),
      (
        'Ghat Road Landslide Debris Avalanche',
        'Rockfall severed Coimbatore-Anaimalai route at hairpin bend 14.',
        TimelineEventType.incidentReported,
        'Coimbatore',
        'INC-CBE-701',
        95,
        'Highways Patrol Unit',
        570,
      ),
      (
        'AI Slope Stability & Seismograph Analysis',
        'Identified continuous moisture saturation causing slope shear.',
        TimelineEventType.aiAnalysis,
        'Coimbatore',
        'INC-CBE-701',
        250,
        'AI Geotech Model',
        585,
      ),
      (
        'Hydraulic Rock Breakers & Cranes Assigned',
        'Heavy equipment mobilized from Pollachi engineering depot.',
        TimelineEventType.resourcesAssigned,
        'Coimbatore',
        'INC-CBE-701',
        0,
        'Highways Dept Command',
        600,
      ),
      (
        'High Altitude Mountain Rescue Squad Deployed',
        'Specialized team with ropes and rappelling stretchers.',
        TimelineEventType.teamsDispatched,
        'Coimbatore',
        'INC-CBE-701',
        0,
        'Nilgiris Mountain Command',
        615,
      ),
      (
        '23 Motorists Extracted from Stranded Vehicles',
        'Crews safely escorted 6 tourist cars past secondary debris chute.',
        TimelineEventType.victimsRescued,
        'Coimbatore',
        'INC-CBE-701',
        23,
        'Mountain Rescue Squad',
        630,
      ),
      (
        'Pollachi Transit Relief Shelter Activated',
        'Emergency shelter for stranded ghat travelers with warm blankets.',
        TimelineEventType.sheltersActivated,
        'Coimbatore',
        'INC-CBE-701',
        60,
        'District Collectorate',
        645,
      ),
      (
        'Hairpin Bend 14 Landslide Fully Cleared',
        'Single-lane traffic safely restored under police pilot vehicle convoy.',
        TimelineEventType.missionCompleted,
        'Coimbatore',
        'INC-CBE-701',
        95,
        'Highways Superintendent',
        660,
      ),
      (
        'Cauvery River Sluice Gate Overspill Alert',
        'Discharge crossed 80,000 cusecs at Mettur Dam discharge conduit.',
        TimelineEventType.incidentReported,
        'Salem',
        'INC-SLM-801',
        540,
        'Mettur Dam Authority',
        675,
      ),
    ];

    for (int i = 0; i < rawTemplates.length; i++) {
      final t = rawTemplates[i];
      events.add(
        TimelineEventModel(
          id: 'TLE-${(i + 1).toString().padLeft(4, '0')}',
          title: t.$1,
          description: t.$2,
          eventType: t.$3,
          district: t.$4,
          incidentId: t.$5,
          timestamp: now.subtract(Duration(minutes: t.$8)),
          affectedCount: t.$6,
          loggedBy: t.$7,
        ),
      );
    }

    return events;
  }

  List<InfrastructureAssetModel> _generateInfrastructureAssets() {
    final now = DateTime.now();
    return [
      InfrastructureAssetModel(
        id: 'INF-001',
        name: 'Rajiv Gandhi Government General Hospital',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Chennai',
        locationAddress: 'EVR Periyar Salai, Park Town, Chennai',
        latitude: 13.0805,
        longitude: 80.2785,
        operationalCapacityRatio: 0.92,
        lastInspected: now.subtract(const Duration(hours: 2)),
        telemetryNotes: 'ICU generators on standby. 240 emergency trauma beds staffed.',
      ),
      InfrastructureAssetModel(
        id: 'INF-002',
        name: 'Kattankulathur Substation 400kV Grid',
        type: InfrastructureType.powerGrid,
        status: InfrastructureStatus.operational,
        district: 'Chennai',
        locationAddress: 'GST Road, Chengalpattu-Chennai Border',
        latitude: 12.8230,
        longitude: 80.0444,
        operationalCapacityRatio: 0.88,
        lastInspected: now.subtract(const Duration(hours: 5)),
        telemetryNotes: 'Substation dry. Feeder lines 1 through 6 functioning normally.',
      ),
      InfrastructureAssetModel(
        id: 'INF-003',
        name: 'Adyar River Maraimalai Bridge',
        type: InfrastructureType.bridge,
        status: InfrastructureStatus.damaged,
        district: 'Chennai',
        locationAddress: 'Saidapet - Guindy Arterial Link, Chennai',
        latitude: 13.0182,
        longitude: 80.2223,
        operationalCapacityRatio: 0.45,
        lastInspected: now.subtract(const Duration(hours: 1)),
        telemetryNotes: 'Pier 3 scour detected. Heavy trucks diverted; light motor vehicles only.',
      ),
      InfrastructureAssetModel(
        id: 'INF-004',
        name: 'Cuddalore Port Coastal BSNL Cellular Tower',
        type: InfrastructureType.communicationTower,
        status: InfrastructureStatus.operational,
        district: 'Cuddalore',
        locationAddress: 'Cuddalore Old Town Harbor Road',
        latitude: 11.7380,
        longitude: 79.7680,
        operationalCapacityRatio: 0.98,
        lastInspected: now.subtract(const Duration(hours: 4)),
        telemetryNotes: 'Satellite backhaul link engaged. 4G/5G signal coverage optimal.',
      ),
      InfrastructureAssetModel(
        id: 'INF-005',
        name: 'Gedilam River Barrage & Water Works',
        type: InfrastructureType.waterSupply,
        status: InfrastructureStatus.critical,
        district: 'Cuddalore',
        locationAddress: 'Tiruvendipuram Road, Cuddalore',
        latitude: 11.7510,
        longitude: 79.7420,
        operationalCapacityRatio: 0.20,
        lastInspected: now.subtract(const Duration(minutes: 45)),
        telemetryNotes: 'Silt intake pump clogged. Water treatment bypass mode activated.',
      ),
      InfrastructureAssetModel(
        id: 'INF-006',
        name: 'Cuddalore Central Fire Station',
        type: InfrastructureType.fireStation,
        status: InfrastructureStatus.operational,
        district: 'Cuddalore',
        locationAddress: 'Beach Road, Manjakuppam, Cuddalore',
        latitude: 11.7580,
        longitude: 79.7650,
        operationalCapacityRatio: 1.00,
        lastInspected: now.subtract(const Duration(hours: 3)),
        telemetryNotes: '6 fire trucks and 4 inflatable rescue boats fueled and ready.',
      ),
      InfrastructureAssetModel(
        id: 'INF-007',
        name: 'Nagapattinam Port Seawall Highway (NH 32)',
        type: InfrastructureType.road,
        status: InfrastructureStatus.damaged,
        district: 'Nagapattinam',
        locationAddress: 'East Coast Highway NH32, Nagapattinam',
        latitude: 10.7600,
        longitude: 79.8400,
        operationalCapacityRatio: 0.50,
        lastInspected: now.subtract(const Duration(hours: 2)),
        telemetryNotes: 'Coastal wave overtopping on northbound lane. 1-way escorted transit.',
      ),
      InfrastructureAssetModel(
        id: 'INF-008',
        name: 'Nagapattinam District Headquarters Hospital',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Nagapattinam',
        locationAddress: 'Public Office Road, Nagapattinam',
        latitude: 10.7680,
        longitude: 79.8390,
        operationalCapacityRatio: 0.85,
        lastInspected: now.subtract(const Duration(hours: 6)),
        telemetryNotes: 'Blood bank well stocked. 3 standby power generators verified.',
      ),
      InfrastructureAssetModel(
        id: 'INF-009',
        name: 'Vellore Fort Police Control HQ',
        type: InfrastructureType.policeStation,
        status: InfrastructureStatus.operational,
        district: 'Vellore',
        locationAddress: 'Officers Line, Anna Salai, Vellore',
        latitude: 12.9210,
        longitude: 79.1350,
        operationalCapacityRatio: 1.00,
        lastInspected: now.subtract(const Duration(hours: 8)),
        telemetryNotes: 'CCTV command wall operating. 40 mobile wireless vans synchronized.',
      ),
      InfrastructureAssetModel(
        id: 'INF-010',
        name: 'Palar River Aqueduct Water Supply Station',
        type: InfrastructureType.waterSupply,
        status: InfrastructureStatus.operational,
        district: 'Vellore',
        locationAddress: 'Katpadi Road, Vellore',
        latitude: 12.9450,
        longitude: 79.1410,
        operationalCapacityRatio: 0.90,
        lastInspected: now.subtract(const Duration(hours: 7)),
        telemetryNotes: 'Chlorination levels safe. Clean water storage reservoir at 85%.',
      ),
      InfrastructureAssetModel(
        id: 'INF-011',
        name: 'Tirunelveli Medical College Hospital',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Tirunelveli',
        locationAddress: 'High Ground, Palayamkottai, Tirunelveli',
        latitude: 8.7090,
        longitude: 77.7420,
        operationalCapacityRatio: 0.95,
        lastInspected: now.subtract(const Duration(hours: 3)),
        telemetryNotes: 'Trauma center operating at peak efficiency. 18 surgeons on call.',
      ),
      InfrastructureAssetModel(
        id: 'INF-012',
        name: 'Palayamkottai 230kV Power Transmission Substation',
        type: InfrastructureType.powerGrid,
        status: InfrastructureStatus.damaged,
        district: 'Tirunelveli',
        locationAddress: 'Trivandrum High Road, Tirunelveli',
        latitude: 8.7180,
        longitude: 77.7350,
        operationalCapacityRatio: 0.60,
        lastInspected: now.subtract(const Duration(hours: 2)),
        telemetryNotes: 'Transformer unit B isolated after lightning surge. Repairs underway.',
      ),
      InfrastructureAssetModel(
        id: 'INF-013',
        name: 'Thoothukudi VOC Port Maritime Relay Tower',
        type: InfrastructureType.communicationTower,
        status: InfrastructureStatus.operational,
        district: 'Thoothukudi',
        locationAddress: 'Harbour Estate, Tuticorin',
        latitude: 8.7510,
        longitude: 78.1720,
        operationalCapacityRatio: 0.99,
        lastInspected: now.subtract(const Duration(hours: 12)),
        telemetryNotes: 'VHF Marine Channel 16 and digital AIS monitoring functional.',
      ),
      InfrastructureAssetModel(
        id: 'INF-014',
        name: 'Thoothukudi Spic Nagar Chemical Fire Station',
        type: InfrastructureType.fireStation,
        status: InfrastructureStatus.operational,
        district: 'Thoothukudi',
        locationAddress: 'Muthiahpuram, Thoothukudi',
        latitude: 8.7240,
        longitude: 78.1400,
        operationalCapacityRatio: 0.95,
        lastInspected: now.subtract(const Duration(hours: 4)),
        telemetryNotes: 'Special chemical neutralizing foam trucks 100% prepared.',
      ),
      InfrastructureAssetModel(
        id: 'INF-015',
        name: 'Madurai Government Rajaji Hospital',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Madurai',
        locationAddress: 'Panagal Road, Shenoy Nagar, Madurai',
        latitude: 9.9310,
        longitude: 78.1320,
        operationalCapacityRatio: 0.90,
        lastInspected: now.subtract(const Duration(hours: 3)),
        telemetryNotes: 'Regional burn ward ready. 12 dedicated ambulances deployed.',
      ),
      InfrastructureAssetModel(
        id: 'INF-016',
        name: 'Vaigai River Albert Victor Bridge',
        type: InfrastructureType.bridge,
        status: InfrastructureStatus.operational,
        district: 'Madurai',
        locationAddress: 'Goripalayam - Simmakkal Road, Madurai',
        latitude: 9.9280,
        longitude: 78.1250,
        operationalCapacityRatio: 1.00,
        lastInspected: now.subtract(const Duration(hours: 5)),
        telemetryNotes: 'Structural vibration sensors show green normal parameters.',
      ),
      InfrastructureAssetModel(
        id: 'INF-017',
        name: 'Coimbatore CMCH Super Specialty Hospital',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Coimbatore',
        locationAddress: 'Trichy Road, Coimbatore',
        latitude: 11.0010,
        longitude: 76.9680,
        operationalCapacityRatio: 0.94,
        lastInspected: now.subtract(const Duration(hours: 2)),
        telemetryNotes: 'Air ambulance helipad operational. 30 ICU beds reserved for rescue.',
      ),
      InfrastructureAssetModel(
        id: 'INF-018',
        name: 'Valparai Ghat Mountain Highway (SH 78)',
        type: InfrastructureType.road,
        status: InfrastructureStatus.offline,
        district: 'Coimbatore',
        locationAddress: 'Aliyar - Valparai Hairpin Road, Anaimalai',
        latitude: 10.4500,
        longitude: 76.9800,
        operationalCapacityRatio: 0.00,
        lastInspected: now.subtract(const Duration(minutes: 30)),
        telemetryNotes: 'Road closed completely due to 12,000 ton boulder rockfall.',
      ),
      InfrastructureAssetModel(
        id: 'INF-019',
        name: 'Mettur Dam Hydro Electric Powerhouse',
        type: InfrastructureType.powerGrid,
        status: InfrastructureStatus.operational,
        district: 'Salem',
        locationAddress: 'Mettur Dam West Bank, Salem',
        latitude: 11.7960,
        longitude: 77.8010,
        operationalCapacityRatio: 0.95,
        lastInspected: now.subtract(const Duration(hours: 4)),
        telemetryNotes: 'Turbine generators generating 240MW stable grid electricity.',
      ),
      InfrastructureAssetModel(
        id: 'INF-020',
        name: 'Salem Mohan Kumaramangalam Medical College',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Salem',
        locationAddress: 'Fort Main Road, Salem',
        latitude: 11.6580,
        longitude: 78.1520,
        operationalCapacityRatio: 0.88,
        lastInspected: now.subtract(const Duration(hours: 6)),
        telemetryNotes: 'Emergency oxygen generation plant operating normally.',
      ),
      InfrastructureAssetModel(
        id: 'INF-021',
        name: 'Tiruchirappalli Grand Anicut (Kallanai Dam)',
        type: InfrastructureType.bridge,
        status: InfrastructureStatus.operational,
        district: 'Tiruchirappalli',
        locationAddress: 'Kallanai, Trichy-Thanjavur Border',
        latitude: 10.8320,
        longitude: 78.8190,
        operationalCapacityRatio: 1.00,
        lastInspected: now.subtract(const Duration(hours: 3)),
        telemetryNotes: 'Ancient stone barrage sluices regulating Cauvery river flow safely.',
      ),
      InfrastructureAssetModel(
        id: 'INF-022',
        name: 'Tiruchirappalli Mahatma Gandhi Memorial Hospital',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Tiruchirappalli',
        locationAddress: 'Collectorate Complex Road, Tiruchirappalli',
        latitude: 10.8050,
        longitude: 78.6890,
        operationalCapacityRatio: 0.91,
        lastInspected: now.subtract(const Duration(hours: 5)),
        telemetryNotes: 'Disaster triage ward operational with 50 emergency response beds.',
      ),
      InfrastructureAssetModel(
        id: 'INF-023',
        name: 'Thanjavur Vennar River Regulator Bridge',
        type: InfrastructureType.bridge,
        status: InfrastructureStatus.operational,
        district: 'Thanjavur',
        locationAddress: 'Kumbakonam Main Road, Thanjavur',
        latitude: 10.7950,
        longitude: 79.1450,
        operationalCapacityRatio: 0.85,
        lastInspected: now.subtract(const Duration(hours: 4)),
        telemetryNotes: 'Water velocity within safe tolerances. Vehicle traffic flow smooth.',
      ),
      InfrastructureAssetModel(
        id: 'INF-024',
        name: 'Thanjavur Medical College & Hospital',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Thanjavur',
        locationAddress: 'Medical College Road, Thanjavur',
        latitude: 10.7600,
        longitude: 79.1120,
        operationalCapacityRatio: 0.89,
        lastInspected: now.subtract(const Duration(hours: 5)),
        telemetryNotes: 'Critical care units fully staffed. Dialysis and trauma wing active.',
      ),
      InfrastructureAssetModel(
        id: 'INF-025',
        name: 'Bhavani River Barrage & Water Filter Complex',
        type: InfrastructureType.waterSupply,
        status: InfrastructureStatus.operational,
        district: 'Erode',
        locationAddress: 'Bhavani - Cauvery Confluence, Erode',
        latitude: 11.4420,
        longitude: 77.6820,
        operationalCapacityRatio: 0.94,
        lastInspected: now.subtract(const Duration(hours: 7)),
        telemetryNotes: 'Drinking water pipeline pressure steady at 4.2 bar.',
      ),
      InfrastructureAssetModel(
        id: 'INF-026',
        name: 'Erode Central Police Operations Tower',
        type: InfrastructureType.policeStation,
        status: InfrastructureStatus.operational,
        district: 'Erode',
        locationAddress: 'Brough Road, Erode',
        latitude: 11.3450,
        longitude: 77.7210,
        operationalCapacityRatio: 1.00,
        lastInspected: now.subtract(const Duration(hours: 9)),
        telemetryNotes: 'Highway patrol response time averaging 6.5 minutes across district.',
      ),
      InfrastructureAssetModel(
        id: 'INF-027',
        name: 'Kanyakumari Vivekananda Rock Marine Beacon Tower',
        type: InfrastructureType.communicationTower,
        status: InfrastructureStatus.operational,
        district: 'Kanyakumari',
        locationAddress: 'Beach Road, Kanyakumari Shoreline',
        latitude: 8.0780,
        longitude: 77.5520,
        operationalCapacityRatio: 1.00,
        lastInspected: now.subtract(const Duration(hours: 4)),
        telemetryNotes: 'High-power optical & radar beacon aiding coastal navigation vessels.',
      ),
      InfrastructureAssetModel(
        id: 'INF-028',
        name: 'Kanyakumari Government Medical College',
        type: InfrastructureType.hospital,
        status: InfrastructureStatus.operational,
        district: 'Kanyakumari',
        locationAddress: 'Asaripallam, Nagercoil, Kanyakumari',
        latitude: 8.1820,
        longitude: 77.4120,
        operationalCapacityRatio: 0.92,
        lastInspected: now.subtract(const Duration(hours: 3)),
        telemetryNotes: 'Coastal storm casualties protocol activated. 60 triage cots ready.',
      ),
      InfrastructureAssetModel(
        id: 'INF-029',
        name: 'Chennai Koyambedu Metro & Bus Hub Substation',
        type: InfrastructureType.powerGrid,
        status: InfrastructureStatus.operational,
        district: 'Chennai',
        locationAddress: 'Koyambedu Junction, Chennai',
        latitude: 13.0690,
        longitude: 80.1940,
        operationalCapacityRatio: 0.96,
        lastInspected: now.subtract(const Duration(hours: 1)),
        telemetryNotes: 'Transit electrical lines powered. Backup diesel generator online.',
      ),
      InfrastructureAssetModel(
        id: 'INF-030',
        name: 'Tambaram Highway Flyover Interconnector',
        type: InfrastructureType.road,
        status: InfrastructureStatus.operational,
        district: 'Chennai',
        locationAddress: 'GST Road - Outer Ring Road Interchange, Tambaram',
        latitude: 12.9250,
        longitude: 80.1170,
        operationalCapacityRatio: 0.82,
        lastInspected: now.subtract(const Duration(hours: 2)),
        telemetryNotes: 'Southbound evacuation transit lane flowing with no bottlenecks.',
      ),
    ];
  }

  List<DigitalTwinPredictionModel> _generatePredictions() {
    final now = DateTime.now();
    final predictions = <DigitalTwinPredictionModel>[];

    final rawPreds = [
      (
        'Adyar River Flood Inundation Expansion',
        PredictionType.floodExpansion,
        'Chennai',
        'Saidapet, Kotturpuram, Jafferkhanpet',
        88,
        0.94,
        'Next 2 Hours',
        'Water depth will escalate by 40-65cm across low-lying river bends.',
        'Dispatch 4 NDRF boat teams and open Kotturpuram flood relief gates.',
      ),
      (
        'Velachery Lake Overflow & Residential Waterlogging',
        PredictionType.floodExpansion,
        'Chennai',
        'Velachery AGS Colony & Lake Area',
        82,
        0.91,
        'Next 4 Hours',
        'Stormwater drainage capacity expected to breach by 120%.',
        'Pre-deploy 6 heavy diesel submersible pumps at 100-ft bypass road.',
      ),
      (
        'GST Road Transit Corridor Submergence',
        PredictionType.roadBlockage,
        'Chennai',
        'Guindy to Tambaram Highway Segment',
        78,
        0.89,
        'Next 3 Hours',
        'Traffic speed will drop to 5 km/h with localized 30cm waterlogging.',
        'Divert airport-bound emergency ambulances via Outer Ring Road.',
      ),
      (
        'Rajiv Gandhi Hospital Trauma Bed Capacity Surge',
        PredictionType.hospitalLoad,
        'Chennai',
        'Central Chennai Medical Ward',
        85,
        0.93,
        'Next 6 Hours',
        'Emergency patient intake projected to rise by 140% from flood zones.',
        'Mobilize 40 reserve doctors and re-route non-critical cases to Omandurar.',
      ),
      (
        'Harbor Coastal Inundation & Seawall Breach',
        PredictionType.floodExpansion,
        'Cuddalore',
        'Cuddalore OT Harbor & Fishing Villages',
        92,
        0.96,
        'Next 90 Mins',
        '3.1m high tide combined with storm runoff will submerge harbor berths.',
        'Evacuate 450 fishing hamlet residents to C-12 Cyclone Shelter immediately.',
      ),
      (
        'Pennaiyar River Basin Flash Spillover',
        PredictionType.floodExpansion,
        'Cuddalore',
        'Panruti & Cuddalore Rural Belt',
        76,
        0.87,
        'Next 5 Hours',
        'River discharge expected to breach 35,000 cusecs safety limit.',
        'Issue red siren sirens to riverbank agricultural settlements.',
      ),
      (
        'Cuddalore Drinking Water Chemical Contamination Risk',
        PredictionType.resourceShortage,
        'Cuddalore',
        'SIPCOT Industrial Corridor',
        70,
        0.84,
        'Next 8 Hours',
        'Stormwater mixing in open drainage could reduce potable water availability.',
        'Dispatch 15 mobile RO water filtration tankers from Puducherry reserve.',
      ),
      (
        'Point Calimere Coastal Highway Erosion',
        PredictionType.roadBlockage,
        'Nagapattinam',
        'Vedaranyam - Point Calimere NH32',
        84,
        0.90,
        'Next 3 Hours',
        'Rough surf will undermine 400m of coastal road subgrade.',
        'Restrict heavy freight transit and deploy geotextile rock armor.',
      ),
      (
        'Fishermen Settlement Evacuation Mandate',
        PredictionType.evacuationRecommendation,
        'Nagapattinam',
        'Nagore Beachside Quarters',
        90,
        0.95,
        'Next 2 Hours',
        'High tide surges will breach residential compound walls.',
        'Coordinate bus convoy evacuation to Velankanni Pilgrim Shelter.',
      ),
      (
        'Nagapattinam Medical Oxygen Cylinder Depletion',
        PredictionType.resourceShortage,
        'Nagapattinam',
        'District Hospital & Primary Clinics',
        68,
        0.82,
        'Next 12 Hours',
        'Current oxygen stockpile will reach 18% reserve buffer.',
        'Route 120 cryogenic oxygen cylinders from Thanjavur medical depot.',
      ),
      (
        'Thamirabarani Lower Basin Inundation Peak',
        PredictionType.floodExpansion,
        'Tirunelveli',
        'Vannarpettai, Kurichi, Kokkirakulam',
        86,
        0.92,
        'Next 3 Hours',
        'River discharge from dams will peak at 52,000 cusecs.',
        'Deploy SDRF inflatable rescue crafts to Low-Level Causeway.',
      ),
      (
        'Palayamkottai Bridge Transit Blockage',
        PredictionType.roadBlockage,
        'Tirunelveli',
        'Sulochana Mudaliar Bridge Link',
        74,
        0.86,
        'Next 4 Hours',
        'Water level rising within 40cm of bridge girder underside.',
        'Enforce barricade closure and divert traffic over New Bypass Flyover.',
      ),
      (
        'Tirunelveli Relief Shelter Blanket & Ration Deficit',
        PredictionType.resourceShortage,
        'Tirunelveli',
        'Palayamkottai School Shelters',
        65,
        0.80,
        'Next 8 Hours',
        'Ration supply will fall short for 350 incoming flood evacuees.',
        'Dispatch 500 dry ration kits and thermal blankets from Madurai hub.',
      ),
      (
        'Tuticorin Port Salt Pan Industrial Inundation',
        PredictionType.floodExpansion,
        'Thoothukudi',
        'Muthiahpuram & VOC Port Approach',
        80,
        0.88,
        'Next 4 Hours',
        'High salinity floodwater will flood ground transformers and switchgear.',
        'Elevate backup generators and seal hazardous chemical storage vaults.',
      ),
      (
        'Thoothukudi Hazmat Vapor Dispersion Zone',
        PredictionType.fireSpread,
        'Thoothukudi',
        'SIPCOT Industrial Complex Zone B',
        72,
        0.85,
        'Next 2 Hours',
        'Wind shift to 25 km/h East will carry acidic vapor plume inland.',
        'Issue indoor shelter-in-place advisory with wet towel facial covers.',
      ),
      (
        'Madurai Old City Market Fire Re-ignition Risk',
        PredictionType.fireSpread,
        'Madurai',
        'Vilakkuthoon Commercial Fabric Market',
        68,
        0.83,
        'Next 90 Mins',
        'High ambient temperature and dry winds may ignite synthetic yarn ruins.',
        'Maintain continuous mist cooling blanket with 2 standby fire engines.',
      ),
      (
        'Madurai Rajaji Hospital ICU Surge Forecast',
        PredictionType.hospitalLoad,
        'Madurai',
        'Trauma & Burn Intensive Care Unit',
        75,
        0.89,
        'Next 5 Hours',
        'Inflow of burn casualties from industrial area will exhaust ventilator bays.',
        'Request 8 transport ventilators from Tiruchirappalli Medical Center.',
      ),
      (
        'Valparai Ghat Road Hairpin Debris Slide Escalation',
        PredictionType.roadBlockage,
        'Coimbatore',
        'Hairpin Bend 11 through 16 Corridor',
        94,
        0.97,
        'Next 1 Hour',
        'Heavy saturation will trigger secondary 5,000-ton boulder slide.',
        'Enforce absolute zero-traffic lockdown on ghat checkpoint.',
      ),
      (
        'Coimbatore Anaimalai Tribal Hamlet Evacuation',
        PredictionType.evacuationRecommendation,
        'Coimbatore',
        'Topslip & Kadamparai Settlement',
        86,
        0.91,
        'Next 3 Hours',
        'Runoff will wash away bamboo footbridges isolating 280 villagers.',
        'Mobilize Forest Department 4x4 troop carriers for high-ground transit.',
      ),
      (
        'Mettur Dam Sluice Surge Hydraulic Pressure Spike',
        PredictionType.floodExpansion,
        'Salem',
        'Bhavani - Mettur Cauvery Downstream',
        78,
        0.87,
        'Next 6 Hours',
        'Inflow from Karnataka dams reaching 110,000 cusecs.',
        'Issue flood discharge alert to 12 downstream riparian villages.',
      ),
      (
        'Salem Industrial Substation Overheating Anomaly',
        PredictionType.fireSpread,
        'Salem',
        'Steel Plant Power Distribution Yard',
        64,
        0.79,
        'Next 4 Hours',
        'High load on transformer bank 3 causing thermal hotspot at 92°C.',
        'Engage auxiliary oil cooling radiators and load-shed industrial feeder 4.',
      ),
      (
        'Kallanai Dam Spillway Discharge Capacity Limit',
        PredictionType.floodExpansion,
        'Tiruchirappalli',
        'Grand Anicut Sluice Basin',
        81,
        0.90,
        'Next 4 Hours',
        'Water discharge will peak at 65,000 cusecs into Vennar and Cauvery branches.',
        'Balance water distribution equally between Vennar and Grand Anicut canal.',
      ),
      (
        'Trichy Srirangam Island Access Causeway Blockage',
        PredictionType.roadBlockage,
        'Tiruchirappalli',
        'Cauvery River Srirangam Link Bridge',
        73,
        0.85,
        'Next 5 Hours',
        'Driftwood and tree debris accumulating against bridge piers.',
        'Deploy boat-mounted hydraulic cranes to clear timber obstructions.',
      ),
      (
        'Palar River Sandbar Structural Erosion',
        PredictionType.floodExpansion,
        'Vellore',
        'Katpadi - Vellore Riverbank Buffer',
        70,
        0.82,
        'Next 6 Hours',
        'High velocity stream eroding 150m of river revetment embankment.',
        'Place concrete armor tetrapods along outer river curve.',
      ),
      (
        'Vellore Fort Relief Center Capacity Exhaustion',
        PredictionType.resourceShortage,
        'Vellore',
        'Fort Grounds Relief Camp',
        66,
        0.81,
        'Next 8 Hours',
        'Shelter capacity will cross 95% occupancy.',
        'Open Katpadi Government College as secondary auxiliary shelter.',
      ),
      (
        'Delta Region Paddy Field Siltation Threat',
        PredictionType.floodExpansion,
        'Thanjavur',
        'Papanasam & Thiruvaiyaru Agro Belt',
        75,
        0.86,
        'Next 10 Hours',
        'Breached canal bund will inundate 3,200 acres of fertile paddy crops.',
        'Deploy JCB earthmovers to rebuild earthen bund with poly-sheet lining.',
      ),
      (
        'Bhavani Urban Drainage Backflow Risk',
        PredictionType.floodExpansion,
        'Erode',
        'Bhavani Town Market Lowlands',
        77,
        0.88,
        'Next 4 Hours',
        'Backwater surge from Cauvery confluence backing into town storm drains.',
        'Operate non-return flap valves and start 3 diesel pump stations.',
      ),
      (
        'Erode Emergency Medical Stockpile Low',
        PredictionType.resourceShortage,
        'Erode',
        'Government Hospital Pharmacy Reserve',
        62,
        0.78,
        'Next 14 Hours',
        'Anti-venom and waterborne illness antibiotic inventory at critical 20%.',
        'Request emergency medical consignment from Coimbatore CMCH.',
      ),
      (
        'Kanyakumari High Tidal Wave Surge at Sunset',
        PredictionType.floodExpansion,
        'Kanyakumari',
        'Muttam & Colachel Shoreline',
        88,
        0.93,
        'Next 2 Hours',
        'Astronomic full moon tide will produce 3.4m breakers.',
        'Prohibit all tourist harbor access and moor catamarans in safety cove.',
      ),
      (
        'Kanyakumari Coastal Highway Sea Spray Barrier Breakdown',
        PredictionType.roadBlockage,
        'Kanyakumari',
        'Kovalam - Kanyakumari Marine Drive',
        79,
        0.87,
        'Next 3 Hours',
        'Heavy seawater spray and sand deposition reducing visibility to 20m.',
        'Deploy traffic police flag units and sand scraper dozers.',
      ),
      (
        'Perungudi IT Corridor Underground Grid Outage',
        PredictionType.resourceShortage,
        'Chennai',
        'OMR Highway Tech Park Zone',
        71,
        0.83,
        'Next 5 Hours',
        'Flooded cable ducts will trigger circuit breaker trips for 15,000 units.',
        'Switch critical data servers to elevated solar micro-grid.',
      ),
      (
        'Tambaram Railway Station Underpass Inundation',
        PredictionType.roadBlockage,
        'Chennai',
        'Tambaram East-West Railway Subway',
        83,
        0.91,
        'Next 2 Hours',
        'Subway will accumulate 1.8m standing water.',
        'Close subway gates and reroute pedestrian commuters over skywalk.',
      ),
      (
        'Vedaranyam Salt Swamp Wildlife Sanctuary Flooding',
        PredictionType.evacuationRecommendation,
        'Nagapattinam',
        'Kodiakkarai Reserve Forest',
        75,
        0.85,
        'Next 6 Hours',
        'Tidal flood will submerge deer and flamingo breeding grounds.',
        'Forest Ranger patrol to guide wildlife to elevated man-made mounds.',
      ),
      (
        'Shencottah Western Ghats Rail Line Boulder Hazard',
        PredictionType.roadBlockage,
        'Tirunelveli',
        'Aryankavu - Shencottah Ghat Railway',
        87,
        0.92,
        'Next 3 Hours',
        'Loose soil on mountain ridge overhanging railway tunnel mouth.',
        'Halt passenger train operations and clear loose boulders.',
      ),
      (
        'Tuticorin Thermal Power Plant Coal Stockpile Drenching',
        PredictionType.resourceShortage,
        'Thoothukudi',
        'Harbor Power Generation Units 1-5',
        69,
        0.82,
        'Next 8 Hours',
        'Heavy rain will saturate open coal yards reducing combustion heat output.',
        'Activate coal conveyor waterproof tarpaulins and drying heaters.',
      ),
      (
        'Madurai Vaigai River Causeway Water Level Warning',
        PredictionType.roadBlockage,
        'Madurai',
        'Nelpettai Low Level River Causeway',
        81,
        0.89,
        'Next 2 Hours',
        'Water flowing 20cm above causeway surface.',
        'Barricade causeway access and route traffic across Bridges 1 & 2.',
      ),
      (
        'Aliyar Dam Spillway Secondary Discharge Vector',
        PredictionType.floodExpansion,
        'Coimbatore',
        'Pollachi River Downstream Villages',
        74,
        0.84,
        'Next 4 Hours',
        'Water discharge crossing 15,000 cusecs.',
        'Issue siren broadcasts to riverside coconut plantations.',
      ),
      (
        'Salem Shevaroy Mountain Valley Mist Low-Visibility Alert',
        PredictionType.roadBlockage,
        'Salem',
        'Yercaud Ghat Hairpin Road 1-20',
        82,
        0.89,
        'Next 3 Hours',
        'Dense mountain fog reducing visibility under 10 meters with rain.',
        'Escort descending tourist vehicles with pilot police cruisers.',
      ),
      (
        'Trichy Airport Runway Surface Drainage Saturation',
        PredictionType.roadBlockage,
        'Tiruchirappalli',
        'International Airport Runway 27',
        70,
        0.84,
        'Next 5 Hours',
        'Runway friction coefficient dropping below civil aviation safe minimum.',
        'Engage high-velocity runway sweepers and drainage pumps.',
      ),
      (
        'Kanyakumari Fishermen GPS Beacon Battery Depletion',
        PredictionType.resourceShortage,
        'Kanyakumari',
        'Deep Sea Trawler Fleet (30km offshore)',
        65,
        0.81,
        'Next 12 Hours',
        'Offshore satellite transponders running on last 15% charge.',
        'Dispatch Coast Guard patrol ship to broadcast radio homing signals.',
      ),
    ];

    for (int i = 0; i < rawPreds.length; i++) {
      final p = rawPreds[i];
      predictions.add(
        DigitalTwinPredictionModel(
          id: 'PRD-${(i + 1).toString().padLeft(4, '0')}',
          title: p.$1,
          type: p.$2,
          district: p.$3,
          affectedZone: p.$4,
          riskScore: p.$5,
          confidenceRatio: p.$6,
          timeHorizon: p.$7,
          projectedOutcome: p.$8,
          preventiveAction: p.$9,
          generatedAt: now.subtract(Duration(minutes: (i + 1) * 7)),
        ),
      );
    }

    return predictions;
  }
}
