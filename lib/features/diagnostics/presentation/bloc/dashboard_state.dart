import 'package:equatable/equatable.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/telemetry_snapshot.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/diagnostic_report.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/connection_status.dart';

enum ScanStatus { idle, scanning, completed, error }

class DashboardState extends Equatable {
  final TelemetrySnapshot? telemetry;
  final ConnectionStatus connectionStatus;
  final bool isSimulatedMode;
  final ScanStatus scanStatus;
  final DiagnosticReport? latestReport;
  final String? errorMessage;

  const DashboardState({
    this.telemetry,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.isSimulatedMode = true,
    this.scanStatus = ScanStatus.idle,
    this.latestReport,
    this.errorMessage,
  });

  bool get isConnected => connectionStatus == ConnectionStatus.connected;

  DashboardState copyWith({
    TelemetrySnapshot? telemetry,
    ConnectionStatus? connectionStatus,
    bool? isSimulatedMode,
    ScanStatus? scanStatus,
    DiagnosticReport? latestReport,
    String? errorMessage,
  }) {
    return DashboardState(
      telemetry: telemetry ?? this.telemetry,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isSimulatedMode: isSimulatedMode ?? this.isSimulatedMode,
      scanStatus: scanStatus ?? this.scanStatus,
      latestReport: latestReport ?? this.latestReport,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        telemetry,
        connectionStatus,
        isSimulatedMode,
        scanStatus,
        latestReport,
        errorMessage,
      ];
}
