# 👥 USER_STORIES.md — User Stories & Acceptance Criteria

> **Standard:** Given / When / Then (Gherkin-style Acceptance Criteria)  
> **Source:** SRS Section 9.2 (US-001 through US-008 + Extended MVP Stories)

---

## Epic 1: Onboarding, Hardware Activation & Vehicle Profile

### US-001: Register & Profile Vehicle
- **As a** Vehicle Owner,  
- **I want to** add my car by selecting Make, Model, Year, Engine displacement, or scanning VIN,  
- **So that** telemetry thresholds, baseline specs, and diagnostic analysis are customized for my vehicle.
- **Acceptance Criteria:**
  - *Given* I am authenticated in the application,
  - *When* I navigate to "My Garage" and input my vehicle details (e.g., 2021 Toyota Corolla 1.8L),
  - *Then* the car profile is saved in Firestore and designated as the active vehicle.

### US-002: Pair OBD-II Bluetooth Dongle
- **As a** Vehicle Owner,  
- **I want to** scan and pair my ESP32/ELM327 Bluetooth adapter directly inside the app,  
- **So that** the app can establish an OBD-II link without manual OS Bluetooth configuration.
- **Acceptance Criteria:**
  - *Given* my Bluetooth adapter is plugged into the OBD-II port with ignition ON,
  - *When* I tap "Connect Scanner" in the app,
  - *Then* the app scans for BLE peripherals, displays discovered devices with RSSI signal strength, and bonds upon tap.
  - *Then* the app verifies ELM327 protocol handshake (`ATZ`, `ATE0`, `0100`) and shows "Connected & Ready".

---

## Epic 2: Live Monitoring & Cockpit Dashboard

### US-003: View Live Telemetry Gauges
- **As a** Vehicle Owner,  
- **I want to** view real-time gauges for RPM, Speed, Coolant Temperature, and Battery Voltage while driving,  
- **So that** I can monitor my engine's vital signs and catch overheating instantly.
- **Acceptance Criteria:**
  - *Given* the scanner is connected and ignition is ON,
  - *When* I open the "Live Dashboard",
  - *Then* the tachometer and speedometer update smoothly at ≥10 Hz.
  - *Then* if Coolant Temperature exceeds 105°C, the gauge turns amber, and if >115°C, it pulses red with an audible/visual warning.

---

## Epic 3: Fault Diagnosis & AI Reports

### US-004: Execute Diagnostic Scan (DTC & Freeze-Frame)
- **As a** Vehicle Owner,  
- **I want to** initiate a full vehicle diagnostic scan with one tap,  
- **So that** I can retrieve all active fault codes and freeze-frame sensor values.
- **Acceptance Criteria:**
  - *Given* the scanner is connected,
  - *When* I press "Start Vehicle Scan",
  - *Then* the app queries Mode 03, Mode 07, and Mode 02.
  - *Then* the app displays the number of faults detected and transitions to the AI analysis pipeline.

### US-005: Understand Plain-Language AI Report
- **As a** Vehicle Owner,  
- **I want to** read an AI-generated explanation of the problem, ranked root causes, and safety urgency,  
- **So that** I know whether my car is safe to drive and what repairs are needed.
- **Acceptance Criteria:**
  - *Given* a diagnostic scan returned DTC `P0301` (Cylinder 1 Misfire),
  - *When* the AI Diagnostic Engine finishes analysis,
  - *Then* the report displays:
    1. Severity Banner (Warning / Orange: Safe to drive cautiously to workshop).
    2. Plain-language explanation: "Cylinder 1 is failing to ignite fuel properly."
    3. Ranked causes: Ignition Coil (65%), Spark Plug (25%), Injector (10%).
    4. Recommended Next Step: Swap Ignition Coil 1 with Cylinder 2 to verify if misfire moves.
    5. Legal Disclaimer distinguishing sensor facts from AI hypotheses.

---

## Epic 4: Service Center Recommender & Booking

### US-006: Discover Compatible Service Centers & Estimate Cost
- **As a** Vehicle Owner with a diagnosed issue,  
- **I want to** view certified repair workshops near me with estimated cost ranges,  
- **So that** I can choose an affordable, trusted service center.
- **Acceptance Criteria:**
  - *Given* an active diagnostic report with estimated repair components,
  - *When* I tap "Find Service Centers",
  - *Then* a map and list of compatible workshops are displayed with distance and average ratings.
  - *Then* a calculated cost range (e.g., "$120 - $180: Parts + Labor") is presented.

### US-007: Book Appointment & Track Repair Lifecycle
- **As a** Vehicle Owner,  
- **I want to** book an appointment and attach my diagnostic report,  
- **So that** the mechanic already has all scan details before I arrive.
- **Acceptance Criteria:**
  - *Given* I select a workshop, date, and timeslot,
  - *When* I confirm the booking,
  - *Then* a digital Work Order is created in Firestore with status "Scheduled".
  - *Then* I can track repair progress in real time ("Diagnosing" ➔ "Awaiting Approval" ➔ "In Progress" ➔ "Completed").

---

## Epic 5: Technician Investigation (Workshop Portal)

### US-008: Review Pre-Scan Telemetry & Service Manual Citations
- **As a** Workshop Technician,  
- **I want to** inspect the vehicle's pre-scan freeze-frame data and retrieved OEM manual procedures,  
- **So that** I can expedite physical troubleshooting without repeating redundant diagnostic steps.
- **Acceptance Criteria:**
  - *Given* a customer brings a vehicle for a booked work order,
  - *When* the technician opens the Work Order details,
  - *Then* exact freeze-frame values (RPM, load, fuel pressure at moment of code) and relevant RAG manual excerpts are visible.
