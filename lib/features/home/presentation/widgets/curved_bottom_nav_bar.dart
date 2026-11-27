import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';

/// Navigation Tab Item Definition
class NavTabItem {
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;

  const NavTabItem({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
  });
}

/// Authentic Animated Curved Bottom Navigation Bar matching Figma Component 2 (Node 274:1474 & 325:1928)
/// Features:
/// 1. Dynamic scoop curve that animates smoothly horizontally to any selected tab.
/// 2. Elevated circular action button that glides to the active tab.
/// 3. Active label ("Home", "Service", "Diagnosis", "History", "Profile") matching Figma typography.
/// 4. 100% pure Flutter code icons (no raster/SVG dependencies).
class CurvedBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CurvedBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const List<NavTabItem> tabs = [
    NavTabItem(
      label: 'Home',
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
    ),
    NavTabItem(
      label: 'Service',
      activeIcon: Icons.build_rounded,
      inactiveIcon: Icons.build_outlined,
    ),
    NavTabItem(
      label: 'Diagnosis',
      activeIcon: Icons.crop_free_rounded,
      inactiveIcon: Icons.crop_free_rounded,
    ),
    NavTabItem(
      label: 'History',
      activeIcon: Icons.history_rounded,
      inactiveIcon: Icons.history_rounded,
    ),
    NavTabItem(
      label: 'Profile',
      activeIcon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
    ),
  ];

  @override
  State<CurvedBottomNavBar> createState() => _CurvedBottomNavBarState();
}

class _CurvedBottomNavBarState extends State<CurvedBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _notchAnim;
  double _prevNotchFraction = 0.1;
  double _targetNotchFraction = 0.1;

  static const List<double> _tabFractions = [
    0.10, // Tab 0: Home (~39px / 390)
    0.30, // Tab 1: Service (~117px / 390)
    0.50, // Tab 2: Diagnosis (195px / 390 - Center)
    0.70, // Tab 3: History (~273px / 390)
    0.90, // Tab 4: Profile (~351px / 390)
  ];

  @override
  void initState() {
    super.initState();
    _targetNotchFraction = _tabFractions[widget.selectedIndex.clamp(0, 4)];
    _prevNotchFraction = _targetNotchFraction;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _notchAnim = Tween<double>(
      begin: _prevNotchFraction,
      end: _targetNotchFraction,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubicEmphasized,
    ));
  }

  @override
  void didUpdateWidget(covariant CurvedBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _prevNotchFraction = _notchAnim.value;
      _targetNotchFraction = _tabFractions[widget.selectedIndex.clamp(0, 4)];

      _notchAnim = Tween<double>(
        begin: _prevNotchFraction,
        end: _targetNotchFraction,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutCubicEmphasized,
      ));

      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const baseBarHeight = 98.0;
    final totalHeight = baseBarHeight + bottomInset;

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;

          return AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              final rawNotchX = _notchAnim.value * totalWidth;
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              final currentNotchX = isRtl ? (totalWidth - rawNotchX) : rawNotchX;
              final activeIndex = widget.selectedIndex.clamp(0, 4);
              final activeTab = CurvedBottomNavBar.tabs[activeIndex];
              final l10n = context.l10n;
              final localizedLabel = switch (activeIndex) {
                0 => l10n.navHome,
                1 => l10n.navService,
                2 => l10n.navDiagnosis,
                3 => l10n.navHistory,
                _ => l10n.navProfile,
              };

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. Dynamic Curved Gradient Navy Bar
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CurvedNavBarPainter(
                        notchCenterX: currentNotchX,
                      ),
                    ),
                  ),

                  // 2. Unselected Interactive Tab Icons
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 28,
                    bottom: bottomInset,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(CurvedBottomNavBar.tabs.length, (index) {
                        final tab = CurvedBottomNavBar.tabs[index];
                        final isSelected = widget.selectedIndex == index;

                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => widget.onTap(index),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isSelected ? 0.0 : 1.0,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 10),
                                child: Icon(
                                  tab.inactiveIcon,
                                  size: 24,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // 3. Sliding Active Floating Circle with Active Icon
                  Positioned(
                    left: currentNotchX - 25,
                    top: 6,
                    child: GestureDetector(
                      onTap: () => widget.onTap(widget.selectedIndex),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF002264), // Figma deep navy
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF001238).withValues(alpha: 0.55),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            activeTab.activeIcon,
                            key: ValueKey(activeTab.activeIcon),
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. Sliding Active Label ("Home", "Service", "Diagnosis", etc.)
                  Positioned(
                    left: currentNotchX - 44,
                    width: 88,
                    top: 66,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: Text(
                          localizedLabel,
                          key: ValueKey(localizedLabel),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Dynamic Custom Painter that shifts the Figma scoop cutout smoothly with notchCenterX
class _CurvedNavBarPainter extends CustomPainter {
  final double notchCenterX;

  _CurvedNavBarPainter({required this.notchCenterX});

  @override
  void paint(Canvas canvas, Size size) {
    const flatTopY = 28.0;
    const notchDepth = 56.0;
    const scoopHalfWidth = 44.0;

    final path = Path();
    path.moveTo(0, flatTopY);

    final leftCutout = (notchCenterX - scoopHalfWidth).clamp(0.0, size.width);
    final rightCutout = (notchCenterX + scoopHalfWidth).clamp(0.0, size.width);

    // Left flat edge
    path.lineTo(leftCutout, flatTopY);

    // Scoop entry curve down
    path.cubicTo(
      notchCenterX - 28,
      flatTopY,
      notchCenterX - 24,
      notchDepth,
      notchCenterX,
      notchDepth,
    );

    // Scoop exit curve up
    path.cubicTo(
      notchCenterX + 24,
      notchDepth,
      notchCenterX + 28,
      flatTopY,
      rightCutout,
      flatTopY,
    );

    // Right flat edge
    path.lineTo(size.width, flatTopY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Figma royal blue to marine navy vertical gradient (#003FB8 -> #001C52)
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF003FB8), // Royal Blue
          Color(0xFF001C52), // Deep Marine Navy
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Ambient drop shadow at the top
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.25), 6, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedNavBarPainter oldDelegate) {
    return oldDelegate.notchCenterX != notchCenterX;
  }
}
