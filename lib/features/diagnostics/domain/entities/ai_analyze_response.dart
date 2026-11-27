import 'package:equatable/equatable.dart';
import 'dtc_fault.dart';
import 'ranked_cause.dart';

/// Pure domain DTO representing structured analysis returned by an AI Engine.
class AiAnalyzeResponse extends Equatable {
  final String summary;
  final List<RankedCause> rankedCauses;
  final List<String> nextSteps;
  final String? safetyWarning;
  final String? limitations;
  final double confidenceScore;
  final DtcSeverity? severityOverride;
  final String provider;

  const AiAnalyzeResponse({
    required this.summary,
    required this.rankedCauses,
    required this.nextSteps,
    this.safetyWarning,
    this.limitations,
    required this.confidenceScore,
    this.severityOverride,
    this.provider = 'hybrid-ai',
  });

  @override
  List<Object?> get props => [
        summary,
        rankedCauses,
        nextSteps,
        safetyWarning,
        limitations,
        confidenceScore,
        severityOverride,
        provider,
      ];
}
