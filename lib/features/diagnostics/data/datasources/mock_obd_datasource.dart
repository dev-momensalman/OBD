import 'dart:async';
import 'dart:math';
import 'package:obd_vision/features/diagnostics/domain/entities/telemetry_snapshot.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/dtc_fault.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/connection_status.dart';

class MockObdDataSource {
  final _random = Random();
  Timer? _timer;
  final _telemetryController = StreamController<TelemetrySnapshot>.broadcast();
  final _connectionController = StreamController<ConnectionStatus>.broadcast();
  
  ConnectionStatus _status = ConnectionStatus.connected;
  double _rpm = 850.0;
  double _speed = 0.0;
  double _coolant = 88.0;
  double _voltage = 14.1;
  double _load = 20.0;
  int _ticks = 0;
  bool _shouldFailNextScan = false;

  Stream<TelemetrySnapshot> get telemetryStream {
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
      // Realistic sinusoidal driving pattern
      final throttleCycle = sin(_ticks * 0.05);
      _rpm = 850.0 + (throttleCycle.abs() * 2800.0) + (_random.nextDouble() * 50 - 25);
      _speed = (throttleCycle.abs() * 95.0) + (_random.nextDouble() * 4 - 2);
      _load = 18.0 + (throttleCycle.abs() * 55.0);
      _voltage = 14.0 + (_random.nextDouble() * 0.3 - 0.15);
      _coolant = 90.0 + sin(_ticks * 0.01) * 4.0;

      _telemetryController.add(TelemetrySnapshot(
        engineRpm: _rpm.clamp(750.0, 6500.0),
        vehicleSpeedKmH: _speed.clamp(0.0, 180.0),
        coolantTempC: _coolant,
        batteryVoltage: _voltage,
        engineLoadPercent: _load.clamp(10.0, 100.0),
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<List<DtcFault>> fetchSimulatedDtcs() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_shouldFailNextScan) {
      _shouldFailNextScan = false;
      throw Exception('ELM327 BUS BUSY: Frame reception timed out');
    }

    return const [
      DtcFault(
        code: 'P0301',
        system: 'Powertrain',
        description: 'Cylinder 1 Misfire Detected',
        severity: DtcSeverity.warning,
      ),
      DtcFault(
        code: 'P0171',
        system: 'Fuel & Air Metering',
        description: 'System Too Lean (Bank 1)',
        severity: DtcSeverity.info,
      ),
    ];
  }

  void dispose() {
    _timer?.cancel();
    _telemetryController.close();
    _connectionController.close();
  }
}
