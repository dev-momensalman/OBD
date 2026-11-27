import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_assets.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';

/// Automotive Digital Instrument Cluster widget built over the cropped
/// transparent dashboard skin (`AppAssets.cockpitClusterSkin`) with smooth
/// `CustomPainter` segmented neon arcs, live OBD readings, and a 4-metric footer.
class CockpitClusterView extends StatelessWidget {
  final double speedKmH;
  final int engineRpm;
  final double coolantTempC;
  final double alternatorVoltage;
  final double maxSpeedKmH;
  final Duration sessionDuration;
  final String tempUnit;
  final String distanceUnit;
  final bool isConnected;
  final bool isSimulated;
  final int dtcCount;
  final bool isFullscreen;
  final VoidCallback? onToggleFullscreen;
  final VoidCallback? onDtcTap;

  const CockpitClusterView({
    super.key,
    required this.speedKmH,
    required this.engineRpm,
    required this.coolantTempC,
    required this.alternatorVoltage,
    this.maxSpeedKmH = 0.0,
    this.sessionDuration = Duration.zero,
    this.tempUnit = '°C',
    this.distanceUnit = 'km',
    this.isConnected = true,
    this.isSimulated = true,
    this.dtcCount = 0,
    this.isFullscreen = false,
    this.onToggleFullscreen,
    this.onDtcTap,
  });

  static const double _skinAspectRatio = 940.0 / 344.0;
  static const double _maxRpmScale = 7000.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usesFahrenheit = tempUnit == '°F';
    final usesMiles = distanceUnit == 'mi';

    final displaySpeed =
        (usesMiles ? speedKmH * 0.621371 : speedKmH).round();
    final displayMaxSpeed =
        (usesMiles ? maxSpeedKmH * 0.621371 : maxSpeedKmH).round();
    final displayCoolant = usesFahrenheit
        ? ((coolantTempC * 9.0 / 5.0) + 32.0).round()
        : coolantTempC.round();
    final speedUnit = usesMiles ? 'mph' : 'km/h';

    final maxGaugeSpeed = usesMiles ? 140.0 : 220.0;
    final shownSpeed = usesMiles ? speedKmH * 0.621371 : speedKmH;
    final speedProgress = (shownSpeed / maxGaugeSpeed).clamp(0.0, 1.0);
    final rpmProgress = (engineRpm / _maxRpmScale).clamp(0.0, 1.0);

    final isLightSurface = !isFullscreen;
    final coolantColor = coolantTempC >= 105.0
        ? (isLightSurface ? const Color(0xFFE11D48) : const Color(0xFFFB7185))
        : coolantTempC >= 98.0
            ? (isLightSurface ? const Color(0xFFD97706) : const Color(0xFFFBBF24))
            : (isLightSurface ? const Color(0xFF16A34A) : const Color(0xFF34D399));
    final batteryColor = alternatorVoltage < 11.8
        ? (isLightSurface ? const Color(0xFFE11D48) : const Color(0xFFFB7185))
        : (isLightSurface ? const Color(0xFF16A34A) : const Color(0xFF34D399));

