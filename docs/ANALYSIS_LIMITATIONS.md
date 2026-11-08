# 🛡️ ANALYSIS_LIMITATIONS.md — Safety, Epistemic & Liability Guardrails

> **Mandate:** SRS Section 6.2 (AI Safety), NFR-USA-001, and Critical Requirements §14

---

## 1. Epistemic Separation: Measured vs Inferred

The system strictly enforces the epistemological boundary between what is **physically measured** by the vehicle sensors and what is **inferred by machine learning or LLM models**:

```
[Vehicle Sensors / ECU]
        │ (Physical Reality: Mode 01 / Mode 02 / Mode 03)
        ▼
╔════════════════════════════════════════════════════════════╗
║ 1. MEASURED SENSOR EVIDENCE (Fact: Coolant = 108°C, P0301) ║
╚════════════════════════════════════════════════════════════╝
        │
        ▼ (Hybrid Reasoning Pipeline)
╔════════════════════════════════════════════════════════════╗
║ 2. INFERRED PROBABILITY (Hypothesis: Failing Coil #1 - 65%)║
╚════════════════════════════════════════════════════════════╝
```

### Non-Negotiable Presentation Rules
1. **Never Assert Absolute Guarantees:** UI text must never state "Your spark plug is broken." Instead, it must state "There is a 65% probability that the ignition coil or spark plug on Cylinder 1 is malfunctioning."
2. **Mandatory Uncertainty Warning:** When sensor data is incomplete or conflicting, a prominent banner must inform the driver that physical inspection is required before purchasing replacement parts.
3. **Legal Disclaimer:**
   > *"This diagnostic report provides advisory guidance generated via automated telemetry analysis. It does not replace professional hands-on inspection by a qualified automotive technician."*
