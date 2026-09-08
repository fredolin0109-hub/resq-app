import '../../domain/entities/resource_entities.dart';
import '../models/resource_models.dart';

/// Comprehensive realistic mock datasource for the Rescue Resource & Shelter Management system.
/// Contains:
/// - 25 Disaster Relief Shelters
/// - 20 Emergency Medical Hospitals
/// - 100 Resource & Equipment Items (across 12 categories)
/// - 15 Logistics Warehouses
/// - Active and historical resource allocations
class ResourceMockDatasource {
  static final ResourceMockDatasource _instance = ResourceMockDatasource._internal();
  factory ResourceMockDatasource() => _instance;
  ResourceMockDatasource._internal() {
    _initializeData();
  }

  final List<ShelterModel> _shelters = [];
  final List<HospitalModel> _hospitals = [];
  final List<WarehouseModel> _warehouses = [];
  final List<ResourceItemModel> _resourceItems = [];
  final List<ResourceAllocationModel> _allocations = [];

  void _initializeData() {
    _initWarehouses();
    _initShelters();
    _initHospitals();
    _initResourceItems();
    _initAllocations();
  }

  // ===========================================================================
  // 15 WAREHOUSES
  // ===========================================================================
  void _initWarehouses() {
    _warehouses.addAll([
      const WarehouseModel(
        id: 'WH-01',
        name: 'Chennai North Central Logistics Depot',
        district: 'Chennai',
        address: 'Harbour Ring Road, Madhavaram, Chennai - 600060',
        managerName: 'K. Rajasekaran',
        contactPhone: '+91 94440 12001',
        latitude: 13.1488,
        longitude: 80.2306,
        totalCapacity: 5000,
        utilizedCapacity: 3450,
        status: WarehouseStatus.operational,
        itemCount: 22,
      ),
      const WarehouseModel(
        id: 'WH-02',
        name: 'Cuddalore Coastal Supply Depot',
        district: 'Cuddalore',
        address: 'Silver Beach Approach Road, Cuddalore - 607001',
        managerName: 'M. Senthil Nathan',
        contactPhone: '+91 94432 33402',
        latitude: 11.7480,
        longitude: 79.7714,
        totalCapacity: 3500,
        utilizedCapacity: 2890,
        status: WarehouseStatus.operational,
        itemCount: 18,
      ),
      const WarehouseModel(
        id: 'WH-03',
        name: 'Nagapattinam Marine Logistics Hub',
        district: 'Nagapattinam',
        address: 'Public Works Complex, Nagore Road, Nagapattinam - 611001',
        managerName: 'R. Veeramani',
        contactPhone: '+91 94421 88903',
        latitude: 10.7672,
        longitude: 79.8449,
        totalCapacity: 3000,
        utilizedCapacity: 2400,
        status: WarehouseStatus.operational,
        itemCount: 16,
      ),
      const WarehouseModel(
        id: 'WH-04',
        name: 'Madurai Central Disaster Reserve',
        district: 'Madurai',
        address: 'Ring Road Logistics Park, Viraganoor, Madurai - 625009',
        managerName: 'S. Alagarsamy',
        contactPhone: '+91 94450 44504',
        latitude: 9.9015,
        longitude: 78.1578,
        totalCapacity: 4500,
        utilizedCapacity: 2100,
        status: WarehouseStatus.operational,
        itemCount: 20,
      ),
      const WarehouseModel(
        id: 'WH-05',
        name: 'Coimbatore Western Regional Depot',
        district: 'Coimbatore',
        address: 'L&T Bypass Logistics Center, Eachanari, Coimbatore - 641021',
        managerName: 'P. Balasubramanian',
        contactPhone: '+91 94433 55605',
        latitude: 10.9322,
        longitude: 76.9723,
        totalCapacity: 4000,
        utilizedCapacity: 2650,
        status: WarehouseStatus.operational,
        itemCount: 17,
      ),
      const WarehouseModel(
        id: 'WH-06',
        name: 'Tirunelveli South Zone Reserve',
        district: 'Tirunelveli',
        address: 'Collectorate Disaster Cell, Palayamkottai, Tirunelveli - 627002',
        managerName: 'T. Murugan',
        contactPhone: '+91 94422 66706',
        latitude: 8.7139,
        longitude: 77.7567,
        totalCapacity: 3500,
        utilizedCapacity: 2950,
        status: WarehouseStatus.operational,
        itemCount: 19,
      ),
      const WarehouseModel(
        id: 'WH-07',
        name: 'Thoothukudi Harbour Supply Hub',
        district: 'Thoothukudi',
        address: 'VOC Port Road, Harbour Estate, Thoothukudi - 628004',
        managerName: 'V. Sundaram',
        contactPhone: '+91 94425 77807',
        latitude: 8.7642,
        longitude: 78.1348,
        totalCapacity: 3200,
        utilizedCapacity: 1800,
        status: WarehouseStatus.operational,
        itemCount: 14,
      ),
      const WarehouseModel(
        id: 'WH-08',
        name: 'Tiruchirappalli Central Hub',
        district: 'Tiruchirappalli',
        address: 'NH45 Central Goods Terminal, Ponmalai, Trichy - 620004',
        managerName: 'G. Shanmugam',
        contactPhone: '+91 94431 88908',
        latitude: 10.7905,
        longitude: 78.7047,
        totalCapacity: 4200,
        utilizedCapacity: 3100,
        status: WarehouseStatus.operational,
        itemCount: 18,
      ),
      const WarehouseModel(
        id: 'WH-09',
        name: 'Salem Inland Logistics Center',
        district: 'Salem',
        address: 'Steel Plant Road, Kandampatty, Salem - 636005',
        managerName: 'D. Elangovan',
        contactPhone: '+91 94434 99009',
        latitude: 11.6643,
        longitude: 78.1460,
        totalCapacity: 3800,
        utilizedCapacity: 2300,
        status: WarehouseStatus.operational,
        itemCount: 15,
      ),
      const WarehouseModel(
        id: 'WH-10',
        name: 'Vellore Northern Forward Base',
        district: 'Vellore',
        address: 'Katpadi Industrial Estate, Vellore - 632007',
        managerName: 'A. Jayachandran',
        contactPhone: '+91 94445 11210',
        latitude: 12.9716,
        longitude: 79.1325,
        totalCapacity: 2800,
        utilizedCapacity: 1950,
        status: WarehouseStatus.operational,
        itemCount: 13,
      ),
      const WarehouseModel(
        id: 'WH-11',
        name: 'Thanjavur Delta Regional Store',
        district: 'Thanjavur',
        address: 'Pudukkottai Road Civil Supplies Depot, Thanjavur - 613007',
        managerName: 'N. Radhakrishnan',
        contactPhone: '+91 94436 22311',
        latitude: 10.7870,
        longitude: 79.1378,
        totalCapacity: 3000,
        utilizedCapacity: 2500,
        status: WarehouseStatus.operational,
        itemCount: 12,
      ),
      const WarehouseModel(
        id: 'WH-12',
        name: 'Erode Textile & Relief Depot',
        district: 'Erode',
        address: 'Perundurai SIPCOT Complex, Erode - 638052',
        managerName: 'K. Thangavel',
        contactPhone: '+91 94438 33412',
        latitude: 11.2789,
        longitude: 77.5833,
        totalCapacity: 3200,
        utilizedCapacity: 1750,
        status: WarehouseStatus.operational,
        itemCount: 14,
      ),
      const WarehouseModel(
        id: 'WH-13',
        name: 'Dindigul Valley Support Hub',
        district: 'Dindigul',
        address: 'Batlagundu Road Depot, Dindigul - 624002',
        managerName: 'C. Sivakumar',
        contactPhone: '+91 94439 44513',
        latitude: 10.3673,
        longitude: 77.9803,
        totalCapacity: 2500,
        utilizedCapacity: 1400,
        status: WarehouseStatus.operational,
        itemCount: 11,
      ),
      const WarehouseModel(
        id: 'WH-14',
        name: 'Kanyakumari South Coast Depot',
        district: 'Kanyakumari',
        address: 'Cape Road Emergency Stores, Nagercoil - 629001',
        managerName: 'J. Anto Fernando',
        contactPhone: '+91 94420 55614',
        latitude: 8.1833,
        longitude: 77.4119,
        totalCapacity: 2800,
        utilizedCapacity: 2200,
        status: WarehouseStatus.operational,
        itemCount: 15,
      ),
      const WarehouseModel(
        id: 'WH-15',
        name: 'Villupuram Transit Supply Center',
        district: 'Villupuram',
        address: 'Trichy Trunk Road Depot, Villupuram - 605602',
        managerName: 'M. Parthasarathy',
        contactPhone: '+91 94442 66715',
        latitude: 11.9401,
        longitude: 79.4861,
        totalCapacity: 3000,
        utilizedCapacity: 1600,
        status: WarehouseStatus.operational,
        itemCount: 12,
      ),
    ]);
  }

