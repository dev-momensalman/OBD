import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';

void main() {
  group('Result<S, F> Pattern Matching & Type Safety', () {
    test('Success returns data and isSuccess == true', () {
      const Result<String, Failure> result = Success('Data');
      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
      expect(result.dataOrNull, 'Data');
      expect(result.errorOrNull, isNull);

      final mapped = result.when(
        success: (d) => 'Handled $d',
        error: (e) => 'Failed',
      );
      expect(mapped, 'Handled Data');
    });

    test('Err returns error failure and isError == true', () {
      const Result<String, Failure> result = Err(BluetoothFailure('Device disconnected'));
      expect(result.isSuccess, isFalse);
      expect(result.isError, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull?.message, 'Device disconnected');

      final mapped = result.when(
        success: (d) => 'Handled $d',
        error: (e) => 'Failed with ${e.message}',
      );
      expect(mapped, 'Failed with Device disconnected');
    });
  });
}
