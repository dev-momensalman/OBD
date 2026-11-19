import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/constants/app_router.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/features/diagnostics/presentation/pages/live_data_page.dart';
import 'package:obd_vision/features/diagnostics/presentation/pages/report_causes_page.dart';
import 'package:obd_vision/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:obd_vision/features/profile/presentation/pages/language_units_page.dart';
import 'package:obd_vision/features/profile/presentation/pages/my_device_page.dart';
import 'package:obd_vision/features/profile/presentation/pages/my_vehicle_page.dart';

void main() {
  group('Figma Complete Screen Verification', () {
    testWidgets('LanguageUnitsPage renders language and measurement units',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LanguageUnitsPage(),
        ),
      );

      expect(find.text('Language & Units'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('Units of Measurement'), findsOneWidget);
      expect(find.text('Distance'), findsOneWidget);
      expect(find.text('Temperature'), findsOneWidget);
    });

    testWidgets('EditProfilePage renders fields and save button',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditProfilePage(),
        ),
      );

      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('All data will be encrypted'), findsOneWidget);
    });

    testWidgets('ReportCausesPage renders AI estimate and root causes',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReportCausesPage(),
        ),
      );

      expect(find.text('Report'), findsOneWidget);
      expect(find.text('AI estimate'), findsOneWidget);
      expect(find.text('Ranked by likelihood'), findsOneWidget);
      expect(find.text('Worn spark plug'), findsOneWidget);
      expect(find.text('Faulty ignition coil'), findsOneWidget);
      expect(find.text('Clogged fuel injector'), findsOneWidget);
      expect(find.text('Find service center'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('LiveDataPage renders telemetry cards and action controls',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LiveDataPage(),
        ),
      );

      expect(find.text('Live data'), findsOneWidget);
      expect(find.text('Engine speed'), findsOneWidget);
      expect(find.text('Battery'), findsOneWidget);
      expect(find.text('Short fuel trim'), findsOneWidget);
      expect(find.text('Pause'), findsOneWidget);
      expect(find.text('Run Diagnosis'), findsOneWidget);
    });

    testWidgets('MyVehiclePage and MyDevicePage render successfully',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyVehiclePage(),
        ),
      );
      expect(find.text('My Vehicle'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: MyDevicePage(),
        ),
      );
      expect(find.text('My device'), findsOneWidget);
    });

    test('AppRouter contains all Figma declared routes', () {
      final routes = AppRouter.routes;
      expect(routes.containsKey(AppRoutes.myVehicle), isTrue);
      expect(routes.containsKey(AppRoutes.addVehicle), isTrue);
      expect(routes.containsKey(AppRoutes.editVehicle), isTrue);
      expect(routes.containsKey(AppRoutes.myDevice), isTrue);
      expect(routes.containsKey(AppRoutes.notifications), isTrue);
      expect(routes.containsKey(AppRoutes.helpSupport), isTrue);
      expect(routes.containsKey(AppRoutes.privacyData), isTrue);
      expect(routes.containsKey(AppRoutes.languageUnits), isTrue);
      expect(routes.containsKey(AppRoutes.editProfile), isTrue);
      expect(routes.containsKey(AppRoutes.reportCauses), isTrue);
      expect(routes.containsKey(AppRoutes.liveData), isTrue);
      expect(routes.containsKey(AppRoutes.centerDetails), isTrue);
      expect(routes.containsKey(AppRoutes.bookAppointment), isTrue);
      expect(routes.containsKey(AppRoutes.bookingConfirm), isTrue);
    });
  });
}
