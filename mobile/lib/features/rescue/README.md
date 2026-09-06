# ResQLink AI - Rescue Command Module

Autonomous Disaster Coordination, Spatial Command, Triage, and Offline Mesh Communication for Emergency Personnel.

---

## 1. Integrated Subsystems
1. **Authentication (`auth/`)**: Secure biometrics, RBAC, and official credentials.
2. **Dashboard (`presentation/`)**: Executive disaster feed, active squads, and operational status.
3. **Mission Map (`map/`)**: Offline vector map overlays, hazard contours, and squad GPS tracking.
4. **Live SOS Command Center (`sos/`)**: Civilian distress triage, medical urgency scorecards, and dispatch routing.
5. **Squad & Fleet Management (`team_management/`)**: Squad readiness, equipment allocation, and leaderboard.
6. **Resource Logistics (`resources/`)**: Shelters, medical kits, rations, and hospital ICU load.
7. **AI Commander (`ai_commander/`)**: Real-time tactical recommendations and situation synthesis.
8. **Digital Twin (`digital_twin/`)**: Hydrodynamic disaster simulations and infrastructure health monitoring.
9. **Offline Mesh (`offline/`)**: Multi-hop BLE mesh store-and-forward communications.
10. **Analytics & Reporting (`analytics/`)**: 500-incident telemetry matrix and exportable SitReps (PDF/CSV/JSON).
11. **Administration & Monitoring (`admin/`)**: 50 users RBAC, hardware nodes, audit trails, and recovery snapshots.

---

## 2. Master Library Entry Point
All 11 modules are cleanly unified in `lib/features/rescue/rescue.dart`:

```dart
import 'package:resq_app/features/rescue/rescue.dart';
```
