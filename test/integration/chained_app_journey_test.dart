import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/ai_analyze_response.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/dtc_fault.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/measured_evidence.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/ranked_cause.dart';
import 'package:obd_vision/features/diagnostics/domain/repositories/i_ai_diagnostic_gateway.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/run_diagnostic_scan_usecase.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:obd_vision/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:obd_vision/injection_container.dart' as di;

import '../helpers/chained_e2e_journey.dart';

/// Contract-verifying AI Gateway used for fast CI E2E runs:
/// captures exact `vehicle` & `lang` forwarded by Steps 3 & 4 so Step 5 fails
/// immediately if prior steps failed to sync `VehicleCubit` or `SettingsCubit`.
class _ChainedContractAiGateway implements IAiDiagnosticGateway {
  Map<String, dynamic>? capturedVehicle;
  String? capturedLang;
  List<String>? capturedDtcs;

  @override
  Future<AiAnalyzeResponse> analyze({
    required Map<String, dynamic> vehicle,
    required List<DtcFault> dtcs,
    required MeasuredEvidence evidence,
    required String lang,
  }) async {
    capturedVehicle = Map<String, dynamic>.from(vehicle);
    capturedLang = lang;
    capturedDtcs = dtcs.map((d) => d.code).toList();

    return AiAnalyzeResponse(
      summary: 'ملخص فحص ذكي لسيارة ${vehicle['make']} ${vehicle['model']} (${vehicle['year']})',
      rankedCauses: const [
        RankedCause(
          cause: 'احتراق غير منتظم في الأسطوانة الأولى',
          probability: 0.89,
          description: 'ارتفاع في قراءات تصحيح الوقود مع رمز P0301.',
        ),
      ],
      nextSteps: const ['فحص البوجيهات والملف الكهربائي للأسطوانة'],
      safetyWarning: 'تجنب القيادة لمسافات طويلة عند اهتزاز المحرك.',
      limitations: 'تقدير احتمالي يعتمد على قراءات OBD-II.',
      confidenceScore: 0.89,
      provider: 'chained-contract-check',
    );
  }
}

void main() {
  testWidgets(
    'Full 6-step chained user journey preserves state from Onboarding to History & Logout',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await di.sl.reset();
      await di.initDependencies(
        preferences: prefs,
        useRealAuth: false,
        useRealAi: false,
      );

      final spyGateway = _ChainedContractAiGateway();
      di.sl.unregister<RunDiagnosticScanUseCase>();
      di.sl.registerLazySingleton<RunDiagnosticScanUseCase>(
        () => RunDiagnosticScanUseCase(
          repository: di.sl(),
          ruleEngine: di.sl(),
          aiGateway: spyGateway,
          isArabic: () => di.sl<SettingsCubit>().state.isArabic,
          vehicleContextProvider: () {
            final vehicle = di.sl<VehicleCubit>().state.activeVehicle!;
            final parts = vehicle.name.trim().split(RegExp(r'\s+'));
            final hasSeparateBrandAndModel =
                parts.length >= 3 && !RegExp(r'^\d{4}$').hasMatch(parts[1]);
            return {
              'make': vehicle.brand,
              'model': hasSeparateBrandAndModel ? parts[1] : parts.first,
              'year': int.tryParse(vehicle.modelYear) ?? 2018,
            };
          },
        ),
      );

      await runChainedE2eJourney(tester);

      // Verify Step 5 actually received Step 3's vehicle ('Honda Civic 2022')
      // and Step 4's language ('ar')!
      expect(spyGateway.capturedLang, 'ar');
      expect(spyGateway.capturedVehicle, {
        'make': 'Honda',
        'model': 'Civic',
        'year': 2022,
      });
      expect(spyGateway.capturedDtcs, isNotEmpty);

      await di.sl.reset();
    },
  );
}
