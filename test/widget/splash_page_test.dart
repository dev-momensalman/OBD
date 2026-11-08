import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets('SplashPage renders elements and triggers onAnimationComplete', (tester) async {
    bool animationCompleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SplashPage(
          animationDuration: const Duration(milliseconds: 1000),
          onAnimationComplete: () {
            animationCompleted = true;
          },
        ),
      ),
    );

    // Initial frame (Stage 1: SplashPanelsPainter rendered with zero separation)
    expect(find.byType(SplashPage), findsOneWidget);
    final customPaintFinder = find.byWidgetPredicate(
      (widget) => widget is CustomPaint && widget.painter is SplashPanelsPainter,
    );
    expect(customPaintFinder, findsOneWidget);

    final CustomPaint customPaint = tester.widget(customPaintFinder);
    final SplashPanelsPainter painter = customPaint.painter as SplashPanelsPainter;
    expect(painter.separation, equals(0.0));
    expect(painter.angle, equals(0.0));

    // Mid-animation (Stage 2 & 3: Logo and RichText present)
    await tester.pump(const Duration(milliseconds: 650));
    expect(find.byType(RichText), findsWidgets);

    // Complete the animation
    await tester.pumpAndSettle();
    expect(animationCompleted, isTrue);
  });

  testWidgets('SplashPage onTap immediately triggers onAnimationComplete', (tester) async {
    bool animationCompleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SplashPage(
          animationDuration: const Duration(seconds: 10),
          onAnimationComplete: () {
            animationCompleted = true;
          },
        ),
      ),
    );

    expect(animationCompleted, isFalse);

    // User taps screen to skip
    await tester.tap(find.byType(SplashPage));
    await tester.pump();

    expect(animationCompleted, isTrue);
  });
}
