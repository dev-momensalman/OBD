import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Language & Units Settings Screen (Figma Node 336:3792)
/// Allows user to toggle display language and measurement units (Distance & Temp).
class LanguageUnitsPage extends StatefulWidget {
  const LanguageUnitsPage({super.key});

  @override
  State<LanguageUnitsPage> createState() => _LanguageUnitsPageState();
}

class _LanguageUnitsPageState extends State<LanguageUnitsPage> {
  String _selectedLanguage = 'en'; // 'en' | 'ar'
  String _distanceUnit = 'km'; // 'km' | 'mi'
  String _tempUnit = '°C'; // '°C' | '°F'

  @override
  Widget build(BuildContext context) {
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
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Language & Units',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION 1: Language ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Language',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2A44),
                        ),
                      ),
                      Text(
                        'System default',
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
                        // English Row
                        _buildRadioRow(
                          icon: Icons.language_rounded,
                          title: 'English',
                          subtitle: 'Default interface translation',
                          isSelected: _selectedLanguage == 'en',
                          onTap: () => setState(() => _selectedLanguage = 'en'),
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        // Arabic Row
                        _buildRadioRow(
                          icon: Icons.translate_rounded,
                          title: 'العربية',
                          pillTag: 'Arabic',
                          subtitle: 'RTL layout optimized',
                          isSelected: _selectedLanguage == 'ar',
                          onTap: () => setState(() => _selectedLanguage = 'ar'),
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
                        'Units of Measurement',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2A44),
                        ),
                      ),
                      Text(
                        'Telemetry sync',
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
                        // Distance Row
                        _buildSegmentedRow(
                          icon: Icons.speed_rounded,
                          title: 'Distance',
                          subtitle: 'Odometer & range',
                          optionA: 'km',
                          optionB: 'mi',
                          selectedValue: _distanceUnit,
                          onChanged: (val) => setState(() => _distanceUnit = val),
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        // Temperature Row
                        _buildSegmentedRow(
                          icon: Icons.thermostat_rounded,
                          title: 'Temperature',
                          subtitle: 'Coolant, oil & cabin',
                          optionA: '°C',
                          optionB: '°F',
                          selectedValue: _tempUnit,
                          onChanged: (val) => setState(() => _tempUnit = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Live Reassurance Note (Figma Node 336:3970)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sync_rounded,
                          size: 16,
                          color: Color(0xFF003FB8),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Changes apply automatically across all connected vehicles',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF424753),
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
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3FF),
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
            // Custom Radio Circle matching Figma
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
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3FF),
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
          // Segmented Pill
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
