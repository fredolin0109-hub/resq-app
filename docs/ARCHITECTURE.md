# ResQLink AI Rescue Module Architecture

## 1. Overview
The ResQLink AI Rescue Module is designed with **Clean Architecture** and **Domain-Driven Design (DDD)** principles. It operates as an autonomous, offline-first mission command and coordination ecosystem for disaster response squads, commanders, paramedics, and volunteers.

```
+------------------------------------------------------------------+
|                   Presentation Layer (UI & Widgets)              |
|  * Screens (Dashboard, Map, SOS, Teams, Twin, Offline, etc.)     |
|  * Reusable Widgets (Telemetry Cards, Skeleton Loaders, Gauges)  |
|  * State Management (Riverpod StateNotifier / Notifiers)         |
+---------------------------------+--------------------------------+
                                  |
                                  v
+---------------------------------+--------------------------------+
|                     Domain Layer (Business Logic)                |
|  * Entities & Value Objects (Missions, Squads, Telemetry)        |
|  * Abstract Repository Contracts (RescueRepository, etc.)        |
|  * Use Cases (GetMissions, DispatchSquad, SyncMesh, etc.)        |
+---------------------------------+--------------------------------+
                                  |
                                  v
+---------------------------------+--------------------------------+
|                      Data Layer (Data & Network)                 |
|  * DTO Models (JSON Serialization & Deserialization)             |
|  * Repository Implementations (RescueRepositoryImpl)             |
|  * Datasources (Local SQLite, BLE Mesh, Remote REST/WS Mock)     |
+---------------------------------+--------------------------------+
                                  |
                                  v
+---------------------------------+--------------------------------+
|                     Services & Hardware Integration              |
|  * BLE Mesh & LoRa Protocols                                     |
|  * Vector Map Tile Caching & Offline Storage                     |
|  * Backup, Recovery & Diagnostic Telemetry Services              |
+------------------------------------------------------------------+
```

---

## 2. Core Subsystems

### 1. Authentication (`features/rescue/auth/`)
- Biometric verification (Fingerprint, FaceID).
- Badge number & official ID token validation.
- Role-Based Access Control (RBAC): SuperAdmin, IncidentCommander, FieldLeader, Paramedic, Logistics, Recon, Volunteer.

### 2. Central Mission Dashboard (`features/rescue/`)
- Live disaster feed aggregation.
- Quick mission statistics and active squad metrics.
- Emergency weather radar integration.

### 3. Mission Command Spatial Map (`features/rescue/map/`)
- Multi-layer tactical overlay (Heatmaps, Hazard zones, Evacuation routes, Squad GPS pins).
- Vector offline map caching with sub-second bounding box queries.
- Incident clustering and geographic radius filters.

### 4. Live SOS Command Center (`features/rescue/sos/`)
- Real-time civilian SOS triage queue with color-coded severity.
- Direct dispatch routing and victim medical status telemetry.
- Audio transcriptions and AI priority score indexing.

### 5. Squad & Fleet Management (`features/rescue/team_management/`)
- Real-time squad availability and vehicle tracking.
- Skill matrix matching (Aquatic, Hazmat, High-Altitude, Canine).
- Squad health telemetry and gear inventory tracking.

### 6. Resource & Shelter Logistics (`features/rescue/resources/`)
- Multi-district supply chain management (Rations, Water, Fuel, Medical Kits).
- Shelter occupancy tracking and hospital trauma center bed load monitoring.

### 7. AI Commander (`features/rescue/ai_commander/`)
- NLP decision support assistant for tactical commanders.
- Multi-district risk projection and dynamic bottleneck avoidance routing.
- Early hazard surge advisory engine.

### 8. Digital Twin Command Center (`features/rescue/digital_twin/`)
- Real-time spatial simulation of flood inundation, storm surges, and fires.
- Infrastructure asset health monitoring (Bridges, Power Grid, Cellular towers).
- Predictive evacuation timelines.

### 9. Offline Mesh Communication (`features/rescue/offline/`)
- Peer-to-peer BLE mesh and LoRa multi-hop store-and-forward routing.
- Automatic offline queue synchronization upon uplink reconnection.
- End-to-end cryptographic packet signing.

### 10. Disaster Analytics & Reporting (`features/rescue/analytics/`)
- Telemetry breakdown across 500 incidents and 13 Tamil Nadu districts.
- Automated SitRep generation into PDF, CSV, and JSON formats.

### 11. Administration & System Monitoring (`features/rescue/admin/`)
- Comprehensive user RBAC management.
- Live server latency and synchronization queue monitoring.
- Automated snapshot backup and disaster recovery archive.

---

## 3. Data Flow & Synchronization
1. **Offline Mode**: When no cellular/WiFi network is detected, commands and messages are queued in encrypted local storage and relayed via BLE Mesh nodes.
2. **Online Sync**: As soon as internet connectivity is detected, the `SyncEngine` drains the pending queue, synchronizes changes with the central backend, and refreshes the local cache.
