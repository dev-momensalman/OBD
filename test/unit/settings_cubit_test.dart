import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_state.dart';

void main() {
  group('SettingsCubit & AppPreferences persistence', () {
    late SharedPreferences prefs;
    late AppPreferences appPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      appPreferences = AppPreferences(prefs);
    });

    test('loads default language en, distance km, temp °C', () {
      final cubit = SettingsCubit(preferences: appPreferences);
      expect(cubit.state, const SettingsState());
      expect(cubit.state.locale, const Locale('en'));
      expect(cubit.state.isArabic, isFalse);
      cubit.close();
    });

    blocTest<SettingsCubit, SettingsState>(
      'persists Arabic locale and Imperial units across instances',
      build: () => SettingsCubit(preferences: appPreferences),
      act: (cubit) async {
        await cubit.setLanguage('ar');
        await cubit.setDistanceUnit('mi');
        await cubit.setTempUnit('°F');
      },
      expect: () => const [
        SettingsState(languageCode: 'ar', distanceUnit: 'km', tempUnit: '°C'),
        SettingsState(languageCode: 'ar', distanceUnit: 'mi', tempUnit: '°C'),
        SettingsState(languageCode: 'ar', distanceUnit: 'mi', tempUnit: '°F'),
      ],
      verify: (_) {
        final restored = SettingsCubit(preferences: AppPreferences(prefs));
        expect(restored.state.languageCode, 'ar');
        expect(restored.state.distanceUnit, 'mi');
        expect(restored.state.tempUnit, '°F');
        expect(restored.state.isArabic, isTrue);
        expect(restored.state.usesMiles, isTrue);
        expect(restored.state.usesFahrenheit, isTrue);
        restored.close();
      },
    );

    test('converts Celsius to Fahrenheit and km to miles accurately', () {
      const imperial = SettingsState(
        languageCode: 'en',
        distanceUnit: 'mi',
        tempUnit: '°F',
      );
      expect(imperial.convertTemp(100), closeTo(212.0, 0.01));
      expect(imperial.formatTemp(100), '212 °F');
      expect(imperial.convertDistanceKm(100), closeTo(62.137, 0.01));
    });
  });
}
