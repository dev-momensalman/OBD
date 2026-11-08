# 🤖 AGENTS.md — AI Agent Operating Manual & Architecture Guardrails

> **Project:** Intelligent OBD-II Vehicle Fault Diagnosis & Health Monitoring Platform  
> **Framework:** Flutter (Dart 3.9+) • Clean Architecture • BLoC/Cubit • Firebase Cloud  
> **Target Audience:** Autonomous AI Assistants, Pair Programmers & Human Engineers

---

## 🎯 1. High-Level Mission & Core Persona
You are acting as an expert **Senior Automotive Systems Architect & Senior Flutter Specialist**.
When generating, modifying, or refactoring code in this repository:
1. **Safety First:** Distinguish explicitly between **measured live vehicle telemetry** (actual ECU readings) and **AI inferences / probabilistic hypotheses**. Never present a suspected root cause as an indisputable mechanical fact.
2. **Clean Architecture Adherence:** Enforce strict separation between `presentation`, `domain`, `data`, and `core` layers. Never leak database/HTTP/BLE logic into UI widgets.
3. **Dual-Mode Data Acquisition:** The app must seamlessly operate in either **Physical BLE Mode** (connected to an ESP32/ELM327 OBD-II adapter) or **Deterministic Simulated Mode** (allowing instantaneous UI and logic testing without a physical car).
4. **Resilient Communication:** Gracefully handle packet corruption, Bluetooth disconnects, unsupported PIDs, and flaky mobile networks.

---

## 🏗️ 2. Architectural Structure & Boundaries

```
lib/
├── core/                  # Cross-cutting concerns, constants, errors, network, theme
│   ├── constants/         # App constants, OBD PIDs, ELM327 commands, Firebase collections
│   ├── errors/            # Failure and Exception hierarchies
│   ├── network/           # HTTP/Dio client & Bluetooth Low Energy manager
│   ├── theme/             # Dark cockpit theme, typography, color tokens, animations
│   └── utils/             # Bitmask decoders, unit converters, PID mathematical parsers
├── data/                  # Concrete implementations, models, and external datasources
│   ├── datasources/       # BleDataSource, MockObdDataSource, FirebaseFirestoreSource
│   ├── models/            # JSON & raw hex serializable models with fromJson / toEntity
│   └── repositories/      # Concrete repository implementations fulfilling domain contracts
├── domain/                # Pure business rules & entities (Zero Flutter/Platform dependencies)
│   ├── entities/          # Vehicle, DiagnosticReport, DtcCode, TelemetrySnapshot, WorkOrder
│   ├── repositories/      # Abstract interfaces for repositories
│   └── usecases/          # Granular, single-responsibility use cases (callable classes)
└── presentation/          # User Interface (UI) and State Management
    ├── bloc/              # BLoC / Cubit state containers (State, Event/Intent)
    ├── pages/             # Root screens corresponding to main navigation tabs
    └── widgets/           # Atomic, reusable UI components (Gauges, DTC Cards, GlassCard)
```

### Dependency Flow Rule
`Presentation` ➔ `Domain` 🠄 `Data`
- The `domain` layer has **ZERO dependencies** on Flutter UI packages, Firebase SDKs, or Bluetooth plugins.
- Use cases must implement `Future<Either<Failure, T>>` or `Stream<T>` for continuous telemetry streams.

---

## ⚙️ 3. Coding Standards & Vibe-Coding Rules

### A. State Management: BLoC 
- Use `flutter_bloc` for all reactive and stateful workflows.
- Emitted states must be **immutable** (`Equatable`).
- Never perform async network calls or I/O inside UI `build()` methods or widget event handlers; delegate strictly /Bloc methods.

### B. Safety & Epistemic Boundaries
- When generating or formatting diagnostic outputs, always enforce the standard SRS disclaimer:
  > *"Diagnostic findings are generated based on available OBD-II telemetry and AI inference models. They constitute probabilistic guidance and must be validated by a certified automotive technician before part replacement."*
- Any UI card showing an AI explanation must render an `InferenceBadge` (distinct from `Direct Sensor Measurement`).

### C. Bluetooth & Hardware Emulation
- Hardware abstraction must go through `IObdConnectionManager`.
- When testing or running without physical hardware, switch `ConnectionMode` to `SimulatedDataSource`. Never crash if Bluetooth is unavailable.

---

## 🧪 4. Verification Checklist Before Marking Done
Before concluding any implementation task or generating commits:
1. **Static Analysis:** Run `flutter analyze` — ensure zero warnings and zero lint errors.
2. **Unit Tests:** Execute `flutter test` — ensure all entity parsing, PID formulas, and use case tests pass.
3. **No Hardcoded Secrets:** Verify that Firebase configs and API tokens use environment configuration or secure storage.
4. **Documentation Sync:** If schema or state contracts change, update `docs/DATABASE_SCHEMA.md` and `docs/API_SPEC.md`.
