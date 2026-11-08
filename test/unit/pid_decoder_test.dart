import 'package:flutter_test/flutter_test.dart';
import 'package:your_flutter_app/core/utils/pid_decoder.dart';

void main() {
  group('PidDecoder Mathematical Formulas', () {
    test('Calculates RPM accurately from 2 bytes', () {
      // 0x1F 0x40 -> (31 * 256 + 64) / 4 = 8000 / 4 = 2000.0 RPM
      expect(PidDecoder.decodeRpm(0x1F, 0x40), 2000.0);
    });

    test('Calculates Speed in km/h from 1 byte', () {
      expect(PidDecoder.decodeSpeed(120), 120.0);
    });

    test('Calculates Coolant Temperature (A - 40)', () {
      // 0x82 (130) -> 130 - 40 = 90.0 °C
      expect(PidDecoder.decodeCoolantTemp(130), 90.0);
    });

    test('Calculates Battery Voltage accurately', () {
      // 14100 / 1000 = 14.1 V
      expect(PidDecoder.decodeVoltage(0x37, 0x14), 14.1);
    });

    test('Decodes 2-byte raw hex to standard SAE DTC code P0301', () {
      // 0x03 0x01 -> Category 0 (P), Type 0 (0), Sub 3, Code 01 -> P0301
      expect(PidDecoder.decodeDtc(0x03, 0x01), 'P0301');
    });

    test('Decodes 2-byte raw hex to standard SAE DTC code P0171', () {
      expect(PidDecoder.decodeDtc(0x01, 0x71), 'P0171');
    });
  });
}
