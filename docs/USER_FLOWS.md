# 🔄 USER_FLOWS.md — System User Flows & Interaction Journeys

> **Scope:** Complete end-to-end user navigation & state transitions  
> **Source:** SRS §2.1.1, Use Cases UC-01 through UC-06, and Sequence Diagrams SD-01 through SD-13

---

## 1. Flow 1: Device Onboarding & Bluetooth Pairing (SD-01)

```mermaid
flowchart TD
    Start([User opens app]) --> CheckAuth{User Logged In?}
    CheckAuth -- No --> AuthScreen[Login / Sign Up Screen]
    AuthScreen --> CheckAuth
    CheckAuth -- Yes --> CheckVehicle{Vehicle Registered?}
    CheckVehicle -- No --> CreateVehicle[Register Vehicle: Make, Model, Year, VIN]
    CreateVehicle --> CheckVehicle
    CheckVehicle -- Yes --> Dashboard[Home Dashboard]

    Dashboard --> TapConnect[User taps 'Connect Scanner']
    TapConnect --> CheckBT{Bluetooth Enabled?}
    CheckBT -- No --> PromptBT[Prompt User to Enable Bluetooth]
    PromptBT --> CheckBT
    CheckBT -- Yes --> ScanBLE[Scan for BLE Peripherals]
    ScanBLE --> ListDevices[Display Discovered Devices: ESP32_OBD / ELM327]
    ListDevices --> SelectDev[User selects adapter]
    SelectDev --> Handshake[Execute AT Command Handshake: ATZ, ATE0, 0100]
    Handshake --> HandshakeOK{Handshake Successful?}
    HandshakeOK -- No --> RetryPair[Show Error: Connection Failed. Retry / Switch to Simulator]
    RetryPair --> TapConnect
    HandshakeOK -- Yes --> SaveDevice[Store Device UUID & Mark Connected]
    SaveDevice --> LiveReady([Ready for Telemetry & Diagnostics])
```

---

## 2. Flow 2: Live Diagnostic Scan & AI Report Generation (SD-02, SD-03, SD-04)

```mermaid
flowchart TD
    Ready([Connected to OBD-II]) --> StartScan[User taps 'Run Full Diagnostics']
    StartScan --> QueryECU[Query Mode 03 Stored DTCs & Mode 07 Pending DTCs]
    QueryECU --> CheckCodes{DTCs Found?}
    
    CheckCodes -- No --> QueryLiveSensors[Query Live Sensor PIDs Mode 01]
    QueryLiveSensors --> CheckAnomalies{Telemetry Anomalies Detected?}
    CheckAnomalies -- No --> CleanReport[Generate 'Clean Bill of Health' Report: Score 100/100]
    CheckAnomalies -- Yes --> EarlyWarning[Generate 'Early Warning Alert' for Anomalous PIDs]

    CheckCodes -- Yes --> QueryFreezeFrame[Query Mode 02 Freeze-Frame Data for DTCs]
    QueryFreezeFrame --> QueryLive[Capture Current Live Telemetry Snapshot]
    QueryLive --> BundleData[Bundle Data: DTCs + Freeze-Frame + Telemetry + Vehicle Profile]

    BundleData --> RuleEngine[Execute Tier 1: Deterministic Safety Rules]
    RuleEngine --> MLInference[Execute Tier 2: ML Anomaly & Classification Model]
    MLInference --> RAGSearch[Execute Tier 3: Vector Search Automotive Knowledge Base]
    RAGSearch --> LLMSummarize[Execute Tier 4: LLM Structured Explanation Synthesis]

    LLMSummarize --> BuildReport[Assemble Final Diagnostic Report]
    BuildReport --> SaveHistory[Save Report to Firestore Vehicle History]
    SaveHistory --> ShowReportUI[Display Report UI: Severity, Ranked Causes, Next Action, Cost Estimate]
```

---

## 3. Flow 3: Service Center Discovery & Booking Lifecycle (SD-05, SD-06, SD-07, SD-08)

```mermaid
flowchart TD
    ReportView([User Views Diagnostic Report]) --> TapFindHelp[User taps 'Find Certified Workshops']
    TapFindHelp --> GetLocation[Retrieve Current GPS Location]
    GetLocation --> QueryCenters[Query Firestore Service Centers matching Make & Region]
    QueryCenters --> DisplayMap[Show Interactive Map & Workshop Cards with Price Ranges]
    
    DisplayMap --> SelectCenter[User selects Workshop]
    SelectCenter --> ChooseSlot[Select Preferred Date & Timeslot]
    ChooseSlot --> ReviewQuote[Review Cost Estimate: Parts + Labor Breakdown]
    ReviewQuote --> ConfirmBooking[User taps 'Confirm Appointment']

    ConfirmBooking --> CreateWorkOrder[Create WorkOrder in Firestore: Status = 'SCHEDULED']
    CreateWorkOrder --> NotifyCenter[Push Notification sent to Service Center Portal]
    NotifyCenter --> CustomerTrack[Customer opens 'Repair Tracker' Screen]

    subgraph WorkshopLifecycle["Workshop Repair Lifecycle"]
        CustomerTrack --> StatusScheduled[Status: SCHEDULED]
        StatusScheduled --> CarDropped[Customer Drops Car at Center]
        CarDropped --> StatusDiagnosing[Status: IN_DIAGNOSIS (Technician Verifies)]
        StatusDiagnosing --> StatusRepairing[Status: IN_REPAIR]
        StatusRepairing --> StatusQC[Status: QUALITY_CHECK & CLEAR_DTC]
        StatusQC --> StatusReady[Status: READY_FOR_PICKUP]
    end

    StatusReady --> PushReady[Send Push Notification to Owner: 'Your car is ready!']
    PushReady --> PickupCar[Owner Picks Up Vehicle & Approves Invoice]
    PickupCar --> UpdateCarHistory[Update Vehicle Historical Maintenance Ledger: Status = 'COMPLETED']
```
