import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../entities/telemetry_snapshot.dart';
import '../entities/dtc_fault.dart';
import '../entities/diagnostic_report.dart';
import '../entities/connection_status.dart';

abstract class IObdRepository {
  Stream<TelemetrySnapshot> streamLiveTelemetry();
  Stream<ConnectionStatus> get connectionStatusStream;
  Future<Result<List<DtcFault>, Failure>> scanActiveFaultCodes();
  Future<Result<DiagnosticReport, Failure>> runComprehensiveAiDiagnosis();
  Future<Result<void, Failure>> toggleConnection({required bool usePhysicalBle});
}
