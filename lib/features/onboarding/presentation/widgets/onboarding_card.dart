import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/core/constants/app_colors.dart';

/// Pixel-perfect Onboarding Illustration Card with top-right notch cutout and Skip action.
/// Strictly matches Figma specification (Card: 358x417, Skip: top 20, right 24).
class OnboardingCard extends StatelessWidget {
  final String imagePath;
  final bool showSkip;
  final VoidCallback onSkip;
  final double scale;
  final double maxHeight;

  const OnboardingCard({
    super.key,
    required this.imagePath,
    required this.showSkip,
    required this.onSkip,
    required this.scale,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio: 358 / 417,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Card Graphic
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.directions_car_filled_rounded,
                      size: 80,
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ),
              ),

              // Skip Action anchored inside top-right notch cutout (x: 315, y: 68 in Figma)
              if (showSkip)
                PositionedDirectional(
                  top: 20 * scale,
                  end: 24 * scale,
                  child: GestureDetector(
                    onTap: onSkip,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        context.l10n.skipButton,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2C2C2C),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
