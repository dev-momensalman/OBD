import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/dtc_fault.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/measured_evidence.dart';
import 'package:obd_vision/features/diagnostics/domain/services/rule_engine.dart';

void main() {
  group('RuleEngine Deterministic Safety Checks', () {
    const engine = RuleEngine();

    test('Detects Critical Overheating when Coolant Temp >= 115°C', () {
      final evidence = MeasuredEvidence(
        detectedDtcs: const [],
        coolantTempC: 118.0,
        batteryVoltage: 14.1,
        engineRpm: 2500,
        measuredAt: DateTime.now(),
      );

      final violations = engine.evaluate(evidence);
      expect(violations.length, 1);
      expect(violations.first.ruleName, 'RULE_CRITICAL_OVERHEAT');
      expect(violations.first.severity, DtcSeverity.critical);
    });

    test('Detects Alternator / Charging failure when Voltage < 11.8V while running', () {
      final evidence = MeasuredEvidence(
        detectedDtcs: const [],
        coolantTempC: 90.0,
        batteryVoltage: 11.2,
        engineRpm: 1200,
        measuredAt: DateTime.now(),
      );

      final violations = engine.evaluate(evidence);
      expect(violations.length, 1);
      expect(violations.first.ruleName, 'RULE_CHARGING_SYSTEM_FAIL');
      expect(violations.first.severity, DtcSeverity.warning);
    });

    test('Detects Fuel Trim Drift when LTFT exceeds 20%', () {
      final evidence = MeasuredEvidence(
        detectedDtcs: const [],
        coolantTempC: 88.0,
        batteryVoltage: 14.0,
        engineRpm: 800,
        longTermFuelTrimPercent: 24.5,
        measuredAt: DateTime.now(),
      );

      final violations = engine.evaluate(evidence);
      expect(violations.length, 1);
      expect(violations.first.ruleName, 'RULE_FUEL_TRIM_DRIFT');
      expect(violations.first.severity, DtcSeverity.warning);
    });

    test('Passes with zero violations under normal healthy conditions', () {
      final evidence = MeasuredEvidence(
        detectedDtcs: const [],
        coolantTempC: 90.0,
        batteryVoltage: 14.1,
        engineRpm: 850,
        longTermFuelTrimPercent: 2.1,
        measuredAt: DateTime.now(),
      );

      final violations = engine.evaluate(evidence);
      expect(violations.isEmpty, isTrue);
    });

    test('Returns Arabic findings when isArabic is true and pure English when false', () {
      final arabicRegex = RegExp(r'[\u0600-\u06FF]');
      final evidence = MeasuredEvidence(
        detectedDtcs: const [],
        coolantTempC: 118.0,
        batteryVoltage: 11.2,
        engineRpm: 2000,
        longTermFuelTrimPercent: 25.0,
        measuredAt: DateTime(2026),
      );

      final arViolations = engine.evaluate(evidence, isArabic: true);
      final enViolations = engine.evaluate(evidence, isArabic: false);

      expect(arViolations.length, 3);
      expect(enViolations.length, 3);
      for (final v in arViolations) {
        expect(arabicRegex.hasMatch(v.description), isTrue);
      }
      for (final v in enViolations) {
        expect(arabicRegex.hasMatch(v.description), isFalse);
      }
    });
  });
}
