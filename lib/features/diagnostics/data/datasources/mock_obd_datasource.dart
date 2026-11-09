import 'dart:async';
import 'dart:math';
import '../models/telemetry_snapshot_model.dart';
import '../models/dtc_fault_model.dart';
import '../models/measured_evidence_model.dart';
import '../../domain/entities/connection_status.dart';
import '../../domain/entities/dtc_fault.dart';

class MockObdDataSource {
  final _random = Random();
  Timer? _timer;
  final _telemetryController = StreamController<TelemetrySnapshotModel>.broadcast();
  final _connectionController = StreamController<ConnectionStatus>.broadcast();
  
  ConnectionStatus _status = ConnectionStatus.connected;
  double _rpm = 850.0;
  double _speed = 0.0;
  double _coolant = 88.0;
  double _voltage = 14.1;
  double _load = 20.0;
  int _ticks = 0;
  bool _shouldFailNextScan = false;

  Stream<TelemetrySnapshotModel> get telemetryStream {
    _startSimulationIfNotRunning();
    return _telemetryController.stream;
  }

  Stream<ConnectionStatus> get connectionStatusStream async* {
    yield _status;
    yield* _connectionController.stream;
  }

  void setShouldFailNextScan(bool fail) {
    _shouldFailNextScan = fail;
  }

  void _startSimulationIfNotRunning() {
    if (_timer != null && _timer!.isActive) return;

    _status = ConnectionStatus.connected;
    _connectionController.add(_status);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _ticks++;
      final throttleCycle = sin(_ticks * 0.05);
      _rpm = 850.0 + (throttleCycle.abs() * 2800.0) + (_random.nextDouble() * 50 - 25);
      _speed = (throttleCycle.abs() * 95.0) + (_random.nextDouble() * 4 - 2);
      _load = 18.0 + (throttleCycle.abs() * 55.0);
      _voltage = 14.0 + (_random.nextDouble() * 0.3 - 0.15);
      _coolant = 90.0 + sin(_ticks * 0.01) * 4.0;

      _telemetryController.add(TelemetrySnapshotModel(
        engineRpm: _rpm.clamp(750.0, 6500.0),
        vehicleSpeedKmH: _speed.clamp(0.0, 180.0),
        coolantTempC: _coolant,
        batteryVoltage: _voltage,
        engineLoadPercent: _load.clamp(10.0, 100.0),
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<List<DtcFaultModel>> fetchSimulatedDtcs() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_shouldFailNextScan) {
      _shouldFailNextScan = false;
      throw Exception('ELM327 BUS BUSY: Frame reception timed out');
    }

    return const [
      DtcFaultModel(
        code: 'P0301',
        system: 'Powertrain',
        description: 'Cylinder 1 Misfire Detected',
        severity: DtcSeverity.warning,
      ),
      DtcFaultModel(
        code: 'P0171',
        system: 'Fuel & Air Metering',
        description: 'System Too Lean (Bank 1)',
        severity: DtcSeverity.info,
      ),
    ];
  }

  Future<MeasuredEvidenceModel> fetchMeasuredEvidence(List<String> detectedDtcs) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MeasuredEvidenceModel(
      detectedDtcs: detectedDtcs,
      coolantTempC: 94.0,
      batteryVoltage: 14.1,
      engineRpm: 2150.0,
      vehicleSpeedKmH: 68.0,
      engineLoadPercent: 58.5,
      shortTermFuelTrimPercent: 7.8,
      longTermFuelTrimPercent: 14.2,
      measuredAt: DateTime.now(),
    );
  }

  void dispose() {
    _timer?.cancel();
    _telemetryController.close();
    _connectionController.close();
  }
}
