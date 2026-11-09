import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Photo Header with PageView Carousel for Center Details (Figma Node 434:1174)
class CenterPhotoHeader extends StatelessWidget {
  final int activePhotoIndex;
  final ValueChanged<int> onPageChanged;
  final String centerName;

  const CenterPhotoHeader({
    super.key,
    required this.activePhotoIndex,
    required this.onPageChanged,
    required this.centerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      color: const Color(0xFF0F172A),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Workshop image gradient carousel
          PageView.builder(
            itemCount: 4,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final gradients = [
                [const Color(0xFF001C52), const Color(0xFF003FB8)],
                [const Color(0xFF0F172A), const Color(0xFF1E293B)],
                [const Color(0xFF1E1B4B), const Color(0xFF4338CA)],
                [const Color(0xFF18181B), const Color(0xFF3F3F46)],
              ];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradients[index % gradients.length],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.precision_manufacturing_rounded,
                        color: Colors.white38,
                        size: 64,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$centerName · Photo ${index + 1}',
                        style: GoogleFonts.inter(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Dark bottom scrim for smooth text contrast
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 70,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Page Indicator dots
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isSelected = activePhotoIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isSelected ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
