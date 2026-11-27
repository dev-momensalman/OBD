import '../entities/ai_analyze_response.dart';
import '../entities/dtc_fault.dart';
import '../entities/measured_evidence.dart';

/// Domain boundary for remote AI diagnostic analysis.
abstract class IAiDiagnosticGateway {
  Future<AiAnalyzeResponse> analyze({
    required Map<String, dynamic> vehicle,
    required List<DtcFault> dtcs,
    required MeasuredEvidence evidence,
    required String lang,
  });
}
