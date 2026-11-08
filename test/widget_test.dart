import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/theme/app_theme.dart';
import 'package:obd_vision/features/diagnostics/data/datasources/mock_obd_datasource.dart';
import 'package:obd_vision/injection_container.dart' as di;
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';
import 'package:obd_vision/features/diagnostics/presentation/pages/home_cockpit_page.dart';

void main() {
  setUp(() async {
    await di.initDependencies();
  });

  tearDown(() async {
    await di.sl.reset();
  });

  testWidgets('Cockpit Dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: BlocProvider(
          create: (_) => di.sl<DashboardCubit>(),
          child: const HomeCockpitPage(),
        ),
      ),
    );
    await tester.pump();

    // Verify Cockpit AppBar and Gauges render
    expect(find.text('OBD-II COCKPIT'), findsOneWidget);
    expect(find.text('TACHOMETER'), findsOneWidget);
    expect(find.text('SPEEDOMETER'), findsOneWidget);
    expect(find.text('RUN DIAGNOSTIC SCAN'), findsOneWidget);

    // Explicitly dispose mock timer before test invariants check
    if (di.sl.isRegistered<MockObdDataSource>()) {
      di.sl<MockObdDataSource>().dispose();
    }
  });
}
