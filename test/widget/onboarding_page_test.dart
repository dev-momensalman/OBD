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

  testWidgets('Get Started button morphs into circular ball and expands across screen', (tester) async {
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

    // Page 1 -> Next
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Page 2 -> Next
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Page 3: "Connect, Discover, Understand" and "Get Started"
    expect(find.text('Connect, Discover, Understand'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap "Get Started"
    await tester.tap(find.text('Get Started'));
    await tester.pump(); // Start morph animation

    // Advance 350ms (Phase 1: Button morphs into 48px ball)
    await tester.pump(const Duration(milliseconds: 350));

    // Advance to 750ms (Phase 3: OnboardingExpandPainter active and expanding with glowing rim)
    await tester.pump(const Duration(milliseconds: 400));
    final expandPainterFinder = find.byWidgetPredicate(
      (widget) => widget is CustomPaint && widget.painter is OnboardingExpandPainter,
    );
    expect(expandPainterFinder, findsOneWidget);

    // Complete the animation
    await tester.pumpAndSettle();
    expect(finished, isTrue);
  });
}
