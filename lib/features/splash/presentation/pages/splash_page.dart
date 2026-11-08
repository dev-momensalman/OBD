import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_assets.dart';
import 'package:obd_vision/core/constants/app_colors.dart';

/// Animated Splash Screen matching the 4 Figma stages with pixel & mathematical precision:
/// - Stage 1 (Splash 1 / 40:2021): 100% deep royal blue screen split vertically down the middle
///   with zero gap, glowing with a bright cyan/white laser seam.
/// - Stage 2 (Splash 2 / 44:7627): Panels rotate seamlessly to 24.8° across the screen without exposing background.
/// - Stage 3 (Splash 3 / 44:7614): Slabs part diagonally along the 24.8° normal, uncovering the light canvas (#DDDDDD / #FFFFFF)
///   where the transparent OBD Vision logo & typography scale and fade in.
/// - Stage 4 (Splash 4 / 44:7619): Radial pulse bloom wave expands outward before completing navigation.
class SplashPage extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  final Duration animationDuration;

  const SplashPage({
    super.key,
    this.onAnimationComplete,
    this.animationDuration = const Duration(milliseconds: 3000),
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Stage 1 & 2: Rotation & seam glow
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _seamOpacityAnimation;

  // Stage 3: Slabs parting outward
  late final Animation<double> _separationAnimation;

  // Stage 3: Brand Identity in center
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;

  // Stage 4: Radial pulse shockwave bloom
  late final Animation<double> _bloomScaleAnimation;
  late final Animation<double> _bloomFadeAnimation;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // -------------------------------------------------------------------------
    // Stage 1 -> 2: Rotation (0.20 - 0.48) from 0° to 24.83°
    // -------------------------------------------------------------------------
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 24.83 * math.pi / 180.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.48, curve: Curves.easeInOutCubic),
      ),
    );

    // Laser seam brightness and dissolve
    _seamOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 12,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: 40,
      ),
    ]).animate(_controller);

    // -------------------------------------------------------------------------
    // Stage 3: Slabs parting diagonally (0.46 - 0.78)
    // -------------------------------------------------------------------------
    _separationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.46, 0.78, curve: Curves.easeInOutCubic),
      ),
    );

    // Brand logo scale (0.52 - 0.80) with bouncy ease-out
    _logoScaleAnimation = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.80, curve: Curves.easeOutBack),
      ),
    );

    // Brand logo opacity (0.50 - 0.72)
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.72, curve: Curves.easeIn),
      ),
    );

    // Typography fade (0.60 - 0.84)
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.84, curve: Curves.easeIn),
      ),
    );

    // Typography slide up (0.60 - 0.84)
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.84, curve: Curves.easeOutCubic),
      ),
    );

    // -------------------------------------------------------------------------
    // Stage 4: Radial pulse shockwave bloom (0.74 - 0.98)
    // -------------------------------------------------------------------------
    _bloomScaleAnimation = Tween<double>(
      begin: 0.1,
      end: 4.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.74, 0.98, curve: Curves.easeOutQuad),
      ),
    );

    _bloomFadeAnimation = Tween<double>(
      begin: 0.7,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.76, 0.98, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handleComplete();
      }
    });

    _controller.forward();
  }

  void _handleComplete() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: _handleComplete,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDDDDD),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final angle = _rotationAnimation.value;
            final separation = _separationAnimation.value * size.width * 1.5;
            final seamGlow = _seamOpacityAnimation.value;

            return Stack(
              fit: StackFit.expand,
              children: [
                // -------------------------------------------------------------
                // 0. Base Light Canvas (Revealed in Stage 3: #DDDDDD / #FFFFFF)
                // -------------------------------------------------------------
                Container(
                  color: const Color(0xFFDDDDDD),
                ),

                // -------------------------------------------------------------
                // 1. Center Brand Identity & Typography (Stage 3 & 4)
                // -------------------------------------------------------------
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Transparent 4K Logo Emblem
                      FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: Container(
                            width: 180,
                            height: 106,
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppAssets.splashLogoFull,
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

                      // "OBD Vision" Typography
                      SlideTransition(
                        position: _textSlideAnimation,
                        child: FadeTransition(
                          opacity: _textFadeAnimation,
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
                                  style: TextStyle(
                                    color: Color(0xFF114AA6),
                                  ),
                                ),
                                TextSpan(
                                  text: ' ',
                                  style: TextStyle(
                                    color: Color(0xFF101010),
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Vision',
                                  style: TextStyle(
                                    color: Color(0xFF101010),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // -------------------------------------------------------------
                // 2. Stage 4: Radial Pulse Shockwave Bloom (Node 44:7623)
                // -------------------------------------------------------------
                if (_bloomScaleAnimation.value > 0.15 && _bloomFadeAnimation.value > 0.01)
                  Center(
                    child: Opacity(
                      opacity: _bloomFadeAnimation.value.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: _bloomScaleAnimation.value,
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
                  ),

                // -------------------------------------------------------------
                // 3. Stage 1, 2, 3: Mathematical Zero-Gap Custom Painted Panels
                // -------------------------------------------------------------
                // When separation == 0, the panels meet with ZERO gap, completely covering the screen
                // in Figma's continuous blue gradient. As separation increases in Stage 3, they slide apart smoothly.
                if (_separationAnimation.value < 0.99)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SplashPanelsPainter(
                        angle: angle,
                        separation: separation,
                        seamGlow: seamGlow,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// CustomPainter that renders the two Figma gradient blue panels meeting seamlessly at the seam
/// with zero subpixel gaps, rotating by angle and parting diagonally.
class SplashPanelsPainter extends CustomPainter {
  final double angle; // in radians
  final double separation; // in pixels
  final double seamGlow; // 0.0 to 1.0

  SplashPanelsPainter({
    required this.angle,
    required this.separation,
    required this.seamGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Direction vector along the seam line:
    // In Figma Splash 2, the seam line rotates 24.83° clockwise:
    // At the top (y < cy), x is to the RIGHT (cx + sin*l).
    // At the bottom (y > cy), x is to the LEFT (cx - sin*l).
    // Therefore, as y increases (going down), x decreases:
    final dx = -math.sin(angle);
    final dy = math.cos(angle);

    // Normal vector perpendicular to seam line (pointing towards the RIGHT panel):
    final nx = math.cos(angle);
    final ny = math.sin(angle);

    // Far reach distance guaranteeing screen bounds coverage in all rotations
    final l = math.sqrt(size.width * size.width + size.height * size.height) * 2.5;

    final cLeft = Offset(cx - nx * separation, cy - ny * separation);
    final cRight = Offset(cx + nx * separation, cy + ny * separation);

    // -------------------------------------------------------------------------
    // 1. Draw Left Panel (From Deep Navy #001C52 at outer left to Royal Blue #003FB8 at seam)
    // Figma 44:7602: bg-gradient-to-l from-[#003fb8] to-[#001c52] to-[55.492%]
    // -------------------------------------------------------------------------
    final p1L = Offset(cLeft.dx - dx * l, cLeft.dy - dy * l);
    final p2L = Offset(cLeft.dx + dx * l, cLeft.dy + dy * l);
    final p3L = Offset(p2L.dx - nx * l, p2L.dy - ny * l);
    final p4L = Offset(p1L.dx - nx * l, p1L.dy - ny * l);

    final pathLeft = Path()
      ..moveTo(p1L.dx, p1L.dy)
      ..lineTo(p2L.dx, p2L.dy)
      ..lineTo(p3L.dx, p3L.dy)
      ..lineTo(p4L.dx, p4L.dy)
      ..close();

    // Gradient runs from outer-left (-nx * size.width) to the seam (cLeft)
    final gradStartLeft = Offset(cLeft.dx - nx * size.width, cLeft.dy - ny * size.width);
    final gradEndLeft = cLeft;

    final paintLeft = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF001C52), // Deep Navy (#001C52) at outer edge
          Color(0xFF001C52), // Reaches full deep navy by 55.5%
          Color(0xFF003FB8), // Royal Blue (#003FB8) at the seam
        ],
        stops: [0.0, 0.445, 1.0],
      ).createShader(Rect.fromPoints(gradStartLeft, gradEndLeft));

    canvas.drawPath(pathLeft, paintLeft);

    // -------------------------------------------------------------------------
    // 2. Draw Right Panel (From Royal Blue #0045CA at seam to Dark Navy #002264 at outer right)
    // Figma 44:7607: bg-gradient-to-l from-[#002264] from-[48.627%] to-[#0045ca]
    // -------------------------------------------------------------------------
    final p1R = Offset(cRight.dx - dx * l, cRight.dy - dy * l);
    final p2R = Offset(cRight.dx + dx * l, cRight.dy + dy * l);
    final p3R = Offset(p2R.dx + nx * l, p2R.dy + ny * l);
    final p4R = Offset(p1R.dx + nx * l, p1R.dy + ny * l);

    final pathRight = Path()
      ..moveTo(p1R.dx, p1R.dy)
      ..lineTo(p2R.dx, p2R.dy)
      ..lineTo(p3R.dx, p3R.dy)
      ..lineTo(p4R.dx, p4R.dy)
      ..close();

    // Gradient runs from seam (cRight) to outer-right (+nx * size.width)
    final gradStartRight = cRight;
    final gradEndRight = Offset(cRight.dx + nx * size.width, cRight.dy + ny * size.width);

    final paintRight = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF0045CA), // Bright Royal Blue (#0045CA) at the seam
          Color(0xFF002264), // Dark Navy (#002264) reaches by 48.6%
          Color(0xFF002264), // Dark Navy to outer edge
        ],
        stops: [0.0, 0.514, 1.0],
      ).createShader(Rect.fromPoints(gradStartRight, gradEndRight));

    canvas.drawPath(pathRight, paintRight);

    // -------------------------------------------------------------------------
    // 3. Draw Seam Shadow / Soft White-Blue Glow (Figma: shadow 10px 0 30px rgba(255,255,255,0.35))
    // Dissolves smoothly as panels begin separating in Stage 3.
    // -------------------------------------------------------------------------
    if (seamGlow > 0.01 && separation < 30.0) {
      final seamCenter = Offset((cLeft.dx + cRight.dx) / 2, (cLeft.dy + cRight.dy) / 2);
      final alpha = (seamGlow * (1.0 - (separation / 30.0).clamp(0.0, 1.0))).clamp(0.0, 1.0);

      // Figma drop shadow: offset 8px in the normal direction (to the right)
      final shadowCenter = Offset(seamCenter.dx + nx * 8.0, seamCenter.dy + ny * 8.0);
      final p1Shadow = Offset(shadowCenter.dx - dx * l, shadowCenter.dy - dy * l);
      final p2Shadow = Offset(shadowCenter.dx + dx * l, shadowCenter.dy + dy * l);

      // Wide soft white bloom (matching Figma shadow: rgba(255,255,255, 0.35))
      final softGlowPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.35 * alpha)
        ..strokeWidth = 28.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawLine(p1Shadow, p2Shadow, softGlowPaint);

      // Inner soft luminous sky-blue highlight along seam line
      final p1 = Offset(seamCenter.dx - dx * l, seamCenter.dy - dy * l);
      final p2 = Offset(seamCenter.dx + dx * l, seamCenter.dy + dy * l);

      final blueGlowPaint = Paint()
        ..color = const Color(0xFF6BA4FF).withValues(alpha: 0.30 * alpha)
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawLine(p1, p2, blueGlowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SplashPanelsPainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.separation != separation ||
        oldDelegate.seamGlow != seamGlow;
  }
}
