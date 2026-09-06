# Changelog - ResQLink AI Rescue Module

All notable changes to the Rescue Module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.4.0-PROD] - 2026-09-06

### Added
- **Authentication & Biometrics**: Implemented multi-factor authentication, biometric fingerprint/FaceID support, and role-based access control.
- **Central Mission Dashboard**: Real-time disaster feed, active squad telemetry, and live weather alerts.
- **Mission Command Map**: Vector tile offline caching, multi-layer tactical overlay, and incident clustering.
- **Live SOS Command Center**: Civilian distress triage queue, medical triage prioritization, and direct dispatch routing.
- **Team & Fleet Management**: 50 rescue squad profiles, skill matrix, and vehicle tracking across 13 Tamil Nadu districts.
- **Resource & Shelter Management**: Inventory monitoring for medical kits, rations, fuel, shelters, and hospital ICU capacity.
- **AI Commander**: Decision intelligence NLP assistant, route optimization, and early warning synthesis.
- **Digital Twin Command Center**: 3D spatial simulation, infrastructure asset monitoring, and flood surge models.
- **Offline Communication System**: BLE mesh multi-hop routing, store-and-forward queue, and LoRa transceiver architecture.
- **Disaster Analytics & Reporting**: 500 incident records analysis, district disaster profiles, and multi-format SitRep generation (PDF, CSV, JSON).
- **Administration & System Management**: 50 users RBAC, 20 teams, 25 hardware devices, 200 alerts, 100 audit logs, and backup/restore snapshots.

### Optimized
- Streamlined Riverpod state management and reduced redundant widget rebuilds with `const` constructors.
- Added comprehensive skeleton loaders and empty state fallbacks across all 11 submodules.
