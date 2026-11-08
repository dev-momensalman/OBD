import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/diagnostics/data/datasources/mock_obd_datasource.dart';
import 'package:obd_vision/features/diagnostics/data/repositories/obd_repository_impl.dart';
import 'package:obd_vision/features/diagnostics/domain/services/rule_engine.dart';

void main() {
  group('ObdRepositoryImpl with EGM Hardened Error Handling', () {
    late MockObdDataSource mockDataSource;
    late ObdRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockObdDataSource();
      repository = ObdRepositoryImpl(
        mockDataSource: mockDataSource,
        ruleEngine: const RuleEngine(),
      );
    });

    tearDown(() {
      mockDataSource.dispose();
    });

    test('runComprehensiveAiDiagnosis returns Success with report', () async {
      final result = await repository.runComprehensiveAiDiagnosis();
      expect(result.isSuccess, isTrue);
      final report = result.dataOrNull;
      expect(report, isNotNull);
      expect(report!.dtcs.length, 2);
      expect(report.measuredEvidence.detectedDtcs, contains('P0301'));
      expect(report.safetyDisclaimer.isNotEmpty, isTrue);
    });

    test('runComprehensiveAiDiagnosis returns Err on hardware/timeout error', () async {
      mockDataSource.setShouldFailNextScan(true);

      final result = await repository.runComprehensiveAiDiagnosis();
      expect(result.isError, isTrue);
      expect(result.errorOrNull?.message, contains('BUS BUSY'));
    });
  });
}
