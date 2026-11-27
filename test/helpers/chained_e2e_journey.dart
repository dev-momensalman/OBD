import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';
import 'package:obd_vision/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:obd_vision/features/profile/presentation/bloc/profile_state.dart';
import 'package:obd_vision/main.dart';

/// Polls frame-by-frame until [finder] matches at least one widget.
/// Avoids `pumpAndSettle` timeouts when continuous animations or 10Hz streams run.
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 15),
  Duration step = const Duration(milliseconds: 100),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      await tester.pump(const Duration(milliseconds: 150));
      return;
    }
  }
  await tester.pump();
  expect(finder, findsWidgets,
      reason: 'Timed out after $timeout waiting for $finder');
}

/// Polls until a transient widget such as a [SnackBar] disappears.
Future<void> pumpUntilGone(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 6),
  Duration step = const Duration(milliseconds: 100),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(step);
    if (finder.evaluate().isEmpty) {
      return;
    }
  }
}

/// Pumps [duration] in short steps so periodic streams never hang the test runner.
Future<void> pumpFor(
  WidgetTester tester,
  Duration duration, {
  Duration step = const Duration(milliseconds: 100),
}) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
  }
}

/// Scrolls [finder] up cleanly away from any floating bottom navigation bar
/// before tapping it.
Future<void> scrollAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 100));

  final viewportHeight =
      tester.view.physicalSize.height / tester.view.devicePixelRatio;
  if (tester.getCenter(finder).dy > viewportHeight - 120) {
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      await tester.drag(scrollable.last, const Offset(0, -200));
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  await tester.tap(finder);
}

