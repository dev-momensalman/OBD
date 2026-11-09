import '../../domain/entities/measured_evidence.dart';

class MeasuredEvidenceModel extends MeasuredEvidence {
  const MeasuredEvidenceModel({
    required super.detectedDtcs,
    required super.coolantTempC,
    required super.batteryVoltage,
    required super.engineRpm,
    required super.vehicleSpeedKmH,
    required super.engineLoadPercent,
    required super.shortTermFuelTrimPercent,
    required super.longTermFuelTrimPercent,
    required super.measuredAt,
  });

  factory MeasuredEvidenceModel.fromJson(Map<String, dynamic> json) {
    return MeasuredEvidenceModel(
      detectedDtcs: List<String>.from(json['detectedDtcs'] as List),
      coolantTempC: (json['coolantTempC'] as num).toDouble(),
      batteryVoltage: (json['batteryVoltage'] as num).toDouble(),
      engineRpm: (json['engineRpm'] as num).toDouble(),
      vehicleSpeedKmH: (json['vehicleSpeedKmH'] as num).toDouble(),
      engineLoadPercent: (json['engineLoadPercent'] as num).toDouble(),
      shortTermFuelTrimPercent: (json['shortTermFuelTrimPercent'] as num).toDouble(),
      longTermFuelTrimPercent: (json['longTermFuelTrimPercent'] as num).toDouble(),
      measuredAt: DateTime.parse(json['measuredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'detectedDtcs': detectedDtcs,
        'coolantTempC': coolantTempC,
        'batteryVoltage': batteryVoltage,
        'engineRpm': engineRpm,
        'vehicleSpeedKmH': vehicleSpeedKmH,
        'engineLoadPercent': engineLoadPercent,
        'shortTermFuelTrimPercent': shortTermFuelTrimPercent,
        'longTermFuelTrimPercent': longTermFuelTrimPercent,
        'measuredAt': measuredAt.toIso8601String(),
      };

  MeasuredEvidence toEntity() => MeasuredEvidence(
        detectedDtcs: detectedDtcs,
        coolantTempC: coolantTempC,
        batteryVoltage: batteryVoltage,
        engineRpm: engineRpm,
        vehicleSpeedKmH: vehicleSpeedKmH,
        engineLoadPercent: engineLoadPercent,
        shortTermFuelTrimPercent: shortTermFuelTrimPercent,
        longTermFuelTrimPercent: longTermFuelTrimPercent,
        measuredAt: measuredAt,
      );
}
