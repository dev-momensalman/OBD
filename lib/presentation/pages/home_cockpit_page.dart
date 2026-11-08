import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/connection_status.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/glass_card.dart';
import '../widgets/radial_gauge_widget.dart';

class HomeCockpitPage extends StatelessWidget {
  const HomeCockpitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD-II COCKPIT'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          BlocBuilder<DashboardCubit, DashboardState>(
            buildWhen: (prev, curr) =>
                prev.connectionStatus != curr.connectionStatus,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
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
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          final t = state.telemetry;
          final rpm = t?.engineRpm ?? 0.0;
          final speed = t?.vehicleSpeedKmH ?? 0.0;
          final coolant = t?.coolantTempC ?? 90.0;
          final voltage = t?.batteryVoltage ?? 14.1;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hardware Connection Status Bar
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: state.isConnected
                              ? AppColors.accentTeal
                              : AppColors.criticalRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isSimulatedMode
                            ? 'SIMULATED OBD-II (10 Hz)'
                            : switch (state.connectionStatus) {
                                ConnectionStatus.connected => 'BLE LINK ACTIVE',
                                ConnectionStatus.connecting => 'CONNECTING...',
                                ConnectionStatus.handshaking => 'HANDSHAKING...',
                                _ => 'DISCONNECTED',
                              },
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const Spacer(),
                      const Text(
                        'Toyota Corolla 2021',
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Gauges Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RadialGaugeWidget(
                      value: rpm,
                      maxValue: 7000,
                      label: 'TACHOMETER',
                      unit: 'RPM',
                      activeColor: rpm > 5500
                          ? AppColors.criticalRed
                          : AppColors.accentCyan,
                    ),
                    RadialGaugeWidget(
                      value: speed,
                      maxValue: 220,
                      label: 'SPEEDOMETER',
                      unit: 'KM/H',
                      activeColor: AppColors.accentTeal,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Metrics Row
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('COOLANT TEMP',
                                style: TextStyle(
                                    color: AppColors.textMuted, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              '${coolant.toStringAsFixed(1)} °C',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: coolant > 105
                                    ? AppColors.criticalRed
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('BATTERY VOLTAGE',
                                style: TextStyle(
                                    color: AppColors.textMuted, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              '${voltage.toStringAsFixed(2)} V',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Error Message Banner (if any)
                if (state.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.criticalRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.criticalRed),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.criticalRed, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: const TextStyle(
                                color: AppColors.criticalRed, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Scan Action Card
                GlassCard(
                  borderColor: AppColors.accentCyan,
                  child: Column(
                    children: [
                      const Text(
                        'AI VEHICLE HEALTH DIAGNOSTIC',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentCyan),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tier 1 Rule Engine ➔ Tier 2 ML Anomaly ➔ Tier 3 RAG Manuals ➔ Tier 4 LLM Explanation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentCyan,
                          foregroundColor: AppColors.bgSurface,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: state.scanStatus == ScanStatus.scanning
                            ? null
                            : () => context
                                .read<DashboardCubit>()
                                .runFullDiagnosticScan(),
                        child: state.scanStatus == ScanStatus.scanning
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('RUN DIAGNOSTIC SCAN',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Report Section (EGM Epistemic Distinction)
                if (state.latestReport != null) ...[
                  GlassCard(
                    borderColor: AppColors.warningAmber,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: AppColors.warningAmber),
                            const SizedBox(width: 8),
                            Text(
                              'DIAGNOSTIC REPORT (${state.latestReport!.dtcs.length} FAULTS)',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warningAmber),
                            ),
                            const Spacer(),
                            Text(
                              'Score: ${state.latestReport!.vehicleHealthScore}/100',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentTeal),
                            ),
                          ],
                        ),
                        const Divider(height: 20, color: AppColors.cardBorder),

                        // Section 1: Physical Measured Evidence
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.sensors,
                                      size: 14, color: AppColors.accentCyan),
                                  SizedBox(width: 4),
                                  Text(
                                    'MEASURED SENSOR EVIDENCE (Physical ECU Fact)',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accentCyan),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'DTCs: ${state.latestReport!.measuredEvidence.detectedDtcs.join(", ")} | '
                                'Coolant: ${state.latestReport!.measuredEvidence.coolantTempC}°C | '
                                'Battery: ${state.latestReport!.measuredEvidence.batteryVoltage}V',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Section 2: Inferred AI Explanation
                        const Row(
                          children: [
                            Icon(Icons.psychology,
                                size: 14, color: AppColors.warningAmber),
                            SizedBox(width: 4),
                            Text(
                              'AI INFERENCE & ANALYSIS (Probabilistic Guidance)',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warningAmber),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.latestReport!.plainLanguageExplanation,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        const Text('Top Probable Causes:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        ...state.latestReport!.rankedCauses.map((c) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                  '• ${c["cause"]} (${c["probabilityPercent"]}%)',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                            )),
                        const SizedBox(height: 12),
                        Text(
                          'Estimated Cost: \$${state.latestReport!.minCostUsd.toInt()} - \$${state.latestReport!.maxCostUsd.toInt()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentCyan),
                        ),
                        const Divider(height: 20, color: AppColors.cardBorder),

                        // Section 3: Safety Disclaimer
                        Text(
                          state.latestReport!.safetyDisclaimer,
                          style: const TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
