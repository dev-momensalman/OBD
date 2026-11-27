import 'package:obd_vision/core/network/ai_engine_client.dart';
import '../../domain/entities/ai_analyze_response.dart';
import '../../domain/entities/dtc_fault.dart';
import '../../domain/entities/measured_evidence.dart';
import '../../domain/entities/ranked_cause.dart';
import '../../domain/repositories/i_ai_diagnostic_gateway.dart';

/// Calls `https://obd-ai-engine.vercel.app/api/analyze` with sensor samples
/// and maps the bilingual rule + ML + RAG explanation into pure domain objects,
/// ensuring clean English output when [lang] is `en` even under server mock mode.
class AiDiagnosticRemoteDataSource implements IAiDiagnosticGateway {
  final AiEngineClient _client;

  const AiDiagnosticRemoteDataSource(this._client);

  static final RegExp _arabicRegex = RegExp(r'[\u0600-\u06FF]');

  static bool _containsArabic(String? text) =>
      text != null && _arabicRegex.hasMatch(text);

  static const Map<String, String> _mlClassLabelsEn = {
    'normal': 'Normal operation',
    'catalyst': 'Weak catalytic converter',
    'vacuum_leak': 'Vacuum / air leak',
    'maf_dirty': 'Dirty or faulty MAF sensor',
    'fuel_delivery': 'Fuel delivery issue',
    'o2_slow': 'Slow O2 sensor response',
    'misfire': 'Engine misfire',
    'thermostat': 'Thermostat fault',
    'charging': 'Charging system fault',
    'overheating': 'Engine overheating',
    'egr_fault': 'EGR system fault',
    'evap_leak': 'EVAP system leak',
    'idle_fault': 'Unstable idle control',
    'sensor_circuit': 'Sensor circuit fault',
    'speed_sensor': 'Vehicle speed sensor fault',
  };

  static const Map<String, String> _testStepsEn = {
    'T_COIL_SWAP':
        'Ignition coil swap test: swap the suspect cylinder coil with a neighboring cylinder and check if the misfire code follows.',
    'T_SPARK_PLUG':
        'Inspect spark plugs: check electrode wear, gap clearance, carbon fouling, or insulator cracks.',
    'T_COMPRESSION':
        'Compression test: verify cylinder compression variance stays within 10–15%.',
    'T_INJECTOR':
        'Fuel injector check: measure coil resistance, injector pulse, and spray/balance leak test.',
    'T_SMOKE':
        'Intake smoke test: pressurize intake tract with smoke to inspect gaskets and vacuum hoses for leaks.',
    'T_EXHAUST_LEAK':
        'Exhaust leak check: inspect manifold, flex pipe, and joints ahead of O2 sensors for soot or leaks.',
    'T_TRIM_RPM':
        'Fuel trim RPM comparison: compare STFT+LTFT at idle vs 2,500 RPM to separate vacuum leak from fuel delivery.',
    'T_O2_DOWNSTREAM':
        'Downstream O2 response check: monitor B1S2 activity at 2,500 RPM during fuel enrichment and lean snaps.',
    'T_CAT_TEMP':
        'Catalyst temperature test: measure inlet vs outlet temperature at 2,500 RPM with IR thermometer.',
    'T_MAF_CHECK':
        'MAF sensor check: compare live MAF airflow against calculated expected airflow and clean element if needed.',
    'T_FUEL_PRESSURE':
        'Fuel pressure test: measure static, running, load, and residual hold pressure against factory specs.',
    'T_EVAP_PURGE':
        'EVAP purge valve test: confirm the purge solenoid seals vacuum completely when not commanded open.',
    'T_CHARGING':
        'Charging system test: measure alternator voltage under load and check drive belt & ground straps.',
    'T_BATTERY':
        'Battery health test: load-test battery and clean terminal clamps.',
    'T_COOLANT_LEVEL':
        'Coolant level check (cold engine only): verify reservoir level and inspect for external coolant leaks.',
    'T_COOLING_SYSTEM':
        'Cooling system inspection: verify radiator fan operation, bleed air pockets, and pressure-test cap/hoses.',
    'T_THERMOSTAT':
        'Thermostat check: compare upper and lower radiator hose warm-up temperatures.',
    'T_ECT_SENSOR':
        'ECT sensor verification: compare live ECT reading against infrared scan of thermostat housing.',
  };

