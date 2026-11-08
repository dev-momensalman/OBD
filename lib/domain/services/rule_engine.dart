import '../entities/dtc_fault.dart';
import '../entities/measured_evidence.dart';

class RuleViolation {
  final String ruleName;
  final String description;
  final DtcSeverity severity;

  const RuleViolation({
    required this.ruleName,
    required this.description,
    required this.severity,
  });
}

class RuleEngine {
  const RuleEngine();

  /// Evaluates deterministic automotive rules on physical sensor telemetry
  List<RuleViolation> evaluate(MeasuredEvidence evidence) {
    final violations = <RuleViolation>[];

    // Rule 1: Critical Engine Overheating (> 115°C)
    if (evidence.coolantTempC != null && evidence.coolantTempC! >= 115.0) {
      violations.add(const RuleViolation(
        ruleName: 'RULE_CRITICAL_OVERHEAT',
        description: 'Engine coolant exceeds 115°C. Immediate shutdown required to prevent head gasket failure.',
        severity: DtcSeverity.critical,
      ));
    } else if (evidence.coolantTempC != null && evidence.coolantTempC! >= 105.0) {
      violations.add(const RuleViolation(
        ruleName: 'RULE_WARNING_OVERHEAT',
        description: 'Engine coolant elevated above 105°C. Cooling fan or thermostat requires inspection.',
        severity: DtcSeverity.warning,
      ));
    }

    // Rule 2: Alternator / Battery Under-Voltage (< 11.5V while running)
    if (evidence.batteryVoltage != null &&
        evidence.engineRpm != null &&
        evidence.engineRpm! > 600 &&
        evidence.batteryVoltage! < 11.8) {
      violations.add(const RuleViolation(
        ruleName: 'RULE_CHARGING_SYSTEM_FAIL',
        description: 'Battery voltage below 11.8V while engine is running. Charging system / alternator failure.',
        severity: DtcSeverity.warning,
      ));
    }

    // Rule 3: Extreme Long-Term Fuel Trim Drift (> ±20%)
    if (evidence.longTermFuelTrimPercent != null &&
        (evidence.longTermFuelTrimPercent! > 20.0 || evidence.longTermFuelTrimPercent! < -20.0)) {
      violations.add(const RuleViolation(
        ruleName: 'RULE_FUEL_TRIM_DRIFT',
        description: 'Fuel trim exceeding stoichiometric adaptation limits (±20%). Probable vacuum leak or MAF failure.',
        severity: DtcSeverity.warning,
      ));
    }

    return violations;
  }
}
