import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/telemetry_snapshot.dart';
import '../entities/dtc_fault.dart';
import '../entities/measured_evidence.dart';
import '../entities/connection_status.dart';

abstract class IObdRepository {
  Stream<TelemetrySnapshot> streamLiveTelemetry();
  Stream<ConnectionStatus> get connectionStatusStream;
  Future<Result<List<DtcFault>, Failure>> scanActiveFaultCodes();
  Future<Result<MeasuredEvidence, Failure>> getMeasuredEvidence(List<String> detectedDtcs);
  Future<Result<void, Failure>> toggleConnection({required bool usePhysicalBle});
}
