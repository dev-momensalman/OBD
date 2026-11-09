import '../../domain/entities/telemetry_snapshot.dart';

class TelemetrySnapshotModel extends TelemetrySnapshot {
  const TelemetrySnapshotModel({
    required super.engineRpm,
    required super.vehicleSpeedKmH,
    required super.coolantTempC,
    required super.batteryVoltage,
    required super.engineLoadPercent,
    required super.timestamp,
  });

  factory TelemetrySnapshotModel.fromJson(Map<String, dynamic> json) {
    return TelemetrySnapshotModel(
      engineRpm: (json['engineRpm'] as num).toDouble(),
      vehicleSpeedKmH: (json['vehicleSpeedKmH'] as num).toDouble(),
      coolantTempC: (json['coolantTempC'] as num).toDouble(),
      batteryVoltage: (json['batteryVoltage'] as num).toDouble(),
      engineLoadPercent: (json['engineLoadPercent'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'engineRpm': engineRpm,
        'vehicleSpeedKmH': vehicleSpeedKmH,
        'coolantTempC': coolantTempC,
        'batteryVoltage': batteryVoltage,
        'engineLoadPercent': engineLoadPercent,
        'timestamp': timestamp.toIso8601String(),
      };

  TelemetrySnapshot toEntity() => TelemetrySnapshot(
        engineRpm: engineRpm,
        vehicleSpeedKmH: vehicleSpeedKmH,
        coolantTempC: coolantTempC,
        batteryVoltage: batteryVoltage,
        engineLoadPercent: engineLoadPercent,
        timestamp: timestamp,
      );
}
