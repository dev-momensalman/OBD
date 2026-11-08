import 'dart:async';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/telemetry_snapshot.dart';
import '../../domain/entities/dtc_fault.dart';
import '../../domain/entities/diagnostic_report.dart';
import '../../domain/entities/measured_evidence.dart';
import '../../domain/entities/connection_status.dart';
import '../../domain/repositories/i_obd_repository.dart';
import '../../domain/services/rule_engine.dart';
import '../datasources/mock_obd_datasource.dart';

class ObdRepositoryImpl implements IObdRepository {
  final MockObdDataSource _mockDataSource;
  final RuleEngine _ruleEngine;

  ObdRepositoryImpl({
    required MockObdDataSource mockDataSource,
    RuleEngine ruleEngine = const RuleEngine(),
  })  : _mockDataSource = mockDataSource,
        _ruleEngine = ruleEngine;

  @override
  Stream<TelemetrySnapshot> streamLiveTelemetry() {
    return _mockDataSource.telemetryStream;
  }

  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      _mockDataSource.connectionStatusStream;

  @override
  Future<Result<List<DtcFault>, Failure>> scanActiveFaultCodes() async {
    try {
      final dtcs = await _mockDataSource.fetchSimulatedDtcs();
      return Success(dtcs);
    } catch (e) {
      return Err(ObdProtocolFailure(e.toString()));
    }
  }

  @override
  Future<Result<DiagnosticReport, Failure>> runComprehensiveAiDiagnosis() async {
    try {
      final dtcs = await _mockDataSource.fetchSimulatedDtcs();

      // Synthesize physical measured evidence snapshot
      final measuredEvidence = MeasuredEvidence(
        detectedDtcs: dtcs.map((d) => d.code).toList(),
        coolantTempC: 94.0,
        batteryVoltage: 14.1,
        engineRpm: 2150.0,
        vehicleSpeedKmH: 68.0,
        engineLoadPercent: 58.5,
        shortTermFuelTrimPercent: 7.8,
        longTermFuelTrimPercent: 14.2,
        measuredAt: DateTime.now(),
      );

      // Tier 1: Evaluate Deterministic Safety Rule Engine
      final ruleViolations = _ruleEngine.evaluate(measuredEvidence);

      // Calculate severity taking rule violations into account
      final hasCriticalRule =
          ruleViolations.any((v) => v.severity == DtcSeverity.critical);
      final hasWarningRule =
          ruleViolations.any((v) => v.severity == DtcSeverity.warning);

      final overallSeverity = hasCriticalRule
          ? DtcSeverity.critical
          : (hasWarningRule || dtcs.isNotEmpty)
              ? DtcSeverity.warning
              : DtcSeverity.healthy;

      final report = DiagnosticReport(
        id: 'rpt_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        dtcs: dtcs,
        measuredEvidence: measuredEvidence,
        overallSeverity: overallSeverity,
        vehicleHealthScore: hasCriticalRule ? 45 : (dtcs.isNotEmpty ? 76 : 98),
        plainLanguageExplanation:
            'Combustion irregularity detected in Cylinder 1 accompanied by positive fuel trims. '
            'Vehicle remains drivable at moderate speeds, but rapid inspection is advised.',
        rankedCauses: const [
          {'cause': 'Ignition Coil Failure (Cylinder 1)', 'probabilityPercent': 65},
          {'cause': 'Fouled or Worn Spark Plug', 'probabilityPercent': 25},
          {'cause': 'Clogged Fuel Injector Nozzle', 'probabilityPercent': 10},
        ],
        recommendedNextAction:
            'Swap Cylinder 1 ignition coil with Cylinder 2 and verify if DTC moves to P0302.',
        confidenceScore: 0.89,
        minCostUsd: 85.0,
        maxCostUsd: 165.0,
      );

      return Success(report);
    } catch (e) {
      return Err(ObdProtocolFailure('Failed to complete diagnostic scan: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> toggleConnection({required bool usePhysicalBle}) async {
    return const Success(null);
  }
}
