import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets('SplashPage renders elements and triggers onAnimationComplete', (tester) async {
    bool animationCompleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SplashPage(
          animationDuration: const Duration(milliseconds: 500),
          onAnimationComplete: () {
            animationCompleted = true;
          },
        ),
      ),
    );

    // Initial frame
    expect(find.byType(SplashPage), findsOneWidget);

    // Pump to mid-animation (logo and text should appear)
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(RichText), findsWidgets);

    // Complete the animation
    await tester.pumpAndSettle();
    expect(animationCompleted, isTrue);
  });
}
