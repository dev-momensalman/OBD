import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_routes.dart';
import 'core/services/app_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/diagnostics/presentation/bloc/dashboard_cubit.dart';
import 'features/diagnostics/presentation/pages/home_cockpit_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const ObdVisionApp());
}

class ObdVisionApp extends StatelessWidget {
  const ObdVisionApp({super.key});

  void _navigateAfterSplash(BuildContext context) {
    final hasSeenOnboarding = di.sl.isRegistered<AppPreferences>()
        ? di.sl<AppPreferences>().hasSeenOnboarding
        : false;
    final nextRoute = hasSeenOnboarding ? AppRoutes.signIn : AppRoutes.onboarding;
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBD Vision',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => SplashPage(
              onAnimationComplete: () => _navigateAfterSplash(context),
            ),
        AppRoutes.onboarding: (_) => OnboardingPage(
              preferences: di.sl.isRegistered<AppPreferences>()
                  ? di.sl<AppPreferences>()
                  : null,
            ),
        AppRoutes.signIn: (_) => BlocProvider(
              create: (_) => di.sl<AuthCubit>(),
              child: const SignInPage(),
            ),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.scan: (_) => BlocProvider(
              create: (_) => di.sl<DashboardCubit>(),
              child: const HomeCockpitPage(),
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.splash) {
          return MaterialPageRoute(
            builder: (context) => SplashPage(
              onAnimationComplete: () => _navigateAfterSplash(context),
            ),
          );
        }
        return null;
      },
    );
  }
}
