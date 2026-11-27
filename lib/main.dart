import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_env.dart';
import 'core/constants/app_router.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/l10n_extensions.dart';
import 'features/auth/domain/entities/auth_session_event.dart';
import 'features/auth/domain/repositories/i_auth_repository.dart';
import 'features/diagnostics/presentation/bloc/dashboard_cubit.dart';
import 'features/history/presentation/bloc/history_cubit.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/settings/presentation/bloc/settings_cubit.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'injection_container.dart' as di;
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: AppEnv.supabaseUrl,
      publishableKey: AppEnv.supabasePublishableKey,
    );
  } catch (e, st) {
    dev.log('Supabase init warning: $e', stackTrace: st, name: 'main');
  }
  await di.initDependencies(
    useRealAi: AppEnv.useRealAi,
    enableTelemetryDemo: true,
  );
  runApp(const ObdVisionApp());
}

class ObdVisionApp extends StatefulWidget {
  const ObdVisionApp({super.key});

  @override
  State<ObdVisionApp> createState() => _ObdVisionAppState();
}

class _RouteTracker extends NavigatorObserver {
  String? currentRouteName;

  void _update(Route<dynamic>? route) {
    if (route?.settings.name != null) {
      currentRouteName = route!.settings.name;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _update(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _update(newRoute);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _update(previousRoute);
}

class _ObdVisionAppState extends State<ObdVisionApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final _RouteTracker _routeTracker = _RouteTracker();
  StreamSubscription<AuthSessionEvent>? _authSub;
  late final SettingsCubit _settingsCubit;
  late final VehicleCubit _vehicleCubit;
  late final bool _ownsSettingsCubit;
  late final bool _ownsVehicleCubit;

  static const Set<String> _authGateRoutes = {
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.signIn,
    AppRoutes.signUp,
    AppRoutes.otpVerification,
    AppRoutes.forgotPassword,
  };

  @override
  void initState() {
    super.initState();

    _ownsSettingsCubit = !di.sl.isRegistered<SettingsCubit>();
    _settingsCubit = _ownsSettingsCubit
        ? SettingsCubit()
        : di.sl<SettingsCubit>();

    _ownsVehicleCubit = !di.sl.isRegistered<VehicleCubit>();
    _vehicleCubit = _ownsVehicleCubit
        ? VehicleCubit()
        : di.sl<VehicleCubit>();

    if (di.sl.isRegistered<IAuthRepository>()) {
      _authSub = di.sl<IAuthRepository>().sessionEvents.listen((event) {
        if (event.kind == AuthSessionKind.passwordRecovery) {
          if (_routeTracker.currentRouteName != AppRoutes.resetPassword) {
            _navigatorKey.currentState?.pushNamed(AppRoutes.resetPassword);
          }
        } else if (event.kind == AuthSessionKind.signedIn &&
            event.user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final current = _routeTracker.currentRouteName;
            if (current != null && _authGateRoutes.contains(current)) {
              _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                AppRoutes.home,
                (route) => false,
              );
            }
          });
        } else if (event.kind == AuthSessionKind.error &&
            event.errorMessage != null) {
          dev.log(event.errorMessage!, name: 'AuthSession');
        }
      });
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    if (_ownsSettingsCubit) {
      _settingsCubit.close();
    }
    if (_ownsVehicleCubit) {
      _vehicleCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providers = <BlocProvider<dynamic>>[
      BlocProvider<SettingsCubit>.value(value: _settingsCubit),
      BlocProvider<VehicleCubit>.value(value: _vehicleCubit),
      if (di.sl.isRegistered<DashboardCubit>())
        BlocProvider<DashboardCubit>(
          create: (_) => di.sl<DashboardCubit>(),
        ),
      if (di.sl.isRegistered<ProfileCubit>())
        BlocProvider<ProfileCubit>(
          create: (_) => di.sl<ProfileCubit>(),
        ),
      if (di.sl.isRegistered<HistoryCubit>())
        BlocProvider<HistoryCubit>(
          create: (_) => di.sl<HistoryCubit>(),
        ),
    ];

    return MultiBlocProvider(
      providers: providers,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            navigatorObservers: [_routeTracker],
            title: 'OBD Vision',
            onGenerateTitle: (ctx) => ctx.l10n.appTitle,
            debugShowCheckedModeBanner: false,
            locale: settingsState.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.darkTheme,
            initialRoute: AppRoutes.splash,
            routes: AppRouter.routes,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
