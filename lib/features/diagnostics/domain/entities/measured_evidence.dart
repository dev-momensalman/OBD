import 'package:equatable/equatable.dart';

class MeasuredEvidence extends Equatable {
  final List<String> detectedDtcs;
  final double? coolantTempC;
  final double? batteryVoltage;
  final double? engineRpm;
  final double? vehicleSpeedKmH;
  final double? engineLoadPercent;
  final double? shortTermFuelTrimPercent;
  final double? longTermFuelTrimPercent;
  final DateTime measuredAt;

  const MeasuredEvidence({
    required this.detectedDtcs,
    this.coolantTempC,
    this.batteryVoltage,
    this.engineRpm,
    this.vehicleSpeedKmH,
    this.engineLoadPercent,
    this.shortTermFuelTrimPercent,
    this.longTermFuelTrimPercent,
    required this.measuredAt,
  });

  @override
  List<Object?> get props => [
        detectedDtcs,
        coolantTempC,
        batteryVoltage,
        engineRpm,
        vehicleSpeedKmH,
        engineLoadPercent,
        shortTermFuelTrimPercent,
        longTermFuelTrimPercent,
        measuredAt,
      ];
}
