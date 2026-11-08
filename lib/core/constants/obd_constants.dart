/// Standard OBD-II Parameter IDs (Mode 01) and AT commands
class ObdConstants {
  ObdConstants._();

  static const String cmdReset = 'ATZ\r';
  static const String cmdEchoOff = 'ATE0\r';
  static const String cmdLinefeedsOff = 'ATL0\r';
  static const String cmdAutoProtocol = 'ATSP0\r';
  
  static const String pidSupported01to20 = '0100\r';
  static const String pidCoolantTemp = '0105\r';
  static const String pidEngineRpm = '010C\r';
  static const String pidVehicleSpeed = '010D\r';
  static const String pidThrottlePos = '0111\r';
  static const String pidBatteryVoltage = '0142\r';

  static const String cmdReadDtc = '03\r';
  static const String cmdClearDtc = '04\r';
  static const String cmdReadPendingDtc = '07\r';
}
