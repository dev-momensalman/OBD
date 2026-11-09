import 'dart:async';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/telemetry_snapshot.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/dtc_fault.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/measured_evidence.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/connection_status.dart';
import 'package:obd_vision/features/diagnostics/domain/repositories/i_obd_repository.dart';
import '../datasources/mock_obd_datasource.dart';

class ObdRepositoryImpl implements IObdRepository {
  final MockObdDataSource _mockDataSource;

  ObdRepositoryImpl({
    required MockObdDataSource mockDataSource,
  }) : _mockDataSource = mockDataSource;

  @override
  Stream<TelemetrySnapshot> streamLiveTelemetry() {
    return _mockDataSource.telemetryStream.map((model) => model.toEntity());
  }

  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      _mockDataSource.connectionStatusStream;

  @override
  Future<Result<List<DtcFault>, Failure>> scanActiveFaultCodes() async {
    try {
      final models = await _mockDataSource.fetchSimulatedDtcs();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Err(ObdProtocolFailure('Failed to scan active fault codes: $e'));
    }
  }

  @override
  Future<Result<MeasuredEvidence, Failure>> getMeasuredEvidence(
      List<String> detectedDtcs) async {
    try {
      final model = await _mockDataSource.fetchMeasuredEvidence(detectedDtcs);
      return Success(model.toEntity());
    } catch (e) {
      return Err(ObdProtocolFailure('Failed to fetch measured evidence: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> toggleConnection({required bool usePhysicalBle}) async {
    return const Success(null);
  }
}
