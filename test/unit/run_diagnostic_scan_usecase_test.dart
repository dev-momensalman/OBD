import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/diagnostics/data/datasources/mock_obd_datasource.dart';
import 'package:obd_vision/features/diagnostics/data/repositories/obd_repository_impl.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/dtc_fault.dart';
import 'package:obd_vision/features/diagnostics/domain/services/rule_engine.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/run_diagnostic_scan_usecase.dart';

void main() {
  group('RunDiagnosticScanUseCase Business Orchestration', () {
    late MockObdDataSource mockDataSource;
    late ObdRepositoryImpl repository;
    late RunDiagnosticScanUseCase useCase;

    setUp(() {
      mockDataSource = MockObdDataSource();
      repository = ObdRepositoryImpl(mockDataSource: mockDataSource);
      useCase = RunDiagnosticScanUseCase(
        repository: repository,
        ruleEngine: const RuleEngine(),
      );
    });

    tearDown(() {
      mockDataSource.dispose();
    });

    test('orchestrates DTCs, RuleEngine and produces full DiagnosticReport', () async {
      final result = await useCase();

      expect(result.isSuccess, isTrue);
      final report = result.dataOrNull;
      expect(report, isNotNull);
      expect(report!.dtcs.length, 2);
      expect(report.overallSeverity, DtcSeverity.warning);
      expect(report.vehicleHealthScore, 76);
      expect(report.rankedCauses.length, 3);
      expect(report.rankedCauses.first.cause, contains('Ignition Coil'));
      expect(report.safetyDisclaimer.isNotEmpty, isTrue);
    });

    test('returns Err when repository fails to retrieve DTC codes', () async {
      mockDataSource.setShouldFailNextScan(true);

      final result = await useCase();
      expect(result.isError, isTrue);
      expect(result.errorOrNull?.message, contains('BUS BUSY'));
    });
  });
}
