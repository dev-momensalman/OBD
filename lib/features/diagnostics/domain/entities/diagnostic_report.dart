import 'package:equatable/equatable.dart';
import 'dtc_fault.dart';
import 'measured_evidence.dart';
import 'ranked_cause.dart';

class DiagnosticReport extends Equatable {
  final String id;
  final DateTime timestamp;
  final List<DtcFault> dtcs;
  final MeasuredEvidence measuredEvidence;
  final DtcSeverity overallSeverity;
  final int vehicleHealthScore;
  final String plainLanguageExplanation;
  final List<RankedCause> rankedCauses;
  final String recommendedNextAction;
  final double confidenceScore;
  final double minCostUsd;
  final double maxCostUsd;
  final String? safetyWarning;
  final String? modelLimitations;
  final List<String> nextSteps;
  final String diagnosisSource;
  final String safetyDisclaimer;

  const DiagnosticReport({
    required this.id,
    required this.timestamp,
    required this.dtcs,
    required this.measuredEvidence,
    required this.overallSeverity,
    required this.vehicleHealthScore,
    required this.plainLanguageExplanation,
    required this.rankedCauses,
    required this.recommendedNextAction,
    required this.confidenceScore,
    required this.minCostUsd,
    required this.maxCostUsd,
    this.safetyWarning,
    this.modelLimitations,
    this.nextSteps = const [],
    this.diagnosisSource = 'RuleEngine',
    this.safetyDisclaimer =
        'Diagnostic findings are generated based on available OBD-II telemetry and AI inference models. '
        'They constitute probabilistic guidance and must be validated by a certified automotive technician before part replacement.',
  });

  @override
  List<Object?> get props => [
        id,
        timestamp,
        dtcs,
        measuredEvidence,
        overallSeverity,
        vehicleHealthScore,
        plainLanguageExplanation,
        rankedCauses,
        recommendedNextAction,
        confidenceScore,
        minCostUsd,
        maxCostUsd,
        safetyWarning,
        modelLimitations,
        nextSteps,
        diagnosisSource,
        safetyDisclaimer,
      ];
}
