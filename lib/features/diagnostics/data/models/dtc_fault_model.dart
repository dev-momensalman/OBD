import '../../domain/entities/dtc_fault.dart';

class DtcFaultModel extends DtcFault {
  const DtcFaultModel({
    required super.code,
    required super.system,
    required super.description,
    required super.severity,
  });

  factory DtcFaultModel.fromJson(Map<String, dynamic> json) {
    return DtcFaultModel(
      code: json['code'] as String,
      system: json['system'] as String,
      description: json['description'] as String,
      severity: DtcSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => DtcSeverity.info,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'system': system,
        'description': description,
        'severity': severity.name,
      };

  DtcFault toEntity() => DtcFault(
        code: code,
        system: system,
        description: description,
        severity: severity,
      );
}