/// Executes one continuous, state-dependent E2E user journey across the real
/// [ObdVisionApp] without resetting DI or state between steps:
///
/// 1. Splash -> Onboarding -> SignIn -> Home
/// 2. Home -> Profile -> EditProfile -> Profile (verifies edited name persists)
/// 3. Profile -> MyVehicle -> AddVehicle ('Honda Civic 2022') -> Home header sync
/// 4. Home -> Profile -> Language & Units (Arabic + °F) -> Home RTL + °F sync
/// 5. Home ('بدء الفحص') -> Diagnosis -> AI Scan -> ReportSummary -> Causes -> History ('الآن')
/// 6. Profile -> Log out -> SignIn (Arabic) & ProfileCubit cleared
Future<void> runChainedE2eJourney(
  WidgetTester tester, {
  Duration scanTimeout = const Duration(seconds: 25),
  void Function(String source, String explanation)? onReportReceived,
}) async {
  await tester.pumpWidget(const ObdVisionApp());

  // ---------------------------------------------------------------------------
  // STEP 1: Splash -> Onboarding -> Sign In -> Home
  // ---------------------------------------------------------------------------
  await pumpUntilFound(
    tester,
    find.text('Skip'),
    timeout: const Duration(seconds: 10),
  );
  await tester.tap(find.text('Skip'));
  await pumpUntilFound(tester, find.text('Sign in to your Account'));

  final signInFields = find.byType(TextField);
  expect(signInFields, findsAtLeastNWidgets(2));
  await tester.enterText(signInFields.at(0), 'momen@obdvision.app');
  await tester.enterText(signInFields.at(1), 'Password123');
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump(const Duration(milliseconds: 250));

  final termsBox = find.byKey(const ValueKey('terms_checkbox'));
  await tester.ensureVisible(termsBox);
  await tester.tap(termsBox);
  await tester.pump(const Duration(milliseconds: 100));

  final signInBtn = find.widgetWithText(ElevatedButton, 'Sign in');
  await tester.ensureVisible(signInBtn);
  await tester.tap(signInBtn);

  // Wait for mock/auth delay and verify arrival on Home Dashboard
  await pumpUntilFound(
    tester,
    find.text('Corolla 2018'),
    timeout: const Duration(seconds: 10),
  );
  expect(find.text('Run diagnosis'), findsOneWidget);

  // ---------------------------------------------------------------------------
  // STEP 2: Home -> Profile -> Edit Profile -> Verify Updated Name on Profile
  // ---------------------------------------------------------------------------
  await tester.tap(find.byIcon(Icons.person_outline_rounded).first);
  await pumpUntilFound(tester, find.text('Edit profile'));

  await tester.tap(find.text('Edit profile'));
  await pumpUntilFound(tester, find.text('Save'));

  final profileFields = find.byType(TextField);
  await tester.enterText(profileFields.at(0), 'Tarek');
  await tester.enterText(profileFields.at(1), 'Hassan');
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump(const Duration(milliseconds: 250));

  await tester.ensureVisible(find.text('Save'));
  await tester.tap(find.text('Save'));

  // Dependent check: ProfilePage reflects updated name from EditProfilePage
  await pumpUntilFound(tester, find.text('Tarek Hassan'));
  await pumpUntilGone(tester, find.byType(SnackBar));

  // ---------------------------------------------------------------------------
  // STEP 3: Profile -> My Vehicle -> Add 'Honda Civic 2022' -> Verify on Home
  // ---------------------------------------------------------------------------
  await tester.tap(find.text('My vehicle'));
  await pumpUntilFound(tester, find.text('Add Vehicle'));

  await tester.tap(find.text('Add Vehicle'));
  await pumpUntilFound(tester, find.widgetWithText(ElevatedButton, 'Add vehicle'));

  final vehicleFields = find.byType(TextField);
  await tester.enterText(vehicleFields.at(0), 'Honda Civic 2022');
  await tester.enterText(vehicleFields.at(1), 'E2E Test Car');
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump(const Duration(milliseconds: 250));

  final addVehicleCta = find.widgetWithText(ElevatedButton, 'Add vehicle');
  await tester.ensureVisible(addVehicleCta);
  await tester.tap(addVehicleCta);

  // Dependent check 3a: Newly added vehicle appears and becomes Current
  await pumpUntilFound(tester, find.text('Honda Civic 2022'));
  expect(find.text('Current'), findsOneWidget);

  // Navigate back to Profile, then Home tab, and verify HomeHeader updated
  await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded).first);
  await pumpUntilFound(tester, find.text('Tarek Hassan'));
  await tester.tap(find.byIcon(Icons.home_outlined).first);
  await pumpUntilFound(tester, find.text('Run diagnosis'));
  await pumpFor(tester, const Duration(milliseconds: 350));

  // Dependent check 3b: Home Dashboard header synced with VehicleCubit
  expect(find.text('Honda Civic 2022'), findsOneWidget);

  // ---------------------------------------------------------------------------
  // STEP 4: Switch to Arabic + °F -> Verify Whole App RTL & °F Telemetry
  // ---------------------------------------------------------------------------
  await tester.tap(find.byIcon(Icons.person_outline_rounded).first);
  await pumpUntilFound(tester, find.text('Language & units'));
  await pumpFor(tester, const Duration(milliseconds: 300));

  await scrollAndTap(tester, find.text('Language & units'));
  await pumpUntilFound(tester, find.text('العربية'));

  await tester.tap(find.text('العربية'));
  await pumpUntilFound(tester, find.text('اللغة والوحدات'));

  await scrollAndTap(tester, find.text('°F'));
  await pumpFor(tester, const Duration(milliseconds: 200));

  await tester.tap(find.byIcon(Icons.arrow_forward_ios_rounded).first);
  await pumpUntilFound(tester, find.text('حسابي'));
  await tester.tap(find.byIcon(Icons.home_outlined).first);
  await pumpUntilFound(tester, find.text('القراءات الحية'));
  await pumpFor(tester, const Duration(milliseconds: 350));

  // Dependent check 4: Home is now RTL, Arabic labels, °F unit, and keeps 'Honda Civic 2022'
  final homeCtx = tester.element(find.text('القراءات الحية'));
  expect(Directionality.of(homeCtx), TextDirection.rtl);
  expect(find.text('Honda Civic 2022'), findsOneWidget);
  expect(find.textContaining('°F'), findsWidgets);
  expect(find.text('بدء الفحص'), findsOneWidget);

  // ---------------------------------------------------------------------------
  // STEP 5: Run Scan -> AI ReportSummary -> Causes -> Done -> Verify History
  // ---------------------------------------------------------------------------
  await scrollAndTap(tester, find.text('بدء الفحص'));
  await pumpUntilFound(tester, find.text('فحص ما قبل المسح'));
  await pumpFor(tester, const Duration(milliseconds: 300));
  await scrollAndTap(tester, find.text('بدء المسح'));

  // Wait for scan + AI inference (real network or stub)
  await pumpUntilFound(
    tester,
    find.text('عرض تقرير الذكاء الاصطناعي الكامل'),
    timeout: scanTimeout,
  );

  // Inspect live DashboardCubit state produced by the scan
  final diagCtx = tester.element(find.text('عرض تقرير الذكاء الاصطناعي الكامل'));
  final latestReport = diagCtx.read<DashboardCubit>().state.latestReport;
  expect(latestReport, isNotNull);
  onReportReceived?.call(
    latestReport!.diagnosisSource,
    latestReport.plainLanguageExplanation,
  );

  // Navigate to Report Summary (depends on DashboardCubit.latestReport)
  await scrollAndTap(tester, find.text('عرض تقرير الذكاء الاصطناعي الكامل'));
  await pumpUntilFound(tester, find.text('التقرير'));
  expect(find.text('استنتاج احتمالي بالذكاء الاصطناعي'), findsOneWidget);
  expect(find.text(latestReport!.plainLanguageExplanation), findsOneWidget);

  // Switch to Causes tab (depends on same latestReport.rankedCauses)
  await tester.tap(find.text('الأسباب'));
  await pumpUntilFound(tester, find.text('تقدير الذكاء الاصطناعي'));
  await pumpFor(tester, const Duration(milliseconds: 350));
  expect(find.text(latestReport.rankedCauses.first.cause), findsOneWidget);

  // Tap Done ('تم') -> back to Home, then open History tab to verify scan was recorded
  final doneBtn = find.widgetWithText(OutlinedButton, 'تم').last;
  await tester.ensureVisible(doneBtn);
  await tester.tap(doneBtn);
  await pumpUntilFound(tester, find.text('القراءات الحية'));
  await pumpFor(tester, const Duration(milliseconds: 350));

  await tester.tap(find.byIcon(Icons.history_rounded).first);
  await pumpUntilFound(tester, find.text('سجل الفحوصات'));
  await pumpFor(tester, const Duration(milliseconds: 350));

  // Dependent check 5: ActivityHistory contains the scan just completed above
  expect(find.text('الآن'), findsOneWidget);

  // ---------------------------------------------------------------------------
  // STEP 6: Profile -> Log out -> Arabic SignIn & ProfileCubit cleared
  // ---------------------------------------------------------------------------
  await tester.tap(find.byIcon(Icons.person_outline_rounded).first);
  await pumpUntilFound(tester, find.text('Tarek Hassan'));
  await pumpFor(tester, const Duration(milliseconds: 300));

  await scrollAndTap(tester, find.text('تسجيل الخروج'));

  await pumpUntilFound(tester, find.text('تسجيل الدخول إلى حسابك'));
  final signInCtx = tester.element(find.text('تسجيل الدخول إلى حسابك'));
  expect(signInCtx.read<ProfileCubit>().state, isA<ProfileInitial>());
}
