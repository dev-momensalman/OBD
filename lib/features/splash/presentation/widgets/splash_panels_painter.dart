import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPainter that renders the two Figma gradient blue panels meeting seamlessly at the seam
/// with zero subpixel gaps, rotating by angle and parting diagonally.
class SplashPanelsPainter extends CustomPainter {
  final double angle; // in radians
  final double separation; // in pixels
  final double seamGlow; // 0.0 to 1.0

  SplashPanelsPainter({
    required this.angle,
    required this.separation,
    required this.seamGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Direction vector along the seam line:
    // In Figma Splash 2, the seam line rotates 24.83° clockwise:
    // At the top (y < cy), x is to the RIGHT (cx + sin*l).
    // At the bottom (y > cy), x is to the LEFT (cx - sin*l).
    // Therefore, as y increases (going down), x decreases:
    final dx = -math.sin(angle);
    final dy = math.cos(angle);

    // Normal vector perpendicular to seam line (pointing towards the RIGHT panel):
    final nx = math.cos(angle);
    final ny = math.sin(angle);

    // Far reach distance guaranteeing screen bounds coverage in all rotations
    final l = math.sqrt(size.width * size.width + size.height * size.height) * 2.5;

    final cLeft = Offset(cx - nx * separation, cy - ny * separation);
    final cRight = Offset(cx + nx * separation, cy + ny * separation);

    // -------------------------------------------------------------------------
    // 1. Draw Left Panel (From Deep Navy #001C52 at outer left to Royal Blue #003FB8 at seam)
    // Figma 44:7602: bg-gradient-to-l from-[#003fb8] to-[#001c52] to-[55.492%]
    // -------------------------------------------------------------------------
    final p1L = Offset(cLeft.dx - dx * l, cLeft.dy - dy * l);
    final p2L = Offset(cLeft.dx + dx * l, cLeft.dy + dy * l);
    final p3L = Offset(p2L.dx - nx * l, p2L.dy - ny * l);
    final p4L = Offset(p1L.dx - nx * l, p1L.dy - ny * l);

    final pathLeft = Path()
      ..moveTo(p1L.dx, p1L.dy)
      ..lineTo(p2L.dx, p2L.dy)
      ..lineTo(p3L.dx, p3L.dy)
      ..lineTo(p4L.dx, p4L.dy)
      ..close();

    final gradStartLeft = Offset(cLeft.dx - nx * size.width, cLeft.dy - ny * size.width);
    final gradEndLeft = cLeft;

    final paintLeft = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF001C52),
          Color(0xFF001C52),
          Color(0xFF003FB8),
        ],
        stops: [0.0, 0.445, 1.0],
      ).createShader(Rect.fromPoints(gradStartLeft, gradEndLeft));

    canvas.drawPath(pathLeft, paintLeft);

    // -------------------------------------------------------------------------
    // 2. Draw Right Panel (From Royal Blue #0045CA at seam to Dark Navy #002264 at outer right)
    // Figma 44:7607: bg-gradient-to-l from-[#002264] from-[48.627%] to-[#0045ca]
    // -------------------------------------------------------------------------
    final p1R = Offset(cRight.dx - dx * l, cRight.dy - dy * l);
    final p2R = Offset(cRight.dx + dx * l, cRight.dy + dy * l);
    final p3R = Offset(p2R.dx + nx * l, p2R.dy + ny * l);
    final p4R = Offset(p1R.dx + nx * l, p1R.dy + ny * l);

    final pathRight = Path()
      ..moveTo(p1R.dx, p1R.dy)
      ..lineTo(p2R.dx, p2R.dy)
      ..lineTo(p3R.dx, p3R.dy)
      ..lineTo(p4R.dx, p4R.dy)
      ..close();

    final gradStartRight = cRight;
    final gradEndRight = Offset(cRight.dx + nx * size.width, cRight.dy + ny * size.width);

    final paintRight = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF0045CA),
          Color(0xFF002264),
          Color(0xFF002264),
        ],
        stops: [0.0, 0.514, 1.0],
      ).createShader(Rect.fromPoints(gradStartRight, gradEndRight));

    canvas.drawPath(pathRight, paintRight);

    // -------------------------------------------------------------------------
    // 3. Draw Seam Shadow / Soft White-Blue Glow (Figma: shadow 10px 0 30px rgba(255,255,255,0.35))
    // -------------------------------------------------------------------------
    if (seamGlow > 0.01 && separation < 30.0) {
      final seamCenter = Offset((cLeft.dx + cRight.dx) / 2, (cLeft.dy + cRight.dy) / 2);
      final alpha = (seamGlow * (1.0 - (separation / 30.0).clamp(0.0, 1.0))).clamp(0.0, 1.0);

      final shadowCenter = Offset(seamCenter.dx + nx * 8.0, seamCenter.dy + ny * 8.0);
      final p1Shadow = Offset(shadowCenter.dx - dx * l, shadowCenter.dy - dy * l);
      final p2Shadow = Offset(shadowCenter.dx + dx * l, shadowCenter.dy + dy * l);

      final softGlowPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.35 * alpha)
        ..strokeWidth = 28.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawLine(p1Shadow, p2Shadow, softGlowPaint);

      final p1 = Offset(seamCenter.dx - dx * l, seamCenter.dy - dy * l);
      final p2 = Offset(seamCenter.dx + dx * l, seamCenter.dy + dy * l);

      final blueGlowPaint = Paint()
        ..color = const Color(0xFF6BA4FF).withValues(alpha: 0.30 * alpha)
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawLine(p1, p2, blueGlowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SplashPanelsPainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.separation != separation ||
        oldDelegate.seamGlow != seamGlow;
  }
}
