import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/constants/app_router.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import 'package:obd_vision/features/diagnostics/data/datasources/mock_obd_datasource.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/connection_status.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/dtc_fault.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/measured_evidence.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/telemetry_snapshot.dart';
import 'package:obd_vision/features/diagnostics/domain/repositories/i_obd_repository.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/get_connection_status_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/run_diagnostic_scan_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/stream_live_telemetry_usecase.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';
import 'package:obd_vision/features/diagnostics/presentation/pages/cockpit_hud_page.dart';
import 'package:obd_vision/features/diagnostics/presentation/pages/diagnosis_page.dart';
import 'package:obd_vision/features/home/presentation/widgets/active_workshop_card.dart';
import 'package:obd_vision/features/home/presentation/widgets/cockpit_cluster_view.dart';
import 'package:obd_vision/features/home/presentation/widgets/curved_bottom_nav_bar.dart';
import 'package:obd_vision/features/home/presentation/widgets/home_header.dart';
import 'package:obd_vision/features/home/presentation/widgets/live_telemetry_section.dart';
import 'package:obd_vision/features/home/presentation/widgets/system_health_card.dart';
import 'package:obd_vision/features/profile/presentation/pages/profile_page.dart';
import 'package:obd_vision/features/workshops/presentation/pages/service_centers_page.dart';
import 'package:obd_vision/injection_container.dart' as di;
import 'package:obd_vision/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeObdRepository implements IObdRepository {
  final _telemetryController = StreamController<TelemetrySnapshot>.broadcast();
  final _statusController = StreamController<ConnectionStatus>.broadcast();

  void emitTelemetry(TelemetrySnapshot snapshot) =>
      _telemetryController.add(snapshot);

  void emitStatus(ConnectionStatus status) => _statusController.add(status);

  Future<void> close() async {
    await _telemetryController.close();
    await _statusController.close();
  }

  @override
  Stream<TelemetrySnapshot> streamLiveTelemetry() => _telemetryController.stream;

  @override
  Stream<ConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  Future<Result<List<DtcFault>, Failure>> scanActiveFaultCodes() async =>
      const Success([]);

  @override
  Future<Result<MeasuredEvidence, Failure>> getMeasuredEvidence(
    List<String> detectedDtcs,
  ) async =>
      Success(
        MeasuredEvidence(
          detectedDtcs: const [],
          measuredAt: DateTime.now(),
        ),
      );

  @override
  Future<Result<void, Failure>> toggleConnection({
    required bool usePhysicalBle,
  }) async =>
      const Success(null);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await di.initDependencies();
  });

  tearDown(() {
    if (di.sl.isRegistered<MockObdDataSource>()) {
      di.sl<MockObdDataSource>().stopSimulation();
    }
  });

  testWidgets('HomePage renders all Figma Home sections correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRoutes.home,
        routes: AppRouter.routes,
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 5 core components are mounted
    expect(find.byType(HomeHeader), findsOneWidget);
    expect(find.byType(SystemHealthCard), findsOneWidget);
    expect(find.byType(LiveTelemetrySection), findsOneWidget);
    expect(find.byType(ActiveWorkshopCard), findsOneWidget);
    expect(find.byType(CurvedBottomNavBar), findsOneWidget);

    // Verify Header details
    expect(find.text('Corolla 2018'), findsOneWidget);
    expect(find.text('Connected · OBD-II v2.4'), findsOneWidget);

    // Verify System Health card
    expect(find.text('86'), findsOneWidget);
    expect(find.text('HEALTH'), findsOneWidget);
    expect(find.text('Early Warning'), findsOneWidget);
    expect(find.text('Run diagnosis'), findsOneWidget);

    // Verify Digital Cockpit Telemetry
    expect(find.byType(CockpitClusterView), findsOneWidget);
    expect(find.text('Live Telemetry'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2)); // Speed + Max Speed
    expect(find.text('km/h'), findsNWidgets(2));
    expect(find.text('780'), findsOneWidget);
    expect(find.text('RPM'), findsOneWidget);
    expect(find.text('96'), findsOneWidget);
    expect(find.text('°C'), findsOneWidget);
    expect(find.text('13.8'), findsOneWidget);
    expect(find.text('V'), findsOneWidget);
    expect(find.text('MAX SPEED'), findsOneWidget);
    expect(find.text('DURATION'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('DTC'), findsOneWidget);
    expect(find.text('SIM'), findsOneWidget);

    // Verify Active Workshop Service
    expect(find.text('Active Workshop Service'), findsOneWidget);
    expect(find.text('Repair in progress'), findsOneWidget);
    expect(find.text('Stage 4/5'), findsOneWidget);
    expect(find.textContaining('Al-Nour Service Center'), findsOneWidget);
  });

  testWidgets('Tapping Run diagnosis smoothly switches to DiagnosisPage tab', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRoutes.home,
        routes: AppRouter.routes,
      ),
    );
    await tester.pumpAndSettle();

    final runDiagnosisButton = find.text('Run diagnosis');
    expect(runDiagnosisButton, findsOneWidget);

    await tester.tap(runDiagnosisButton);
    await tester.pumpAndSettle();

    expect(find.byType(DiagnosisPage), findsOneWidget);
    expect(find.text('Check before you scan'), findsOneWidget);
    expect(find.text('Start scan'), findsOneWidget);
    expect(find.text('Watch live data only'), findsOneWidget);
  });

  testWidgets('CurvedBottomNavBar switches between authentic Figma screens', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRoutes.home,
        routes: AppRouter.routes,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    final bottomNav = find.byType(CurvedBottomNavBar);
    expect(bottomNav, findsOneWidget);

    // Tap Service Centers tab (Wrench icon)
    final serviceIconFinder = find.byIcon(Icons.build_outlined);
    expect(serviceIconFinder, findsOneWidget);
    await tester.tap(serviceIconFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ServiceCentersPage), findsOneWidget);
    expect(find.text('Service Centers'), findsOneWidget);
    expect(find.text('Service'), findsOneWidget); // active bottom nav label

    // Tap Profile tab (Person icon)
    final profileIconFinder = find.byIcon(Icons.person_outline_rounded);
    expect(profileIconFinder, findsOneWidget);
    await tester.tap(profileIconFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('momen salman'), findsOneWidget);
    expect(find.text('Profile'), findsWidgets);
  });

  testWidgets('Tapping fullscreen toggle opens CockpitHudPage and returns cleanly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRoutes.home,
        routes: AppRouter.routes,
      ),
    );
    await tester.pumpAndSettle();

    final expandBtn = find.byKey(const ValueKey('cockpit_fullscreen_toggle'));
    expect(expandBtn, findsOneWidget);

    await tester.ensureVisible(expandBtn);
    await tester.tap(expandBtn);
    await tester.pumpAndSettle();

    expect(find.byType(CockpitHudPage), findsOneWidget);
    expect(find.text('Corolla 2018'), findsOneWidget);
    expect(find.byType(CockpitClusterView), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('cockpit_fullscreen_toggle')));
    await tester.pumpAndSettle();

    expect(find.byType(CockpitHudPage), findsNothing);
    expect(find.byType(LiveTelemetrySection), findsOneWidget);
  });

  testWidgets('CockpitClusterView preserves LTR dial geometry under RTL Arabic locale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: CockpitClusterView(
              speedKmH: 85,
              engineRpm: 2450,
              coolantTempC: 92,
              alternatorVoltage: 14.0,
              maxSpeedKmH: 120,
              sessionDuration: Duration(minutes: 4, seconds: 12),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('الحرارة'), findsOneWidget);
    expect(find.text('البطارية'), findsOneWidget);
    expect(find.text('أقصى سرعة'), findsOneWidget);
    expect(find.text('المدة'), findsOneWidget);
    expect(find.text('04:12'), findsOneWidget);

    // Even in Arabic RTL, Speed (85) stays in the left dial and RPM (2450) in the right dial.
    final speedCenter = tester.getCenter(find.text('85'));
    final rpmCenter = tester.getCenter(find.text('2450'));
    expect(speedCenter.dx, lessThan(rpmCenter.dx));
  });

  test('DashboardCubit tracks peak maxSpeedKmH and sessionDuration across snapshots', () async {
    final fakeRepo = _FakeObdRepository();
    final cubit = DashboardCubit(
      streamLiveTelemetryUseCase: StreamLiveTelemetryUseCase(fakeRepo),
      runDiagnosticScanUseCase: RunDiagnosticScanUseCase(repository: fakeRepo),
      getConnectionStatusUseCase: GetConnectionStatusUseCase(fakeRepo),
    );
    addTearDown(() async {
      await cubit.close();
      await fakeRepo.close();
    });

    final t0 = DateTime(2026, 11, 27, 20, 0, 0);
    fakeRepo.emitStatus(ConnectionStatus.connected);
    fakeRepo.emitTelemetry(TelemetrySnapshot(
      engineRpm: 1600,
      vehicleSpeedKmH: 42.0,
      coolantTempC: 88.0,
      batteryVoltage: 14.1,
      engineLoadPercent: 30.0,
      timestamp: t0,
    ));
    fakeRepo.emitTelemetry(TelemetrySnapshot(
      engineRpm: 3200,
      vehicleSpeedKmH: 118.0,
      coolantTempC: 92.0,
      batteryVoltage: 14.2,
      engineLoadPercent: 55.0,
      timestamp: t0.add(const Duration(seconds: 15)),
    ));
    fakeRepo.emitTelemetry(TelemetrySnapshot(
      engineRpm: 2100,
      vehicleSpeedKmH: 65.0,
      coolantTempC: 91.0,
      batteryVoltage: 14.0,
      engineLoadPercent: 35.0,
      timestamp: t0.add(const Duration(seconds: 75)),
    ));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.maxSpeedKmH, 118.0);
    expect(cubit.state.sessionDuration, const Duration(seconds: 75));

    cubit.clearSession();
    expect(cubit.state.maxSpeedKmH, 0.0);
    expect(cubit.state.sessionDuration, Duration.zero);
  });
}
