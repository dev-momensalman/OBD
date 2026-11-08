# 📄 PROJECT_BRIEF.md — Executive Project Brief

> **Project Name:** AI-Powered Vehicle Health & Predictive Diagnosis Platform  
> **Prepared For:** Computer Engineering Capstone / Graduation Project  
> **Supervised by:** Dr. Mahmoud Elrakaiby & Eng. Youssef Elsheheimy  
> **Lead Researcher & Engineer:** Alaa-Allah Ahmed Sallam  
> **Target Framework:** Flutter • Firebase • Clean Architecture  
> **Version:** 1.0.0 (Production Blueprint)

---

## 1. Executive Summary
Modern vehicles produce a massive continuous stream of real-time telemetry and diagnostic fault data through the standard on-board diagnostics (OBD-II) port. However, everyday vehicle owners face significant pain points:
1. **Cryptic Diagnostic Trouble Codes (DTCs):** Codes like `P0301` or `P0171` provide zero plain-language context regarding cause, severity, or driving safety.
2. **Lack of Contextual Fusion:** Raw DTCs do not account for accompanying sensor readings (freeze-frame snapshots, engine RPM, coolant temperature, fuel trim).
3. **Information Asymmetry & Mistrust:** Vehicle owners fear exploitation and unpredictable repair pricing at traditional workshops.
4. **Reactive Instead of Proactive:** Issues are only addressed after the Check Engine Light (MIL) triggers, when component damage is often already done.

This project delivers an **end-to-end intelligent automotive platform** connecting an affordable Bluetooth OBD-II hardware adapter (ESP32 / ELM327) with a cross-platform Flutter application and a cloud-based **Hybrid AI Diagnostic Engine**. The system ingests telemetry, runs edge safety rules, detects early anomalies via machine learning, grounds findings in automotive technical documentation using Retrieval-Augmented Generation (RAG), and produces clear, actionable natural-language reports alongside vetted workshop booking and repair tracking.

---

## 2. Strategic Objectives & Success Metrics

| Strategic Objective | Metric | Target SLA |
|---|---|---|
| **Diagnostic Comprehensibility** | User comprehension score of diagnostic report | > 90% non-technical user satisfaction |
| **Real-Time Responsiveness** | Telemetry acquisition & gauge refresh rate | ≥ 10 Hz refresh rate for critical PIDs |
| **AI Reliability & Hallucination Elimination** | Factuality of explanations grounded in verified service manuals | Zero unsupported mechanical assertions (Strict RAG) |
| **Early Anomaly Detection** | Detection of thermal/fuel abnormalities before DTC triggers | Detection at least 3-7 days prior to critical MIL |
| **E2E Repair Lifecycle Closure** | Seamless flow from scan ➔ AI report ➔ quote ➔ workshop booking ➔ archive | 100% verified state transitions in work order flow |

---

## 3. Scope Boundaries

### In Scope (MVP)
- **Data Acquisition:** SAE J1979 OBD-II standard PIDs (Speed, RPM, Coolant Temp, MAF, O2 Sensor, Fuel Trim, Battery Voltage), Mode 03 DTCs, Mode 02 Freeze-Frames.
- **Hardware Integration:** BLE communication with ESP32 / ELM327 adapters, plus built-in software telemetry simulator.
- **AI Diagnostic Engine:** 4-tier pipeline combining Deterministic Rules, ML Anomaly Scoring, RAG Manual Search, and LLM Explanations.
- **Mobile Experience (Flutter):** Dashboard Cockpit, Vehicle Health Score, Interactive DTC Inspection, Service Center Discovery with Cost Range, and Live Work Order Tracker.
- **Cloud Backend (Firebase):** User auth, vehicle garage, diagnostic history, service center catalog, and real-time appointment booking.

### Explicitly Out of Scope (Safety & Legal Boundaries)
- No proprietary OEM protocols (e.g., proprietary Mercedes DAS, BMW ISTA adaptations).
- No bidirectional ECU flashing, actuation tests, or software modification of engine ECUs.
- No autonomous vehicle control, remote steering, or braking interventions.
- No guaranteed legal liability for hardware mechanical failures.
