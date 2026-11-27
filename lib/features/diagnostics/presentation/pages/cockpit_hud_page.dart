import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_state.dart';
import 'package:obd_vision/features/diagnostics/presentation/widgets/dashboard_cubit_scope.dart';
import 'package:obd_vision/features/home/presentation/widgets/cockpit_cluster_view.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_state.dart';
import 'package:obd_vision/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:obd_vision/injection_container.dart' as di;

/// Fullscreen Landscape Digital HUD screen.
/// Reuses an existing [DashboardCubit] when launched from [HomePage] so
/// max speed and session duration persist seamlessly while driving.
class CockpitHudPage extends StatefulWidget {
  const CockpitHudPage({super.key});

  @override
  State<CockpitHudPage> createState() => _CockpitHudPageState();
}

class _CockpitHudPageState extends State<CockpitHudPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _activeVehicleName(BuildContext context) {
    try {
      final active = context.watch<VehicleCubit>().state.activeVehicle;
      if (active != null) return active.name;
    } catch (_) {}
    if (di.sl.isRegistered<VehicleCubit>()) {
      return di.sl<VehicleCubit>().state.activeVehicle?.name ?? 'Corolla 2018';
    }
    return 'Corolla 2018';
  }

  SettingsState _readSettings(BuildContext context) {
    try {
      return context.watch<SettingsCubit>().state;
    } catch (_) {}
    if (di.sl.isRegistered<SettingsCubit>()) {
      return di.sl<SettingsCubit>().state;
    }
    return const SettingsState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = _readSettings(context);
    final vehicleName = _activeVehicleName(context);

    return DashboardCubitScope(
      create: () => di.sl.isRegistered<DashboardCubit>()
          ? di.sl<DashboardCubit>()
          : DashboardCubit(
              streamLiveTelemetryUseCase: di.sl(),
              runDiagnosticScanUseCase: di.sl(),
              getConnectionStatusUseCase: di.sl(),
            ),
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                final telemetry = state.telemetry;
                final speed = telemetry?.vehicleSpeedKmH ?? 0.0;
                final rpm = telemetry?.engineRpm.toInt() ?? 780;
                final coolant = telemetry?.coolantTempC ?? 96.0;
                final voltage = telemetry?.batteryVoltage ?? 13.8;
                final dtcCount = state.latestReport?.dtcs.length ?? 0;

                return Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            context.backIcon,
                            color: Colors.white,
                            size: 18,
                          ),
                          tooltip: context.l10n.cockpitExitFullscreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vehicleName,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.liveData);
                          },
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFF38BDF8),
                            size: 16,
                          ),
                          label: Text(
                            context.l10n.seeAll,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF38BDF8),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: 720,
                            child: CockpitClusterView(
                              speedKmH: speed,
                              engineRpm: rpm,
                              coolantTempC: coolant,
                              alternatorVoltage: voltage,
                              maxSpeedKmH: state.maxSpeedKmH,
                              sessionDuration: state.sessionDuration,
                              tempUnit: settings.tempUnit,
                              distanceUnit: settings.distanceUnit,
                              isConnected: state.isConnected,
                              isSimulated: state.isSimulatedMode,
                              dtcCount: dtcCount,
                              isFullscreen: true,
                              onToggleFullscreen: () =>
                                  Navigator.of(context).pop(),
                              onDtcTap: () {
                                if (state.latestReport != null) {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.reportSummary,
                                    arguments: state.latestReport,
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
