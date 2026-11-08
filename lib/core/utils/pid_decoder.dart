/// High-precision mathematical parser for SAE J1979 OBD-II PIDs
class PidDecoder {
  PidDecoder._();

  /// Mode 01 PID 0C: Engine RPM
  /// Formula: ((A * 256) + B) / 4
  static double decodeRpm(int byteA, int byteB) {
    return ((byteA * 256) + byteB) / 4.0;
  }

  /// Mode 01 PID 0D: Vehicle Speed in km/h
  /// Formula: A
  static double decodeSpeed(int byteA) {
    return byteA.toDouble();
  }

  /// Mode 01 PID 05: Engine Coolant Temperature in °C
  /// Formula: A - 40
  static double decodeCoolantTemp(int byteA) {
    return (byteA - 40).toDouble();
  }

  /// Mode 01 PID 42: Control Module Voltage in Volts
  /// Formula: ((A * 256) + B) / 1000
  static double decodeVoltage(int byteA, int byteB) {
    return ((byteA * 256) + byteB) / 1000.0;
  }

  /// Mode 01 PID 04: Calculated Engine Load in %
  /// Formula: A * 100 / 255
  static double decodeEngineLoad(int byteA) {
    return (byteA * 100.0) / 255.0;
  }

  /// Decode 2-byte DTC hex into standard SAE alphanumeric string (e.g. P0301)
  static String decodeDtc(int byteA, int byteB) {
    final typeBits = (byteA >> 6) & 0x03;
    final prefix = switch (typeBits) {
      0 => 'P',
      1 => 'C',
      2 => 'B',
      3 => 'U',
      _ => 'P',
    };

    final secondDigit = (byteA >> 4) & 0x03;
    final thirdHex = (byteA & 0x0F).toRadixString(16).toUpperCase();
    final fourthHex = ((byteB >> 4) & 0x0F).toRadixString(16).toUpperCase();
    final fifthHex = (byteB & 0x0F).toRadixString(16).toUpperCase();

    return '$prefix$secondDigit$thirdHex$fourthHex$fifthHex';
  }
}
