import 'package:shared_preferences/shared_preferences.dart';

/// Service managing persistent key-value preferences.
class AppPreferences {
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';

  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  /// Returns whether the user has already viewed and completed the onboarding flow.
  bool get hasSeenOnboarding => _prefs.getBool(keyHasSeenOnboarding) ?? false;

  /// Sets the onboarding completion flag.
  Future<bool> setHasSeenOnboarding(bool value) =>
      _prefs.setBool(keyHasSeenOnboarding, value);

  /// Clears the onboarding completion flag (useful for testing or logout/reset).
  Future<bool> clearOnboarding() => _prefs.remove(keyHasSeenOnboarding);
}
