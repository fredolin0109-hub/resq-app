# Rescue Module Documentation — ResQLink AI

## 1. Overview
The **Rescue Module** (`mobile/lib/features/rescue/`) is the mission-critical operations core of the ResQLink AI platform. It equips first responders, field rescue personnel, and tactical incident coordinators with tools for disaster tracking, victim locating, triage management, dispatch routing, and live response telemetry.

## 2. Folder Ownership & Structure

### Primary Rescue Feature Workspace
```
mobile/lib/features/rescue/
├── data/
│   ├── datasources/       # Remote (FastAPI/WebSockets) and local (cache/offline DB) data providers
│   ├── models/            # DTOs and JSON serialization/deserialization classes
│   └── repositories/      # Concrete implementations of domain repositories
├── domain/
│   ├── entities/          # Pure immutable business entities (independent of frameworks)
│   ├── repositories/      # Abstract repository interfaces/contracts
│   ├── usecases/          # Granular business logic operations (single responsibility)
│   └── providers/         # Domain dependency providers and state contracts
├── presentation/
│   ├── screens/           # Full-page UI views for rescue operations
│   ├── widgets/           # Sub-widgets and reusable UI components specific to rescue
│   ├── controllers/       # UI/State controllers, Cubits/Notifiers
│   └── state/             # View state models (loading, success, error, data states)
├── services/              # Hardware/sensor integration, background sync, mesh dispatchers
├── utils/                 # Module-specific formatters, constants, and helpers
└── README.md
```

### Associated Rescue-Owned Feature Modules
- **`mobile/lib/features/navigation/`**: Tactical routing, hazard avoidance paths, and offline navigation.
- **`mobile/lib/features/digital_twin/`**: Structural damage rendering, environmental simulation, and 2D/3D disaster telemetry.
- **`mobile/lib/features/ai_commander/`**: AI-driven triage scoring, resource allocation recommendations, and incident command orchestration.

## 3. Developer Responsibilities
- **Developer A (Rescue Team Lead)** is strictly responsible for:
  - Designing and implementing clean architecture layers within `mobile/lib/features/rescue/`.
  - Implementing domain logic, entities, and use cases for rescue operations.
  - Developing rescue-specific UI screens and operational workflows.
  - Managing integration with tactical modules (`navigation`, `digital_twin`, `ai_commander`).
  - Maintaining documentation and tests within the rescue domain.

## 4. Integration Points
- **Core Layer (`mobile/lib/core/`)**:
  - Consume shared network clients (`core/network/`), error handling mechanisms (`core/errors/`), global constants (`core/constants/`), and local storage utilities (`core/storage/`).
- **Shared Layer (`mobile/lib/shared/`)**:
  - Utilize common design system UI components, buttons, dialogs, and animations.
- **Backend Communication**:
  - Connect to rescue-specific endpoints via designated data sources adhering to agreed API contracts.

## 5. Coding Standards
- **Clean Architecture & Separation of Concerns**:
  - `domain` layer must remain pure Dart without dependencies on UI frameworks or external packages.
  - `data` models must implement `domain` entity mappers (`toDomain()`, `fromEntity()`).
  - `presentation` layer interacts with `domain` exclusively through Use Cases or State Controllers.
- **Immutability & Type Safety**:
  - Prefer immutable data structures.
  - Strongly typed models and explicit return types on all methods.
- **Error Handling**:
  - Wrap network and data operations in domain-specific `Failure` / `Result` wrappers.

## 6. Development Workflow & Git Practices
- **Active Branch**: `feature/rescue`
- **Commit Message Conventions**:
  - `feat(rescue): <description>` — New feature for the rescue module
  - `fix(rescue): <description>` — Bug fix in rescue feature
  - `refactor(rescue): <description>` — Code refactoring without functionality change
  - `docs(rescue): <description>` — Documentation additions or updates
  - `test(rescue): <description>` — Adding or updating rescue unit/integration tests
  - `chore(rescue): <description>` — Maintenance, configuration, or folder setup

## 7. Protected Files & Boundaries (NEVER Modify)
The Rescue developer must **NEVER** modify, rename, or delete the following files and directories:
1. **Civilian Module**: `mobile/lib/features/civilian/` (owned exclusively by Developer B).
2. **Authentication Flow**: `mobile/lib/features/auth/` (shared infrastructure).
3. **Backend APIs & Core Services**: `backend/` (unless coordinated with cross-team approval).
4. **App Initialization & Root Config**: `mobile/lib/app/`, `mobile/lib/main.dart`.
5. **Project Dependencies**: `mobile/pubspec.yaml`, `backend/requirements.txt`.
6. **Civilian Git Branches**: Never reference or checkout `feature/civilian`.
