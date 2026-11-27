import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';

/// System Health & Alert Card matching Figma Node 274:983
/// Features dynamic 86 Health score ring, early warning tag, and Run diagnosis action.
class SystemHealthCard extends StatelessWidget {
  final int healthScore;
  final String warningTitle;
  final String warningSubtitle;
  final VoidCallback onRunDiagnosis;
  final VoidCallback onSeeDetails;

  const SystemHealthCard({
    super.key,
    this.healthScore = 86,
    this.warningTitle = 'Coolant temperature\ntrending high',
    this.warningSubtitle = 'Last scan today, 09:40 · Inspect sensor',
    required this.onRunDiagnosis,
    required this.onSeeDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title & Link
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.systemHealthAndAlert,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              GestureDetector(
                onTap: onSeeDetails,
                child: Text(
                  context.l10n.seeDetails,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003FB8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Main Card Container (Figma: soft ice blue gradient, rounded 24)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEFF6FF), // Soft Ice Blue
                Color(0xFFDBEAFE), // Luminous Sky
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF003FB8).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Warning Badge, Title, Subtitle, Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Early Warning" Pill Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: Color(0xFF9333EA),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.earlyWarning,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF9333EA),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Title with Red alert text (dynamic warningTitle or localized default)
                        Builder(builder: (context) {
                          final effectiveTitle =
                              warningTitle == 'Coolant temperature\ntrending high'
                                  ? context.l10n.defaultWarningTitle
                                  : warningTitle;
                          final lines = effectiveTitle.split('\n');
                          if (lines.length >= 2) {
                            return Text.rich(
                              TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.25,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${lines.first}\n',
                                    style: const TextStyle(color: Color(0xFF1E293B)),
                                  ),
                                  TextSpan(
                                    text: lines.sublist(1).join('\n'),
                                    style: const TextStyle(color: Color(0xFFE11D48)),
                                  ),
                                ],
                              ),
                              textDirection: detectTextDirection(effectiveTitle),
                            );
                          }
                          return Text(
                            effectiveTitle,
                            textDirection: detectTextDirection(effectiveTitle),
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                              color: const Color(0xFF1E293B),
                            ),
                          );
                        }),
                        const SizedBox(height: 6),

                        // Subtitle
                        Text(
                          warningSubtitle == 'Last scan today, 09:40 · Inspect sensor'
                              ? context.l10n.defaultWarningSubtitle
                              : warningSubtitle,
                          textDirection: detectTextDirection(
                            warningSubtitle == 'Last scan today, 09:40 · Inspect sensor'
                                ? context.l10n.defaultWarningSubtitle
                                : warningSubtitle,
                          ),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // "Run diagnosis" Button
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: onRunDiagnosis,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003FB8),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.monitor_heart_outlined,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.l10n.runDiagnosisHome,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Column: Circular Health Score Ring (86 HEALTH)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Progress Arc Ring
                        SizedBox(
                          width: 74,
                          height: 74,
                          child: CircularProgressIndicator(
                            value: healthScore / 100.0,
                            strokeWidth: 7,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF7C3AED), // Vibrant Purple
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        // Score Text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$healthScore',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.l10n.healthScoreBadge,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF64748B),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Carousel Page Indicator (active 20x6 pill, inactive 6x6 dots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF003FB8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF93C5FD),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF93C5FD),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF93C5FD),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
