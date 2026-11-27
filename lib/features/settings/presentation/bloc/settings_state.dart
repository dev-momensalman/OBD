import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Reactive application-wide localization and measurement unit settings.
class SettingsState extends Equatable {
  final String languageCode;
  final String distanceUnit;
  final String tempUnit;

  const SettingsState({
    this.languageCode = 'en',
    this.distanceUnit = 'km',
    this.tempUnit = '°C',
  });

  Locale get locale => Locale(languageCode);
  bool get isArabic => languageCode == 'ar';
  bool get usesMiles => distanceUnit == 'mi';
  bool get usesFahrenheit => tempUnit == '°F';

  /// Converts Celsius to the user's selected temperature unit.
  double convertTemp(double celsius) =>
      usesFahrenheit ? (celsius * 9.0 / 5.0) + 32.0 : celsius;

  /// Formats temperature string with the active unit symbol.
  String formatTemp(double celsius, {int fractionDigits = 0}) {
    final value = convertTemp(celsius);
    return '${value.toStringAsFixed(fractionDigits)} $tempUnit';
  }

  /// Converts kilometers to the user's selected distance unit.
  double convertDistanceKm(double km) => usesMiles ? km * 0.621371 : km;

  SettingsState copyWith({
    String? languageCode,
    String? distanceUnit,
    String? tempUnit,
  }) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }

  @override
  List<Object?> get props => [languageCode, distanceUnit, tempUnit];
}