    return Container(
      decoration: BoxDecoration(
        color: isLightSurface ? Colors.white : null,
        gradient: isLightSurface
            ? null
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF040916),
                  Color(0xFF071127),
                  Color(0xFF030712),
                ],
              ),
        borderRadius: BorderRadius.circular(isFullscreen ? 24 : 20),
        border: Border.all(
          color: isLightSurface
              ? const Color(0xFFE2E8F0)
              : const Color(0xFF1E3A8A).withValues(alpha: 0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isLightSurface
                ? const Color(0xFF0F172A).withValues(alpha: 0.04)
                : const Color(0xFF0284C7).withValues(alpha: 0.16),
            blurRadius: isLightSurface ? 12 : 18,
            offset: Offset(0, isLightSurface ? 4 : 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopHudBar(context, l10n),
          _buildClusterCanvas(
            displaySpeed: displaySpeed,
            speedUnit: speedUnit,
            speedProgress: speedProgress,
            rpmProgress: rpmProgress,
          ),
          _buildBottomTelemetryStrip(
            l10n: l10n,
            displayCoolant: displayCoolant,
            coolantColor: coolantColor,
            batteryColor: batteryColor,
            displayMaxSpeed: displayMaxSpeed,
            speedUnit: speedUnit,
          ),
        ],
      ),
    );
  }

  Widget _buildTopHudBar(BuildContext context, dynamic l10n) {
    final isLightSurface = !isFullscreen;
    final dtcHasFault = dtcCount > 0;
    final dtcColor = dtcHasFault
        ? (isLightSurface ? const Color(0xFFE11D48) : const Color(0xFFFB7185))
        : (isLightSurface ? const Color(0xFF16A34A) : const Color(0xFF34D399));
    final dtcBg = isLightSurface
        ? (dtcHasFault ? const Color(0xFFFFE4E6) : const Color(0xFFDCFCE7))
        : dtcColor.withValues(alpha: 0.14);

    final statusColor = !isConnected
        ? (isLightSurface ? const Color(0xFFE11D48) : const Color(0xFFFB7185))
        : isSimulated
            ? (isLightSurface ? const Color(0xFF0369A1) : const Color(0xFF38BDF8))
            : (isLightSurface ? const Color(0xFF16A34A) : const Color(0xFF34D399));
    final statusBg = isLightSurface
        ? (!isConnected
            ? const Color(0xFFFFE4E6)
            : isSimulated
                ? const Color(0xFFE0F2FE)
                : const Color(0xFFDCFCE7))
        : statusColor.withValues(alpha: 0.12);

    final statusLabel = !isConnected
        ? l10n.cockpitOfflineBadge as String
        : isSimulated
            ? l10n.cockpitSimBadge as String
            : l10n.cockpitLiveBadge as String;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isFullscreen ? 18 : 12,
          vertical: isFullscreen ? 10 : 8,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isLightSurface
                  ? const Color(0xFFF1F5F9)
                  : const Color(0xFF1E293B).withValues(alpha: 0.8),
              width: 0.9,
            ),
          ),
        ),
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onDtcTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: dtcBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: dtcColor.withValues(alpha: isLightSurface ? 0.3 : 0.55),
                      width: 0.9,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        dtcHasFault
                            ? Icons.warning_amber_rounded
                            : Icons.verified_outlined,
                        size: 13,
                        color: dtcColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dtcHasFault ? 'DTC ($dtcCount)' : 'DTC',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: dtcColor,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.build_circle_outlined,
              size: 16,
              color: dtcColor.withValues(alpha: 0.9),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: statusColor.withValues(alpha: isLightSurface ? 0.25 : 0.4),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    statusLabel,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (onToggleFullscreen != null)
              Tooltip(
                message: isFullscreen
                    ? l10n.cockpitExitFullscreen as String
                    : l10n.cockpitFullscreenTooltip as String,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const ValueKey('cockpit_fullscreen_toggle'),
                    onTap: onToggleFullscreen,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isLightSurface
                            ? const Color(0xFFEFF6FF)
                            : const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isLightSurface
                              ? const Color(0xFFBFDBFE)
                              : const Color(0xFF38BDF8).withValues(alpha: 0.35),
                        ),
                      ),
                      child: Icon(
                        isFullscreen
                            ? Icons.fullscreen_exit_rounded
                            : Icons.fullscreen_rounded,
                        size: 17,
                        color: isLightSurface
                            ? const Color(0xFF003FB8)
                            : const Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClusterCanvas({
    required int displaySpeed,
    required String speedUnit,
    required double speedProgress,
    required double rpmProgress,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isFullscreen ? 12 : 10,
          vertical: isFullscreen ? 6 : 8,
        ),
        child: AspectRatio(
          aspectRatio: _skinAspectRatio,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              final dialBoxW = w * (124.0 / 940.0);
              final dialBoxH = h * (114.0 / 344.0);
              final leftCenter = Offset(w * 0.1957, h * 0.5073);
              final rightCenter = Offset(w * 0.8037, h * 0.5073);

              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppAssets.cockpitClusterSkin,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(end: speedProgress),
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    builder: (context, animSpeed, _) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(end: rpmProgress),
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        builder: (context, animRpm, _) {
                          return CustomPaint(
                            painter: _CockpitDialArcsPainter(
                              speedProgress: animSpeed,
                              rpmProgress: animRpm,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Positioned.fromRect(
                    rect: Rect.fromCenter(
                      center: leftCenter,
                      width: dialBoxW,
                      height: dialBoxH,
                    ),
                    child: _DialCenterReadout(
                      valueText: '$displaySpeed',
                      unitText: speedUnit,
                      accentColor: const Color(0xFF22D3EE),
                    ),
                  ),
                  Positioned.fromRect(
                    rect: Rect.fromCenter(
                      center: rightCenter,
                      width: dialBoxW,
                      height: dialBoxH,
                    ),
                    child: _DialCenterReadout(
                      topTag: engineRpm < 1000 && speedKmH < 5 ? 'N' : 'D',
                      valueText: '$engineRpm',
                      unitText: 'RPM',
                      accentColor: const Color(0xFF60A5FA),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTelemetryStrip({
    required dynamic l10n,
    required int displayCoolant,
    required Color coolantColor,
    required Color batteryColor,
    required int displayMaxSpeed,
    required String speedUnit,
  }) {
    final isLightSurface = !isFullscreen;
    final formattedDuration = _formatDuration(sessionDuration);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isFullscreen ? 16 : 8,
        vertical: isFullscreen ? 11 : 10,
      ),
      decoration: BoxDecoration(
        color: isLightSurface
            ? const Color(0xFFF8FAFC)
            : const Color(0xFF030712).withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: isLightSurface
                ? const Color(0xFFE2E8F0)
                : const Color(0xFF1E3A8A).withValues(alpha: 0.45),
            width: 0.9,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FooterMetricCell(
              label: l10n.cockpitCoolantShort as String,
              value: '$displayCoolant',
              unit: tempUnit,
              accentColor: coolantColor,
              isLightSurface: isLightSurface,
            ),
          ),
          _verticalDivider(isLightSurface),
          Expanded(
            child: _FooterMetricCell(
              label: l10n.cockpitBatteryShort as String,
              value: alternatorVoltage.toStringAsFixed(1),
              unit: 'V',
              accentColor: batteryColor,
              isLightSurface: isLightSurface,
            ),
          ),
          _verticalDivider(isLightSurface),
          Expanded(
            child: _FooterMetricCell(
              label: l10n.cockpitMaxSpeed as String,
              value: '$displayMaxSpeed',
              unit: speedUnit,
              accentColor: isLightSurface
                  ? const Color(0xFF003FB8)
                  : const Color(0xFF38BDF8),
              isLightSurface: isLightSurface,
            ),
          ),
          _verticalDivider(isLightSurface),
          Expanded(
            child: _FooterMetricCell(
              label: l10n.cockpitDuration as String,
              value: formattedDuration,
              unit: null,
              accentColor: isLightSurface
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFFA78BFA),
              isLightSurface: isLightSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider(bool isLightSurface) {
    return Container(
      width: 1,
      height: isFullscreen ? 32 : 26,
      color: isLightSurface ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
    );
  }

  String _formatDuration(Duration d) {
    final totalSeconds = d.inSeconds < 0 ? 0 : d.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class _DialCenterReadout extends StatelessWidget {
  final String? topTag;
  final String valueText;
  final String unitText;
  final Color accentColor;

  const _DialCenterReadout({
    this.topTag,
    required this.valueText,
    required this.unitText,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topTag != null) ...[
            Text(
              topTag!,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: accentColor.withValues(alpha: 0.9),
                height: 1.0,
              ),
            ),
            const SizedBox(height: 1),
          ],
          Text(
            valueText,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.05,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 1),
          Text(
            unitText,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterMetricCell extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final Color accentColor;
  final bool isLightSurface;

  const _FooterMetricCell({
    required this.label,
    required this.value,
    required this.unit,
    required this.accentColor,
    this.isLightSurface = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = isLightSurface ? const Color(0xFF0F172A) : Colors.white;
    final unitColor =
        isLightSurface ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: accentColor,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Directionality(
            textDirection: TextDirection.ltr,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: valueColor,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 2),
                    Text(
                      unit!,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: unitColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CockpitDialArcsPainter extends CustomPainter {
  final double speedProgress;
  final double rpmProgress;

  const _CockpitDialArcsPainter({
    required this.speedProgress,
    required this.rpmProgress,
  });

  static const double _startAngle = 135.0 * (math.pi / 180.0);
  static const double _maxSweep = 270.0 * (math.pi / 180.0);
  static const int _segmentCount = 30;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final leftCenter = Offset(w * 0.1957, h * 0.5073);
    final rightCenter = Offset(w * 0.8037, h * 0.5073);
    final rx = h * (94.0 / 344.0);
    final ry = h * (89.5 / 344.0);
    final strokeW = math.max(3.0, h * (16.5 / 344.0));

    _drawSegmentedArc(
      canvas: canvas,
      center: leftCenter,
      rx: rx,
      ry: ry,
      strokeWidth: strokeW,
      progress: speedProgress,
      colors: const [
        Color(0xFF00E5FF),
        Color(0xFF22D3EE),
        Color(0xFF34D399),
        Color(0xFF38BDF8),
      ],
    );

    _drawSegmentedArc(
      canvas: canvas,
      center: rightCenter,
      rx: rx,
      ry: ry,
      strokeWidth: strokeW,
      progress: rpmProgress,
      colors: const [
        Color(0xFF00E5FF),
        Color(0xFF3B82F6),
        Color(0xFF8B5CF6),
        Color(0xFFEF4444),
      ],
    );
  }

  void _drawSegmentedArc({
    required Canvas canvas,
    required Offset center,
    required double rx,
    required double ry,
    required double strokeWidth,
    required double progress,
    required List<Color> colors,
  }) {
    final clamped = progress.clamp(0.0, 1.0);
    if (clamped <= 0.005) return;

    final rect = Rect.fromCenter(center: center, width: rx * 2, height: ry * 2);
    final activeSegments = (clamped * _segmentCount).ceil().clamp(1, _segmentCount);
    final step = _maxSweep / _segmentCount;
    final segSweep = step * 0.72;

    // Outer neon ambient glow behind active segments
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.35
      ..strokeCap = StrokeCap.butt
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: _maxSweep,
        transform: const GradientRotation(_startAngle - 0.05),
        colors: colors,
      ).createShader(rect)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.45);

    canvas.drawArc(rect, _startAngle, _maxSweep * clamped, false, glowPaint);

    // Crisp individual illuminated LED gauge blocks
    final segPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: _maxSweep,
        transform: const GradientRotation(_startAngle - 0.05),
        colors: colors,
      ).createShader(rect);

    for (var i = 0; i < activeSegments; i++) {
      final a = _startAngle + (i * step);
      canvas.drawArc(rect, a, segSweep, false, segPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CockpitDialArcsPainter oldDelegate) =>
      oldDelegate.speedProgress != speedProgress ||
      oldDelegate.rpmProgress != rpmProgress;
}
