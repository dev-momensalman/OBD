import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obd_vision/core/utils/result.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/stream_live_telemetry_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/run_diagnostic_scan_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/get_connection_status_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final StreamLiveTelemetryUseCase _streamLiveTelemetryUseCase;
  final RunDiagnosticScanUseCase _runDiagnosticScanUseCase;
  final GetConnectionStatusUseCase _getConnectionStatusUseCase;
  
  StreamSubscription? _telemetrySub;
  StreamSubscription? _connectionSub;

  DashboardCubit({
    required StreamLiveTelemetryUseCase streamLiveTelemetryUseCase,
    required RunDiagnosticScanUseCase runDiagnosticScanUseCase,
    required GetConnectionStatusUseCase getConnectionStatusUseCase,
  })  : _streamLiveTelemetryUseCase = streamLiveTelemetryUseCase,
        _runDiagnosticScanUseCase = runDiagnosticScanUseCase,
        _getConnectionStatusUseCase = getConnectionStatusUseCase,
        super(const DashboardState()) {
    _initStreams();
  }

  void _initStreams() {
    _connectionSub = _getConnectionStatusUseCase().listen((status) {
      emit(state.copyWith(connectionStatus: status));
    });

    _telemetrySub = _streamLiveTelemetryUseCase().listen((snapshot) {
      emit(state.copyWith(telemetry: snapshot));
    });
  }

  Future<void> runFullDiagnosticScan() async {
    emit(state.copyWith(scanStatus: ScanStatus.scanning, errorMessage: null));
    
    final result = await _runDiagnosticScanUseCase();

    switch (result) {
      case Success(data: final report):
        emit(state.copyWith(
          scanStatus: ScanStatus.completed,
          latestReport: report,
        ));
      case Err(error: final failure):
        emit(state.copyWith(
          scanStatus: ScanStatus.error,
          errorMessage: failure.message,
        ));
    }
  }

  @override
  Future<void> close() {
    _telemetrySub?.cancel();
    _connectionSub?.cancel();
    return super.close();
  }
}
