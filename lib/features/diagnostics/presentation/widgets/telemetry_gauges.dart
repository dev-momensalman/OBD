import 'package:flutter/material.dart';
import 'package:obd_vision/core/constants/app_colors.dart';
import 'glass_card.dart';
import 'radial_gauge_widget.dart';

class TelemetryGauges extends StatelessWidget {
  final double rpm;
  final double speed;
  final double coolantTemp;
  final double batteryVoltage;

  const TelemetryGauges({
    super.key,
    required this.rpm,
    required this.speed,
    required this.coolantTemp,
    required this.batteryVoltage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Gauges Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RadialGaugeWidget(
              value: rpm,
              maxValue: 7000,
              label: 'TACHOMETER',
              unit: 'RPM',
              activeColor:
                  rpm > 5500 ? AppColors.criticalRed : AppColors.accentCyan,
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
                    const Text(
                      'COOLANT TEMP',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${coolantTemp.toStringAsFixed(1)} °C',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: coolantTemp > 105
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
                    const Text(
                      'BATTERY VOLTAGE',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${batteryVoltage.toStringAsFixed(2)} V',
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
      ],
    );
  }
}
