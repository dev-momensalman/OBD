import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_assets.dart';
import 'package:obd_vision/core/constants/app_colors.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/features/onboarding/domain/models/onboarding_model.dart';

/// Pixel-Perfect Onboarding Screen strictly matching the Figma specification
/// (Nodes: 52:8041, 61:8289, 61:8321 on Canvas 390x844).
///
/// Exact Figma Metrics:
/// - Screen Canvas: 390 x 844
/// - Illustration Card: width: 358, height: 417 (aspectRatio: 358 / 417), x: 16, y: 48
/// - Notch Action (Skip): x: 315, y: 68 -> top: 20, right: 24 inside card cutout
/// - Gap Card to Title: 38px
/// - Title: x: 24, y: 503, fontSize: 32, FontWeight.w800, leading: 1.15
///   - First Word: #003FB8 (Primary Blue)
///   - Remaining Words: #2C2C2C
/// - Gap Title to Body: 17px
/// - Body Text: x: 24, y: 597, fontSize: 16, FontWeight.w500, color: rgba(44, 44, 44, 0.65)
/// - Gap Body to Bottom: 39px
/// - Bottom Nav:
///   - Screens 1 & 2: Button (Next) width: 152, height: 48, radius: 16, #003FB8 | Indicators: active pill 53x6, inactive 6x6
///   - Screen 3 (Final): Button (Get Started) width: 216, height: 48, centered | Indicators: hidden
class OnboardingPage extends StatefulWidget {
  final VoidCallback? onFinished;

  const OnboardingPage({super.key, this.onFinished});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final GlobalKey _buttonKey = GlobalKey();
  int _currentIndex = 0;

  // Figma Morph & Expand Animation (Onboarding 4 -> 5 / Nodes 67:8416 & 67:8499)
  late final AnimationController _morphController;
  late final Animation<double> _buttonWidthAnimation;
  late final Animation<double> _buttonShiftAnimation;
  late final Animation<double> _buttonTextFadeAnimation;
  late final Animation<double> _ballPulseAnimation;
  late final Animation<double> _expandRadiusAnimation;

  bool _isMorphing = false;
  Offset _circleCenter = Offset.zero;

  static const List<OnboardingModel> _pages = [
    OnboardingModel(
      title: 'Turn Vehicle Data Into Smart Insights',
      description:
          'Let AI analyze your car’s data, uncover potential issues, and guide you toward the next step.',
      imagePath: AppAssets.onboarding1Illustration,
      buttonText: 'Next',
    ),
    OnboardingModel(
      title: 'See Your Car’s Story in Real Time',
      description:
          'Monitor live vehicle data and stay connected to what’s happening under the hood.',
      imagePath: AppAssets.onboarding2Illustration,
      buttonText: 'Next',
    ),
    OnboardingModel(
      title: 'Connect, Discover, Understand',
      description:
          'Plug into your vehicle’s OBD port and unlock the data your car has to tell you.',
      imagePath: AppAssets.onboarding3Illustration,
      buttonText: 'Get Started',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Luxurious, smooth, cinematic duration (1600ms total)
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // -------------------------------------------------------------------------
    // Phase 1 (0ms - 400ms / 0.0 -> 0.25):
    // Button shrinks from width 216 to 48 (circular ball), shifts right by +84px, text fades out
    // -------------------------------------------------------------------------
    _buttonWidthAnimation = Tween<double>(
      begin: 216.0,
      end: 48.0,
    ).animate(
      CurvedAnimation(
        parent: _morphController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOutCubic),
      ),
    );

    _buttonShiftAnimation = Tween<double>(
      begin: 0.0,
      end: 84.0,
    ).animate(
      CurvedAnimation(
        parent: _morphController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOutCubic),
      ),
    );

