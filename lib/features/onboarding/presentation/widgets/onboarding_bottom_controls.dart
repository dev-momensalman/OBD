import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'onboarding_page_indicator.dart';

/// Bottom Navigation Area for Onboarding:
/// - Screens 1 & 2: "Next" button (152x48) + indicators (53x6 active pill, 6x6 inactive dots).
/// - Screen 3: "Get Started" button (216x48) morphing into a 48px expanding energy sphere on tap.
class OnboardingBottomControls extends StatelessWidget {
  final bool isLastPage;
  final int pageCount;
  final int currentIndex;
  final double scale;
  final VoidCallback onNext;
  final VoidCallback onGetStarted;
  final GlobalKey buttonKey;
  final bool isMorphing;
  final AnimationController morphController;
  final Animation<double> buttonWidthAnimation;
  final Animation<double> buttonShiftAnimation;
  final Animation<double> buttonTextFadeAnimation;
  final Animation<double> ballPulseAnimation;

  const OnboardingBottomControls({
    super.key,
    required this.isLastPage,
    required this.pageCount,
    required this.currentIndex,
    required this.scale,
    required this.onNext,
    required this.onGetStarted,
    required this.buttonKey,
    required this.isMorphing,
    required this.morphController,
    required this.buttonWidthAnimation,
    required this.buttonShiftAnimation,
    required this.buttonTextFadeAnimation,
    required this.ballPulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 24 * scale),
      child: !isLastPage
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // "Next" Button: width: 152, height: 48, radius: 16
                SizedBox(
                  width: 152,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onNext,
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
                          context.l10n.nextButton,
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
                OnboardingPageIndicator(
                  pageCount: pageCount,
                  currentIndex: currentIndex,
                ),
              ],
            )
          : Center(
              // Final Screen "Get Started" Button (width: 216, height: 48)
              // Morphs into a 48px circular ball (Onboarding 4 / Node 67:8416) on tap
              child: AnimatedBuilder(
                animation: morphController,
                builder: (context, child) {
                  final width = isMorphing ? buttonWidthAnimation.value : 216.0;
                  final shift = (isMorphing ? buttonShiftAnimation.value : 0.0) * scale;
                  final textOpacity = isMorphing ? buttonTextFadeAnimation.value : 1.0;
                  final pulse = isMorphing ? ballPulseAnimation.value : 1.0;

                  return Transform.translate(
                    offset: Offset(shift, 0.0),
                    child: Transform.scale(
                      scale: pulse,
                      child: Container(
                        key: buttonKey,
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
                            if (isMorphing && pulse > 1.02)
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
                            onTap: isMorphing ? null : onGetStarted,
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: textOpacity > 0.01
                                  ? Opacity(
                                      opacity: textOpacity.clamp(0.0, 1.0),
                                      child: Text(
                                        context.l10n.getStartedButton,
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
    );
  }
}
