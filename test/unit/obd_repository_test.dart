import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/diagnostics/data/datasources/mock_obd_datasource.dart';
import 'package:obd_vision/features/diagnostics/data/repositories/obd_repository_impl.dart';

void main() {
  group('ObdRepositoryImpl with Clean Architecture Responsibility', () {
    late MockObdDataSource mockDataSource;
    late ObdRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockObdDataSource();
      repository = ObdRepositoryImpl(
        mockDataSource: mockDataSource,
      );
    });

    tearDown(() {
      mockDataSource.dispose();
    });

    test('scanActiveFaultCodes returns Success with simulated DTC entities', () async {
      final result = await repository.scanActiveFaultCodes();
      expect(result.isSuccess, isTrue);
      final dtcs = result.dataOrNull;
      expect(dtcs, isNotNull);
      expect(dtcs!.length, 2);
      expect(dtcs.first.code, 'P0301');
    });

    test('scanActiveFaultCodes returns Err on hardware/timeout error', () async {
      mockDataSource.setShouldFailNextScan(true);

      final result = await repository.scanActiveFaultCodes();
      expect(result.isError, isTrue);
      expect(result.errorOrNull?.message, contains('BUS BUSY'));
    });

    test('getMeasuredEvidence returns sensor telemetry evidence snapshot', () async {
      final result = await repository.getMeasuredEvidence(['P0301']);
      expect(result.isSuccess, isTrue);
      final evidence = result.dataOrNull;
      expect(evidence, isNotNull);
      expect(evidence!.coolantTempC, 94.0);
      expect(evidence.batteryVoltage, 14.1);
    });
  });
}
