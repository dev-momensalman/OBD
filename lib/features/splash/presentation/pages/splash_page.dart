import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../widgets/splash_branding.dart';
import '../widgets/splash_bloom_wave.dart';
import '../widgets/splash_panels_painter.dart';

// Export SplashPanelsPainter for widget tests backward-compatibility
export '../widgets/splash_panels_painter.dart';

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
  final bool enableSound;

  const SplashPage({
    super.key,
    this.onAnimationComplete,
    this.animationDuration = const Duration(milliseconds: 4200),
    this.enableSound = true,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  AudioPlayer? _audioPlayer;

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
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 28),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 12),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 40),
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

    // Brand logo scale (0.52 - 0.80)
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

    // Typography fade & slide (0.60 - 0.84)
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.84, curve: Curves.easeIn),
      ),
    );

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

    if (widget.enableSound) {
      _playStartupSound();
    }

    _controller.forward();
  }

  Future<void> _playStartupSound() async {
    try {
      _audioPlayer = AudioPlayer();
      await _audioPlayer?.setVolume(1.0);
      try {
        await _audioPlayer?.play(AssetSource('sounds/car_startup.mp3'));
      } catch (_) {
        await _audioPlayer?.play(AssetSource('1109.MP3'));
      }
    } catch (e) {
      debugPrint('Startup audio playback notice: $e');
    }
  }

  void _handleComplete() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    try {
      _audioPlayer?.stop();
    } catch (_) {}
    widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    try {
      _audioPlayer?.stop();
      _audioPlayer?.dispose();
    } catch (_) {}
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
                // 0. Base Light Canvas
                const ColoredBox(color: Color(0xFFDDDDDD)),

                // 1. Center Brand Identity & Typography
                SplashBranding(
                  logoFadeAnimation: _logoFadeAnimation,
                  logoScaleAnimation: _logoScaleAnimation,
                  textFadeAnimation: _textFadeAnimation,
                  textSlideAnimation: _textSlideAnimation,
                ),

                // 2. Stage 4: Radial Pulse Shockwave Bloom
                SplashBloomWave(
                  bloomScaleAnimation: _bloomScaleAnimation,
                  bloomFadeAnimation: _bloomFadeAnimation,
                ),

                // 3. Stage 1, 2, 3: Mathematical Zero-Gap Custom Painted Panels
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