  // ===========================================================================
  // 25 SHELTERS
  // ===========================================================================
  void _initShelters() {
    _shelters.addAll([
      ShelterModel(
        id: 'SH-01',
        name: 'Chennai Central Cyclone Relief Center',
        district: 'Chennai',
        address: 'Jawaharlal Nehru Indoor Stadium, Periamet, Chennai',
        capacity: 1200,
        currentOccupancy: 840,
        availableBeds: 360,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
        latitude: 13.0838,
        longitude: 80.2748,
        contactPerson: 'Dr. S. Kabilan',
        contactPhone: '+91 98401 10001',
      ),
      ShelterModel(
        id: 'SH-02',
        name: 'Velachery Community Flood Shelter',
        district: 'Chennai',
        address: 'Corporation Community Hall, 100ft Road, Velachery, Chennai',
        capacity: 650,
        currentOccupancy: 610,
        availableBeds: 40,
        medicalSupport: true,
        foodAvailability: StockLevel.medium,
        waterAvailability: StockLevel.medium,
        electricity: true,
        internet: true,
        status: ShelterStatus.nearCapacity,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 25)),
        latitude: 12.9815,
        longitude: 80.2180,
        contactPerson: 'M. Revathi',
        contactPhone: '+91 98402 20002',
      ),
      ShelterModel(
        id: 'SH-03',
        name: 'Cuddalore Silver Beach Cyclone Haven',
        district: 'Cuddalore',
        address: 'Coastal High School Ground, Devanampattinam, Cuddalore',
        capacity: 900,
        currentOccupancy: 780,
        availableBeds: 120,
        medicalSupport: true,
        foodAvailability: StockLevel.medium,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: false,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 40)),
        latitude: 11.7450,
        longitude: 79.7790,
        contactPerson: 'K. Vetrivel',
        contactPhone: '+91 98411 30003',
      ),
      ShelterModel(
        id: 'SH-04',
        name: 'Chidambaram Relief Hall',
        district: 'Cuddalore',
        address: 'Annamalai Nagar Community Pavilion, Chidambaram',
        capacity: 500,
        currentOccupancy: 500,
        availableBeds: 0,
        medicalSupport: true,
        foodAvailability: StockLevel.low,
        waterAvailability: StockLevel.medium,
        electricity: false,
        internet: false,
        status: ShelterStatus.full,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
        latitude: 11.3992,
        longitude: 79.7126,
        contactPerson: 'P. Ramanathan',
        contactPhone: '+91 98412 40004',
      ),
      ShelterModel(
        id: 'SH-05',
        name: 'Nagapattinam Coastal Multi-Hazard Shelter',
        district: 'Nagapattinam',
        address: 'Fisheries Training Center Campus, Nagapattinam',
        capacity: 800,
        currentOccupancy: 520,
        availableBeds: 280,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
        latitude: 10.7656,
        longitude: 79.8428,
        contactPerson: 'T. Bharathi',
        contactPhone: '+91 98421 50005',
      ),
      ShelterModel(
        id: 'SH-06',
        name: 'Velankanni Pilgrims Disaster Haven',
        district: 'Nagapattinam',
        address: 'Church Pilgrim Center Block B, Velankanni',
        capacity: 1500,
        currentOccupancy: 1100,
        availableBeds: 400,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.medium,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 50)),
        latitude: 10.6800,
        longitude: 79.8490,
        contactPerson: 'Fr. X. Lawrence',
        contactPhone: '+91 98422 60006',
      ),
      ShelterModel(
        id: 'SH-07',
        name: 'Tirunelveli Thamirabarani Flood Camp',
        district: 'Tirunelveli',
        address: 'VOC Ground Indoor Pavilion, Palayamkottai, Tirunelveli',
        capacity: 750,
        currentOccupancy: 420,
        availableBeds: 330,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 20)),
        latitude: 8.7180,
        longitude: 77.7420,
        contactPerson: 'S. Gomathinayagam',
        contactPhone: '+91 98431 70007',
      ),
      ShelterModel(
        id: 'SH-08',
        name: 'Ambasamudram Riverbank Emergency Camp',
        district: 'Tirunelveli',
        address: 'Govt Higher Secondary School, Ambasamudram',
        capacity: 400,
        currentOccupancy: 380,
        availableBeds: 20,
        medicalSupport: false,
        foodAvailability: StockLevel.low,
        waterAvailability: StockLevel.low,
        electricity: true,
        internet: false,
        status: ShelterStatus.nearCapacity,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
        latitude: 8.7050,
        longitude: 77.4580,
        contactPerson: 'M. Nellaiyappan',
        contactPhone: '+91 98432 80008',
      ),
      ShelterModel(
        id: 'SH-09',
        name: 'Thoothukudi Port Coastal Shelter',
        district: 'Thoothukudi',
        address: 'Beach Road Community Center, Thoothukudi',
        capacity: 850,
        currentOccupancy: 560,
        availableBeds: 290,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 45)),
        latitude: 8.7980,
        longitude: 78.1420,
        contactPerson: 'C. Johnson',
        contactPhone: '+91 98433 90009',
      ),
      ShelterModel(
        id: 'SH-10',
        name: 'Tiruchendur Temple Camp',
        district: 'Thoothukudi',
        address: 'Devasthanam Yatri Nivas, Tiruchendur',
        capacity: 1000,
        currentOccupancy: 950,
        availableBeds: 50,
        medicalSupport: true,
        foodAvailability: StockLevel.medium,
        waterAvailability: StockLevel.medium,
        electricity: true,
        internet: true,
        status: ShelterStatus.nearCapacity,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 18)),
        latitude: 8.4975,
        longitude: 78.1280,
        contactPerson: 'R. Muthukrishnan',
        contactPhone: '+91 98434 10010',
      ),
      ShelterModel(
        id: 'SH-11',
        name: 'Madurai Vaigai Relief Haven',
        district: 'Madurai',
        address: 'Gandhi Museum Grounds Hall, Madurai',
        capacity: 1100,
        currentOccupancy: 670,
        availableBeds: 430,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 35)),
        latitude: 9.9320,
        longitude: 78.1380,
        contactPerson: 'A. Sundararajan',
        contactPhone: '+91 98440 20011',
      ),
      ShelterModel(
        id: 'SH-12',
        name: 'Sholavandan Flood Evacuation Center',
        district: 'Madurai',
        address: 'Panchayat Union Middle School, Sholavandan',
        capacity: 450,
        currentOccupancy: 310,
        availableBeds: 140,
        medicalSupport: false,
        foodAvailability: StockLevel.medium,
        waterAvailability: StockLevel.medium,
        electricity: true,
        internet: false,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 60)),
        latitude: 10.0234,
        longitude: 77.9620,
        contactPerson: 'V. Jayaraman',
        contactPhone: '+91 98441 30012',
      ),
      ShelterModel(
        id: 'SH-13',
        name: 'Coimbatore Western Ghats Landslide Camp',
        district: 'Coimbatore',
        address: 'Mettupalayam Govt Arts College Hall, Mettupalayam',
        capacity: 700,
        currentOccupancy: 480,
        availableBeds: 220,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 22)),
        latitude: 11.3000,
        longitude: 76.9500,
        contactPerson: 'P. Nanjappan',
        contactPhone: '+91 98450 40013',
      ),
      ShelterModel(
        id: 'SH-14',
        name: 'Valparai High Range Rescue Shelter',
        district: 'Coimbatore',
        address: 'Valparai Town Hall & Community Center, Valparai',
        capacity: 350,
        currentOccupancy: 340,
        availableBeds: 10,
        medicalSupport: true,
        foodAvailability: StockLevel.critical,
        waterAvailability: StockLevel.low,
        electricity: false,
        internet: false,
        status: ShelterStatus.nearCapacity,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 8)),
        latitude: 10.3250,
        longitude: 76.9550,
        contactPerson: 'M. Sivagnanam',
        contactPhone: '+91 98451 50014',
      ),
      ShelterModel(
        id: 'SH-15',
        name: 'Kanyakumari Coastal Refuge Haven',
        district: 'Kanyakumari',
        address: 'SLB Government School, Nagercoil',
        capacity: 850,
        currentOccupancy: 530,
        availableBeds: 320,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
        latitude: 8.1880,
        longitude: 77.4280,
        contactPerson: 'Dr. C. Mary Stella',
        contactPhone: '+91 98460 60015',
      ),
      ShelterModel(
        id: 'SH-16',
        name: 'Colachel Harbour Cyclone Shelter',
        district: 'Kanyakumari',
        address: 'Fisheries Marine Complex, Colachel',
        capacity: 600,
        currentOccupancy: 590,
        availableBeds: 10,
        medicalSupport: true,
        foodAvailability: StockLevel.medium,
        waterAvailability: StockLevel.medium,
        electricity: true,
        internet: true,
        status: ShelterStatus.nearCapacity,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 12)),
        latitude: 8.1750,
        longitude: 77.2550,
        contactPerson: 'S. Sahayaraj',
        contactPhone: '+91 98461 70016',
      ),
      ShelterModel(
        id: 'SH-17',
        name: 'Trichy Cauvery River Basin Shelter',
        district: 'Tiruchirappalli',
        address: 'Anna Stadium Indoor Hall, Khajamalai, Trichy',
        capacity: 1000,
        currentOccupancy: 610,
        availableBeds: 390,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 28)),
        latitude: 10.7980,
        longitude: 78.6850,
        contactPerson: 'R. Gunasekaran',
        contactPhone: '+91 98470 80017',
      ),
      ShelterModel(
        id: 'SH-18',
        name: 'Srirangam Island Evacuation Camp',
        district: 'Tiruchirappalli',
        address: 'Boys High School Ground, Srirangam',
        capacity: 550,
        currentOccupancy: 550,
        availableBeds: 0,
        medicalSupport: true,
        foodAvailability: StockLevel.medium,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.full,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 42)),
        latitude: 10.8620,
        longitude: 78.6920,
        contactPerson: 'V. Srinivasan',
        contactPhone: '+91 98471 90018',
      ),
      ShelterModel(
        id: 'SH-19',
        name: 'Salem Shevaroys Hill Base Camp',
        district: 'Salem',
        address: 'Govt Arts College Auditorium, Hasthampatti, Salem',
        capacity: 800,
        currentOccupancy: 410,
        availableBeds: 390,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 33)),
        latitude: 11.6850,
        longitude: 78.1600,
        contactPerson: 'M. Dharmalingam',
        contactPhone: '+91 98480 10019',
      ),
      ShelterModel(
        id: 'SH-20',
        name: 'Yercaud Ghat Road Emergency Point',
        district: 'Salem',
        address: 'Forest Department Rest House Complex, Yercaud',
        capacity: 300,
        currentOccupancy: 210,
        availableBeds: 90,
        medicalSupport: false,
        foodAvailability: StockLevel.medium,
        waterAvailability: StockLevel.medium,
        electricity: true,
        internet: false,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 55)),
        latitude: 11.7750,
        longitude: 78.2090,
        contactPerson: 'K. Perumal',
        contactPhone: '+91 98481 20020',
      ),
      ShelterModel(
        id: 'SH-21',
        name: 'Vellore Palar River Evacuation Camp',
        district: 'Vellore',
        address: 'Voorhees College Ground Hall, Vellore',
        capacity: 650,
        currentOccupancy: 380,
        availableBeds: 270,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 19)),
        latitude: 12.9200,
        longitude: 79.1300,
        contactPerson: 'D. Charles',
        contactPhone: '+91 98490 30021',
      ),
      ShelterModel(
        id: 'SH-22',
        name: 'Thanjavur Grand Anicut Relief Camp',
        district: 'Thanjavur',
        address: 'Kallanai PWD Inspection Bungalow Grounds, Thanjavur',
        capacity: 500,
        currentOccupancy: 290,
        availableBeds: 210,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 27)),
        latitude: 10.8350,
        longitude: 78.8200,
        contactPerson: 'T. Paneerselvam',
        contactPhone: '+91 98491 40022',
      ),
      ShelterModel(
        id: 'SH-23',
        name: 'Erode Bhavani Confluence Camp',
        district: 'Erode',
        address: 'Govt Higher Secondary School, Bhavani, Erode',
        capacity: 600,
        currentOccupancy: 340,
        availableBeds: 260,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 36)),
        latitude: 11.4450,
        longitude: 77.6820,
        contactPerson: 'N. Subramaniam',
        contactPhone: '+91 98492 50023',
      ),
      ShelterModel(
        id: 'SH-24',
        name: 'Dindigul Kodaikanal Foothill Shelter',
        district: 'Dindigul',
        address: 'Batlagundu Union Hall, Batlagundu, Dindigul',
        capacity: 450,
        currentOccupancy: 220,
        availableBeds: 230,
        medicalSupport: false,
        foodAvailability: StockLevel.medium,
        waterAvailability: StockLevel.medium,
        electricity: true,
        internet: true,
        status: ShelterStatus.operational,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 48)),
        latitude: 10.1600,
        longitude: 77.7600,
        contactPerson: 'G. Selvaraj',
        contactPhone: '+91 98493 60024',
      ),
      ShelterModel(
        id: 'SH-25',
        name: 'Villupuram Coastal Cyclone Refuge',
        district: 'Villupuram',
        address: 'Marakkanam Salt Road Shelter, Marakkanam',
        capacity: 700,
        currentOccupancy: 0,
        availableBeds: 700,
        medicalSupport: true,
        foodAvailability: StockLevel.high,
        waterAvailability: StockLevel.high,
        electricity: true,
        internet: true,
        status: ShelterStatus.closed,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        latitude: 12.1950,
        longitude: 79.9450,
        contactPerson: 'B. Elumalai',
        contactPhone: '+91 98494 70025',
      ),
    ]);
  }

  // ===========================================================================
  // 20 HOSPITALS
  // ===========================================================================
  void _initHospitals() {
    _hospitals.addAll([
      HospitalModel(
        id: 'HOSP-01',
        name: 'Rajiv Gandhi Government General Hospital (RGGGH)',
        district: 'Chennai',
        address: 'EVR Periyar Salai, Park Town, Chennai - 600003',
        totalBeds: 1800,
        availableBeds: 340,
        icuBeds: 45,
        emergencyDoctors: 32,
        ambulances: 14,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'A-': StockLevel.medium,
          'B+': StockLevel.high,
          'B-': StockLevel.low,
          'O+': StockLevel.high,
          'O-': StockLevel.critical,
          'AB+': StockLevel.medium,
          'AB-': StockLevel.low,
        },
        traumaCenter: true,
        contactNumber: '+91 44 2530 5000',
        status: HospitalStatus.operational,
        latitude: 13.0805,
        longitude: 80.2778,
        specialtyServices: const [
          'Level-1 Trauma Care',
          'Burn Unit',
          'Emergency Surgery',
          'Neurosurgery',
          'Triage Center'
        ],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      HospitalModel(
        id: 'HOSP-02',
        name: 'Government Stanley Medical College Hospital',
        district: 'Chennai',
        address: 'Old Jail Road, Royapuram, Chennai - 600001',
        totalBeds: 1300,
        availableBeds: 180,
        icuBeds: 28,
        emergencyDoctors: 24,
        ambulances: 10,
        bloodAvailability: const {
          'A+': StockLevel.medium,
          'A-': StockLevel.low,
          'B+': StockLevel.high,
          'B-': StockLevel.medium,
          'O+': StockLevel.medium,
          'O-': StockLevel.low,
          'AB+': StockLevel.high,
          'AB-': StockLevel.critical,
        },
        traumaCenter: true,
        contactNumber: '+91 44 2528 1351',
        status: HospitalStatus.operational,
        latitude: 13.1070,
        longitude: 80.2880,
        specialtyServices: const ['Plastic & Reconstructive Surgery', 'Trauma Ward', 'Toxicology'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      HospitalModel(
        id: 'HOSP-03',
        name: 'Government Kilpauk Medical College Hospital',
        district: 'Chennai',
        address: 'Poonamallee High Road, Kilpauk, Chennai - 600010',
        totalBeds: 950,
        availableBeds: 85,
        icuBeds: 16,
        emergencyDoctors: 18,
        ambulances: 8,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.medium,
          'O+': StockLevel.low,
          'AB+': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 44 2836 4951',
        status: HospitalStatus.operational,
        latitude: 13.0780,
        longitude: 80.2430,
        specialtyServices: const ['Specialized Burns Unit', 'Emergency Pediatrics', 'General Trauma'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      HospitalModel(
        id: 'HOSP-04',
        name: 'Cuddalore Government District Headquarters Hospital',
        district: 'Cuddalore',
        address: 'Hospital Road, Cuddalore - 607001',
        totalBeds: 700,
        availableBeds: 95,
        icuBeds: 14,
        emergencyDoctors: 14,
        ambulances: 6,
        bloodAvailability: const {
          'A+': StockLevel.medium,
          'B+': StockLevel.medium,
          'O+': StockLevel.critical,
          'O-': StockLevel.critical,
        },
        traumaCenter: true,
        contactNumber: '+91 4142 230234',
        status: HospitalStatus.limited,
        latitude: 11.7510,
        longitude: 79.7640,
        specialtyServices: const ['Emergency Triage', 'Orthopedic Trauma', 'Epidemic Isolation Ward'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      HospitalModel(
        id: 'HOSP-05',
        name: 'Rajah Muthiah Medical College & Hospital',
        district: 'Cuddalore',
        address: 'Annamalai Nagar, Chidambaram - 608002',
        totalBeds: 1100,
        availableBeds: 210,
        icuBeds: 26,
        emergencyDoctors: 20,
        ambulances: 8,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.high,
          'O+': StockLevel.high,
          'AB+': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 4144 238321',
        status: HospitalStatus.operational,
        latitude: 11.3960,
        longitude: 79.7150,
        specialtyServices: const ['Cardiac Emergency', 'Surgical ICU', 'Dialysis Unit'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      HospitalModel(
        id: 'HOSP-06',
        name: 'Nagapattinam Government District Hospital',
        district: 'Nagapattinam',
        address: 'Neela North Street, Nagapattinam - 611001',
        totalBeds: 550,
        availableBeds: 45,
        icuBeds: 8,
        emergencyDoctors: 10,
        ambulances: 5,
        bloodAvailability: const {
          'A+': StockLevel.low,
          'B+': StockLevel.low,
          'O+': StockLevel.critical,
        },
        traumaCenter: false,
        contactNumber: '+91 4365 242222',
        status: HospitalStatus.limited,
        latitude: 10.7680,
        longitude: 79.8410,
        specialtyServices: const ['Emergency First Aid', 'Maternity Emergency', 'Minor OT'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      HospitalModel(
        id: 'HOSP-07',
        name: 'Tirunelveli Medical College Hospital (TVMCH)',
        district: 'Tirunelveli',
        address: 'High Ground, Palayamkottai, Tirunelveli - 627011',
        totalBeds: 1500,
        availableBeds: 290,
        icuBeds: 38,
        emergencyDoctors: 28,
        ambulances: 12,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.high,
          'O+': StockLevel.high,
          'O-': StockLevel.low,
          'AB+': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 462 257 2720',
        status: HospitalStatus.operational,
        latitude: 8.7120,
        longitude: 77.7530,
        specialtyServices: const [
          'Apex Trauma Center',
          'Neurosurgery',
          'Pediatric Emergency',
          'Blood Bank Hub'
        ],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
      HospitalModel(
        id: 'HOSP-08',
        name: 'Shifa Hospitals Disaster Care Wing',
        district: 'Tirunelveli',
        address: '82 Main Road, Kailasapuram, Tirunelveli - 627001',
        totalBeds: 400,
        availableBeds: 70,
        icuBeds: 12,
        emergencyDoctors: 12,
        ambulances: 4,
        bloodAvailability: const {
          'A+': StockLevel.medium,
          'B+': StockLevel.medium,
          'O+': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 462 233 8841',
        status: HospitalStatus.operational,
        latitude: 8.7300,
        longitude: 77.7050,
        specialtyServices: const ['Intensive Care', 'Advanced Life Support', 'Cardiology'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 35)),
      ),
      HospitalModel(
        id: 'HOSP-09',
        name: 'Thoothukudi Government Medical College Hospital',
        district: 'Thoothukudi',
        address: '3rd Mile, Kamraj Nagar, Thoothukudi - 628008',
        totalBeds: 1050,
        availableBeds: 160,
        icuBeds: 22,
        emergencyDoctors: 22,
        ambulances: 9,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.medium,
          'O+': StockLevel.medium,
          'O-': StockLevel.low,
        },
        traumaCenter: true,
        contactNumber: '+91 461 234 6023',
        status: HospitalStatus.operational,
        latitude: 8.7910,
        longitude: 78.1250,
        specialtyServices: const ['Port Disaster Response', 'Maritime Trauma', 'Pulmonary Care'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 22)),
      ),
      HospitalModel(
        id: 'HOSP-10',
        name: 'Madurai Government Rajaji Hospital (GRH)',
        district: 'Madurai',
        address: 'Panagal Road, Shenoy Nagar, Madurai - 625020',
        totalBeds: 2100,
        availableBeds: 310,
        icuBeds: 52,
        emergencyDoctors: 36,
        ambulances: 16,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'A-': StockLevel.medium,
          'B+': StockLevel.high,
          'B-': StockLevel.low,
          'O+': StockLevel.high,
          'O-': StockLevel.low,
          'AB+': StockLevel.high,
          'AB-': StockLevel.critical,
        },
        traumaCenter: true,
        contactNumber: '+91 452 253 2535',
        status: HospitalStatus.operational,
        latitude: 9.9290,
        longitude: 78.1320,
        specialtyServices: const [
          'Apex Regional Trauma Center',
          'Super Specialty Wing',
          'Burn Center',
          'Pediatric ICU'
        ],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      HospitalModel(
        id: 'HOSP-11',
        name: 'Meenakshi Mission Hospital & Research Centre',
        district: 'Madurai',
        address: 'Lake Area, Melur Road, Madurai - 625107',
        totalBeds: 800,
        availableBeds: 140,
        icuBeds: 24,
        emergencyDoctors: 18,
        ambulances: 7,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.high,
          'O+': StockLevel.high,
          'AB+': StockLevel.high,
        },
        traumaCenter: true,
        contactNumber: '+91 452 426 3000',
        status: HospitalStatus.operational,
        latitude: 9.9540,
        longitude: 78.1620,
        specialtyServices: const ['Advanced Trauma ICU', 'Cardiac Emergency', 'Helipad Evac'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 16)),
      ),
      HospitalModel(
        id: 'HOSP-12',
        name: 'Coimbatore Medical College Hospital (CMCH)',
        district: 'Coimbatore',
        address: 'Trichy Road, Gopalapuram, Coimbatore - 641018',
        totalBeds: 1600,
        availableBeds: 270,
        icuBeds: 40,
        emergencyDoctors: 30,
        ambulances: 14,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.high,
          'O+': StockLevel.high,
          'O-': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 422 230 1393',
        status: HospitalStatus.operational,
        latitude: 10.9980,
        longitude: 76.9690,
        specialtyServices: const ['Western Ghats Emergency Response', 'Trauma Surgery', 'Toxico-Poison Care'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 14)),
      ),
      HospitalModel(
        id: 'HOSP-13',
        name: 'PSG Hospital & Emergency Trauma Wing',
        district: 'Coimbatore',
        address: 'Avinashi Road, Peelamedu, Coimbatore - 641004',
        totalBeds: 1000,
        availableBeds: 180,
        icuBeds: 30,
        emergencyDoctors: 22,
        ambulances: 8,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.high,
          'O+': StockLevel.high,
          'AB+': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 422 257 0170',
        status: HospitalStatus.operational,
        latitude: 11.0260,
        longitude: 77.0030,
        specialtyServices: const ['Advanced Surgical ICU', 'Multi-organ Trauma', 'Hyperbaric Medicine'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 24)),
      ),
      HospitalModel(
        id: 'HOSP-14',
        name: 'Kanyakumari Government Medical College Hospital',
        district: 'Kanyakumari',
        address: 'Asaripallam, Nagercoil - 629201',
        totalBeds: 850,
        availableBeds: 110,
        icuBeds: 18,
        emergencyDoctors: 16,
        ambulances: 6,
        bloodAvailability: const {
          'A+': StockLevel.medium,
          'B+': StockLevel.medium,
          'O+': StockLevel.low,
          'O-': StockLevel.critical,
        },
        traumaCenter: true,
        contactNumber: '+91 4652 223201',
        status: HospitalStatus.operational,
        latitude: 8.1900,
        longitude: 77.3980,
        specialtyServices: const ['Coastal Disaster Ward', 'Emergency Orthopedics', 'Pediatric ICU'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 19)),
      ),
      HospitalModel(
        id: 'HOSP-15',
        name: 'Tiruchirappalli Mahatma Gandhi Memorial Govt Hospital (MGMGH)',
        district: 'Tiruchirappalli',
        address: 'Collector Office Road, Cantonment, Trichy - 620017',
        totalBeds: 1400,
        availableBeds: 220,
        icuBeds: 34,
        emergencyDoctors: 26,
        ambulances: 11,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.high,
          'O+': StockLevel.high,
          'AB+': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 431 241 2244',
        status: HospitalStatus.operational,
        latitude: 10.8030,
        longitude: 78.6880,
        specialtyServices: const ['Central Tamil Nadu Trauma Hub', 'Mass Casualty Triage', 'Dialysis Emergency'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 21)),
      ),
      HospitalModel(
        id: 'HOSP-16',
        name: 'Government Mohan Kumaramangalam Medical College Hospital',
        district: 'Salem',
        address: 'Fort Main Road, Salem - 636001',
        totalBeds: 1350,
        availableBeds: 190,
        icuBeds: 32,
        emergencyDoctors: 24,
        ambulances: 10,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.high,
          'O+': StockLevel.medium,
          'O-': StockLevel.low,
        },
        traumaCenter: true,
        contactNumber: '+91 427 221 1213',
        status: HospitalStatus.operational,
        latitude: 11.6580,
        longitude: 78.1530,
        specialtyServices: const ['Highways Trauma Center', 'Emergency Neurosurgery', 'Toxicology'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 28)),
      ),
      HospitalModel(
        id: 'HOSP-17',
        name: 'Government Vellore Medical College Hospital',
        district: 'Vellore',
        address: 'Adukkamparai, Vellore - 632011',
        totalBeds: 900,
        availableBeds: 130,
        icuBeds: 20,
        emergencyDoctors: 18,
        ambulances: 7,
        bloodAvailability: const {
          'A+': StockLevel.medium,
          'B+': StockLevel.high,
          'O+': StockLevel.medium,
          'AB+': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 416 226 0900',
        status: HospitalStatus.operational,
        latitude: 12.8720,
        longitude: 79.1380,
        specialtyServices: const ['Regional Disaster Center', 'Emergency ICU', 'Infectious Disease Ward'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 32)),
      ),
      HospitalModel(
        id: 'HOSP-18',
        name: 'Thanjavur Medical College Hospital (TMCH)',
        district: 'Thanjavur',
        address: 'Medical College Road, Thanjavur - 613004',
        totalBeds: 1250,
        availableBeds: 200,
        icuBeds: 28,
        emergencyDoctors: 22,
        ambulances: 9,
        bloodAvailability: const {
          'A+': StockLevel.high,
          'B+': StockLevel.high,
          'O+': StockLevel.high,
          'O-': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 4362 240024',
        status: HospitalStatus.operational,
        latitude: 10.7570,
        longitude: 79.1060,
        specialtyServices: const ['Cauvery Delta Emergency Care', 'Burn Trauma', 'Pediatric Emergency'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 17)),
      ),
      HospitalModel(
        id: 'HOSP-19',
        name: 'Government Headquarters Hospital Erode',
        district: 'Erode',
        address: 'Surampatti, Erode - 638009',
        totalBeds: 650,
        availableBeds: 40,
        icuBeds: 8,
        emergencyDoctors: 10,
        ambulances: 4,
        bloodAvailability: const {
          'A+': StockLevel.low,
          'B+': StockLevel.medium,
          'O+': StockLevel.critical,
        },
        traumaCenter: false,
        contactNumber: '+91 424 225 2200',
        status: HospitalStatus.overwhelmed,
        latitude: 11.3320,
        longitude: 77.7180,
        specialtyServices: const ['Emergency Triage', 'Industrial Accident Care'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      HospitalModel(
        id: 'HOSP-20',
        name: 'Dindigul Government Headquarters Hospital',
        district: 'Dindigul',
        address: 'Hospital Road, Dindigul - 624001',
        totalBeds: 600,
        availableBeds: 90,
        icuBeds: 12,
        emergencyDoctors: 12,
        ambulances: 5,
        bloodAvailability: const {
          'A+': StockLevel.medium,
          'B+': StockLevel.medium,
          'O+': StockLevel.medium,
        },
        traumaCenter: true,
        contactNumber: '+91 451 242 3444',
        status: HospitalStatus.operational,
        latitude: 10.3620,
        longitude: 77.9740,
        specialtyServices: const ['Hill Station Evacuation Hub', 'General Trauma Care', 'Emergency OT'],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 38)),
      ),
    ]);
  }

  // ===========================================================================
  // 100 RESOURCE ITEMS (ACROSS ALL 12 CATEGORIES)
  // ===========================================================================
  void _initResourceItems() {
    final whList = _warehouses;

    // Helper to add resource items
    void addRes(
      String id,
      String name,
      ResourceCategory category,
      int whIndex,
      int currentQty,
      int threshold,
      String unit,
      String desc,
    ) {
      final wh = whList[whIndex % whList.length];
      final status = ResourceItem.calculateStatus(currentQty, threshold);
      final item = ResourceItemModel(
        id: id,
        name: name,
        category: category,
        warehouseId: wh.id,
        warehouseName: wh.name,
        district: wh.district,
        currentQuantity: currentQty,
        minimumThreshold: threshold,
        unit: unit,
        status: status,
        lastUpdated: DateTime.now().subtract(Duration(minutes: (id.hashCode % 120).abs())),
        autoWarning: currentQty <= threshold,
        description: desc,
        usageHistory: [
          ResourceUsageRecordModel(
            id: 'LOG-${id}-1',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            changeAmount: -50,
            remainingQuantity: currentQty,
            reason: 'Emergency dispatch to relief center',
            performedBy: 'Dispatch Officer R. Kumar',
            destinationName: '${wh.district} Coastal Relief Sector',
          ),
          ResourceUsageRecordModel(
            id: 'LOG-${id}-2',
            timestamp: DateTime.now().subtract(const Duration(hours: 24)),
            changeAmount: 200,
            remainingQuantity: currentQty + 50,
            reason: 'State emergency stockpile replenishment',
            performedBy: 'Supply Officer M. Suresh',
            destinationName: wh.name,
          ),
        ],
      );
      _resourceItems.add(item);
    }

    // 1. Food Packs (10 items)
    addRes('RES-FP-01', 'Ready-to-Eat Disaster Ration Packs (Standard Veg)', ResourceCategory.foodPacks, 0, 12000, 3000, 'packs', 'High-calorie 24hr survival meals with self-heating packs');
    addRes('RES-FP-02', 'High-Protein Emergency Meal Kits', ResourceCategory.foodPacks, 1, 8500, 2500, 'packs', 'Nutritionally dense ration packs for rescue teams and refugees');
    addRes('RES-FP-03', 'Infant Baby Food & Nutrition Powder Packs', ResourceCategory.foodPacks, 2, 950, 1000, 'packs', 'Specialized baby cereal, formula milk, and fortified nutrition');
    addRes('RES-FP-04', 'Dry Biscuit & Energy Bar Crates', ResourceCategory.foodPacks, 3, 15000, 4000, 'packs', 'Long shelf-life dry rations for immediate mass distribution');
    addRes('RES-FP-05', 'Ready-to-Eat Rice & Dal Meal Pouches', ResourceCategory.foodPacks, 4, 1800, 5000, 'packs', 'Pre-cooked traditional meals ready for rapid boil distribution');
    addRes('RES-FP-06', 'High-Calorie Nut Butter Sachets', ResourceCategory.foodPacks, 5, 6200, 1500, 'packs', 'Compact pocket emergency energy paste for rescue personnel');
    addRes('RES-FP-07', 'Family Emergency Food Hamper (3-Day Supply)', ResourceCategory.foodPacks, 6, 450, 1200, 'kits', 'Assorted essential dry grains, spices, pulses, and ready bites');
    addRes('RES-FP-08', 'Diabetic & Senior Ready Ration Packs', ResourceCategory.foodPacks, 7, 320, 800, 'packs', 'Low-glycemic emergency meal rations for elderly and medical evacuees');
    addRes('RES-FP-09', 'Community Kitchen Bulk Grain Sacks (50kg Rice)', ResourceCategory.foodPacks, 8, 120, 300, 'sacks', 'Raw bulk staples for large-scale relief kitchen operations');
    addRes('RES-FP-10', 'Instant Noodles & Hot Beverage Crates', ResourceCategory.foodPacks, 9, 3400, 1000, 'packs', 'Quick hot sustenance packs for storm evacuation centers');

    // 2. Water Bottles (9 items)
    addRes('RES-WB-01', 'Packaged Drinking Water Bottles (1 Litre)', ResourceCategory.waterBottles, 0, 35000, 8000, 'bottles', 'Certified purified bottled water for immediate civilian intake');
    addRes('RES-WB-02', 'Bulk Emergency Water Cans (20 Litre)', ResourceCategory.waterBottles, 1, 1400, 2000, 'cans', 'Heavy duty refillable dispenser cans for camp dining halls');
    addRes('RES-WB-03', 'Electrolyte Rehydration Drink Bottles (500ml)', ResourceCategory.waterBottles, 2, 4500, 1500, 'bottles', 'Oral rehydration salt enriched bottled fluids for dehydration');
    addRes('RES-WB-04', 'Collapsible Water Storage Bladders (1000L)', ResourceCategory.waterBottles, 3, 45, 100, 'units', 'Industrial flexible storage tanks for field water distribution');
    addRes('RES-WB-05', 'Emergency Water Purification Drops (Box of 100)', ResourceCategory.waterBottles, 4, 2800, 800, 'boxes', 'Chlorine-dioxide water treatment drops for contaminated water');
    addRes('RES-WB-06', 'High-Efficiency Portable Gravity Water Filters', ResourceCategory.waterBottles, 5, 80, 250, 'units', 'Micro-filtration camp kits purifying muddy flood waters');
    addRes('RES-WB-07', 'Packaged Mineral Water Pouches (250ml)', ResourceCategory.waterBottles, 6, 22000, 5000, 'pouches', 'Rapid air-drop water pouches for marooned flood victims');
    addRes('RES-WB-08', 'Desalination Survival Hand Pumps', ResourceCategory.waterBottles, 7, 0, 20, 'units', 'Seawater hand filtration kits for coastal marine emergencies');
    addRes('RES-WB-09', 'Water Testing & Chlorine Level Diagnostic Kits', ResourceCategory.waterBottles, 8, 350, 100, 'kits', 'Water quality assurance testing sets for camp sanitation officers');

    // 3. Blankets & Shelter Linens (8 items)
    addRes('RES-BL-01', 'Thermal Fleece Emergency Blankets (Heavy Duty)', ResourceCategory.blankets, 0, 8500, 2000, 'units', 'Warm polyester fleece blankets for disaster shelters');
    addRes('RES-BL-02', 'Reflective Mylar Space Survival Blankets', ResourceCategory.blankets, 1, 12000, 3000, 'units', 'Ultralight waterproof hypothermia reflection sheets');
    addRes('RES-BL-03', 'Waterproof Ground Tarpaulins (15x12 ft)', ResourceCategory.blankets, 2, 3200, 1000, 'sheets', 'Heavy gauge PVC shelter ground covers and makeshift roofs');
    addRes('RES-BL-04', 'Inflatable Camp Mattresses with Foot Pump', ResourceCategory.blankets, 3, 400, 1200, 'units', 'Quick-inflation sleeping mats for emergency field hospitals');
    addRes('RES-BL-05', 'Mosquito Netting Bed Enclosures (Double)', ResourceCategory.blankets, 4, 2100, 800, 'units', 'Insecticide treated vector control nets for flood zones');
    addRes('RES-BL-06', 'Folding Aluminum Camp Cots', ResourceCategory.blankets, 5, 650, 800, 'units', 'Sturdy collapsible hospital and shelter bed frames');
    addRes('RES-BL-07', 'Disaster Relief Sleeping Bags (-5°C rated)', ResourceCategory.blankets, 6, 750, 300, 'units', 'Cold-weather thermal sleeping bags for hilly terrain rescues');
    addRes('RES-BL-08', 'Cotton Bed Sheets & Pillow Sets (Shelter Pack)', ResourceCategory.blankets, 7, 4500, 1500, 'sets', 'Hygienic shelter bedding sets with antibacterial treatment');

    // 4. Medicines & Pharmaceuticals (9 items)
    addRes('RES-MED-01', 'Broad Spectrum Antibiotics Emergency Cache', ResourceCategory.medicines, 0, 4800, 1200, 'strips', 'Essential Amoxicillin, Azithromycin, and Doxycycline stocks');
    addRes('RES-MED-02', 'Pain Relief & Antipyretic Tablets (Paracetamol)', ResourceCategory.medicines, 1, 25000, 5000, 'strips', 'Fever and analgesia medication for general camp dispensary');
    addRes('RES-MED-03', 'Antivenom Multi-Snake Neutralizing Vials', ResourceCategory.medicines, 2, 120, 200, 'vials', 'Critical polyvalent antivenom for post-flood snakebite cases');
    addRes('RES-MED-04', 'Anti-Diarrheal & Gastrointestinal Tablets', ResourceCategory.medicines, 3, 900, 2500, 'strips', 'Waterborne disease treatment tablets including ORS packets');
    addRes('RES-MED-05', 'Antiseptic Solution & Povidone Iodine Drums', ResourceCategory.medicines, 4, 180, 50, 'liters', 'Surgical wound cleansing fluids and disinfectant solutions');
    addRes('RES-MED-06', 'Insulin Vials with Portable Cold Chain Bags', ResourceCategory.medicines, 5, 240, 300, 'vials', 'Temperature-controlled regular and glargine insulin pens');
    addRes('RES-MED-07', 'Tetanus Toxoid Vaccine Vials (Ampoules)', ResourceCategory.medicines, 6, 1500, 400, 'vials', 'Post-injury immunization shots for flood and debris trauma');
    addRes('RES-MED-08', 'Emergency Inhalers & Bronchodilators', ResourceCategory.medicines, 7, 650, 200, 'units', 'Salbutamol respiratory inhalers for smoke and dust inhalation');
    addRes('RES-MED-09', 'Pediatric Antibiotic Syrups & Drops', ResourceCategory.medicines, 8, 1200, 500, 'bottles', 'Child dosages for respiratory and digestive bacterial infections');

    // 5. Medical Kits (8 items)
    addRes('RES-MK-01', 'Comprehensive Major Trauma Response Kits', ResourceCategory.medicalKits, 0, 140, 50, 'kits', 'Paramedic trauma bags with tourniquets, chest seals, and airway');
    addRes('RES-MK-02', 'Mass Casualty Triage Field Bags', ResourceCategory.medicalKits, 1, 85, 30, 'kits', 'Color-coded triage tags, trauma dressings, and rapid splints');
    addRes('RES-MK-03', 'Portable Emergency Defibrillator (AED Units)', ResourceCategory.medicalKits, 2, 28, 40, 'units', 'Automated external defibrillators with voice guidance and pads');
    addRes('RES-MK-04', 'Surgical Suture & Wound Closure Field Packs', ResourceCategory.medicalKits, 3, 520, 150, 'packs', 'Sterile needles, sutures, scalpel blades, and hemostatic gauze');
    addRes('RES-MK-05', 'Emergency Burn Dressing & Hydrogel Packs', ResourceCategory.medicalKits, 4, 310, 100, 'packs', 'Cooling sterile burn blankets and non-adherent gel pads');
    addRes('RES-MK-06', 'Pediatric & Neonatal Resuscitation Kits', ResourceCategory.medicalKits, 5, 45, 60, 'kits', 'Bag-valve masks, infant suction pumps, and warming blankets');
    addRes('RES-MK-07', 'Splints & Cervical Immobilization Collar Sets', ResourceCategory.medicalKits, 6, 280, 80, 'sets', 'Rigid neck collars and malleable SAM splints for fractures');
    addRes('RES-MK-08', 'Portable Oxygen Concentrators & Tanks (10L)', ResourceCategory.medicalKits, 7, 35, 50, 'units', 'Medical grade oxygen tanks with regulators and nasal cannulas');

    // 6. Rescue Equipment (9 items)
    addRes('RES-RE-01', 'Hydraulic Spreader & Cutter Sets (Jaws of Life)', ResourceCategory.rescueEquipment, 0, 22, 10, 'sets', 'Heavy vehicle extrication tools with battery power packs');
    addRes('RES-RE-02', 'High-Output Submersible Flood Trash Pumps', ResourceCategory.rescueEquipment, 1, 48, 20, 'units', 'Gasoline powered 4-inch water dewatering trash pumps');
    addRes('RES-RE-03', 'Pneumatic Lifting Air Bags (20 Ton capacity)', ResourceCategory.rescueEquipment, 2, 18, 15, 'sets', 'Heavy rubble lifting air bladders for collapsed structure rescue');
    addRes('RES-RE-04', 'Rotary Concrete & Steel Rescue Saws', ResourceCategory.rescueEquipment, 3, 30, 12, 'units', 'Diamond blade handheld cutting saws for structural breach');
    addRes('RES-RE-05', 'Search & Rescue Thermal Acoustic Listening Probes', ResourceCategory.rescueEquipment, 4, 12, 15, 'units', 'Seismic microphones detecting trapped survivors under debris');
    addRes('RES-RE-06', 'High-Intensity LED Disaster Tower Lights (500W)', ResourceCategory.rescueEquipment, 5, 42, 25, 'units', 'Telescopic mast floodlights with integrated battery power');
    addRes('RES-RE-07', 'Chainsaws with Heavy-Duty Timber Blades', ResourceCategory.rescueEquipment, 6, 55, 20, 'units', 'Tree clearing petrol saws for road clearance during storms');
    addRes('RES-RE-08', 'Sledgehammers, Crowbars & Breaching Toolkits', ResourceCategory.rescueEquipment, 7, 180, 50, 'sets', 'Manual forcible entry toolsets for ground teams');
    addRes('RES-RE-09', 'Hazmat Chemical Spill Containment Kits', ResourceCategory.rescueEquipment, 8, 25, 20, 'kits', 'Neutralizing absorbents, chemical suits, and sealing pads');

    // 7. Life Jackets & Flotation (8 items)
    addRes('RES-LJ-01', 'SOLAS Approved High-Buoyancy Life Jackets', ResourceCategory.lifeJackets, 0, 3200, 800, 'units', 'Type I adult life vests with whistle and distress strobe');
    addRes('RES-LJ-02', 'Swift Water Rescue Specialist Life Vests (PFD)', ResourceCategory.lifeJackets, 1, 450, 150, 'units', 'Quick-release rescue harness vests with knife and tether attachment');
    addRes('RES-LJ-03', 'Children & Infant Inflatable Flotation Vests', ResourceCategory.lifeJackets, 2, 850, 400, 'units', 'Self-righting neck support flotation vests for young evacuees');
    addRes('RES-LJ-04', 'Rigid Marine Lifebuoy Rings with 30m Throw Lines', ResourceCategory.lifeJackets, 3, 620, 200, 'units', 'High-visibility polyurethane life rings for flood boats');
    addRes('RES-LJ-05', 'Throw Bag Rescue Floating Ropes (25m)', ResourceCategory.lifeJackets, 4, 780, 250, 'bags', 'Spectra floating core throw lines for swift water riverbanks');
    addRes('RES-LJ-06', 'Rescue Inflatable Flotation Sleds', ResourceCategory.lifeJackets, 5, 22, 30, 'units', 'Towable inflatable rafts for shallow mud and flood zones');
    addRes('RES-LJ-07', 'Drysuits for Swift Water Rescue Teams', ResourceCategory.lifeJackets, 6, 65, 80, 'suits', 'Breathable waterproof protective suits for cold water diving');
    addRes('RES-LJ-08', 'Automatic Inflatable CO2 Life Vests', ResourceCategory.lifeJackets, 7, 310, 100, 'units', 'Slim-profile vests auto-inflating upon water immersion');

    // 8. Ropes & Rigging (8 items)
    addRes('RES-RP-01', 'Static Kernmantle Rescue Ropes (11mm x 100m)', ResourceCategory.ropes, 0, 140, 40, 'coils', 'Low-stretch NFPA certified high-angle descent and haul ropes');
    addRes('RES-RP-02', 'Dynamic Climbing & Rappelling Ropes (60m)', ResourceCategory.ropes, 1, 95, 30, 'coils', 'Impact absorbing climbing ropes for cliff and building access');
    addRes('RES-RP-03', 'Heavy Duty Tow Straps (10 Ton x 10m)', ResourceCategory.ropes, 2, 220, 60, 'units', 'Polyester webbing straps with reinforced steel forged hooks');
    addRes('RES-RP-04', 'Locking Steel Carabiners & Screwgates (Pack of 10)', ResourceCategory.ropes, 3, 380, 100, 'packs', '50kN high-strength load bearing connection hardware');
    addRes('RES-RP-05', 'Pulley Systems & Mechanical Advantage Kits (4:1)', ResourceCategory.ropes, 4, 48, 20, 'kits', 'Hauling rigs for raising stretchers and heavy debris');
    addRes('RES-RP-06', 'Full Body Evacuation & Fall Arrest Harnesses', ResourceCategory.ropes, 5, 110, 50, 'units', 'Padded multi-point adjustable harnesses with dorsal D-rings');
    addRes('RES-RP-07', 'Stretcher Hoisting Bridle & Tag Lines', ResourceCategory.ropes, 6, 35, 25, 'sets', 'Basket stretcher vertical and horizontal lifting sling rigs');
    addRes('RES-RP-08', 'Wire Rope Winch Cables (12mm x 50m)', ResourceCategory.ropes, 7, 60, 30, 'coils', 'Galvanized steel winch replacement cables for recovery trucks');

    // 9. Generators & Power (9 items)
    addRes('RES-GN-01', 'Portable Silent Inverter Generators (3.5 kVA)', ResourceCategory.generators, 0, 65, 20, 'units', 'Clean sine wave generators for medical equipment and radios');
    addRes('RES-GN-02', 'Heavy Duty Diesel Generators on Wheels (15 kVA)', ResourceCategory.generators, 1, 24, 15, 'units', 'Camp powerhouses running shelters and high-output water pumps');
    addRes('RES-GN-03', 'Solar Rechargeable Battery Power Stations (2000Wh)', ResourceCategory.generators, 2, 85, 30, 'units', 'Lithium iron phosphate power banks with 200W solar panels');
    addRes('RES-GN-04', 'Industrial Power Distribution Extension Boards (50m)', ResourceCategory.generators, 3, 190, 60, 'units', 'Waterproof outdoor electrical cable reels with MCB breakers');
    addRes('RES-GN-05', 'Emergency Battery Charging Multi-Hubs', ResourceCategory.generators, 4, 110, 40, 'units', 'Simultaneous charging banks for radios, drones, and cellphones');
    addRes('RES-GN-06', 'Industrial Diesel Generator Units (45 kVA Trailer)', ResourceCategory.generators, 5, 8, 10, 'units', 'Hospital emergency backup prime generators with ATS switch');
    addRes('RES-GN-07', 'Solar Powered Camp Floodlight Lanterns', ResourceCategory.generators, 6, 450, 150, 'units', 'Portable lanterns with integrated USB power outlets');
    addRes('RES-GN-08', 'Step-down Transformers & Voltage Stabilizers', ResourceCategory.generators, 7, 30, 20, 'units', 'Heavy industrial surge and spike protection units');
    addRes('RES-GN-09', 'Gasoline Engine Spark Plugs & Service Spare Kits', ResourceCategory.generators, 8, 120, 50, 'kits', 'Maintenance consumables for continuous generator operation');

    // 10. Fuel & Petroleum (8 items)
    addRes('RES-FL-01', 'Commercial High-Speed Diesel Fuel Drums (200L)', ResourceCategory.fuel, 0, 180, 50, 'drums', 'Filtered diesel for heavy rescue trucks, pumps, and generators');
    addRes('RES-FL-02', 'Automotive Gasoline Petrol Jerrycans (20L)', ResourceCategory.fuel, 1, 350, 100, 'cans', 'Metal jerrycans for boats, chainsaws, and portable engines');
    addRes('RES-FL-03', 'Synthetic 2-Stroke Outboard Motor Oil (1L)', ResourceCategory.fuel, 2, 600, 150, 'bottles', 'Marine engine premix oil for inflatable rescue boat engines');
    addRes('RES-FL-04', 'Industrial Multi-Grade Engine Oil (15W-40, 5L)', ResourceCategory.fuel, 3, 240, 80, 'cans', 'Heavy machinery and fleet vehicle maintenance lubricants');
    addRes('RES-FL-05', 'Liquefied Petroleum Gas Commercial Cylinders (19kg)', ResourceCategory.fuel, 4, 420, 120, 'cylinders', 'Cooking gas for mass relief center kitchens');
    addRes('RES-FL-06', 'Aviation Turbine Fuel (ATF / Jet A-1) Drums (200L)', ResourceCategory.fuel, 5, 45, 30, 'drums', 'Helicopter and heavy UAV refueling reserve stocks');
    addRes('RES-FL-07', 'Fuel Hand Rotary Transfer Pumps & Hoses', ResourceCategory.fuel, 6, 85, 30, 'units', 'Manual siphon and drum emptying pumps with grounding wire');
    addRes('RES-FL-08', 'Emergency Spill Containment Booms & Pads', ResourceCategory.fuel, 7, 110, 40, 'sets', 'Hydrocarbon absorbent pads preventing water source contamination');

    // 11. Boats & Watercraft (8 items)
    addRes('RES-BT-01', 'Inflatable Rubber Rescue Boats (IRB - 6 Person)', ResourceCategory.boats, 0, 32, 12, 'units', 'Hypalon heavy-duty hulls with aluminum floorboards');
    addRes('RES-BT-02', 'Outboard Marine Engines (40 HP 2-Stroke)', ResourceCategory.boats, 1, 28, 10, 'units', 'Submersible carburetor marine engines with tiller control');
    addRes('RES-BT-03', 'Rigid Inflatable Boats (RIB - 10 Person with Console)', ResourceCategory.boats, 2, 14, 8, 'units', 'Deep-V fiberglass hull fast response craft with 90HP engine');
    addRes('RES-BT-04', 'Flat-Bottom Aluminum Flood Punt Boats (8 Person)', ResourceCategory.boats, 3, 22, 10, 'units', 'Shallow water puncture-proof boats for submerged debris areas');
    addRes('RES-BT-05', 'Paddle Rafts & Oar Sets (Disaster Grade)', ResourceCategory.boats, 4, 45, 20, 'units', 'Non-motorized quiet evacuation rafts for narrow alleyways');
    addRes('RES-BT-06', 'Electric Trolling Motors with Marine Batteries', ResourceCategory.boats, 5, 18, 15, 'units', 'Zero-emission shallow water propulsion for sensitive zones');
    addRes('RES-BT-07', 'Boat Trailer Transporters (Galvanized Steel)', ResourceCategory.boats, 6, 20, 10, 'units', 'Road tow trailers with winch for rapid boat launch');
    addRes('RES-BT-08', 'Boat Puncture Repair & Adhesive Vulcanizing Kits', ResourceCategory.boats, 7, 75, 30, 'kits', 'Field emergency hull patches and two-part marine glue');

    // 12. Drones & Aerial Technology (7 items)
    addRes('RES-DR-01', 'Thermal Imaging Search & Rescue Hexacopter Drones', ResourceCategory.drones, 0, 16, 6, 'units', 'FLIR radiometric thermal camera drones with 40min flight time');
    addRes('RES-DR-02', 'Payload Delivery Heavy Lift Drones (10kg Payload)', ResourceCategory.drones, 1, 9, 5, 'units', 'Drop mechanism drones air-delivering life vests and medicine');
    addRes('RES-DR-03', 'High-Zoom 4K Aerial Surveillance Quadcopters', ResourceCategory.drones, 2, 24, 10, 'units', 'Optical 30x zoom reconnaissance drones for damage assessment');
    addRes('RES-DR-04', 'Tethered Continuous Monitoring Aerial Drone System', ResourceCategory.drones, 3, 4, 3, 'units', '24-hour persistent airborne radio repeater and floodlight platform');
    addRes('RES-DR-05', 'Drone Rapid Battery Charging Stations & Smart Hubs', ResourceCategory.drones, 4, 35, 15, 'units', 'Multi-battery field chargers compatible with generator power');
    addRes('RES-DR-06', 'Long-Range Replacement Flight Batteries (16000mAh)', ResourceCategory.drones, 5, 120, 40, 'units', 'High-capacity LiPo flight packs with storage voltage monitors');
    addRes('RES-DR-07', 'Aero-Loudspeaker & Searchlight Drone Attachments', ResourceCategory.drones, 6, 18, 10, 'sets', '120dB public announcement speaker and 10000lm spotlight');
  }

  // ===========================================================================
  // ALLOCATIONS & DISPATCH ORDERS
  // ===========================================================================
  void _initAllocations() {
    _allocations.addAll([
      ResourceAllocationModel(
        id: 'ALC-2026-001',
        items: const [
          AllocatedItemModel(
            resourceItemId: 'RES-FP-01',
            resourceName: 'Ready-to-Eat Disaster Ration Packs',
            category: ResourceCategory.foodPacks,
            quantity: 500,
            unit: 'packs',
          ),
          AllocatedItemModel(
            resourceItemId: 'RES-WB-01',
            resourceName: 'Packaged Drinking Water Bottles',
            category: ResourceCategory.waterBottles,
            quantity: 1000,
            unit: 'bottles',
          ),
          AllocatedItemModel(
            resourceItemId: 'RES-BL-01',
            resourceName: 'Thermal Fleece Emergency Blankets',
            category: ResourceCategory.blankets,
            quantity: 200,
            unit: 'units',
          ),
        ],
        destinationType: DestinationType.shelter,
        destinationId: 'SH-01',
        destinationName: 'Chennai Central Cyclone Relief Center',
        destinationDistrict: 'Chennai',
        priority: AllocationPriority.critical,
        vehicleId: 'TN-01-GA-1101',
        vehicleName: 'Heavy Logistics Supply Truck 01',
        assignedTeamId: 'ALPHA-01',
        assignedTeamName: 'Bravo Logistics Unit',
        estimatedArrival: '25 mins',
        deliveryStatus: DeliveryStatus.inTransit,
        createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
        notes: 'Urgent influx of evacuees from Harbour shoreline.',
      ),
      ResourceAllocationModel(
        id: 'ALC-2026-002',
        items: const [
          AllocatedItemModel(
            resourceItemId: 'RES-MK-01',
            resourceName: 'Comprehensive Major Trauma Response Kits',
            category: ResourceCategory.medicalKits,
            quantity: 10,
            unit: 'kits',
          ),
          AllocatedItemModel(
            resourceItemId: 'RES-MED-03',
            resourceName: 'Antivenom Multi-Snake Neutralizing Vials',
            category: ResourceCategory.medicines,
            quantity: 30,
            unit: 'vials',
          ),
        ],
        destinationType: DestinationType.hospital,
        destinationId: 'HOSP-04',
        destinationName: 'Cuddalore Government District Headquarters Hospital',
        destinationDistrict: 'Cuddalore',
        priority: AllocationPriority.high,
        vehicleId: 'TN-31-EM-4402',
        vehicleName: 'Emergency Medical Courier Van',
        assignedTeamId: 'MED-03',
        assignedTeamName: 'Delta Medical Squad',
        estimatedArrival: '45 mins',
        deliveryStatus: DeliveryStatus.dispatched,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        notes: 'Replenishing critical antivenom and trauma reserves.',
      ),
      ResourceAllocationModel(
        id: 'ALC-2026-003',
        items: const [
          AllocatedItemModel(
            resourceItemId: 'RES-BT-01',
            resourceName: 'Inflatable Rubber Rescue Boats',
            category: ResourceCategory.boats,
            quantity: 4,
            unit: 'units',
          ),
          AllocatedItemModel(
            resourceItemId: 'RES-LJ-01',
            resourceName: 'SOLAS Approved High-Buoyancy Life Jackets',
            category: ResourceCategory.lifeJackets,
            quantity: 100,
            unit: 'units',
          ),
          AllocatedItemModel(
            resourceItemId: 'RES-FL-02',
            resourceName: 'Automotive Gasoline Petrol Jerrycans',
            category: ResourceCategory.fuel,
            quantity: 20,
            unit: 'cans',
          ),
        ],
        destinationType: DestinationType.fieldCamp,
        destinationId: 'SH-03',
        destinationName: 'Cuddalore Silver Beach Cyclone Haven',
        destinationDistrict: 'Cuddalore',
        priority: AllocationPriority.critical,
        vehicleId: 'TN-31-HV-9901',
        vehicleName: 'Marine Rescue Transport Truck',
        assignedTeamId: 'AQUA-01',
        assignedTeamName: 'Coastal Water Rescue Team Alpha',
        estimatedArrival: '10 mins',
        deliveryStatus: DeliveryStatus.inTransit,
        createdAt: DateTime.now().subtract(const Duration(minutes: 50)),
        notes: 'Boats and PFDs for flash-flood river delta rescues.',
      ),
      ResourceAllocationModel(
        id: 'ALC-2026-004',
        items: const [
          AllocatedItemModel(
            resourceItemId: 'RES-GN-01',
            resourceName: 'Portable Silent Inverter Generators',
            category: ResourceCategory.generators,
            quantity: 5,
            unit: 'units',
          ),
          AllocatedItemModel(
            resourceItemId: 'RES-FL-01',
            resourceName: 'Commercial High-Speed Diesel Fuel Drums',
            category: ResourceCategory.fuel,
            quantity: 4,
            unit: 'drums',
          ),
        ],
        destinationType: DestinationType.shelter,
        destinationId: 'SH-08',
        destinationName: 'Ambasamudram Riverbank Emergency Camp',
        destinationDistrict: 'Tirunelveli',
        priority: AllocationPriority.high,
        vehicleId: 'TN-72-SV-3301',
        vehicleName: 'Support Supply Utility 04',
        assignedTeamId: 'TECH-02',
        assignedTeamName: 'Grid Power & Comms Unit',
        estimatedArrival: 'Delivered',
        deliveryStatus: DeliveryStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        notes: 'Power backup established for communications post.',
      ),
      ResourceAllocationModel(
        id: 'ALC-2026-005',
        items: const [
          AllocatedItemModel(
            resourceItemId: 'RES-DR-01',
            resourceName: 'Thermal Imaging Search & Rescue Hexacopter Drones',
            category: ResourceCategory.drones,
            quantity: 2,
            unit: 'units',
          ),
          AllocatedItemModel(
            resourceItemId: 'RES-DR-05',
            resourceName: 'Drone Rapid Battery Charging Stations',
            category: ResourceCategory.drones,
            quantity: 2,
            unit: 'units',
          ),
        ],
        destinationType: DestinationType.fieldCamp,
        destinationId: 'SH-14',
        destinationName: 'Valparai High Range Rescue Shelter',
        destinationDistrict: 'Coimbatore',
        priority: AllocationPriority.high,
        vehicleId: 'TN-38-SV-1002',
        vehicleName: '4x4 Western Ghats Rapid Response Vehicle',
        assignedTeamId: 'AERO-01',
        assignedTeamName: 'SkyWatch Aerial Recon Team',
        estimatedArrival: '60 mins',
        deliveryStatus: DeliveryStatus.dispatched,
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        notes: 'Aerial search deployment for hill slope landslides.',
      ),
    ]);
  }

  // ===========================================================================
  // PUBLIC ACCESSORS AND MUTATORS
  // ===========================================================================

  List<ShelterModel> get shelters => List.unmodifiable(_shelters);
  List<HospitalModel> get hospitals => List.unmodifiable(_hospitals);
  List<WarehouseModel> get warehouses => List.unmodifiable(_warehouses);
  List<ResourceItemModel> get resourceItems => List.unmodifiable(_resourceItems);
  List<ResourceAllocationModel> get allocations => List.unmodifiable(_allocations);

  ResourceSummary getSummary() {
    int totalRes = _resourceItems.length;
    int availRes = 0;
    int limRes = 0;
    int critRes = 0;
    int foodTotal = 0;
    int waterTotal = 0;
    int medKitsTotal = 0;
    int fuelTotal = 0;
    int criticalAlerts = 0;

    for (final item in _resourceItems) {
      switch (item.status) {
        case ResourceStatus.available:
          availRes++;
          break;
        case ResourceStatus.limited:
          limRes++;
          break;
        case ResourceStatus.critical:
        case ResourceStatus.outOfStock:
          critRes++;
          criticalAlerts++;
          break;
      }

      switch (item.category) {
        case ResourceCategory.foodPacks:
          foodTotal += item.currentQuantity;
          break;
        case ResourceCategory.waterBottles:
          waterTotal += item.currentQuantity;
          break;
        case ResourceCategory.medicalKits:
          medKitsTotal += item.currentQuantity;
          break;
        case ResourceCategory.fuel:
          fuelTotal += item.currentQuantity;
          break;
        default:
          break;
      }
    }

    int activeShelters = _shelters.where((s) => s.status != ShelterStatus.closed).length;
    int availBeds = _hospitals.fold(0, (sum, h) => sum + h.availableBeds);
    int icuBeds = _hospitals.fold(0, (sum, h) => sum + h.icuBeds);
    int activeAllocs = _allocations
        .where((a) => a.deliveryStatus == DeliveryStatus.pending ||
            a.deliveryStatus == DeliveryStatus.dispatched ||
            a.deliveryStatus == DeliveryStatus.inTransit)
        .length;

    return ResourceSummary(
      totalResources: totalRes,
      availableResources: availRes,
      limitedResources: limRes,
      criticalResources: critRes,
      activeShelters: activeShelters,
      totalShelters: _shelters.length,
      totalHospitals: _hospitals.length,
      availableHospitalBeds: availBeds,
      availableIcuBeds: icuBeds,
      foodStockPacks: foodTotal,
      waterStockBottles: waterTotal,
      medicalKitsCount: medKitsTotal,
      fuelAvailableLiters: fuelTotal * 100, // Normalized bulk liters
      activeAllocations: activeAllocs,
      criticalAlerts: criticalAlerts,
    );
  }

  ResourceItemModel updateResourceQuantity({
    required String resourceId,
    required int quantityChange,
    required String reason,
    required String performedBy,
    required String destinationName,
  }) {
    final idx = _resourceItems.indexWhere((r) => r.id == resourceId);
    if (idx == -1) {
      throw Exception('Resource $resourceId not found');
    }

    final old = _resourceItems[idx];
    final newQty = (old.currentQuantity + quantityChange).clamp(0, 999999);
    final newStatus = ResourceItem.calculateStatus(newQty, old.minimumThreshold);

    final record = ResourceUsageRecordModel(
      id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      changeAmount: quantityChange,
      remainingQuantity: newQty,
      reason: reason,
      performedBy: performedBy,
      destinationName: destinationName,
    );

    final updated = ResourceItemModel(
      id: old.id,
      name: old.name,
      category: old.category,
      warehouseId: old.warehouseId,
      warehouseName: old.warehouseName,
      district: old.district,
      currentQuantity: newQty,
      minimumThreshold: old.minimumThreshold,
      unit: old.unit,
      status: newStatus,
      lastUpdated: DateTime.now(),
      autoWarning: newQty <= old.minimumThreshold,
      description: old.description,
      usageHistory: [record, ...old.usageHistory],
    );

    _resourceItems[idx] = updated;
    return updated;
  }

  ShelterModel updateShelter({
    required String id,
    int? currentOccupancy,
    StockLevel? foodAvailability,
    StockLevel? waterAvailability,
    bool? medicalSupport,
    ShelterStatus? status,
  }) {
    final idx = _shelters.indexWhere((s) => s.id == id);
    if (idx == -1) throw Exception('Shelter $id not found');

    final old = _shelters[idx];
    final updated = ShelterModel(
      id: old.id,
      name: old.name,
      district: old.district,
      address: old.address,
      capacity: old.capacity,
      currentOccupancy: currentOccupancy ?? old.currentOccupancy,
      availableBeds: currentOccupancy != null
          ? (old.capacity - currentOccupancy).clamp(0, old.capacity)
          : old.availableBeds,
      medicalSupport: medicalSupport ?? old.medicalSupport,
      foodAvailability: foodAvailability ?? old.foodAvailability,
      waterAvailability: waterAvailability ?? old.waterAvailability,
      electricity: old.electricity,
      internet: old.internet,
      status: status ?? old.status,
      lastUpdated: DateTime.now(),
      latitude: old.latitude,
      longitude: old.longitude,
      contactPerson: old.contactPerson,
      contactPhone: old.contactPhone,
    );

    _shelters[idx] = updated;
    return updated;
  }

  HospitalModel updateHospital({
    required String id,
    int? availableBeds,
    int? icuBeds,
    int? emergencyDoctors,
    int? ambulances,
    HospitalStatus? status,
  }) {
    final idx = _hospitals.indexWhere((h) => h.id == id);
    if (idx == -1) throw Exception('Hospital $id not found');

    final old = _hospitals[idx];
    final updated = HospitalModel(
      id: old.id,
      name: old.name,
      district: old.district,
      address: old.address,
      totalBeds: old.totalBeds,
      availableBeds: availableBeds ?? old.availableBeds,
      icuBeds: icuBeds ?? old.icuBeds,
      emergencyDoctors: emergencyDoctors ?? old.emergencyDoctors,
      ambulances: ambulances ?? old.ambulances,
      bloodAvailability: old.bloodAvailability,
      traumaCenter: old.traumaCenter,
      contactNumber: old.contactNumber,
      status: status ?? old.status,
      latitude: old.latitude,
      longitude: old.longitude,
      specialtyServices: old.specialtyServices,
      lastUpdated: DateTime.now(),
    );

    _hospitals[idx] = updated;
    return updated;
  }

  ResourceAllocationModel addAllocation(ResourceAllocation allocation) {
    final model = ResourceAllocationModel(
      id: allocation.id.isEmpty
          ? 'ALC-${DateTime.now().year}-${_allocations.length + 100}'
          : allocation.id,
      items: allocation.items
          .map((e) => AllocatedItemModel(
                resourceItemId: e.resourceItemId,
                resourceName: e.resourceName,
                category: e.category,
                quantity: e.quantity,
                unit: e.unit,
              ))
          .toList(),
      destinationType: allocation.destinationType,
      destinationId: allocation.destinationId,
      destinationName: allocation.destinationName,
      destinationDistrict: allocation.destinationDistrict,
      priority: allocation.priority,
      vehicleId: allocation.vehicleId,
      vehicleName: allocation.vehicleName,
      assignedTeamId: allocation.assignedTeamId,
      assignedTeamName: allocation.assignedTeamName,
      estimatedArrival: allocation.estimatedArrival,
      deliveryStatus: allocation.deliveryStatus,
      createdAt: allocation.createdAt,
      notes: allocation.notes,
    );

    // Deduct stock for allocated items
    for (final itm in allocation.items) {
      try {
        updateResourceQuantity(
          resourceId: itm.resourceItemId,
          quantityChange: -itm.quantity,
          reason: 'Dispatched in order ${model.id}',
          performedBy: 'Mission Control',
          destinationName: model.destinationName,
        );
      } catch (_) {}
    }

    _allocations.insert(0, model);
    return model;
  }

  ResourceAllocationModel updateAllocationStatus({
    required String allocationId,
    required DeliveryStatus newStatus,
  }) {
    final idx = _allocations.indexWhere((a) => a.id == allocationId);
    if (idx == -1) throw Exception('Allocation $allocationId not found');

    final old = _allocations[idx];
    final updated = ResourceAllocationModel(
      id: old.id,
      items: old.items,
      destinationType: old.destinationType,
      destinationId: old.destinationId,
      destinationName: old.destinationName,
      destinationDistrict: old.destinationDistrict,
      priority: old.priority,
      vehicleId: old.vehicleId,
      vehicleName: old.vehicleName,
      assignedTeamId: old.assignedTeamId,
      assignedTeamName: old.assignedTeamName,
      estimatedArrival: newStatus == DeliveryStatus.delivered ? 'Delivered' : old.estimatedArrival,
      deliveryStatus: newStatus,
      createdAt: old.createdAt,
      notes: old.notes,
    );

    _allocations[idx] = updated;
    return updated;
  }
}
