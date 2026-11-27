import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:obd_vision/core/network/ai_engine_client.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/diagnostics/data/datasources/ai_diagnostic_datasource.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/dtc_fault.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/measured_evidence.dart';

class MockAiEngineClient extends Mock implements AiEngineClient {}

void main() {
  group('AiDiagnosticRemoteDataSource.parseAnalyzeResponse', () {
    final sampleApiPayload = <String, dynamic>{
      'rule_findings': [
        {
          'rule_id': 'RULE_COOLANT_HIGH',
          'severity': 'critical',
          'confidence': 0.94,
        },
      ],
      'ml': {
        'top_probability': 0.88,
      },
      'explanation': {
        '_meta': {'provider': 'gemini'},
        'summary': 'ارتفاع واضح في حرارة المحرك مع خلل في الاحتراق.',
        'summary_en': 'Elevated engine temperature with cylinder misfire.',
        'safety': 'أوقف السيارة في مكان آمن فوراً.',
        'safety_en': 'Pull over safely and shut off the engine.',
        'limitations': 'تقدير احتمالي يعتمد على قراءات OBD المتاحة.',
        'limitations_en': 'Probabilistic estimate from available OBD sensors.',
        'likely_causes': [
          {
            'cause': 'Thermostat stuck closed',
            'likelihood': 'high',
            'why': 'Coolant exceeds 108°C under light load.',
          },
          {
            'cause': 'Ignition coil degradation',
            'likelihood': 'medium',
            'why': 'Intermittent P0301 misfire counts observed.',
          },
        ],
        'next_steps': [
          {'step': 'Inspect coolant reservoir level when cool'},
          {'step': 'Pressure-test cooling system'},
        ],
      },
    };

    test('extracts English fields and overrides severity from critical rule', () {
      final parsed = AiDiagnosticRemoteDataSource.parseAnalyzeResponse(
        sampleApiPayload,
        isArabic: false,
      );

      expect(
        parsed.summary,
        'Elevated engine temperature with cylinder misfire.',
      );
      expect(
        parsed.safetyWarning,
        'Pull over safely and shut off the engine.',
      );
      expect(
        parsed.limitations,
        'Probabilistic estimate from available OBD sensors.',
      );
      expect(parsed.provider, 'gemini');
      expect(parsed.severityOverride, DtcSeverity.critical);
      expect(parsed.confidenceScore, closeTo(0.94, 0.001));
      expect(parsed.rankedCauses.length, 2);
      expect(parsed.rankedCauses.first.cause, 'Thermostat stuck closed');
      expect(parsed.rankedCauses.first.probability, closeTo(0.88, 0.001));
      expect(parsed.nextSteps, [
        'Inspect coolant reservoir level when cool',
        'Pressure-test cooling system',
      ]);
    });

    test('extracts Arabic fields when isArabic is true', () {
      final parsed = AiDiagnosticRemoteDataSource.parseAnalyzeResponse(
        sampleApiPayload,
        isArabic: true,
      );

      expect(
        parsed.summary,
        'ارتفاع واضح في حرارة المحرك مع خلل في الاحتراق.',
      );
      expect(parsed.safetyWarning, 'أوقف السيارة في مكان آمن فوراً.');
      expect(
        parsed.limitations,
        'تقدير احتمالي يعتمد على قراءات OBD المتاحة.',
      );
    });

    test('handles empty/partial JSON gracefully without throwing', () {
      final parsed = AiDiagnosticRemoteDataSource.parseAnalyzeResponse(
        const <String, dynamic>{},
        isArabic: false,
      );

      expect(parsed.summary, isEmpty);
      expect(parsed.rankedCauses, isEmpty);
      expect(parsed.nextSteps, isEmpty);
      expect(parsed.confidenceScore, closeTo(0.85, 0.001));
      expect(parsed.provider, 'hybrid-ai');
    });

    test(
      'sanitizes mixed Arabic mock output into pure English when isArabic is false',
      () {
        final arabicRegex = RegExp(r'[\u0600-\u06FF]');
        final mixedMockPayload = <String, dynamic>{
          'rule_findings': [
            {
              'rule_id': 'R_OVERHEAT',
              'severity': 'critical',
              'confidence': 0.96,
              'title_en': 'Engine Coolant Overheating Detected',
            },
          ],
          'ml': {
            'top_class': 'COOLING_OVERHEAT',
            'top_probability': 0.91,
          },
          'retrieved': [
            {
              'code': 'P0301',
              'title_en': 'Thermostat Stuck Closed or Coolant Leak',
            },
          ],
          'evidence_ids': {
            'E1': {
              'type': 'rule',
              'rule_id': 'R_OVERHEAT',
              'title_en': 'Engine Coolant Overheating Detected',
              'evidence': ['ECT=115C', 'تحذير عربي مخفي'],
            },
          },
          'explanation': {
            '_meta': {'provider': 'mock'},
            'summary': 'تحذير: ارتفاع حرارة المحرك بشكل خطير.',
            'summary_en': 'ارتفاع حرارة المحرك — mock bilingual leak.',
            'safety': 'أوقف السيارة فوراً.',
            'safety_en': 'تحذير سلامة باللغة العربية.',
            'limitations': 'هذه نتائج تجريبية.',
            'limitations_en': 'تعتمد هذه القراءات على محاكاة.',
            'feature_labels_en': ['Coolant Temp (ECT)', 'Engine Load'],
            'likely_causes': [
              {
                'cause': 'ثرموستات المحرك عالق',
                'likelihood': 'high',
                'why': 'درجة حرارة سائل التبريد تجاوزت الحد الآمن.',
                'evidence': ['E1'],
              },
            ],
            'next_steps': [
              {
                'step': 'افحص مستوى سائل التبريد بعد أن يبرد المحرك',
                'test_id': 'CHECK_COOLANT',
              },
            ],
          },
        };

        final parsed = AiDiagnosticRemoteDataSource.parseAnalyzeResponse(
          mixedMockPayload,
          isArabic: false,
        );

        expect(arabicRegex.hasMatch(parsed.summary), isFalse);
        expect(arabicRegex.hasMatch(parsed.safetyWarning ?? ''), isFalse);
        expect(arabicRegex.hasMatch(parsed.limitations ?? ''), isFalse);
        expect(parsed.summary, isNotEmpty);
        expect(parsed.rankedCauses, isNotEmpty);
        expect(
          parsed.rankedCauses.first.cause,
          'Engine Coolant Overheating Detected',
        );
        expect(parsed.nextSteps, isNotEmpty);
        for (final cause in parsed.rankedCauses) {
          expect(arabicRegex.hasMatch(cause.cause), isFalse);
          expect(arabicRegex.hasMatch(cause.description), isFalse);
        }
        for (final step in parsed.nextSteps) {
          expect(arabicRegex.hasMatch(step), isFalse);
        }
      },
    );
  });

  group('AiDiagnosticRemoteDataSource.analyze payload contract', () {
    test('maps coolant to ect, engineLoad to load, and sends >= 6 samples', () async {
      final mockClient = MockAiEngineClient();
      final dataSource = AiDiagnosticRemoteDataSource(mockClient);

      Map<String, dynamic>? capturedData;
      when(() => mockClient.postJson('/api/analyze', data: any(named: 'data')))
          .thenAnswer((invocation) async {
        capturedData = invocation.namedArguments[#data] as Map<String, dynamic>;
        return <String, dynamic>{
          'explanation': {
            'summary': 'ملخص تجريبي',
            'likely_causes': const [],
            'next_steps': const [],
          },
        };
      });

      await dataSource.analyze(
        vehicle: const {'make': 'Toyota', 'model': 'Corolla', 'year': 2018},
        dtcs: const [],
        evidence: MeasuredEvidence(
          detectedDtcs: const [],
          coolantTempC: 112.0,
          batteryVoltage: 11.9,
          engineRpm: 780.0,
          vehicleSpeedKmH: 0.0,
          engineLoadPercent: 26.0,
          shortTermFuelTrimPercent: 8.0,
          longTermFuelTrimPercent: 5.0,
          measuredAt: DateTime(2026),
        ),
        lang: 'ar',
      );

      expect(capturedData, isNotNull);
      final samples = capturedData!['samples'] as List<dynamic>;
      expect(samples.length, greaterThanOrEqualTo(6));
      final first = samples.first as Map<String, dynamic>;
      expect(first['ect'], 112.0);
      expect(first['load'], 26.0);
      expect(first['rpm'], 780.0);
      expect(first['voltage'], 11.9);
      expect(first.containsKey('coolant_c'), isFalse);
      expect(first.containsKey('engine_load'), isFalse);
    });
  });

  group('detectTextDirection BiDi helper', () {
    test('detects Arabic text as RTL and English text as LTR', () {
      expect(
        detectTextDirection('ضعف في شمعات الاحتراق (البوجيهات)'),
        TextDirection.rtl,
      );
      expect(
        detectTextDirection('Spark plug wear on cylinder 1'),
        TextDirection.ltr,
      );
      expect(detectTextDirection(''), TextDirection.ltr);
    });
  });
}
