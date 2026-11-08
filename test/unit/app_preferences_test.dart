import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obd_vision/core/services/app_preferences.dart';

void main() {
  group('AppPreferences Single-Launch Onboarding Flag', () {
    late AppPreferences appPreferences;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('hasSeenOnboarding returns false by default on initial fresh install', () async {
      final prefs = await SharedPreferences.getInstance();
      appPreferences = AppPreferences(prefs);

      expect(appPreferences.hasSeenOnboarding, isFalse);
    });

    test('setHasSeenOnboarding stores true and persists flag', () async {
      final prefs = await SharedPreferences.getInstance();
      appPreferences = AppPreferences(prefs);

      await appPreferences.setHasSeenOnboarding(true);
      expect(appPreferences.hasSeenOnboarding, isTrue);

      // Verify persistence by creating a new instance with same backing prefs
      final freshInstance = AppPreferences(prefs);
      expect(freshInstance.hasSeenOnboarding, isTrue);
    });

    test('clearOnboarding resets flag back to false', () async {
      final prefs = await SharedPreferences.getInstance();
      appPreferences = AppPreferences(prefs);

      await appPreferences.setHasSeenOnboarding(true);
      expect(appPreferences.hasSeenOnboarding, isTrue);

      await appPreferences.clearOnboarding();
      expect(appPreferences.hasSeenOnboarding, isFalse);
    });
  });
}
