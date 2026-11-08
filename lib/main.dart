import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/diagnostics/presentation/bloc/dashboard_cubit.dart';
import 'features/diagnostics/presentation/pages/home_cockpit_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBD Vision',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => SplashPage(
              onAnimationComplete: () {},
            ),
        AppRoutes.onboarding: (_) => const OnboardingPage(),
        AppRoutes.home: (_) => BlocProvider(
              create: (_) => di.sl<DashboardCubit>(),
              child: const HomeCockpitPage(),
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.splash) {
          return MaterialPageRoute(
            builder: (context) => SplashPage(
              onAnimationComplete: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
              },
            ),
          );
        }
        return null;
      },
    );
  }
}
