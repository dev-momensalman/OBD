import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_state.dart';
import 'package:obd_vision/injection_container.dart' as di;

/// Language & Units Settings Screen (Figma Node 336:3792)
/// Allows user to toggle display language (`en`/`ar`) and measurement units (`km`/`mi`, `°C`/`°F`).
class LanguageUnitsPage extends StatelessWidget {
  const LanguageUnitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<SettingsCubit>();
      return const _LanguageUnitsView();
    } catch (_) {
      return BlocProvider<SettingsCubit>(
        create: (_) => di.sl.isRegistered<SettingsCubit>()
            ? di.sl<SettingsCubit>()
            : SettingsCubit(),
        child: const _LanguageUnitsView(),
      );
    }
  }
}

class _LanguageUnitsView extends StatelessWidget {
  const _LanguageUnitsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // 1. Curved Dark Blue Header (Figma Node 336:3793)
              Container(
                height: 124,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 44, left: 16, right: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF000C24),
                      Color(0xFF002F8A),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          context.backIcon,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.languageAndUnits,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // 2. Settings Content
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- SECTION 1: Language ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.languageSection,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2A44),
                            ),
                          ),
                          Text(
                            l10n.systemDefault,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF727784),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD9E2F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildRadioRow(
                              icon: Icons.language_rounded,
                              title: l10n.englishLabel,
                              subtitle: l10n.englishSubtitle,
                              isSelected: state.languageCode == 'en',
                              onTap: () => cubit.setLanguage('en'),
                            ),
                            const Divider(height: 1, color: Color(0xFFE8EEFF)),
                            _buildRadioRow(
                              icon: Icons.translate_rounded,
                              title: l10n.arabicLabel,
                              pillTag: l10n.arabicPill,
                              subtitle: l10n.arabicSubtitle,
                              isSelected: state.languageCode == 'ar',
                              onTap: () => cubit.setLanguage('ar'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // --- SECTION 2: Units of Measurement ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.unitsOfMeasurement,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2A44),
                            ),
                          ),
                          Text(
                            l10n.telemetrySync,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF727784),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD9E2F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSegmentedRow(
                              icon: Icons.speed_rounded,
                              title: l10n.distanceTitle,
                              subtitle: l10n.distanceSubtitle,
                              optionA: 'km',
                              optionB: 'mi',
                              selectedValue: state.distanceUnit,
                              onChanged: cubit.setDistanceUnit,
                            ),
                            const Divider(height: 1, color: Color(0xFFE8EEFF)),
                            _buildSegmentedRow(
                              icon: Icons.thermostat_rounded,
                              title: l10n.temperatureTitle,
                              subtitle: l10n.temperatureSubtitle,
                              optionA: '°C',
                              optionB: '°F',
                              selectedValue: state.tempUnit,
                              onChanged: cubit.setTempUnit,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Live Reassurance Note (Figma Node 336:3970)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.sync_rounded,
                              size: 16,
                              color: Color(0xFF003FB8),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                l10n.unitsReassuranceNote,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF424753),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioRow({
    required IconData icon,
    required String title,
    String? pillTag,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F3FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF003FB8), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2A44),
                        ),
                      ),
                      if (pillTag != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3FF),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            pillTag,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF424753),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF424753),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF003FB8) : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF003FB8)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String optionA,
    required String optionB,
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F3FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF003FB8), size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2A44),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF424753),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 36,
            width: 110,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3FF),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(optionA),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedValue == optionA
                            ? const Color(0xFF003FB8)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        optionA,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selectedValue == optionA
                              ? Colors.white
                              : const Color(0xFF003FB8),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(optionB),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedValue == optionB
                            ? const Color(0xFF003FB8)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        optionB,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selectedValue == optionB
                              ? Colors.white
                              : const Color(0xFF003FB8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
