# ✅ TASKS.md — Granular Engineering Backlog

> **Format:** Epic ➔ User Story ➔ Technical Subtasks  
> **Checklist Status:** 🔲 Not Started • ⏳ In Progress • ✅ Done

---

## Epic 1: Architectural Scaffolding & Shared Core
- [x] **TASK-101:** Initialize Flutter project (`your_flutter_app`) with Dart 3.9+ and Android/iOS/Web targets.
- [ ] **TASK-102:** Configure `pubspec.yaml` with core dependencies (`flutter_bloc`, `get_it`, `dartz`, `fl_chart`, `google_fonts`, `flutter_blue_plus`, `firebase_core`, `cloud_firestore`).
- [ ] **TASK-103:** Create directory layout matching Clean Architecture (`core`, `data`, `domain`, `presentation`).
- [ ] **TASK-104:** Implement `AppTheme` with Midnight Carbon palette (`#0B0F19`), neon cyan/amber/crimson accents, and Glassmorphic decorations.
- [ ] **TASK-105:** Implement `ServiceLocator` using `get_it` for lazy dependency injection.

---

## Epic 2: OBD-II Telemetry & Dual-Mode Connectivity
- [ ] **TASK-201:** Define domain entities: `TelemetrySnapshot`, `DtcFault`, `VehicleProfile`.
- [ ] **TASK-202:** Implement mathematical PID formula decoders (`PidDecoder`) covering RPM, Speed, ECT, MAP, MAF, Fuel Trims, Voltage.
- [ ] **TASK-203:** Build `MockObdDataSource` capable of generating realistic continuous driving telemetry and injecting simulated faults on demand.
- [ ] **TASK-204:** Build `BleObdDataSource` utilizing `flutter_blue_plus` with ELM327 initialization state machine (`ATZ`, `ATE0`, `0100`).
- [ ] **TASK-205:** Implement `ObdRepositoryImpl` switching seamlessly between Physical BLE and Mock Simulator.
- [ ] **TASK-206:** Build `DashboardCubit` providing `Stream<TelemetrySnapshot>` to the presentation layer.
- [ ] **TASK-207:** Build UI `RadialGaugeWidget` for RPM and Speed, plus linear bar for Coolant Temperature.

---

## Epic 3: Fault Diagnosis, Rule Engine & AI Engine
- [ ] **TASK-301:** Implement DTC 2-byte bitmask decoder converting raw hex responses to SAE standard codes (e.g., `P0301`).
- [ ] **TASK-302:** Implement Tier 1 Deterministic `RuleEngine` for safety thresholds (ECT > 115°C, Voltage < 11.8V, LTFT > +20%).
- [ ] **TASK-303:** Implement `DiagnosticReport` entity containing severity, ranked causes, recommended next action, and confidence.
- [ ] **TASK-304:** Implement AI Service Client communicating with Cloud Function / Gemini Flash API with strict RAG context.
- [ ] **TASK-305:** Build `DiagnosticsCubit` managing scan lifecycle: Idle ➔ Scanning ➔ Processing AI ➔ Report Ready.
- [ ] **TASK-306:** Build `DiagnosticReportPage` featuring `SeverityBanner`, `DtcCardWidget`, and `CauseRankingBarChart`.

---

## Epic 4: Service Center Recommender & Work Order Tracker
- [ ] **TASK-401:** Define Firestore data models for `ServiceCenter` and `WorkOrder`.
- [ ] **TASK-402:** Implement `CostEstimatorService` computing parts & labor price ranges based on DTC severity and workshop pricing tier.
- [ ] **TASK-403:** Build `ServiceCenterPage` rendering workshop cards with ratings, distance, and booking buttons.
- [ ] **TASK-404:** Implement `BookingCubit` dispatching appointment creation to Firestore.
- [ ] **TASK-405:** Build `RepairTrackerPage` listening to real-time Firestore updates and animating work order progress steps.

---

## Epic 5: Verification, Testing & Polish
- [ ] **TASK-501:** Write unit tests for `PidDecoder` validating mathematical conversions against known hex vectors.
- [ ] **TASK-502:** Write unit tests for `RuleEngine` evaluating edge threshold triggers.
- [ ] **TASK-503:** Write BLoC tests for `DashboardCubit` and `DiagnosticsCubit`.
- [ ] **TASK-504:** Execute `flutter analyze` and resolve all warnings.
- [ ] **TASK-505:** Validate Level 1 Software Simulation acceptance scenarios per SRS §10.2.