    _buttonTextFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _morphController,
        curve: const Interval(0.0, 0.12, curve: Curves.easeOut),
      ),
    );

    // -------------------------------------------------------------------------
    // Phase 2 (360ms - 600ms / 0.22 -> 0.38):
    // Anticipation Pulse - the ball breathes with a radiant glow halo
    // -------------------------------------------------------------------------
    _ballPulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 22, // 0.0 -> 0.22
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 8, // 0.22 -> 0.30
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.18, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 8, // 0.30 -> 0.38
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 62, // 0.38 -> 1.0
      ),
    ]).animate(_morphController);

    // -------------------------------------------------------------------------
    // Phase 3 (560ms - 1520ms / 0.35 -> 0.95):
    // Luxurious Radial Expansion across the screen with radiant energy rim
    // -------------------------------------------------------------------------
    _expandRadiusAnimation = Tween<double>(
      begin: 24.0,
      end: 1600.0,
    ).animate(
      CurvedAnimation(
        parent: _morphController,
        curve: const Interval(0.35, 0.95, curve: Curves.easeInOutCubic),
      ),
    );
  }

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _onGetStartedPressed();
    }
  }

  void _onGetStartedPressed() {
    if (_isMorphing) return;

    final renderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final buttonTopLeft = renderBox.localToGlobal(Offset.zero);
      _circleCenter = Offset(
        buttonTopLeft.dx + renderBox.size.width - 24.0,
        buttonTopLeft.dy + renderBox.size.height / 2.0,
      );
    } else {
      final size = MediaQuery.sizeOf(context);
      _circleCenter = Offset(size.width * 0.5 + 84.0, size.height - 48.0);
    }

    setState(() {
      _isMorphing = true;
    });

    _morphController.forward().then((_) {
      if (mounted) {
        _finish();
      }
    });
  }

  void _finish() {
    if (widget.onFinished != null) {
      widget.onFinished!();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildFigmaStyledTitle(String title, double scale) {
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

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;

    // Scale smoothly based on Figma 844 reference height (never overflow on small screens)
    final scale = (screenHeight / 844.0).clamp(0.85, 1.0);

    final cardMaxHeight = 417.0 * scale;
    final gapCardToTitle = 38.0 * scale;
    final gapTitleToBody = 17.0 * scale;
    final gapBodyToBottom = 39.0 * scale;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // -------------------------------------------------------------------
          // 0. Figma Soft Ambient Ellipses Background
          // -------------------------------------------------------------------
          Positioned(
            left: -120,
            top: -40,
            child: Container(
              width: 297,
              height: 297,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.45),
              ),
            ),
          ),
          Positioned(
            right: -100,
            top: screenHeight * 0.45,
            child: Container(
              width: 297,
              height: 297,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.35),
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // 1. Main Page Content
          // -------------------------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),

                              // -----------------------------------------------
                              // Illustration Card with Top-Right Notch Cutout
                              // -----------------------------------------------
                              Center(
                                child: Container(
                                  constraints: BoxConstraints(maxHeight: cardMaxHeight),
                                  child: AspectRatio(
                                    aspectRatio: 358 / 417,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        // Card Graphic
                                        Positioned.fill(
                                          child: Image.asset(
                                            page.imagePath,
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
                                        if (_currentIndex < _pages.length - 1)
                                          Positioned(
                                            top: 20 * scale,
                                            right: 24 * scale,
                                            child: GestureDetector(
                                              onTap: _finish,
                                              behavior: HitTestBehavior.opaque,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 6,
                                                ),
                                                child: Text(
                                                  'Skip',
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
                              ),

                              SizedBox(height: gapCardToTitle),

                              // -----------------------------------------------
                              // Headline Title (x: 24, fontSize: 32)
                              // -----------------------------------------------
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: _buildFigmaStyledTitle(page.title, scale),
                              ),

                              SizedBox(height: gapTitleToBody),

                              // -----------------------------------------------
                              // Body Description (x: 24, fontSize: 16)
                              // -----------------------------------------------
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  page.description,
                                  style: GoogleFonts.inter(
                                    fontSize: (16.0 * scale).clamp(14.0, 16.0),
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                    color: const Color(0xA62C2C2C), // rgba(44, 44, 44, 0.65)
                                  ),
                                ),
                              ),

                              SizedBox(height: gapBodyToBottom),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // -------------------------------------------------------------
                // 2. Bottom Navigation Area (Button + Indicators)
                // -------------------------------------------------------------
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 24 * scale),
                  child: _currentIndex < _pages.length - 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // "Next" Button: width: 152, height: 48, radius: 16
                            SizedBox(
                              width: 152,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _onNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003FB8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Next',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Indicators: 3 items (Active: 53x6 pill, Inactive: 6x6 circle)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(_pages.length, (index) {
                                final isActive = index == _currentIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: isActive ? 53 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF003FB8)
                                        : const Color(0xFFCBD5E1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            ),
                          ],
                        )
                      : Center(
                          // Final Screen "Get Started" Button (width: 216, height: 48)
                          // Morphs into a 48px circular ball (Onboarding 4 / Node 67:8416) on tap
                          child: AnimatedBuilder(
                            animation: _morphController,
                            builder: (context, child) {
                              final width = _isMorphing ? _buttonWidthAnimation.value : 216.0;
                              final shift = (_isMorphing ? _buttonShiftAnimation.value : 0.0) * scale;
                              final textOpacity = _isMorphing ? _buttonTextFadeAnimation.value : 1.0;
                              final pulse = _isMorphing ? _ballPulseAnimation.value : 1.0;

                              return Transform.translate(
                                offset: Offset(shift, 0.0),
                                child: Transform.scale(
                                  scale: pulse,
                                  child: Container(
                                    key: _buttonKey,
                                    width: width,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF003FB8),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF003FB8).withValues(alpha: 0.35 * pulse),
                                          blurRadius: 12 * pulse,
                                          offset: const Offset(0, 4),
                                        ),
                                        if (_isMorphing && pulse > 1.02)
                                          BoxShadow(
                                            color: const Color(0xFF6BA4FF).withValues(alpha: 0.45),
                                            blurRadius: 24,
                                            spreadRadius: 2,
                                          ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _isMorphing ? null : _onGetStartedPressed,
                                        borderRadius: BorderRadius.circular(16),
                                        child: Center(
                                          child: textOpacity > 0.01
                                              ? Opacity(
                                                  opacity: textOpacity.clamp(0.0, 1.0),
                                                  child: Text(
                                                    'Get Started',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------------
          // 2. Onboarding 5 Expanding Radial Gradient Wave (Node 67:8473 & 67:8499)
          // The blue ball smoothly expands with a luminous glowing leading edge
          // -------------------------------------------------------------------
          if (_isMorphing)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _morphController,
                builder: (context, child) {
                  if (_expandRadiusAnimation.value <= 24.5) {
                    return const SizedBox.shrink();
                  }
                  return IgnorePointer(
                    child: CustomPaint(
                      painter: OnboardingExpandPainter(
                        center: _circleCenter,
                        radius: _expandRadiusAnimation.value,
                        progress: _morphController.value,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// CustomPainter that renders Figma's expanding radial gradient circle (Node 67:8499 / Onboarding 5)
/// with an aesthetic luminous glowing leading rim expanding from the ball center across the screen.
class OnboardingExpandPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final double progress;

  OnboardingExpandPainter({
    required this.center,
    required this.radius,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (radius <= 0) return;

    // 1. Rich 4-Stop Radial Gradient Fill (Figma Nodes 67:8473 & 67:8499)
    final mainPaint = Paint()
      ..shader = RadialGradient(
        colors: const [
          Color(0xFF0045CA), // Radiant Center
          Color(0xFF003CAF), // Figma Core Blue
          Color(0xFF002C81), // Deep Mid
          Color(0xFF001C52), // Deep Navy Outer Edge
        ],
        stops: const [0.0, 0.35, 0.70, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, mainPaint);

    // 2. Aesthetic Luminous Energy Rim Glow at leading edge
    // Visible while expanding; dissolves smoothly as circle envelopes full screen
    final rimAlpha = (1.0 - (progress - 0.45).clamp(0.0, 0.45) / 0.45).clamp(0.0, 1.0);
    if (rimAlpha > 0.02 && radius > 28.0) {
      // Soft outer neon halo
      final haloPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24.0
        ..color = const Color(0xFF6BA4FF).withValues(alpha: 0.35 * rimAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16.0);
      canvas.drawCircle(center, radius, haloPaint);

      // Fine luminous highlight rim
      final edgePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..color = Colors.white.withValues(alpha: 0.70 * rimAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawCircle(center, radius, edgePaint);

      // Sharp crisp boundary
      final crispPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = Colors.white.withValues(alpha: 0.90 * rimAlpha);
      canvas.drawCircle(center, radius, crispPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OnboardingExpandPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.center != center ||
        oldDelegate.progress != progress;
  }
}
