import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/diagnostics/presentation/pages/report_summary_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/workshops/presentation/pages/service_centers_page.dart';
import '../../injection_container.dart' as di;
import '../services/app_preferences.dart';
import 'app_routes.dart';

/// Centralized Declarative Route Registry for OBD Vision
/// Maps authentic application flows to real Figma pages with zero placeholder screens.
class AppRouter {
  AppRouter._();

  static void navigateAfterSplash(BuildContext context) {
    final hasSeenOnboarding = di.sl.isRegistered<AppPreferences>()
        ? di.sl<AppPreferences>().hasSeenOnboarding
        : false;
    final nextRoute = hasSeenOnboarding ? AppRoutes.signIn : AppRoutes.onboarding;
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  static Map<String, WidgetBuilder> get routes => {
        // --- 1. Splash & Onboarding ---
        AppRoutes.splash: (context) => SplashPage(
              onAnimationComplete: () => navigateAfterSplash(context),
            ),
        AppRoutes.onboarding: (_) => OnboardingPage(
              preferences: di.sl.isRegistered<AppPreferences>()
                  ? di.sl<AppPreferences>()
                  : null,
            ),

        // --- 2. Authentication Flow ---
        AppRoutes.signIn: (_) => BlocProvider(
              create: (_) => di.sl<AuthCubit>(),
              child: const SignInPage(),
            ),

        // --- 3. Core Shell & Main Navigation Tabs ---
        AppRoutes.home: (_) => const HomePage(initialIndex: 0),
        AppRoutes.serviceCentersList: (_) => const HomePage(initialIndex: 1),
        AppRoutes.preCheck: (_) => const HomePage(initialIndex: 2),
        AppRoutes.scan: (_) => const HomePage(initialIndex: 2),
        AppRoutes.activity: (_) => const HomePage(initialIndex: 3),
        AppRoutes.profile: (_) => const HomePage(initialIndex: 4),

        // --- 4. Sub-Screens & Dedicated Flow Views ---
        AppRoutes.reportSummary: (_) => const ReportSummaryPage(),
        AppRoutes.centerDetails: (_) => const ServiceCentersPage(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.splash) {
      return MaterialPageRoute(
        builder: (context) => SplashPage(
          onAnimationComplete: () => navigateAfterSplash(context),
        ),
      );
    }
    if (settings.name == AppRoutes.home && settings.arguments is int) {
      final initialIndex = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => HomePage(initialIndex: initialIndex),
      );
    }
    return null;
  }
}
