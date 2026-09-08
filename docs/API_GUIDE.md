# ResQLink AI Rescue Module API Guide

This guide describes the backend-ready repository contracts, endpoints, and data contracts used across the 11 Rescue submodules.

---

## 1. Authentication Endpoints
- `POST /api/v1/rescue/auth/login`
  - Payload: `{ "email": "commander@resqlink.tn.gov.in", "password": "***", "badgeNumber": "TN-NDRF-01" }`
  - Response: `{ "token": "jwt...", "user": { "id": "USR-101", "role": "superAdmin" } }`
- `POST /api/v1/rescue/auth/biometric`
  - Payload: `{ "biometricToken": "base64...", "deviceId": "DEV-301" }`

---

## 2. Mission & Telemetry Endpoints
- `GET /api/v1/rescue/missions`
  - Query Params: `district`, `status`, `severity`, `category`
- `POST /api/v1/rescue/missions/{id}/dispatch`
  - Payload: `{ "squadId": "TEAM-201", "assignedVehicles": ["VEH-01", "VEH-02"] }`
- `GET /api/v1/rescue/missions/{id}/telemetry`

---

## 3. Live SOS & Triage Endpoints
- `GET /api/v1/rescue/sos/stream` (WebSocket)
  - Incoming stream of civilian distress beacons with GPS coordinates and victim vitals.
- `PUT /api/v1/rescue/sos/{id}/triage`
  - Payload: `{ "status": "dispatched", "squadId": "TEAM-201", "triagePriority": "critical" }`

---

## 4. Digital Twin & Prediction Endpoints
- `GET /api/v1/rescue/twin/layers`
  - Query Params: `district`, `layerTypes`
- `POST /api/v1/rescue/twin/simulations/run`
  - Payload: `{ "disasterType": "flood", "rainfallMm": 180, "durationHours": 48 }`
- `GET /api/v1/rescue/twin/predictions`

---

## 5. AI Commander Decision Intelligence Endpoints
- `POST /api/v1/rescue/ai/chat`
  - Payload: `{ "prompt": "Suggest evacuation bypass for Cuddalore lower catchment", "contextDistrict": "Cuddalore" }`
  - Response: `{ "reply": "...", "recommendationId": "REC-04", "confidenceScore": 0.94 }`
- `GET /api/v1/rescue/ai/recommendations`

---

## 6. Disaster Analytics & SitRep Endpoints
- `GET /api/v1/rescue/analytics/summary`
- `GET /api/v1/rescue/analytics/incidents`
- `POST /api/v1/rescue/analytics/reports/generate`
  - Payload: `{ "timeframe": "daily", "format": "pdf", "district": "All" }`

---

## 7. Administration & System Management Endpoints
- `GET /api/v1/rescue/admin/health`
- `GET /api/v1/rescue/admin/users`
- `PUT /api/v1/rescue/admin/users/{id}/status`
  - Payload: `{ "status": "onDuty" }`
- `GET /api/v1/rescue/admin/audit-logs`
- `POST /api/v1/rescue/admin/backups/create`
  - Payload: `{ "name": "Pre-Monsoon Baseline" }`
