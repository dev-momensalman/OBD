import 'package:equatable/equatable.dart';

class TelemetrySnapshot extends Equatable {
  final double engineRpm;
  final double vehicleSpeedKmH;
  final double coolantTempC;
  final double batteryVoltage;
  final double engineLoadPercent;
  final DateTime timestamp;

  const TelemetrySnapshot({
    required this.engineRpm,
    required this.vehicleSpeedKmH,
    required this.coolantTempC,
    required this.batteryVoltage,
    required this.engineLoadPercent,
    required this.timestamp,
  });

  bool get isOverheating => coolantTempC >= 105.0;
  bool get isCriticalOverheat => coolantTempC >= 115.0;
  bool get isLowBattery => batteryVoltage < 11.8;

  @override
  List<Object?> get props => [
        engineRpm,
        vehicleSpeedKmH,
        coolantTempC,
        batteryVoltage,
        engineLoadPercent,
        timestamp,
      ];
}
