import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_assets.dart';

/// Top header for Authentication screens matching Figma (Node 67:8513)
/// Features soft luminous blue ambient aura, 4x sharp vector emblem,
/// brand wordmark "OBD Vision", and screen title.
class AuthHeader extends StatelessWidget {
  final String title;

  const AuthHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 240 + topPadding,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Soft Ambient Blue Aura background (Figma Shadow: w: 543, h: 454)
          Positioned(
            top: -120 + topPadding * 0.4,
            child: SvgPicture.asset(
              'assets/icons/signin_icon_3.svg',
              width: 543,
              height: 454,
              fit: BoxFit.contain,
            ),
          ),

          // 2. Logo Emblem, Wordmark, and Title Column
          Positioned(
            top: topPadding + 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 4x Ultra-Sharp Emblem Logo
                Image.asset(
                  AppAssets.appLogoMark,
                  width: 96,
                  height: 58,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),

                // OBD Vision Wordmark (Figma Node 86:1614: Inter Bold 20px)
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                    children: const [
                      TextSpan(
                        text: 'OBD',
                        style: TextStyle(color: Color(0xFF004FE7)),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: 'Vision',
                        style: TextStyle(color: Color(0xFF000000)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Screen Headline Title (Figma Node 77:219: Inter 24px)
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
