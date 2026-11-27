import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/features/home/presentation/widgets/curved_bottom_nav_bar.dart';
import 'package:obd_vision/features/profile/presentation/pages/language_units_page.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_state.dart';
import 'package:obd_vision/l10n/app_localizations.dart';

void main() {
  testWidgets(
      'LanguageUnitsPage switches app locale from LTR English to RTL Arabic and updates units',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settingsCubit = SettingsCubit(preferences: AppPreferences(prefs));
    addTearDown(settingsCubit.close);

    await tester.pumpWidget(
      BlocProvider<SettingsCubit>.value(
        value: settingsCubit,
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return MaterialApp(
              locale: state.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const LanguageUnitsPage(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Language & Units'), findsOneWidget);

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(settingsCubit.state.languageCode, 'ar');
    expect(find.text('اللغة والوحدات'), findsOneWidget);

    final rtlContext = tester.element(find.byType(LanguageUnitsPage));
    expect(Directionality.of(rtlContext), TextDirection.rtl);

    await tester.tap(find.text('°F'));
    await tester.pumpAndSettle();
    expect(settingsCubit.state.tempUnit, '°F');
  });

  testWidgets('CurvedBottomNavBar mirrors floating active tab under RTL Arabic',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          bottomNavigationBar: CurvedBottomNavBar(
            selectedIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('الرئيسية'), findsOneWidget);

    final navRect = tester.getRect(find.byType(CurvedBottomNavBar));
    final activeIconRect = tester.getRect(find.byIcon(Icons.home_rounded));

    // In RTL, tab 0 ("الرئيسية") sits on the right half of the bar
    expect(activeIconRect.center.dx, greaterThan(navRect.center.dx));
  });
}
