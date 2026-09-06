# ResQLink AI Rescue Module Deployment Guide

## 1. Release Build Instructions

### Android Release APK / App Bundle (AAB)
```bash
cd mobile

# Build universal release APK
flutter build apk --release --split-per-abi

# Build Google Play App Bundle
flutter build appbundle --release
```

### iOS Release IPA
```bash
cd mobile
flutter build ipa --release
```

---

## 2. CI/CD Automated Pipelines
ResQLink AI utilizes GitHub Actions (`.github/workflows/rescue_ci.yml`) to automatically execute:
1. **Static Analysis**: `flutter analyze` ensuring 0 warnings/lint errors.
2. **Unit & Widget Test Suites**: `flutter test` across all 11 submodules.
3. **Security Audit**: Automated check for hardcoded secrets, keys, or plaintext tokens.
4. **Artifact Compilation**: Building signed Android APKs and testing integration artifacts.

---

## 3. Production Hardening Checklist
- [x] JWT Token storage using encrypted keystores (`flutter_secure_storage`).
- [x] Role-Based Access Control (RBAC) enforced across all routes.
- [x] Vector map offline tile cache bounded to configured disk limits (128 MB - 1024 MB).
- [x] Mock and Real data source toggle seamless via Dependency Injection (`RescueDependencies`, `AdminDependencies`, etc.).
- [x] BLE packet signing enabled with SHA-256 HMAC integrity checks.
