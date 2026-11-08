# 💡 DECISIONS.md — Architecture Decision Records (ADR)

> **Format:** Context, Decision, Consequences, Status

---

## ADR-001: Mobile Framework Selection (Flutter)
- **Status:** Accepted
- **Context:** Need cross-platform support (Android, iOS) with high-performance 60 FPS custom rendering for automotive HUD gauges and dials.
- **Decision:** Adopt Flutter 3.35+ with Dart.
- **Consequences:** Single shared codebase, rich Canvas/CustomPainter capabilities for speedometer/tachometer gauges, strong ecosystem for Bluetooth and Firebase.

---

## ADR-002: State Management (BLoC / Cubit)
- **Status:** Accepted
- **Context:** Complex asynchronous telemetry streams, hardware connection states, and diagnostic flows require predictable, testable state management.
- **Decision:** Adopt `flutter_bloc` with Cubit for straightforward state management and Bloc for event-driven telemetry.
- **Consequences:** Clear unidirectional data flow, separation of business logic from UI, first-class testability with `bloc_test`.

---

## ADR-003: Hybrid 4-Tier AI Diagnostic Architecture
- **Status:** Accepted
- **Context:** Relying solely on an LLM causes dangerous hallucinations; relying solely on rule engines fails to explain complex multi-system interactions in plain language.
- **Decision:** Combine:
  1. Deterministic Rule Engine for critical safety bounds.
  2. Machine Learning for pattern anomaly detection.
  3. RAG over indexed OEM repair manuals to ground knowledge.
  4. LLM strictly for structuring plain-language explanations.
- **Consequences:** Eliminates hallucinations, preserves safety guarantees, and delivers human-friendly explanations.

---

## ADR-004: Dual-Mode OBD-II Pipeline (Simulated & Physical BLE)
- **Status:** Accepted
- **Context:** Developers and AI coding agents cannot plug into a physical car during continuous development.
- **Decision:** Implement `IObdConnectionManager` with a toggleable `MockObdDataSource` generating synthetic telemetry and DTC fault scenarios.
- **Consequences:** Instant vibe-coding without hardware; frictionless local automated testing.
