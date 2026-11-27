import 'package:shared_preferences/shared_preferences.dart';

/// Service managing persistent key-value preferences.
class AppPreferences {
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyLanguageCode = 'preferred_language_code';
  static const String keyDistanceUnit = 'preferred_distance_unit';
  static const String keyTempUnit = 'preferred_temp_unit';
  static const String keyCachedAuthUser = 'cached_auth_user_json';
  static const String keyIsGuestSession = 'is_guest_session';
  static const String keyActivatedSerial = 'activated_device_serial';
  static const String keyDevicePaired = 'obd_device_paired';
  static const String keySavedProfile = 'saved_user_profile_json';
  static const String keySavedVehicles = 'saved_vehicles_json';
  static const String keySavedHistoryLogs = 'saved_history_logs_json';
  static const String keySavedNotifications = 'saved_notifications_json';
  static const String keySavedActiveBooking = 'saved_active_booking_json';

  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  /// Returns whether the user has already viewed and completed the onboarding flow.
  bool get hasSeenOnboarding => _prefs.getBool(keyHasSeenOnboarding) ?? false;

  /// Sets the onboarding completion flag.
  Future<bool> setHasSeenOnboarding(bool value) =>
      _prefs.setBool(keyHasSeenOnboarding, value);

  /// Clears the onboarding completion flag (useful for testing or logout/reset).
  Future<bool> clearOnboarding() => _prefs.remove(keyHasSeenOnboarding);

  String get languageCode => _prefs.getString(keyLanguageCode) ?? 'en';

  Future<bool> setLanguageCode(String code) =>
      _prefs.setString(keyLanguageCode, code);

  String get distanceUnit => _prefs.getString(keyDistanceUnit) ?? 'km';

  Future<bool> setDistanceUnit(String unit) =>
      _prefs.setString(keyDistanceUnit, unit);

  String get tempUnit => _prefs.getString(keyTempUnit) ?? '°C';

  Future<bool> setTempUnit(String unit) => _prefs.setString(keyTempUnit, unit);

  String? get cachedAuthUserJson => _prefs.getString(keyCachedAuthUser);

  Future<bool> setCachedAuthUserJson(String? json) => json == null
      ? _prefs.remove(keyCachedAuthUser)
      : _prefs.setString(keyCachedAuthUser, json);

  bool get isGuestSession => _prefs.getBool(keyIsGuestSession) ?? false;

  Future<bool> setGuestSession(bool value) =>
      _prefs.setBool(keyIsGuestSession, value);

  String? get activatedSerial => _prefs.getString(keyActivatedSerial);

  Future<bool> setActivatedSerial(String? serial) => serial == null
      ? _prefs.remove(keyActivatedSerial)
      : _prefs.setString(keyActivatedSerial, serial);

  bool get devicePaired => _prefs.getBool(keyDevicePaired) ?? true;

  Future<bool> setDevicePaired(bool value) =>
      _prefs.setBool(keyDevicePaired, value);

  String? get savedProfileJson => _prefs.getString(keySavedProfile);

  Future<bool> setSavedProfileJson(String? json) => json == null
      ? _prefs.remove(keySavedProfile)
      : _prefs.setString(keySavedProfile, json);

  String? get savedVehiclesJson => _prefs.getString(keySavedVehicles);

  Future<bool> setSavedVehiclesJson(String? json) => json == null
      ? _prefs.remove(keySavedVehicles)
      : _prefs.setString(keySavedVehicles, json);

  String? get savedHistoryLogsJson => _prefs.getString(keySavedHistoryLogs);

  Future<bool> setSavedHistoryLogsJson(String? json) => json == null
      ? _prefs.remove(keySavedHistoryLogs)
      : _prefs.setString(keySavedHistoryLogs, json);

  String? get savedNotificationsJson =>
      _prefs.getString(keySavedNotifications);

  Future<bool> setSavedNotificationsJson(String? json) => json == null
      ? _prefs.remove(keySavedNotifications)
      : _prefs.setString(keySavedNotifications, json);

  String? get savedActiveBookingJson =>
      _prefs.getString(keySavedActiveBooking);

  Future<bool> setSavedActiveBookingJson(String? json) => json == null
      ? _prefs.remove(keySavedActiveBooking)
      : _prefs.setString(keySavedActiveBooking, json);

  Future<void> clearUserSessionData() async {
    await _prefs.remove(keyCachedAuthUser);
    await _prefs.remove(keyIsGuestSession);
    await _prefs.remove(keySavedProfile);
    await _prefs.remove(keySavedVehicles);
    await _prefs.remove(keySavedHistoryLogs);
    await _prefs.remove(keySavedActiveBooking);
  }
}
