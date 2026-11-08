# 🔗 TRACEABILITY_MATRIX.md — Requirements Traceability Matrix (RTM)

> **Traceability Chain:** PRD Feature ➔ SRS Requirement ➔ Architecture Component ➔ Verification Test

---

| PRD Feature | SRS Req ID | Requirement Description | Architecture Component | Test Case | Status |
|:---:|:---:|---|---|---|:---:|
| **F-001** | `FR-DAQ-001` | Collect Mode 01 Live Telemetry | `BleObdDataSource` / `ObdRepositoryImpl` | `test_telemetry_stream.dart` | ✅ Mapped |
| **F-001** | `FR-DAQ-002` | Retrieve Mode 03 Stored DTCs | `DtcParser` / `ObdRepositoryImpl` | `test_dtc_parser.dart` | ✅ Mapped |
| **F-001** | `FR-DAQ-004` | Retrieve Mode 02 Freeze-Frames | `FreezeFrameParser` | `test_freeze_frame.dart` | ✅ Mapped |
| **F-002** | `FR-DAQ-007` | Sensor Data Validation & Filtering | `PidDecoder` / `DataValidator` | `test_pid_decoder.dart` | ✅ Mapped |
| **F-003** | `FR-DIA-001` | DTC Interpretation & System Mapping | `DtcInterpretationService` | `test_dtc_lookup.dart` | ✅ Mapped |
| **F-004** | `FR-DIA-003` | Evaluate Deterministic Rule Engine | `RuleEngine` | `test_rule_engine.dart` | ✅ Mapped |
| **F-004** | `FR-DIA-006` | ML Pattern Anomaly Detection | `AiDiagnosticClient` | `test_ml_service.dart` | ✅ Mapped |
| **F-004** | `FR-AI-001` | RAG Knowledge Retrieval | `RagKnowledgeService` | `test_rag_search.dart` | ✅ Mapped |
| **F-004** | `FR-AI-004` | LLM Plain-Language Explanation | `GeminiDiagnosticGenerator` | `test_llm_output.dart` | ✅ Mapped |
| **F-005** | `FR-DIA-008` | Cause Ranking & Probabilities | `DiagnosticReportModel` | `test_cause_ranking.dart` | ✅ Mapped |
| **F-006** | `FR-MON-001` | Real-Time Telemetry Dashboard | `DashboardCubit` / `CockpitGauge` | `test_dashboard_bloc.dart` | ✅ Mapped |
| **F-007** | `FR-HIS-001` | Vehicle Diagnostic History Storage | `FirestoreVehicleDataSource` | `test_history_store.dart` | ✅ Mapped |
| **F-008** | `FR-MON-005` | Early Anomaly Warning Generation | `AnomalyDetectorService` | `test_early_warning.dart` | ✅ Mapped |
| **F-009** | `FR-APP-004` | Service Center Recommender | `WorkshopRepositoryImpl` | `test_workshop_lookup.dart`| ✅ Mapped |
| **F-009** | `FR-APP-005` | Estimated Repair Cost Range | `CostEstimatorService` | `test_cost_estimator.dart`| ✅ Mapped |
| **F-010** | `FR-APP-006` | Work Order Booking & Status Tracking | `BookingCubit` / `WorkOrderTracker` | `test_booking_flow.dart` | ✅ Mapped |
