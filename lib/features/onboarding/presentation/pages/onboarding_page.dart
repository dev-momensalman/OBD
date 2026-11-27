import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/core/constants/app_assets.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/features/onboarding/domain/models/onboarding_model.dart';
import 'package:obd_vision/injection_container.dart' as di;

import '../widgets/onboarding_bottom_controls.dart';
import '../widgets/onboarding_card.dart';
import '../widgets/onboarding_expand_painter.dart';
import '../widgets/onboarding_title.dart';

export '../widgets/onboarding_expand_painter.dart';

/// Pixel-Perfect Onboarding Screen strictly matching the Figma specification
/// (Nodes: 52:8041, 61:8289, 61:8321 on Canvas 390x844).
class OnboardingPage extends StatefulWidget {
  final VoidCallback? onFinished;
  final AppPreferences? preferences;

  const OnboardingPage({
    super.key,
    this.onFinished,
    this.preferences,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final GlobalKey _buttonKey = GlobalKey();
  int _currentIndex = 0;

  // Figma Morph & Expand Animation (Nodes 67:8416 & 67:8499)
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
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _buttonWidthAnimation = Tween<double>(begin: 216.0, end: 48.0).animate(
      CurvedAnimation(
        parent: _morphController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOutCubic),
      ),
    );

    _buttonShiftAnimation = Tween<double>(begin: 0.0, end: 84.0).animate(
      CurvedAnimation(
        parent: _morphController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOutCubic),
      ),
    );

    _buttonTextFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _morphController,
        curve: const Interval(0.0, 0.12, curve: Curves.easeOut),
      ),
    );

    _ballPulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 22),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.18).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.18, end: 1.0).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 8,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 62),
    ]).animate(_morphController);

    _expandRadiusAnimation = Tween<double>(begin: 24.0, end: 1600.0).animate(
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
    final prefs = widget.preferences ??
        (di.sl.isRegistered<AppPreferences>() ? di.sl<AppPreferences>() : null);
    prefs?.setHasSeenOnboarding(true);

    if (widget.onFinished != null) {
      widget.onFinished!();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final scale = (screenHeight / 844.0).clamp(0.85, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Background Soft Ellipses
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

          // Main Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
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
                              OnboardingCard(
                                imagePath: page.imagePath,
                                showSkip: _currentIndex < _pages.length - 1,
                                onSkip: _finish,
                                scale: scale,
                                maxHeight: 417.0 * scale,
                              ),
                              SizedBox(height: 38.0 * scale),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: OnboardingTitle(
                                  title: [
                                    context.l10n.onboarding1Title,
                                    context.l10n.onboarding2Title,
                                    context.l10n.onboarding3Title,
                                  ][index],
                                  scale: scale,
                                ),
                              ),
                              SizedBox(height: 17.0 * scale),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  [
                                    context.l10n.onboarding1Desc,
                                    context.l10n.onboarding2Desc,
                                    context.l10n.onboarding3Desc,
                                  ][index],
                                  style: GoogleFonts.inter(
                                    fontSize: (16.0 * scale).clamp(14.0, 16.0),
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                    color: const Color(0xA62C2C2C),
                                  ),
                                ),
                              ),
                              SizedBox(height: 39.0 * scale),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                OnboardingBottomControls(
                  isLastPage: _currentIndex == _pages.length - 1,
                  pageCount: _pages.length,
                  currentIndex: _currentIndex,
                  scale: scale,
                  onNext: _onNext,
                  onGetStarted: _onGetStartedPressed,
                  buttonKey: _buttonKey,
                  isMorphing: _isMorphing,
                  morphController: _morphController,
                  buttonWidthAnimation: _buttonWidthAnimation,
                  buttonShiftAnimation: _buttonShiftAnimation,
                  buttonTextFadeAnimation: _buttonTextFadeAnimation,
                  ballPulseAnimation: _ballPulseAnimation,
                ),
              ],
            ),
          ),

          // Expanding Radial Gradient Wave
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
