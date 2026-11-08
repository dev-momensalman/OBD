import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';

/// Animated Splash Screen matching the 4-stage sequence in Figma (Nodes 40:2021, 44:7627, 44:7614, 44:7619).
///
/// Sequence:
/// - Stage 1 (0.0 - 0.25): Two gradient blue rectangular slabs meet in the center.
/// - Stage 2 (0.20 - 0.55): Slabs rotate by 24.8° and translate outwards to uncover the core.
/// - Stage 3 (0.40 - 0.75): Center glowing pulse appears, Brand Logo & "OBD Vision" mark scale & fade in.
/// - Stage 4 (0.70 - 1.00): Expansive radial ripple blooms outward before triggering [onAnimationComplete].
class SplashPage extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  final Duration animationDuration;

  const SplashPage({
    super.key,
    this.onAnimationComplete,
    this.animationDuration = const Duration(milliseconds: 2800),
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Rotation & panel shift animations (Stage 1 -> 2 -> 3)
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _leftPanelShiftAnimation;
  late final Animation<double> _rightPanelShiftAnimation;

  // Center elements animation (Stage 3)
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;

  // Radial ripple bloom (Stage 4)
  late final Animation<double> _rippleScaleAnimation;
  late final Animation<double> _rippleFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Panel rotation from 0 to ~24.8 degrees (0.433 rad)
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 24.8 * math.pi / 180,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.50, curve: Curves.easeInOutCubic),
      ),
    );

    // Panel separation outward
    _leftPanelShiftAnimation = Tween<double>(
      begin: 0.0,
      end: -320.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.60, curve: Curves.easeInOutCubic),
      ),
    );

    _rightPanelShiftAnimation = Tween<double>(
      begin: 0.0,
      end: 320.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.60, curve: Curves.easeInOutCubic),
      ),
    );

    // Brand logo fade & scale
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.70, curve: Curves.easeIn),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.75, curve: Curves.easeOutBack),
      ),
    );

    // Brand text fade & slide
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // Ripple bloom (Stage 4)
    _rippleScaleAnimation = Tween<double>(begin: 0.0, end: 3.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 0.98, curve: Curves.easeOutQuad),
      ),
    );

    _rippleFadeAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // -----------------------------------------------------------
              // 1. Sliding & Rotating Gradient Panels (Splash 1 -> 2 -> 3)
              // -----------------------------------------------------------
              // Left Gradient Slab
              Positioned(
                left: -size.width * 0.4 + _leftPanelShiftAnimation.value,
                top: -120,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width * 1.15,
                    height: size.height * 1.35,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          AppColors.brandMedium,
                          AppColors.brandDeepNavy,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.35),
                          offset: const Offset(10, 0),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Right Gradient Slab
              Positioned(
                right: -size.width * 0.4 - _rightPanelShiftAnimation.value,
                top: -120,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width * 1.15,
                    height: size.height * 1.35,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          AppColors.brandDark,
                          AppColors.brandLight,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.35),
                          offset: const Offset(-10, 0),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------
              // 2. Center Expanding Ripple Bloom (Stage 4 / Node 44:7623)
              // -----------------------------------------------------------
              if (_rippleScaleAnimation.value > 0.01)
                Center(
                  child: Opacity(
                    opacity: _rippleFadeAnimation.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: _rippleScaleAnimation.value,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.brandPrimary.withValues(alpha: 0.4),
                            width: 2.0,
                          ),
                          gradient: RadialGradient(
                            colors: [
                              AppColors.brandLight.withValues(alpha: 0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // -----------------------------------------------------------
              // 3. Center Brand Identity & Typography (Stage 3 / Node 44:7614)
              // -----------------------------------------------------------
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Logo Mark with scale and fade
                    FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: Container(
                          width: 140,
                          height: 80,
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppAssets.splashLogoFull,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Elegant fallback if asset file is not ready
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

                    const SizedBox(height: 20),

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
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            children: const [
                              TextSpan(
                                text: 'OBD',
                                style: TextStyle(
                                  color: AppColors.brandPrimary,
                                ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: AppColors.foundationBlack,
                                ),
                              ),
                              TextSpan(
                                text: 'Vision',
                                style: TextStyle(
                                  color: AppColors.foundationBlack,
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
            ],
          );
        },
      ),
    );
  }
}
