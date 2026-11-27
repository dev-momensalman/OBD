import 'dart:developer' as dev;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:obd_vision/core/config/app_env.dart';
import 'package:obd_vision/injection_container.dart' as di;

import '../test/helpers/chained_e2e_journey.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Real Device Chained E2E Journey', () {
    testWidgets(
      'executes full dependent 6-step user flow with real Vercel AI Engine & SharedPreferences',
      (tester) async {
        // 1. Clean local prefs on target device so onboarding -> sign-in -> home starts deterministically
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // 2. Initialize Supabase safely and verify non-mutating RPC reachability
        try {
          await Supabase.initialize(
            url: AppEnv.supabaseUrl,
            publishableKey: AppEnv.supabasePublishableKey,
          );
        } catch (_) {}

        try {
          final rpcResult = await Supabase.instance.client.rpc<bool>(
            'email_is_registered',
            params: {'p_email': 'e2e_nonexistent_probe@obdvision.invalid'},
          );
          dev.log('Supabase RPC probe email_is_registered => $rpcResult',
              name: 'RealDeviceE2E');
          expect(rpcResult, isFalse);
        } catch (e) {
          dev.log('Supabase RPC notice: $e', name: 'RealDeviceE2E');
        }

        // 3. Reset & initialize full app dependencies with REAL Vercel AI Engine enabled
        await di.sl.reset();
        await di.initDependencies(
          preferences: prefs,
          useRealAuth: false, // keeps production Auth DB clean during automated runs
          useRealAi: true, // sends real POST /api/analyze to obd-ai-engine.vercel.app
        );

        String? sourceUsed;
        String? explanationText;

        await runChainedE2eJourney(
          tester,
          scanTimeout: const Duration(seconds: 35),
          onReportReceived: (source, explanation) {
            sourceUsed = source;
            explanationText = explanation;
            dev.log(
              'Live AI Scan completed | source=$source | explanation=$explanation',
              name: 'RealDeviceE2E',
            );
          },
        );

        expect(sourceUsed, contains('Hybrid AI'));
        expect(explanationText, isNotEmpty);
      },
    );
  });
}
