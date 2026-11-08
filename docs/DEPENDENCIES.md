# 📦 DEPENDENCIES.md — Package Catalog & Version Rationale

> **Target:** Flutter 3.35+ • Dart 3.9+ • `pubspec.yaml` Specification

---

## 1. Production Dependencies

| Package | Version | Purpose & Rationale |
|---|---|---|
| `flutter_bloc` | `^9.0.0` | Enterprise predictable state management. |
| `equatable` | `^2.0.7` | Value equality for immutable states and entities. |
| `get_it` | `^8.0.3` | High-performance service locator for dependency injection. |
| `dartz` | `^0.10.1` | Functional programming primitives (`Either<Failure, T>`). |
| `flutter_blue_plus` | `^1.35.0` | Cross-platform Bluetooth Low Energy (BLE) scanning and GATT I/O. |
| `firebase_core` | `^3.12.0` | Firebase initialization. |
| `firebase_auth` | `^5.5.0` | User authentication (Email, Google, Phone). |
| `cloud_firestore` | `^5.6.4` | Real-time database for vehicle garage, reports, and bookings. |
| `fl_chart` | `^0.70.2` | High-performance charting for telemetry time-series and gauges. |
| `google_fonts` | `^6.2.1` | Typography (Outfit, Space Grotesk). |
| `dio` | `^5.8.0` | Robust HTTP client for AI microservice communication. |
| `shared_preferences` | `^2.5.2` | Key-value local storage for user settings and preferences. |
| `flutter_secure_storage` | `^9.2.4` | Encrypted storage for API keys and auth tokens. |

---

## 2. Dev & Testing Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_lints` | `^5.0.0` | Official Flutter lint rules and code standards. |
| `bloc_test` | `^10.0.0` | Testing utility for validating BLoC/Cubit state streams. |
| `mocktail` | `^1.0.4` | Type-safe mocking library for unit testing repositories and datasources. |
