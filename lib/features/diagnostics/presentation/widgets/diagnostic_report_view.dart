import 'package:flutter/material.dart';
import 'package:obd_vision/core/constants/app_colors.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/diagnostic_report.dart';
import 'glass_card.dart';

class DiagnosticReportView extends StatelessWidget {
  final DiagnosticReport report;

  const DiagnosticReportView({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
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
                'DIAGNOSTIC REPORT (${report.dtcs.length} FAULTS)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.warningAmber,
                ),
              ),
              const Spacer(),
              Text(
                'Score: ${report.vehicleHealthScore}/100',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentTeal,
                ),
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
                    Icon(Icons.sensors, size: 14, color: AppColors.accentCyan),
                    SizedBox(width: 4),
                    Text(
                      'MEASURED SENSOR EVIDENCE (Physical ECU Fact)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'DTCs: ${report.measuredEvidence.detectedDtcs.join(", ")} | '
                  'Coolant: ${report.measuredEvidence.coolantTempC}°C | '
                  'Battery: ${report.measuredEvidence.batteryVoltage}V',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Section 2: Inferred AI Explanation
          const Row(
            children: [
              Icon(Icons.psychology, size: 14, color: AppColors.warningAmber),
              SizedBox(width: 4),
              Text(
                'AI INFERENCE & ANALYSIS (Probabilistic Guidance)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warningAmber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            report.plainLanguageExplanation,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Top Probable Causes:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          ...report.rankedCauses.map(
            (c) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• ${c.cause} (${(c.probability * 100).toInt()}%)',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Estimated Cost: \$${report.minCostUsd.toInt()} - \$${report.maxCostUsd.toInt()}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.accentCyan,
            ),
          ),
          const Divider(height: 20, color: AppColors.cardBorder),

          // Section 3: Safety Disclaimer
          Text(
            report.safetyDisclaimer,
            style: const TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
