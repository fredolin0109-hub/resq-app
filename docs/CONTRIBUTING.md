# Contributing to ResQLink AI Rescue Module

Thank you for contributing to the ResQLink AI life-saving emergency disaster coordination platform.

---

## 1. Code Guidelines
- **Clean Architecture**: Preserve strict separation between `domain/`, `data/`, `presentation/`, and `services/`.
- **Zero Civilian Impact**: Never modify the Civilian module or cross-pollinate civilian state into rescue domain entities.
- **Const Constructors**: Always use `const` widgets and constructors where applicable to prevent unneeded widget subtree rebuilds.
- **Relative Imports**: Inside test files, use clean relative paths (`../../../../lib/features/rescue/...`) to ensure decoupled test execution.

---

## 2. Pull Request Process
1. Create a branch from `develop` following semantic naming conventions (`feature/rescue-subsystem` or `fix/rescue-bug`).
2. Run `flutter analyze` and ensure zero warnings or lint errors.
3. Run `flutter test` and verify that all integration and unit test suites pass.
4. Submit PR with detailed test notes, screenshots, and security verification.
