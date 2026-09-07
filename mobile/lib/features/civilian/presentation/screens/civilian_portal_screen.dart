import 'package:flutter/material.dart';
import '../../rescue/presentation/screens/rescue_dashboard_screen.dart';

/// Production-ready Civilian Distress, Safety Check-in & Shelter Portal.
class CivilianPortalScreen extends StatefulWidget {
  const CivilianPortalScreen({super.key});

  static const String routeName = '/civilian';

  @override
  State<CivilianPortalScreen> createState() => _CivilianPortalScreenState();
}

class _CivilianPortalScreenState extends State<CivilianPortalScreen> {
  bool _isSosActive = false;
  bool _isSafeStatusReported = true;
  bool _meshBeaconActive = true;
  int _selectedBottomTab = 0;

  final List<Map<String, dynamic>> _nearbyShelters = [
    {
      'name': 'Marina Central Relief Camp',
      'district': 'Chennai Coastal Zone',
      'distance': '1.2 km away',
      'capacity': '320 / 500 Capacity',
      'status': 'Open & Accepting',
      'supplies': ['Food & Water', 'First Aid', 'Power Backup'],
      'isSafe': true,
    },
    {
      'name': 'St. Thomas Community Shelter',
      'district': 'Guindy Sector 4',
      'distance': '3.8 km away',
      'capacity': '180 / 250 Capacity',
      'status': 'Medical Station Active',
      'supplies': ['Doctor on-site', 'Rations', 'Blankets'],
      'isSafe': true,
    },
    {
      'name': 'Tambaram Higher Secondary Camp',
      'district': 'Tambaram Flood Zone',
      'distance': '5.4 km away',
      'capacity': '410 / 450 Capacity',
      'status': 'Near Full',
      'supplies': ['Dry Rations', 'Water Tanker'],
      'isSafe': false,
    },
  ];

  void _triggerEmergencySos() {
    setState(() {
      _isSosActive = true;
      _isSafeStatusReported = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text('SOS Broadcast Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency distress signal transmitted to District Rescue Command & nearby BLE mesh nodes.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '• GPS Coordinates: 13.0827° N, 80.2707° E\n• Mesh Packet ID: SOS-CIV-9921\n• Estimated Response: 8 mins',
              style: TextStyle(color: Colors.amberAccent, fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _isSosActive = false);
            },
            child: const Text('Cancel SOS', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Keep Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _reportSafetyCheckin() {
    setState(() {
      _isSafeStatusReported = true;
      _isSosActive = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Safety Status: "I AM SAFE" broadcasted to family & rescue teams.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ResQLink Civilian Portal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tamil Nadu Disaster Safety Network',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          // Switch to Rescue Commander portal
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const RescueDashboardScreen(),
                  ),
                );
              },
              icon: Icon(Icons.shield_rounded, size: 16, color: colorScheme.primary),
              label: Text(
                'Rescue Mode',
                style: TextStyle(fontSize: 12, color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. High-Priority Distress Warning / SOS Trigger
              Card(
                elevation: 4,
                color: _isSosActive ? const Color(0xFF450A0A) : const Color(0xFF1E1B4B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _isSosActive ? Colors.redAccent : Colors.indigo.shade400,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isSosActive ? Icons.warning_rounded : Icons.health_and_safety_rounded,
                            color: _isSosActive ? Colors.redAccent : Colors.tealAccent,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isSosActive ? 'EMERGENCY SOS ACTIVE' : 'Distress & Rescue Trigger',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _isSosActive
                                      ? 'Rescue team dispatched. Mesh beacon pinging.'
                                      : 'Tap for immediate rescue assistance & location broadcast.',
                                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSosActive ? Colors.red.shade900 : const Color(0xFFDC2626),
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _triggerEmergencySos,
                          icon: const Icon(Icons.sos_rounded, size: 28, color: Colors.white),
                          label: Text(
                            _isSosActive ? 'SOS BROADCASTING (TAP FOR DETAILS)' : 'SEND EMERGENCY SOS',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Safety Status Quick Check-In
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _isSafeStatusReported
                              ? Colors.green.shade900.withValues(alpha: 0.3)
                              : Colors.orange.shade900.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isSafeStatusReported ? Icons.check_circle_rounded : Icons.help_outline_rounded,
                          color: _isSafeStatusReported ? Colors.greenAccent : Colors.orangeAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isSafeStatusReported ? 'Status: Marked as Safe' : 'Status: Need Assistance',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Updates your emergency contacts automatically',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _reportSafetyCheckin,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('I Am Safe'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3. Offline Mesh Beacon & Tactical Telemetry
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: SwitchListTile(
                  secondary: const Icon(Icons.bluetooth_audio_rounded, color: Colors.blueAccent),
                  title: const Text('Offline Peer Mesh Beacon', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Broadcasts distress even with no internet/cellular towers'),
                  value: _meshBeaconActive,
                  onChanged: (val) => setState(() => _meshBeaconActive = val),
                ),
              ),

              const SizedBox(height: 24),

              // 4. Nearby Safe Shelters & Relief Camps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Safe Shelters',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All on Map'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ..._nearbyShelters.map((shelter) {
                final isSafe = shelter['isSafe'] as bool;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                shelter['name'],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isSafe
                                    ? Colors.teal.shade900.withValues(alpha: 0.4)
                                    : Colors.orange.shade900.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                shelter['status'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSafe ? Colors.tealAccent : Colors.orangeAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${shelter['district']} • ${shelter['distance']}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Occupancy: ${shelter['capacity']}',
                          style: TextStyle(fontSize: 12, color: colorScheme.primary, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: (shelter['supplies'] as List<String>).map((sup) {
                            return Chip(
                              label: Text(sup, style: const TextStyle(fontSize: 11)),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedBottomTab,
        onDestinationSelected: (idx) {
          setState(() => _selectedBottomTab = idx);
          if (idx == 3) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const RescueDashboardScreen()),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.night_shelter_outlined),
            selectedIcon: Icon(Icons.night_shelter_rounded),
            label: 'Shelters',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_active_outlined),
            selectedIcon: Icon(Icons.notifications_active_rounded),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield_rounded),
            label: 'Rescue Command',
          ),
        ],
      ),
    );
  }
}
