import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'presentation/bloc/dashboard_cubit.dart';
import 'presentation/pages/home_cockpit_page.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const ObdDiagnosticApp());
}

class ObdDiagnosticApp extends StatelessWidget {
  const ObdDiagnosticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBD Vision',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Builder(
        builder: (context) {
          return SplashPage(
            onAnimationComplete: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => BlocProvider(
                    create: (_) => di.sl<DashboardCubit>(),
                    child: const HomeCockpitPage(),
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 600),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