  @override
  Future<AiAnalyzeResponse> analyze({
    required Map<String, dynamic> vehicle,
    required List<DtcFault> dtcs,
    required MeasuredEvidence evidence,
    required String lang,
  }) async {
    final sample = <String, dynamic>{
      if (evidence.engineRpm != null) 'rpm': evidence.engineRpm,
      if (evidence.vehicleSpeedKmH != null) 'speed': evidence.vehicleSpeedKmH,
      if (evidence.coolantTempC != null) 'ect': evidence.coolantTempC,
      if (evidence.batteryVoltage != null) 'voltage': evidence.batteryVoltage,
      if (evidence.engineLoadPercent != null)
        'load': evidence.engineLoadPercent,
      if (evidence.shortTermFuelTrimPercent != null)
        'stft': evidence.shortTermFuelTrimPercent,
      if (evidence.longTermFuelTrimPercent != null)
        'ltft': evidence.longTermFuelTrimPercent,
    };

    final payload = {
      'vehicle': vehicle,
      'dtcs': dtcs.map((d) => d.code).toList(),
      // Backend feature extractor requires >=6 samples for idle/coolant features
      'samples': List.generate(6, (_) => Map<String, dynamic>.of(sample)),
      'sample_interval': 0.25,
      'displacement_liters': vehicle['displacement_l'] ?? 1.6,
      'lang': lang,
    };

    final json = await _client.postJson('/api/analyze', data: payload);
    return parseAnalyzeResponse(json, isArabic: lang == 'ar');
  }

