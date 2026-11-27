import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obd_vision/core/constants/app_router.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/diagnostic_report.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/dtc_fault.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/measured_evidence.dart';
import 'package:obd_vision/features/history/data/datasources/history_remote_datasource.dart';
import 'package:obd_vision/features/history/data/repositories/history_repository_impl.dart';
import 'package:obd_vision/features/history/domain/usecases/get_diagnostic_history_usecase.dart';
import 'package:obd_vision/features/history/presentation/bloc/history_cubit.dart';
import 'package:obd_vision/features/history/presentation/bloc/history_state.dart';
import 'package:obd_vision/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:obd_vision/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:obd_vision/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:obd_vision/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:obd_vision/features/profile/presentation/bloc/profile_state.dart';
import 'package:obd_vision/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:obd_vision/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:obd_vision/injection_container.dart' as di;

void main() {
  group('AppPreferences persistence across cubits', () {
    test('VehicleCubit persists added and active vehicles across restart', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = AppPreferences(sp);

      final cubit1 = VehicleCubit(preferences: prefs);
      cubit1.addVehicle(
        const VehicleEntity(
          id: 'veh_custom',
          name: 'Mazda 3 2023',
          nickname: 'Work car',
          brand: 'Mazda',
          modelYear: '2023',
          fuelType: 'Petrol',
          mileage: '12,000 km',
          plateNumber: '9001 CAI',
          vin: 'JM1BPABL6P1600001',
        ),
      );
      expect(cubit1.state.activeVehicle?.name, 'Mazda 3 2023');
      await cubit1.close();

      final cubit2 = VehicleCubit(preferences: prefs);
      expect(cubit2.state.activeVehicle?.name, 'Mazda 3 2023');

      cubit2.resetForLogout();
      expect(cubit2.state.activeVehicle?.name, 'Corolla 2018');
      await cubit2.close();
    });

    test('ProfileCubit persists profile edits across restart and clears on logout', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = AppPreferences(sp);
      final repo = ProfileRepositoryImpl(MockProfileRemoteDataSource());
      final useCase = GetUserProfileUseCase(repo);

      final cubit1 = ProfileCubit(useCase, profileRepository: repo, preferences: prefs);
      await cubit1.updateProfile(
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@obd.cloud',
      );
      await cubit1.close();

      final cubit2 = ProfileCubit(useCase, profileRepository: repo, preferences: prefs);
      await cubit2.fetchProfile();
      expect(cubit2.state, isA<ProfileLoaded>());
      final loaded = cubit2.state as ProfileLoaded;
      expect(loaded.profile.displayName, 'Ahmed Ali');
      expect(loaded.profile.email, 'ahmed@obd.cloud');

      cubit2.clearSession();
      await cubit2.close();
      expect(prefs.savedProfileJson, isNull);
    });

    test('HistoryCubit persists recorded scans across restart and clears on clearSession', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = AppPreferences(sp);
      final repo = HistoryRepositoryImpl(MockHistoryRemoteDataSource());
      final useCase = GetDiagnosticHistoryUseCase(repo);

      final cubit1 = HistoryCubit(useCase, preferences: prefs);
      cubit1.recordScanReport(
        DiagnosticReport(
          id: 'scan_persist_1',
          timestamp: DateTime(2026, 11, 27),
          dtcs: const [
            DtcFault(
              code: 'P0301',
              description: 'Cylinder 1 Misfire',
              system: 'Powertrain',
              severity: DtcSeverity.warning,
            ),
          ],
          measuredEvidence: MeasuredEvidence(
            detectedDtcs: const [],
            coolantTempC: 98,
            batteryVoltage: 13.7,
            engineRpm: 800,
            measuredAt: DateTime(2026, 11, 27),
          ),
          overallSeverity: DtcSeverity.warning,
          vehicleHealthScore: 76,
          plainLanguageExplanation: 'Misfire found',
          rankedCauses: const [],
          recommendedNextAction: 'Check spark plug',
          confidenceScore: 0.9,
          minCostUsd: 20,
          maxCostUsd: 80,
        ),
      );
      await cubit1.close();

      final cubit2 = HistoryCubit(useCase, preferences: prefs);
      await cubit2.fetchHistory();
      final loaded = cubit2.state as HistoryLoaded;
      expect(loaded.logs.any((l) => l.id == 'scan_persist_1'), isTrue);

      cubit2.clearSession();
      expect(prefs.savedHistoryLogsJson, isNull);
      await cubit2.close();
    });

    testWidgets('AppRouter routes directly to Home when cached auth user exists', (tester) async {
      await di.sl.reset();
      SharedPreferences.setMockInitialValues({
        AppPreferences.keyHasSeenOnboarding: true,
        AppPreferences.keyCachedAuthUser:
            '{"id":"usr_saved","email":"saved@obd.cloud","displayName":"Saved User","role":"Customer","token":"tok_1"}',
      });
      await di.initDependencies();
      expect(di.sl<IAuthRepository>().currentUser?.email, 'saved@obd.cloud');

      String? navigatedTo;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => AppRouter.navigateAfterSplash(context),
                child: const Text('Go'),
              ),
            ),
          ),
          routes: {
            AppRoutes.home: (_) {
              navigatedTo = AppRoutes.home;
              return const SizedBox.shrink();
            },
            AppRoutes.signIn: (_) {
              navigatedTo = AppRoutes.signIn;
              return const SizedBox.shrink();
            },
          },
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(navigatedTo, AppRoutes.home);
      await di.sl.reset();
    });
  });
}
