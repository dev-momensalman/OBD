import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Live Telemetry Section matching Figma Node 274:983
/// Features Engine Speed (780 RPM / IDLE), Coolant Temp (96°C / HIGH), and Alternator (13.8V / NORMAL).
class LiveTelemetrySection extends StatelessWidget {
  final int engineRpm;
  final double coolantTemp;
  final double alternatorVoltage;
  final VoidCallback onSeeAll;

  const LiveTelemetrySection({
    super.key,
    this.engineRpm = 780,
    this.coolantTemp = 96.0,
    this.alternatorVoltage = 13.8,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: Title + LIVE badge + See All link
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'Live Telemetry',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 8),
              // "LIVE" Green Pulse Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'LIVE',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF16A34A),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  'See All',
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

        // 3 Telemetry Cards Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Card 1: Engine Speed (780 RPM - IDLE)
              Expanded(
                child: _TelemetryCard(
                  badgeText: 'IDLE',
                  badgeBg: const Color(0xFFDBEAFE),
                  badgeTextColor: const Color(0xFF1D4ED8),
                  icon: SvgPicture.asset(
                    'assets/icons/home/telemetry_speedometer.svg',
                    width: 16,
                    height: 16,
                  ),
                  label: 'Engine Speed',
                  valueText: '$engineRpm',
                  unitText: 'RPM',
                  valueColor: const Color(0xFF0F172A),
                  progressRatio: (engineRpm / 6000.0).clamp(0.1, 1.0),
                  progressColor: const Color(0xFF003FB8),
                ),
              ),
              const SizedBox(width: 10),

              // Card 2: Coolant Temp (96°C - HIGH)
              Expanded(
                child: _TelemetryCard(
                  badgeText: 'HIGH',
                  badgeBg: const Color(0xFFFEF3C7),
                  badgeTextColor: const Color(0xFFD97706),
                  icon: SvgPicture.asset(
                    'assets/icons/home/telemetry_temp.svg',
                    width: 16,
                    height: 16,
                  ),
                  label: 'Coolant Temp',
                  valueText: '${coolantTemp.toInt()}',
                  unitText: '°C',
                  valueColor: const Color(0xFFD97706),
                  progressRatio: (coolantTemp / 120.0).clamp(0.1, 1.0),
                  progressColor: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 10),

              // Card 3: Alternator (13.8V - NORMAL)
              Expanded(
                child: _TelemetryCard(
                  badgeText: 'NORMAL',
                  badgeBg: const Color(0xFFDCFCE7),
                  badgeTextColor: const Color(0xFF16A34A),
                  icon: SvgPicture.asset(
                    'assets/icons/home/telemetry_battery.svg',
                    width: 16,
                    height: 16,
                  ),
                  label: 'Alternator',
                  valueText: alternatorVoltage.toStringAsFixed(1),
                  unitText: 'V',
                  valueColor: const Color(0xFF0F172A),
                  progressRatio: (alternatorVoltage / 16.0).clamp(0.1, 1.0),
                  progressColor: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TelemetryCard extends StatelessWidget {
  final String badgeText;
  final Color badgeBg;
  final Color badgeTextColor;
  final Widget icon;
  final String label;
  final String valueText;
  final String unitText;
  final Color valueColor;
  final double progressRatio;
  final Color progressColor;

  const _TelemetryCard({
    required this.badgeText,
    required this.badgeBg,
    required this.badgeTextColor,
    required this.icon,
    required this.label,
    required this.valueText,
    required this.unitText,
    required this.valueColor,
    required this.progressRatio,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: Badge + Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              ),
              icon,
            ],
          ),
          const SizedBox(height: 10),

          // Label
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Value and Unit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                valueText,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unitText,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Bottom Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 4,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}
