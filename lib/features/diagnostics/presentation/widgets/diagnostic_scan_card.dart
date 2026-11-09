import 'package:flutter/material.dart';
import 'package:obd_vision/core/constants/app_colors.dart';
import 'glass_card.dart';

class DiagnosticScanCard extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onRunScan;

  const DiagnosticScanCard({
    super.key,
    required this.isScanning,
    required this.onRunScan,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.accentCyan,
      child: Column(
        children: [
          const Text(
            'AI VEHICLE HEALTH DIAGNOSTIC',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.accentCyan,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tier 1 Rule Engine ➔ Tier 2 ML Anomaly ➔ Tier 3 RAG Manuals ➔ Tier 4 LLM Explanation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: AppColors.bgSurface,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: isScanning ? null : onRunScan,
            child: isScanning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'RUN DIAGNOSTIC SCAN',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}
