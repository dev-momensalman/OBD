import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/constants/app_router.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/features/diagnostics/presentation/pages/diagnosis_page.dart';
import 'package:obd_vision/features/home/presentation/widgets/active_workshop_card.dart';
import 'package:obd_vision/features/home/presentation/widgets/curved_bottom_nav_bar.dart';
import 'package:obd_vision/features/home/presentation/widgets/home_header.dart';
import 'package:obd_vision/features/home/presentation/widgets/live_telemetry_section.dart';
import 'package:obd_vision/features/home/presentation/widgets/system_health_card.dart';
import 'package:obd_vision/features/profile/presentation/pages/profile_page.dart';
import 'package:obd_vision/features/workshops/presentation/pages/service_centers_page.dart';
import 'package:obd_vision/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await di.initDependencies();
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

    // Verify Live Telemetry
    expect(find.text('Live Telemetry'), findsOneWidget);
    expect(find.text('780'), findsOneWidget);
    expect(find.text('RPM'), findsOneWidget);
    expect(find.text('96'), findsOneWidget);
    expect(find.text('°C'), findsOneWidget);
    expect(find.text('13.8'), findsOneWidget);
    expect(find.text('V'), findsOneWidget);

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
    expect(find.text('youssefgad_26'), findsOneWidget);
    expect(find.text('Profile'), findsWidgets);
  });
}
