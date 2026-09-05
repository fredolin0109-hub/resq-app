# Rescue Module — ResQLink AI

## 1. Rescue Module Responsibility
The Rescue module is responsible for the mission-critical operational tools used by first responders, rescue coordinators, and field teams. Its core responsibilities include:
- Real-time disaster response coordination and team dispatch.
- Victim search, locating, and triage prioritization.
- Live telemetry, hazard reporting, and field status synchronization.
- Integration with tactical modules including navigation, digital twin simulation, and AI Commander decision support.

## 2. Folder Purpose & Architecture
```
mobile/lib/features/rescue/
├── data/
│   ├── datasources/       # Remote (REST/WebSockets) and local (cache/offline DB) data sources
│   ├── models/            # Data Transfer Objects (DTOs) with JSON serialization
│   ├── repositories/      # Concrete implementations of domain repository interfaces
│   └── services/          # Low-level network/device communication services for rescue data
│
├── domain/
│   ├── entities/          # Pure immutable business entities (framework-independent)
│   ├── repositories/      # Abstract repository interfaces and domain contracts
│   └── usecases/          # Business logic use cases with single-responsibility execution
│
├── presentation/
│   ├── screens/           # Main UI screens for rescue workflows (tactical dashboard, dispatch, etc.)
│   ├── widgets/           # Modular and reusable UI widgets specific to the rescue domain
│   ├── providers/         # Dependency injection, state providers, and reactive riverpod/bloc providers
│   └── controllers/       # UI event handlers, controllers, and view-state coordinators
│
├── core/                  # Module-specific constants, configurations, base classes, and errors
│
├── utils/                 # Rescue-specific utility functions, geospatial helpers, and formatters
│
└── README.md              # Module architecture and developer guidelines
```

## 3. Development Rules
- **Role Isolation**: Developer A owns ONLY the Rescue module (`mobile/lib/features/rescue/`) and tactical modules (`navigation/`, `digital_twin/`, `ai_commander/`).
- **Civilian Module Protection**: NEVER modify, import private civilian internals from, or touch `mobile/lib/features/civilian/`.
- **Clean Architecture Boundaries**:
  - `domain/` must remain pure Dart with zero dependencies on Flutter UI or external packages.
  - `presentation/` interacts with data exclusively through domain Use Cases and Providers.
  - `data/` models must map cleanly to and from domain entities.
- **Immutability & Safety**: All entities and models should favor immutability and explicit typing.
- **Git Branching & Commits**:
  - Work on `feature/rescue`.
  - Use conventional commits: `chore(rescue):`, `feat(rescue):`, `fix(rescue):`, `refactor(rescue):`, `docs(rescue):`.

## 4. Integration Points
- **Core Platform Layer (`mobile/lib/core/`)**: Consumes global HTTP/WebSocket clients (`network/`), shared storage (`storage/`), and base error types (`errors/`).
- **Shared UI Layer (`mobile/lib/shared/`)**: Utilizes shared UI design system widgets, buttons, dialogs, and themes.
- **Tactical Feature Modules**:
  - `mobile/lib/features/navigation/` for evacuation routes and waypoint guidance.
  - `mobile/lib/features/digital_twin/` for 2D/3D disaster impact visualization.
  - `mobile/lib/features/ai_commander/` for automated triage recommendations.
- **Backend Communication**: Interfaces with rescue endpoints exposed by the FastAPI backend adhering to defined contracts.
