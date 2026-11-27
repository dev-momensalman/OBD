import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'settings_state.dart';

/// Manages language (`en`/`ar`) and unit preferences (`km`/`mi`, `°C`/`°F`)
/// persisted via [AppPreferences].
class SettingsCubit extends Cubit<SettingsState> {
  final AppPreferences? _preferences;

  SettingsCubit({AppPreferences? preferences})
      : _preferences = preferences,
        super(
          SettingsState(
            languageCode: preferences?.languageCode ?? 'en',
            distanceUnit: preferences?.distanceUnit ?? 'km',
            tempUnit: preferences?.tempUnit ?? '°C',
          ),
        );

  Future<void> setLanguage(String code) async {
    final normalized = code == 'ar' ? 'ar' : 'en';
    emit(state.copyWith(languageCode: normalized));
    await _preferences?.setLanguageCode(normalized);
  }

  Future<void> setDistanceUnit(String unit) async {
    final normalized = unit == 'mi' ? 'mi' : 'km';
    emit(state.copyWith(distanceUnit: normalized));
    await _preferences?.setDistanceUnit(normalized);
  }

  Future<void> setTempUnit(String unit) async {
    final normalized = unit == '°F' ? '°F' : '°C';
    emit(state.copyWith(tempUnit: normalized));
    await _preferences?.setTempUnit(normalized);
  }
}