  /// Pure parsing helper exposed for deterministic unit testing.
  static AiAnalyzeResponse parseAnalyzeResponse(
    Map<String, dynamic> json, {
    required bool isArabic,
  }) {
    final explanation =
        json['explanation'] as Map<String, dynamic>? ?? const {};
    final ml = json['ml'] as Map<String, dynamic>? ?? const {};
    final ruleFindings = json['rule_findings'] as List<dynamic>? ?? const [];
    final retrieved = json['retrieved'] as List<dynamic>? ?? const [];
    final evidenceIds =
        json['evidence_ids'] as Map<String, dynamic>? ?? const {};
    final meta = explanation['_meta'] as Map<String, dynamic>? ?? const {};

    final retrievedByCode = <String, Map<String, dynamic>>{};
    for (final doc in retrieved.whereType<Map<String, dynamic>>()) {
      final code = doc['code'] as String?;
      if (code != null && code.isNotEmpty) {
        retrievedByCode[code.toUpperCase()] = doc;
      }
    }

    final ruleById = <String, Map<String, dynamic>>{};
    for (final rule in ruleFindings.whereType<Map<String, dynamic>>()) {
      final ruleId = rule['rule_id'] as String?;
      if (ruleId != null && ruleId.isNotEmpty) {
        ruleById[ruleId] = rule;
      }
    }

    final rawCauses =
        explanation['likely_causes'] as List<dynamic>? ?? const [];
    final mlTopProb = (ml['top_probability'] as num?)?.toDouble();

    final rankedCauses = <RankedCause>[];
    for (var i = 0; i < rawCauses.length; i++) {
      final item = rawCauses[i];
      if (item is! Map<String, dynamic>) continue;
      var title = item['cause'] as String? ?? '';
      var why = item['why'] as String? ?? '';
      final evidenceList =
          (item['evidence'] as List<dynamic>? ?? const []).whereType<String>().toList();

      if (!isArabic && (_containsArabic(title) || _containsArabic(why))) {
        final resolved = _resolveEnglishCause(
          rawTitle: title,
          rawWhy: why,
          evidenceRefs: evidenceList,
          evidenceIds: evidenceIds,
          ruleById: ruleById,
          retrievedByCode: retrievedByCode,
          ml: ml,
        );
        title = resolved.$1;
        why = resolved.$2;
      }

      final likelihood = (item['likelihood'] as String? ?? '').toLowerCase();
      final probability = switch (likelihood) {
        'high' =>
          i == 0 && mlTopProb != null ? mlTopProb.clamp(0.65, 0.96) : 0.85,
        'medium' => 0.55,
        'low' => 0.25,
        _ => mlTopProb ?? 0.50,
      };
      if (title.isNotEmpty) {
        rankedCauses.add(
          RankedCause(
            cause: title,
            probability: probability,
            description: why,
          ),
        );
      }
    }

    final rawSteps = explanation['next_steps'] as List<dynamic>? ?? const [];
    final nextSteps = <String>[];
    for (final stepMap in rawSteps.whereType<Map<String, dynamic>>()) {
      var step = stepMap['step'] as String? ?? '';
      final testId = stepMap['test_id'] as String?;
      if (!isArabic && _containsArabic(step)) {
        if (testId != null && _testStepsEn.containsKey(testId)) {
          step = _testStepsEn[testId]!;
        } else if (testId != null && testId.isNotEmpty) {
          step =
              'Perform diagnostic verification: ${testId.replaceFirst('T_', '').replaceAll('_', ' ').toLowerCase()}.';
        }
      }
      if (step.isNotEmpty) {
        nextSteps.add(step);
      }
    }

    var summary = isArabic
        ? (explanation['summary'] as String? ??
            explanation['summary_en'] as String? ??
            '')
        : (explanation['summary_en'] as String? ??
            explanation['summary'] as String? ??
            '');

    if (!isArabic && _containsArabic(summary)) {
      summary = _buildCleanEnglishSummary(
        json: json,
        ruleFindings: ruleFindings,
        rankedCauses: rankedCauses,
      );
    }

    var safety = isArabic
        ? (explanation['safety'] as String? ??
            explanation['safety_en'] as String?)
        : (explanation['safety_en'] as String? ??
            explanation['safety'] as String?);
    if (!isArabic && _containsArabic(safety)) {
      safety = null;
    }

    var limitations = isArabic
        ? (explanation['limitations'] as String? ??
            explanation['limitations_en'] as String?)
        : (explanation['limitations_en'] as String? ??
            explanation['limitations'] as String?);

    if (!isArabic && _containsArabic(limitations)) {
      limitations = _buildCleanEnglishLimitations(json: json, ml: ml);
    }

    DtcSeverity? severity;
    double confidence = mlTopProb ?? 0.85;
    for (final finding in ruleFindings.whereType<Map<String, dynamic>>()) {
      final sev = (finding['severity'] as String? ?? '').toLowerCase();
      final ruleConf = (finding['confidence'] as num?)?.toDouble();
      if (ruleConf != null && ruleConf > confidence) {
        confidence = ruleConf;
      }
      if (sev == 'critical' || sev == 'high') {
        severity =
            sev == 'critical' ? DtcSeverity.critical : DtcSeverity.warning;
      }
    }

    return AiAnalyzeResponse(
      summary: summary,
      rankedCauses: rankedCauses,
      nextSteps: nextSteps,
      safetyWarning: safety,
      limitations: limitations,
      confidenceScore: confidence.clamp(0.1, 0.99),
      severityOverride: severity,
      provider: meta['provider'] as String? ?? 'hybrid-ai',
    );
  }

