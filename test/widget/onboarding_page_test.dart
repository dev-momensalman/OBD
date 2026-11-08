import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  testWidgets('OnboardingPage renders first page and progresses on tap', (tester) async {
    bool finished = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingPage(
          onFinished: () {
            finished = true;
          },
        ),
      ),
    );

    // Verify first page text
    expect(find.text('Turn Vehicle Data Into Smart Insights'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Verify second page text
    expect(find.text('See Your Car’s Story in Real Time'), findsOneWidget);

    // Tap Skip to complete onboarding
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(finished, isTrue);
  });
}
