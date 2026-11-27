import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/ai_analyze_response.dart';
import '../entities/diagnostic_report.dart';
import '../entities/dtc_fault.dart';
import '../entities/measured_evidence.dart';
import '../entities/ranked_cause.dart';
import '../repositories/i_ai_diagnostic_gateway.dart';
import '../repositories/i_obd_repository.dart';
import '../services/rule_engine.dart';

/// Business orchestration use case responsible for executing the AI vehicle health diagnostic pipeline:
/// 1. Fetches raw DTC fault codes and sensor evidence from the OBD repository.
/// 2. Evaluates telemetry against the deterministic Tier-1 [RuleEngine].
/// 3. Optionally queries the remote Hybrid AI Engine (`POST /api/analyze`), falling back gracefully offline.
/// 4. Computes the composite vehicle health score, ranked causes, and epistemic safety metadata.
class RunDiagnosticScanUseCase {
  final IObdRepository _repository;
  final RuleEngine _ruleEngine;
  final IAiDiagnosticGateway? _aiGateway;
  final bool Function() _isArabic;
  final Map<String, dynamic> Function() _vehicleContextProvider;

  const RunDiagnosticScanUseCase({
    required IObdRepository repository,
    RuleEngine ruleEngine = const RuleEngine(),
    IAiDiagnosticGateway? aiGateway,
    bool Function()? isArabic,
    Map<String, dynamic> Function()? vehicleContextProvider,
  })  : _repository = repository,
        _ruleEngine = ruleEngine,
        _aiGateway = aiGateway,
        _isArabic = isArabic ?? _defaultIsArabic,
        _vehicleContextProvider =
            vehicleContextProvider ?? _defaultVehicleContext;

  static bool _defaultIsArabic() => false;

  static Map<String, dynamic> _defaultVehicleContext() => const {
        'make': 'Toyota',
        'model': 'Corolla',
        'year': 2018,
      };

  Future<Result<DiagnosticReport, Failure>> call() async {
    final faultsResult = await _repository.scanActiveFaultCodes();
    if (faultsResult case Err(error: final err)) {
      return Err(err);
    }
    final rawDtcs = (faultsResult as Success<List<DtcFault>, Failure>).data;

    final arabic = _isArabic();
    final dtcs = arabic ? _localizeKnownDtcsArabic(rawDtcs) : rawDtcs;

    final dtcCodes = dtcs.map((d) => d.code).toList();
    final evidenceResult = await _repository.getMeasuredEvidence(dtcCodes);
    if (evidenceResult case Err(error: final err)) {
      return Err(err);
    }
    final evidence = (evidenceResult as Success<MeasuredEvidence, Failure>).data;

    final ruleViolations = _ruleEngine.evaluate(evidence, isArabic: arabic);

    final hasCriticalRule =
        ruleViolations.any((v) => v.severity == DtcSeverity.critical);
    final hasWarningRule =
        ruleViolations.any((v) => v.severity == DtcSeverity.warning);

    var overallSeverity = hasCriticalRule
        ? DtcSeverity.critical
        : (hasWarningRule || dtcs.isNotEmpty)
            ? DtcSeverity.warning
            : DtcSeverity.healthy;

    final healthScore = hasCriticalRule ? 45 : (dtcs.isNotEmpty ? 76 : 98);

    AiAnalyzeResponse? aiResult;
    if (_aiGateway != null) {
      try {
        aiResult = await _aiGateway.analyze(
          vehicle: _vehicleContextProvider(),
          dtcs: dtcs,
          evidence: evidence,
          lang: arabic ? 'ar' : 'en',
        );
        if (aiResult.severityOverride == DtcSeverity.critical) {
          overallSeverity = DtcSeverity.critical;
        }
      } catch (_) {
        aiResult = null;
      }
    }

    final rankedCauses = (aiResult != null && aiResult.rankedCauses.isNotEmpty)
        ? aiResult.rankedCauses
        : (dtcs.isNotEmpty ? _fallbackCauses(arabic) : const <RankedCause>[]);

    final explanation = (aiResult != null && aiResult.summary.isNotEmpty)
        ? aiResult.summary
        : _fallbackExplanation(dtcs.isNotEmpty, arabic);

    final nextSteps = (aiResult != null && aiResult.nextSteps.isNotEmpty)
        ? aiResult.nextSteps
        : _fallbackNextSteps(dtcs.isNotEmpty, arabic);

    final diagnosisSource = aiResult != null
        ? (arabic
            ? 'ذكاء اصطناعي هجين (${aiResult.provider}) + محرك القواعد'
            : 'Hybrid AI (${aiResult.provider}) + RuleEngine')
        : (arabic
            ? 'محرك القواعد المحلي (أوفلاين)'
            : 'Offline RuleEngine Fallback');

    final report = DiagnosticReport(
      id: 'rpt_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      dtcs: dtcs,
      measuredEvidence: evidence,
      overallSeverity: overallSeverity,
      vehicleHealthScore: healthScore,
      plainLanguageExplanation: explanation,
      rankedCauses: rankedCauses,
      recommendedNextAction: nextSteps.first,
      nextSteps: nextSteps,
      safetyWarning: aiResult?.safetyWarning ??
          (ruleViolations.isNotEmpty ? ruleViolations.first.description : null),
      modelLimitations: aiResult?.limitations,
      diagnosisSource: diagnosisSource,
      confidenceScore:
          aiResult?.confidenceScore ?? (dtcs.isNotEmpty ? 0.89 : 0.99),
      minCostUsd: dtcs.isNotEmpty ? 85.0 : 0.0,
      maxCostUsd: dtcs.isNotEmpty ? 165.0 : 0.0,
    );

    return Success(report);
  }