  static (String, String) _resolveEnglishCause({
    required String rawTitle,
    required String rawWhy,
    required List<String> evidenceRefs,
    required Map<String, dynamic> evidenceIds,
    required Map<String, Map<String, dynamic>> ruleById,
    required Map<String, Map<String, dynamic>> retrievedByCode,
    required Map<String, dynamic> ml,
  }) {
    String? titleEn;
    String? whyEn;

    for (final ref in evidenceRefs) {
      final ev = evidenceIds[ref];
      if (ev is! Map<String, dynamic>) continue;
      final type = ev['type'] as String? ?? '';

      if (type == 'rule') {
        final ruleId = ev['rule_id'] as String?;
        final ruleMap = ruleId != null ? ruleById[ruleId] : null;
        titleEn ??= (ev['title_en'] as String?) ?? (ruleMap?['title_en'] as String?);
        final ruleEvidence =
            (ev['evidence'] as List<dynamic>? ?? const []).whereType<String>();
        final cleanEvidence =
            ruleEvidence.where((e) => !_containsArabic(e)).toList();
        if (cleanEvidence.isNotEmpty) {
          whyEn ??= 'Confirmed by telemetry/rules: ${cleanEvidence.join(', ')}.';
        } else {
          whyEn ??= 'Confirmed by diagnostic rule evaluation.';
        }
      } else if (type == 'dtc') {
        final code = (ev['code'] as String? ?? '').toUpperCase();
        final kbTitle = retrievedByCode[code]?['title_en'] as String?;
        if (code.isNotEmpty) {
          titleEn ??= kbTitle != null
              ? '$code — $kbTitle'
              : 'Fault code $code common causes';
          whyEn ??=
              'Fault code $code is stored; additional live sensor samples are needed to confirm a single root cause.';
        }
      } else if (type == 'ml') {
        final cls = ev['class'] as String? ?? ml['top_class'] as String? ?? '';
        final label = _mlClassLabelsEn[cls] ?? cls.replaceAll('_', ' ');
        titleEn ??= 'Telemetry pattern matches $label (ML indicator)';
        whyEn ??=
            'Statistical ML match only without a deterministic rule confirmation; verify physically before repair.';
      }
    }

    if (titleEn == null && _containsArabic(rawTitle)) {
      final codeMatch = RegExp(r'\b[PCBU][0-9A-F]{4}\b').firstMatch(rawTitle);
      if (codeMatch != null) {
        final code = codeMatch.group(0)!;
        final kbTitle = retrievedByCode[code]?['title_en'] as String?;
        titleEn = kbTitle != null ? '$code — $kbTitle' : 'Fault code $code';
      } else {
        titleEn = 'Suspected vehicle system fault (verify with scan)';
      }
    }

    if (whyEn == null && _containsArabic(rawWhy)) {
      whyEn = 'Supporting diagnostic evidence requires technician verification.';
    }

    return (
      titleEn ?? rawTitle,
      whyEn ?? rawWhy,
    );
  }

  static String _buildCleanEnglishSummary({
    required Map<String, dynamic> json,
    required List<dynamic> ruleFindings,
    required List<RankedCause> rankedCauses,
  }) {
    final dtcMap = json['dtcs'] as Map<String, dynamic>? ?? const {};
    final stored = (dtcMap['stored'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList();
    final pending = (dtcMap['pending'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList();
    final allDtcs = {...stored, ...pending}.toList();

    final dtcText =
        allDtcs.isNotEmpty ? allDtcs.join(', ') : 'None (sensor-based analysis)';

    String? topFinding;
    for (final r in ruleFindings.whereType<Map<String, dynamic>>()) {
      final t = r['title_en'] as String?;
      if (t != null && t.isNotEmpty && !_containsArabic(t)) {
        topFinding = t;
        break;
      }
    }
    topFinding ??= rankedCauses.isNotEmpty
        ? rankedCauses.first.cause
        : 'Telemetry and rule evaluation complete';

    return 'DTCs read: $dtcText. Most likely finding based on available evidence: $topFinding.';
  }

  static String _buildCleanEnglishLimitations({
    required Map<String, dynamic> json,
    required Map<String, dynamic> ml,
  }) {
    final missing = (ml['missing_features'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList();
    final labelsEn =
        json['feature_labels_en'] as Map<String, dynamic>? ?? const {};

    const base =
        'ML model is trained on simulated data; its results are supporting evidence only.';
    if (missing.isEmpty) return base;

    final readable = missing
        .map((key) => labelsEn[key] as String? ?? key.replaceAll('_', ' '))
        .where((s) => s.isNotEmpty && !_containsArabic(s))
        .take(6)
        .toList();
    if (readable.isEmpty) return base;

    return '$base Unused sensors: ${readable.join(', ')}.';
  }
}
