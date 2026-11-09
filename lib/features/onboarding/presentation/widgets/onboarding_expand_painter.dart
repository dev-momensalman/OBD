import 'package:flutter/material.dart';

/// CustomPainter that renders Figma's expanding radial gradient circle (Node 67:8499 / Onboarding 5)
/// with an aesthetic luminous glowing leading rim expanding from the ball center across the screen.
class OnboardingExpandPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final double progress;

  OnboardingExpandPainter({
    required this.center,
    required this.radius,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (radius <= 0) return;

    // 1. Rich 4-Stop Radial Gradient Fill (Figma Nodes 67:8473 & 67:8499)
    final mainPaint = Paint()
      ..shader = RadialGradient(
        colors: const [
          Color(0xFF0045CA), // Radiant Center
          Color(0xFF003CAF), // Figma Core Blue
          Color(0xFF002C81), // Deep Mid
          Color(0xFF001C52), // Deep Navy Outer Edge
        ],
        stops: const [0.0, 0.35, 0.70, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, mainPaint);

    // 2. Aesthetic Luminous Energy Rim Glow at leading edge
    final rimAlpha = (1.0 - (progress - 0.45).clamp(0.0, 0.45) / 0.45).clamp(0.0, 1.0);
    if (rimAlpha > 0.02 && radius > 28.0) {
      // Soft outer neon halo
      final haloPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24.0
        ..color = const Color(0xFF6BA4FF).withValues(alpha: 0.35 * rimAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16.0);
      canvas.drawCircle(center, radius, haloPaint);

      // Fine luminous highlight rim
      final edgePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..color = Colors.white.withValues(alpha: 0.70 * rimAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawCircle(center, radius, edgePaint);

      // Sharp crisp boundary
      final crispPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = Colors.white.withValues(alpha: 0.90 * rimAlpha);
      canvas.drawCircle(center, radius, crispPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OnboardingExpandPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.center != center ||
        oldDelegate.progress != progress;
  }
}