  static List<DtcFault> _localizeKnownDtcsArabic(List<DtcFault> dtcs) {
    const arDescriptions = <String, String>{
      'P0301': 'تقطيع في احتراق الأسطوانة رقم 1',
      'P0171': 'خليط الوقود فقير جداً (بنك 1)',
      'P0420': 'كفاءة المحول الحفاز أقل من الحد المطلوب (بنك 1)',
      'P0562': 'انخفاض جهد نظام الشحن / البطارية',
    };
    const arSystems = <String, String>{
      'Powertrain': 'منظومة الحركة والمحرك',
      'Fuel & Air Metering': 'نظام الوقود والهواء',
    };

    return dtcs
        .map(
          (d) => DtcFault(
            code: d.code,
            system: arSystems[d.system] ?? d.system,
            description: arDescriptions[d.code] ?? d.description,
            severity: d.severity,
          ),
        )
        .toList();
  }

  static List<RankedCause> _fallbackCauses(bool arabic) {
    if (arabic) {
      return const [
        RankedCause(
          cause: 'ضعف أو عطل في موبينة الإشعال (الأسطوانة 1)',
          probability: 0.65,
          description: 'انخفاض مقاومة الملف الابتدائي تحت الحمل.',
        ),
        RankedCause(
          cause: 'تلف أو اتساخ شمعات الاحتراق (البوجيهات)',
          probability: 0.25,
          description: 'اتساع خلوص البوجيه عن المعدل القياسي 1.1 مم.',
        ),
        RankedCause(
          cause: 'انسداد جزئي في رشاش الوقود (البخاخ)',
          probability: 0.10,
          description: 'ضعف ذرية رش الوقود على البنك الأول.',
        ),
      ];
    }
    return const [
      RankedCause(
        cause: 'Ignition Coil Failure (Cylinder 1)',
        probability: 0.65,
        description: 'Primary coil resistance out of specification under load.',
      ),
      RankedCause(
        cause: 'Fouled or Worn Spark Plug',
        probability: 0.25,
        description: 'Electrode gap exceeds standard 1.1mm clearance.',
      ),
      RankedCause(
        cause: 'Clogged Fuel Injector Nozzle',
        probability: 0.10,
        description: 'Partial spray atomization blockage on Bank 1.',
      ),
    ];
  }

  static String _fallbackExplanation(bool hasDtcs, bool arabic) {
    if (arabic) {
      return hasDtcs
          ? 'تم رصد عدم انتظام في الاحتراق بالأسطوانة 1 مع ارتفاع في تصحيح الوقود. يمكن قيادة السيارة بسرعات هادئة مؤقتاً مع التوصية بالفحص القريب.'
          : 'تعمل كافة حساسات المحرك ومنظومة الانبعاثات ضمن الحدود القياسية الطبيعية.';
    }
    return hasDtcs
        ? 'Combustion irregularity detected in Cylinder 1 accompanied by positive fuel trims. '
            'Vehicle remains drivable at moderate speeds, but rapid inspection is advised.'
        : 'All powertrain sensors and emission monitoring systems operate within nominal tolerances.';
  }

  static List<String> _fallbackNextSteps(bool hasDtcs, bool arabic) {
    if (arabic) {
      return hasDtcs
          ? const [
              'بدّل موبينة الأسطوانة 1 مع الأسطوانة 2 وتأكد هل انتقل الكود إلى P0302.'
            ]
          : const [
              'تابع القيادة بشكل طبيعي، وموعد الصيانة الدورية القادم بعد 10,000 كم.'
            ];
    }
    return hasDtcs
        ? const [
            'Swap Cylinder 1 ignition coil with Cylinder 2 and verify if DTC moves to P0302.'
          ]
        : const [
            'Continue normal driving routine. Next preventive maintenance at 10,000 km.'
          ];
  }
}
