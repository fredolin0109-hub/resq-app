# ResQLink AI Offline Communication & Mesh Architecture

## 1. Zero-Internet Resilience
In severe disaster scenarios (cyclones, catastrophic flooding, infrastructure destruction), cellular base stations and fiber optic backhauls frequently fail. ResQLink AI operates continuously without internet through its multi-tiered offline architecture:

```
[ Civilian Device ]
       | (BLE Beacon / SOS Broadcast)
       v
[ Field Rescue Squad Terminal ] <==== BLE Mesh Multi-Hop ====> [ Incident Commander Node ]
       |                                                                 |
       +------------------- Encrypted Store-and-Forward -----------------+
                                         |
                            (When Uplink Restored)
                                         v
                            [ Central Cloud Datacenter ]
```

---

## 2. Core Capabilities
1. **Bluetooth Low Energy (BLE) Mesh**:
   - Dynamic peer discovery across up to 32 hops.
   - Low energy overhead preserving field terminal battery life.
2. **Encrypted Store-and-Forward Queue**:
   - Outbound SOS responses, triage notes, and resource requests are cached locally in encrypted SQLite storage.
   - Automatic delta synchronization upon cellular, satellite, or WiFi reconnection.
3. **Offline Vector Map Tile Caching**:
   - Pre-downloadable high-resolution terrain, road network, and elevation tiles for 13 Tamil Nadu districts.
   - In-memory spatial index with sub-second polygon queries.
4. **Hardware Agnostic Design**:
   - Prepared for plug-and-play LoRa / Semtech SX1262 transceivers for long-range (10 km+) peer connectivity.
