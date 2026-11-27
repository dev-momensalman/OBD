import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/workshops/presentation/utils/service_center_l10n.dart';
import 'package:obd_vision/features/diagnostics/presentation/widgets/dashboard_cubit_scope.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:obd_vision/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../injection_container.dart' as di;
import '../../../diagnostics/presentation/bloc/dashboard_cubit.dart';
import '../../../diagnostics/presentation/bloc/dashboard_state.dart';
import '../../../diagnostics/presentation/pages/cockpit_hud_page.dart';
import '../../../diagnostics/presentation/pages/diagnosis_page.dart';
import '../../../history/presentation/pages/activity_history_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../workshops/presentation/pages/service_centers_page.dart';
import '../widgets/active_workshop_card.dart';
import '../widgets/curved_bottom_nav_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/live_telemetry_section.dart';
import '../widgets/system_health_card.dart';

/// Authentic Root Home & Navigation Shell matching Figma Node 274:983 & Component 2
/// Hosts the 5 core application tabs connected to Clean Architecture DashboardCubit:
/// [0] Home Dashboard
/// [1] Service Centers & Workshops
/// [2] Diagnosis & Scan
/// [3] Activity & History
/// [4] Profile & Settings
class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentNavIndex;

  @override
  void initState() {
    super.initState();
    _currentNavIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    if (_currentNavIndex != index) {
      setState(() {
        _currentNavIndex = index;
      });
    }
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeDashboard();
      case 1:
        return ServiceCentersPage(onBack: () => _onNavTap(0));
      case 2:
        return DiagnosisPage(onBack: () => _onNavTap(0));
      case 3:
        return ActivityHistoryPage(onBack: () => _onNavTap(0));
      case 4:
        return ProfilePage(onBack: () => _onNavTap(0));
      default:
        return _buildHomeDashboard();
    }
  }

  String _activeVehicleName(BuildContext context) {
    try {
      final current = context.watch<VehicleCubit>().state.activeVehicle;
      if (current != null) return current.name;
    } catch (_) {}
    if (di.sl.isRegistered<VehicleCubit>()) {
      return di.sl<VehicleCubit>().state.activeVehicle?.name ?? 'Corolla 2018';
    }
    return 'Corolla 2018';
  }

  String _activeDistanceUnit(BuildContext context) {
    try {
      return context.watch<SettingsCubit>().state.distanceUnit;
    } catch (_) {}
    if (di.sl.isRegistered<SettingsCubit>()) {
      return di.sl<SettingsCubit>().state.distanceUnit;
    }
    return 'km';
  }

  String _activeTempUnit(BuildContext context) {
    try {
      return context.watch<SettingsCubit>().state.tempUnit;
    } catch (_) {}
    if (di.sl.isRegistered<SettingsCubit>()) {
      return di.sl<SettingsCubit>().state.tempUnit;
    }
    return '°C';
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCubitScope(
      create: () => di.sl.isRegistered<DashboardCubit>()
          ? di.sl<DashboardCubit>()
          : DashboardCubit(
              streamLiveTelemetryUseCase: di.sl(),
              runDiagnosticScanUseCase: di.sl(),
              getConnectionStatusUseCase: di.sl(),
            ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Stack(
          children: [
            // 1. Smooth Animated Tab Content Transition
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(_currentNavIndex),
                  child: _buildCurrentTab(),
                ),
              ),
            ),

            // 2. Persistent Authentic Animated Figma Curved Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CurvedBottomNavBar(
                selectedIndex: _currentNavIndex,
                onTap: _onNavTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeDashboard() {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final telemetry = state.telemetry;
        final rpm = telemetry?.engineRpm.toInt() ?? 780;
        final coolant = telemetry?.coolantTempC ?? 96.0;
        final voltage = telemetry?.batteryVoltage ?? 13.8;
        final isConnected = state.isConnected;
        final healthScore = state.latestReport?.vehicleHealthScore ?? 86;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Vehicle Header (Corolla 2018 + Dynamic OBD-II connection status)
              HomeHeader(
                vehicleName: _activeVehicleName(context),
                connectionText: isConnected
                    ? context.l10n.connectedObdLabel
                    : context.l10n.connectingObdLabel,
                isConnected: isConnected,
                onVehicleTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.myVehicle);
                },
                onBluetoothTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.myDevice);
                },
                onNotificationsTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.notifications);
                },
              ),
              const SizedBox(height: 16),

              // 2. System Health & Alert Card (Calculated from RuleEngine)
              SystemHealthCard(
                healthScore: healthScore,
                warningTitle: (state.latestReport != null &&
                        state.latestReport!.dtcs.isNotEmpty)
                    ? state.latestReport!.dtcs.first.description
                    : context.l10n.defaultWarningTitle,
                warningSubtitle: context.l10n.defaultWarningSubtitle,
                onRunDiagnosis: () {
                  _onNavTap(2);
                },
                onSeeDetails: () {
                  Navigator.of(context).pushNamed(AppRoutes.reportSummary);
                },
              ),
              const SizedBox(height: 20),

              // 3. Live Dynamic Digital Cockpit Cluster (10Hz StreamLiveTelemetryUseCase)
              LiveTelemetrySection(
                speedKmH: telemetry?.vehicleSpeedKmH ?? 0.0,
                engineRpm: rpm,
                coolantTemp: coolant,
                tempUnit: _activeTempUnit(context),
                distanceUnit: _activeDistanceUnit(context),
                alternatorVoltage: voltage,
                maxSpeedKmH: state.maxSpeedKmH,
                sessionDuration: state.sessionDuration,
                isConnected: isConnected,
                isSimulated: state.isSimulatedMode,
                dtcCount: state.latestReport?.dtcs.length ?? 0,
                onSeeAll: () {
                  Navigator.of(context).pushNamed(AppRoutes.liveData);
                },
                onOpenFullscreen: () {
                  final dashboardCubit = context.read<DashboardCubit>();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BlocProvider<DashboardCubit>.value(
                        value: dashboardCubit,
                        child: const CockpitHudPage(),
                      ),
                    ),
                  );
                },
                onDtcTap: () {
                  if (state.latestReport != null) {
                    Navigator.of(context).pushNamed(
                      AppRoutes.reportSummary,
                      arguments: state.latestReport,
                    );
                  } else {
                    _onNavTap(2);
                  }
                },
              ),
              const SizedBox(height: 20),

              // 4. Active Workshop Service
              Builder(
                builder: (context) {
                  Map<String, dynamic>? booking;
                  if (di.sl.isRegistered<AppPreferences>()) {
                    final raw = di.sl<AppPreferences>().savedActiveBookingJson;
                    if (raw != null && raw.isNotEmpty) {
                      try {
                        booking = jsonDecode(raw) as Map<String, dynamic>;
                      } catch (_) {}
                    }
                  }
                  final centerName = booking?['centerName'] as String?;
                  final schedule = booking?['schedule'] as String?;
                  return ActiveWorkshopCard(
                    statusText: context.l10n.repairInProgress,
                    stageText: context.l10n.stageLabel,
                    centerName: centerName != null
                        ? ServiceCenterL10n.name(context, centerName)
                        : context.l10n.defaultCenterName,
                    serviceType: schedule ?? context.l10n.defaultServiceType,
                    onTrack: () {
                      _onNavTap(1);
                    },
                  );
                },
              ),

              const SizedBox(height: 120),
            ],
          ),
        );
      },
    );
  }
}
