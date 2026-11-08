import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_assets.dart';
import 'package:obd_vision/core/constants/app_colors.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/features/onboarding/domain/models/onboarding_model.dart';

/// Pixel-Perfect Onboarding Screen based on Figma Nodes (52:8041, 61:8289, 61:8321, 67:8390, 67:8473)
class OnboardingPage extends StatefulWidget {
  final VoidCallback? onFinished;

  const OnboardingPage({super.key, this.onFinished});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
      title: 'Connect Seamlessly with OBD-II',
      description:
          'Plug into your vehicle’s OBD port and unlock the rich telemetry your car has to tell you.',
      imagePath: AppAssets.onboarding3Illustration,
      buttonText: 'Next',
    ),
    OnboardingModel(
      title: 'Instant Diagnostic Health Scan',
      description:
          'Quickly detect check-engine faults and get actionable mechanical fixes before breakdowns happen.',
      imagePath: AppAssets.onboarding3Illustration,
      buttonText: 'Next',
    ),
    OnboardingModel(
      title: 'Certified Auto Care & Service Centers',
      description:
          'Find top-rated mechanics near you and book maintenance appointments with one tap.',
      imagePath: AppAssets.onboarding5Illustration,
      buttonText: 'Get Started',
    ),
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentIndex < _pages.length - 1)
                    TextButton(
                      onPressed: _finish,
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 48),
                ],
              ),
            ),

            // Main Carousel
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Illustration Container - Responsive flex
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(maxHeight: 340),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
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
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Title & Description Container
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  page.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.25,
                                    color: AppColors.foundationBlack,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  page.description,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Row (Button on Left, Indicators on Right)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Next / Get Started Action Button
                  ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(152, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _pages[_currentIndex].buttonText,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                      ],
                    ),
                  ),

                  // Page Indicators matching Figma: Active = 48x6 pill, Inactive = 6x6 circle
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 48 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.brandPrimary
                              : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
