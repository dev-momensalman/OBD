import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obd_vision/core/constants/app_colors.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/connection_status_bar.dart';
import '../widgets/diagnostic_report_view.dart';
import '../widgets/diagnostic_scan_card.dart';
import '../widgets/telemetry_gauges.dart';

class HomeCockpitPage extends StatelessWidget {
  const HomeCockpitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.cockpitTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          BlocBuilder<DashboardCubit, DashboardState>(
            buildWhen: (prev, curr) =>
                prev.connectionStatus != curr.connectionStatus,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 16.0),
                child: Icon(
                  state.isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: state.isConnected
                      ? AppColors.accentCyan
                      : AppColors.criticalRed,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Connection Status: Rebuilds ONLY when connection status changes
            BlocBuilder<DashboardCubit, DashboardState>(
              buildWhen: (prev, curr) =>
                  prev.connectionStatus != curr.connectionStatus ||
                  prev.isSimulatedMode != curr.isSimulatedMode,
              builder: (context, state) {
                return ConnectionStatusBar(
                  isConnected: state.isConnected,
                  isSimulatedMode: state.isSimulatedMode,
                  connectionStatus: state.connectionStatus,
                );
              },
            ),
            const SizedBox(height: 16),

            // 2. High-Frequency Telemetry Gauges (10Hz): Isolated rebuilds strictly confined here
            BlocBuilder<DashboardCubit, DashboardState>(
              buildWhen: (prev, curr) => prev.telemetry != curr.telemetry,
              builder: (context, state) {
                final t = state.telemetry;
                return TelemetryGauges(
                  rpm: t?.engineRpm ?? 0.0,
                  speed: t?.vehicleSpeedKmH ?? 0.0,
                  coolantTemp: t?.coolantTempC ?? 90.0,
                  batteryVoltage: t?.batteryVoltage ?? 14.1,
                );
              },
            ),
            const SizedBox(height: 24),

            // 3. Error Banner: Rebuilds ONLY when errorMessage changes
            BlocBuilder<DashboardCubit, DashboardState>(
              buildWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
              builder: (context, state) {
                if (state.errorMessage == null) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.criticalRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.criticalRed),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.criticalRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.criticalRed,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 4. Diagnostic Scan Action Card: Rebuilds ONLY when scan status changes
            BlocBuilder<DashboardCubit, DashboardState>(
              buildWhen: (prev, curr) => prev.scanStatus != curr.scanStatus,
              builder: (context, state) {
                return DiagnosticScanCard(
                  isScanning: state.scanStatus == ScanStatus.scanning,
                  onRunScan: () =>
                      context.read<DashboardCubit>().runFullDiagnosticScan(),
                );
              },
            ),
            const SizedBox(height: 16),

            // 5. Diagnostic Report View: Rebuilds ONLY when latestReport changes
            BlocBuilder<DashboardCubit, DashboardState>(
              buildWhen: (prev, curr) =>
                  prev.latestReport != curr.latestReport,
              builder: (context, state) {
                if (state.latestReport == null) {
                  return const SizedBox.shrink();
                }
                return DiagnosticReportView(report: state.latestReport!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
