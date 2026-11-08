# ⚠️ KNOWN_LIMITATIONS.md — System & Architectural Boundaries

> **Source:** SRS Section 1.2.2 (Out of Scope) & Technical Constraints

---

## 1. Documented System Boundaries

| Category | Known Boundary / Limitation | Rationale & Safety Impact |
|---|---|---|
| **Protocol Scope** | Standard SAE J1979 OBD-II only; no proprietary OEM manufacturer protocols (e.g. BMW Ediabas, Mercedes Vediamo). | Ensures universal legality, broad compatibility, and eliminates risk of bricking proprietary CAN buses. |
| **Control Action** | Strictly read-only data acquisition; no bi-directional actuation or ECU remapping. | Critical safety guardrail: App will never engage ABS solenoids, throttle actuators, or clear airbag codes during motion. |
| **Mechanical Inferences**| AI diagnostics are probabilistic, not infallible physical inspections. | A DTC indicates an electrical sensor reading abnormality, not always a failed part (e.g., vacuum leak vs bad MAF). |
| **Sensor Availability** | Dependent on individual vehicle make/year. | Older vehicles may not report PIDs like Transmission Temp or Fuel Rail Pressure; app must handle null telemetry gracefully. |
| **Connectivity** | Real-time AI RAG and workshop booking require internet connectivity. | Offline mode relies on local Rule Engine and cached SAE DTC definitions. |
