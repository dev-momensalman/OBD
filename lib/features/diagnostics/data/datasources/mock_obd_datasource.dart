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
  late final StreamController<TelemetrySnapshotModel> _telemetryController =
      StreamController<TelemetrySnapshotModel>.broadcast(
    onListen: _startSimulationIfNotRunning,
    onCancel: () {
      if (!_telemetryController.hasListener) {
        stopSimulation();
      }
    },
  );
  final _connectionController = StreamController<ConnectionStatus>.broadcast();
  
  ConnectionStatus _status = ConnectionStatus.connected;
  double _rpm = 780.0;
  double _speed = 0.0;
  double _coolant = 96.0;
  double _voltage = 13.8;
  double _load = 20.0;
  int _ticks = 0;
  bool _shouldFailNextScan = false;
  bool _enableFluctuation;

  MockObdDataSource({bool enableFluctuation = false})
      : _enableFluctuation = enableFluctuation;

  Stream<TelemetrySnapshotModel> get telemetryStream => _telemetryController.stream;

  Stream<ConnectionStatus> get connectionStatusStream async* {
    yield _status;
    yield* _connectionController.stream;
  }

  void setShouldFailNextScan(bool fail) {
    _shouldFailNextScan = fail;
  }

  void setFluctuationEnabled(bool enabled) {
    _enableFluctuation = enabled;
  }

  void _startSimulationIfNotRunning() {
    if (_timer != null && _timer!.isActive) return;

    _status = ConnectionStatus.connected;
    _connectionController.add(_status);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _ticks++;
      if (!_enableFluctuation || _ticks <= 1) {
        _rpm = 780.0;
        _coolant = 96.0;
        _voltage = 13.8;
        _speed = 0.0;
        _load = 20.0;
      } else {
        // Smooth temporary driving demo wave (~4s ramp up, ~4s coast down) for UI preview.
        final wave = 0.5 - 0.5 * cos((_ticks - 1) * 0.08);
        final pulse = 0.5 - 0.5 * cos((_ticks - 1) * 0.03);
        final blended = (wave * 0.85) + (pulse * 0.15);

        _rpm = 820.0 + (blended * 4650.0) + (_random.nextDouble() * 80 - 40);
        _speed = (blended * 145.0) + (_random.nextDouble() * 3 - 1.5);
        _load = 18.0 + (blended * 64.0) + (_random.nextDouble() * 4 - 2);
        _voltage = 13.7 + (_random.nextDouble() * 0.6 - 0.2);
        _coolant = 90.0 + (blended * 11.0) + (_random.nextDouble() * 0.4 - 0.2);
      }

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

  void stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stopSimulation();
    _telemetryController.close();
    _connectionController.close();
  }
}
