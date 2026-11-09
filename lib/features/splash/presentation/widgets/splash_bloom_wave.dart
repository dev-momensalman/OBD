import 'package:flutter/material.dart';

/// Radial pulse bloom shockwave emitted during Stage 4 of the splash sequence.
class SplashBloomWave extends StatelessWidget {
  final Animation<double> bloomScaleAnimation;
  final Animation<double> bloomFadeAnimation;

  const SplashBloomWave({
    super.key,
    required this.bloomScaleAnimation,
    required this.bloomFadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (bloomScaleAnimation.value <= 0.15 || bloomFadeAnimation.value <= 0.01) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Opacity(
        opacity: bloomFadeAnimation.value.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: bloomScaleAnimation.value,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF003FB8).withValues(alpha: 0.5),
                width: 3.0,
              ),
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF0045CA).withValues(alpha: 0.25),
                  const Color(0xFF114AA6).withValues(alpha: 0.10),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
