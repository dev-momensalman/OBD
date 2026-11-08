import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RadialGaugeWidget extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final String label;
  final String unit;
  final Color activeColor;

  const RadialGaugeWidget({
    super.key,
    required this.value,
    this.minValue = 0.0,
    required this.maxValue,
    required this.label,
    required this.unit,
    this.activeColor = AppColors.accentCyan,
  });

  @override
  Widget build(BuildContext context) {
    final progress = ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(140, 140),
            painter: _GaugePainter(
              progress: progress,
              activeColor: activeColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.toInt().toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: activeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color activeColor;

  _GaugePainter({required this.progress, required this.activeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;

    const startAngle = 135.0 * (pi / 180.0);
    const sweepAngle = 270.0 * (pi / 180.0);

    // Track
    final trackPaint = Paint()
      ..color = AppColors.cardBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Progress Arc
    final progressPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.activeColor != activeColor;
}
