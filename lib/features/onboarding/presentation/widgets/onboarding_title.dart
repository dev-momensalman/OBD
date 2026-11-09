import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma styled two-tone title: First word in Brand Blue (#003FB8), remaining in #2C2C2C.
class OnboardingTitle extends StatelessWidget {
  final String title;
  final double scale;

  const OnboardingTitle({
    super.key,
    required this.title,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final firstSpace = title.indexOf(' ');
    final fontSize = (32.0 * scale).clamp(24.0, 32.0);

    if (firstSpace == -1) {
      return Text(
        title,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          height: 1.15,
          letterSpacing: -0.5,
          color: const Color(0xFF003FB8),
        ),
      );
    }

    final firstWord = title.substring(0, firstSpace);
    final rest = title.substring(firstSpace);

    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          height: 1.15,
          letterSpacing: -0.5,
        ),
        children: [
          TextSpan(
            text: firstWord,
            style: const TextStyle(
              color: Color(0xFF003FB8),
            ),
          ),
          TextSpan(
            text: rest,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }
}
