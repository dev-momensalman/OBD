import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/diagnostic_report.dart';
import '../repositories/i_obd_repository.dart';

class RunDiagnosticScanUseCase {
  final IObdRepository _repository;

  const RunDiagnosticScanUseCase(this._repository);

  Future<Result<DiagnosticReport, Failure>> call() {
    return _repository.runComprehensiveAiDiagnosis();
  }
}
