# ResQLink AI Rescue Module Setup & Local Development

## 1. Prerequisites
- **Flutter SDK**: `>=3.19.0`
- **Dart SDK**: `>=3.3.0`
- **Android Studio / Xcode**: For mobile terminal emulators and physical BLE mesh hardware testing
- **Git**: `>=2.40.0`

---

## 2. Quickstart
```bash
# Clone the repository
git clone https://github.com/fredolin0109-hub/resq-app.git

# Navigate to the workspace
cd resq-app/mobile

# Install Flutter dependencies
flutter pub get

# Run unit and widget tests
flutter test

# Run application on target device / simulator
flutter run -t lib/main.dart
```

---

## 3. Environment Variables
Copy the `.env.example` file in the root directory to `.env`:
```bash
cp .env.example .env
```

Configure the following parameters:
- `API_BASE_URL`: Central Disaster Management REST URL
- `WS_TELEMETRY_URL`: Live SOS and Squad stream WebSocket endpoint
- `AI_COMMANDER_ENDPOINT`: Gemini / AI Intelligence inference gateway
- `BLE_SERVICE_UUID`: BLE Mesh Service Identifier for local field nodes
