import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Authentic Curved Bottom Navigation Bar matching Figma Node 274:983 (Home Page)
/// Uses native Flutter IconData code (Home, Build, QR/Scan, History, Person) without raster/SVG images.
class CurvedBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CurvedBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    const barHeight = 74.0;
    final totalHeight = barHeight + bottomPadding;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Custom Painted Curved Blue Background
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: CustomPaint(
              painter: _CurvedNavBarPainter(),
            ),
          ),

          // 2. Interactive Navigation Items (Icon Code)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: bottomPadding,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final tabWidth = totalWidth / 5;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Item 0: Home (Elevated Circular Button + "Home" Label)
                    SizedBox(
                      width: tabWidth,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTap(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            // Circular Elevated Button
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF002264),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF001238)
                                        .withValues(alpha: 0.45),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.home_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // "Home" Label
                            Text(
                              'Home',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Item 1: Tools (Icon Code: Icons.build_rounded)
                    _buildNavItem(
                      width: tabWidth,
                      index: 1,
                      icon: Icons.build_rounded,
                    ),

                    // Item 2: Scan (Icon Code: Icons.qr_code_scanner_rounded)
                    _buildNavItem(
                      width: tabWidth,
                      index: 2,
                      icon: Icons.qr_code_scanner_rounded,
                    ),

                    // Item 3: History (Icon Code: Icons.history_rounded)
                    _buildNavItem(
                      width: tabWidth,
                      index: 3,
                      icon: Icons.history_rounded,
                    ),

                    // Item 4: Profile (Icon Code: Icons.person_outline_rounded)
                    _buildNavItem(
                      width: tabWidth,
                      index: 4,
                      icon: Icons.person_outline_rounded,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required double width,
    required int index,
    required IconData icon,
  }) {
    final isSelected = selectedIndex == index;

    return SizedBox(
      width: width,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter creating the exact Figma scoop curve at the Home tab position.
class _CurvedNavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const flatTopY = 20.0;
    final notchCenterX = size.width / 10;
    const notchDepth = 48.0;

    final path = Path();
    path.moveTo(0, flatTopY + 14);

    // Left edge into the scoop
    path.cubicTo(
      notchCenterX - 34,
      flatTopY + 14,
      notchCenterX - 26,
      notchDepth,
      notchCenterX,
      notchDepth,
    );

    // Right edge out of the scoop returning to flat line
    path.cubicTo(
      notchCenterX + 26,
      notchDepth,
      notchCenterX + 34,
      flatTopY,
      notchCenterX + 48,
      flatTopY,
    );

    // Continue flat to right screen edge
    path.lineTo(size.width, flatTopY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF003FB8), // Figma Royal Blue
          Color(0xFF002A7E), // Deep Marine Navy
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw subtle drop shadow at the top edge of navbar
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.2), 6, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
