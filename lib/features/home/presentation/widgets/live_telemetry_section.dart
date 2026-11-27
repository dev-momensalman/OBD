import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/home/presentation/widgets/cockpit_cluster_view.dart';

/// Live Telemetry Section displaying the automotive digital instrument cluster
/// (`CockpitClusterView`) in place of the legacy 3-card row.
class LiveTelemetrySection extends StatelessWidget {
  final double speedKmH;
  final int engineRpm;
  final double coolantTemp;
  final String tempUnit;
  final String distanceUnit;
  final double alternatorVoltage;
  final double maxSpeedKmH;
  final Duration sessionDuration;
  final bool isConnected;
  final bool isSimulated;
  final int dtcCount;
  final VoidCallback onSeeAll;
  final VoidCallback? onOpenFullscreen;
  final VoidCallback? onDtcTap;

  const LiveTelemetrySection({
    super.key,
    this.speedKmH = 0.0,
    this.engineRpm = 780,
    this.coolantTemp = 96.0,
    this.tempUnit = '°C',
    this.distanceUnit = 'km',
    this.alternatorVoltage = 13.8,
    this.maxSpeedKmH = 0.0,
    this.sessionDuration = Duration.zero,
    this.isConnected = true,
    this.isSimulated = true,
    this.dtcCount = 0,
    required this.onSeeAll,
    this.onOpenFullscreen,
    this.onDtcTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final indicatorColor = !isConnected
        ? const Color(0xFFE11D48)
        : isSimulated
            ? const Color(0xFF0284C7)
            : const Color(0xFF16A34A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                l10n.liveTelemetry,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  l10n.seeAll,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003FB8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CockpitClusterView(
            speedKmH: speedKmH,
            engineRpm: engineRpm,
            coolantTempC: coolantTemp,
            alternatorVoltage: alternatorVoltage,
            maxSpeedKmH: maxSpeedKmH,
            sessionDuration: sessionDuration,
            tempUnit: tempUnit,
            distanceUnit: distanceUnit,
            isConnected: isConnected,
            isSimulated: isSimulated,
            dtcCount: dtcCount,
            onToggleFullscreen: onOpenFullscreen,
            onDtcTap: onDtcTap,
          ),
        ),
      ],
    );
  }
}
