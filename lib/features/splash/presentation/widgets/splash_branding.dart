import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_assets.dart';
import 'package:obd_vision/core/constants/app_colors.dart';

/// Centers the brand logo and typography during the splash animation.
class SplashBranding extends StatelessWidget {
  final Animation<double> logoFadeAnimation;
  final Animation<double> logoScaleAnimation;
  final Animation<double> textFadeAnimation;
  final Animation<Offset> textSlideAnimation;

  const SplashBranding({
    super.key,
    required this.logoFadeAnimation,
    required this.logoScaleAnimation,
    required this.textFadeAnimation,
    required this.textSlideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: logoFadeAnimation,
            child: ScaleTransition(
              scale: logoScaleAnimation,
              child: Container(
                width: 180,
                height: 106,
                alignment: Alignment.center,
                child: Image.asset(
                  AppAssets.appLogoMark,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.directions_car_filled_rounded,
                      size: 64,
                      color: AppColors.brandPrimary,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SlideTransition(
            position: textSlideAnimation,
            child: FadeTransition(
              opacity: textFadeAnimation,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                  children: const [
                    TextSpan(
                      text: 'OBD',
                      style: TextStyle(color: Color(0xFF114AA6)),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(color: Color(0xFF101010), fontSize: 16),
                    ),
                    TextSpan(
                      text: 'Vision',
                      style: TextStyle(color: Color(0xFF101010)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
