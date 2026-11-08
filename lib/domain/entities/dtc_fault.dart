import 'package:equatable/equatable.dart';

enum DtcSeverity { healthy, info, warning, critical }

class DtcFault extends Equatable {
  final String code;
  final String system;
  final String description;
  final DtcSeverity severity;

  const DtcFault({
    required this.code,
    required this.system,
    required this.description,
    required this.severity,
  });

  @override
  List<Object?> get props => [code, system, description, severity];
}
