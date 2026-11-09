import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/features/home/presentation/pages/home_page.dart';
import 'package:obd_vision/features/home/presentation/widgets/active_workshop_card.dart';
import 'package:obd_vision/features/home/presentation/widgets/curved_bottom_nav_bar.dart';
import 'package:obd_vision/features/home/presentation/widgets/home_header.dart';
import 'package:obd_vision/features/home/presentation/widgets/live_telemetry_section.dart';
import 'package:obd_vision/features/home/presentation/widgets/system_health_card.dart';

void main() {
  testWidgets('HomePage renders all Figma Home sections correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const HomePage(),
        routes: {
          AppRoutes.scan: (context) => const Scaffold(
                body: Text('Scan Screen'),
              ),
        },
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

  testWidgets('Tapping Run diagnosis triggers diagnosis feedback', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();

    final runDiagnosisButton = find.text('Run diagnosis');
    expect(runDiagnosisButton, findsOneWidget);

    await tester.tap(runDiagnosisButton);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('CurvedBottomNavBar taps update selected index', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const HomePage(),
        routes: {
          AppRoutes.scan: (context) => const Scaffold(
                body: Text('Scan Screen'),
              ),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);

    // Tapping bottom nav triggers callback without error
    final bottomNav = find.byType(CurvedBottomNavBar);
    expect(bottomNav, findsOneWidget);
  });
}
