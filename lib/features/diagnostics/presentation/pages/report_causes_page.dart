import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/history/domain/entities/activity_log_entity.dart';
import '../../domain/entities/diagnostic_report.dart';
import '../../domain/entities/ranked_cause.dart';
import '../bloc/dashboard_cubit.dart';

/// Authentic Report Causes Screen matching Figma Node 253:979
/// Displays AI-estimated root causes from [DashboardCubit] ranked by likelihood.
class ReportCausesPage extends StatefulWidget {
  final DiagnosticReport? reportArg;
  final ActivityLogEntity? historyLog;

  const ReportCausesPage({super.key, this.reportArg, this.historyLog});

  @override
  State<ReportCausesPage> createState() => _ReportCausesPageState();
}

class _ReportCausesPageState extends State<ReportCausesPage> {
  static const List<RankedCause> _fallbackCauses = [
    RankedCause(
      cause: 'Worn spark plug',
      probability: 0.93,
      description: 'A common cause of cylinder 1 misfire',
    ),
    RankedCause(
      cause: 'Faulty ignition coil',
      probability: 0.65,
      description: 'Often leads to misfires in multiple cylinders',
    ),
    RankedCause(
      cause: 'Clogged fuel injector',
      probability: 0.22,
      description: 'Can cause poor fuel delivery and misfires',
    ),
  ];

  DiagnosticReport? _readReport(BuildContext context) {
    if (widget.reportArg != null) return widget.reportArg;
    try {
      return context.watch<DashboardCubit>().state.latestReport;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final report = _readReport(context);
    final arabicFallbackCauses = context.isArabic
        ? const [
            RankedCause(
              cause: 'تلف أو اتساخ شمعات الاحتراق (البوجيهات)',
              probability: 0.93,
              description: 'سبب شائع لتقطيع الاحتراق في الأسطوانة الأولى',
            ),
            RankedCause(
              cause: 'عطل في موبينة الإشعال',
              probability: 0.65,
              description: 'يؤدي غالباً إلى عدم انتظام الاحتراق بالأسطوانات',
            ),
            RankedCause(
              cause: 'انسداد في رشاش الوقود (البخاخ)',
              probability: 0.22,
              description: 'يسبب ضعف ضخ الوقود وتقطيع المحرك',
            ),
          ]
        : _fallbackCauses;
    final causes = (report != null && report.rankedCauses.isNotEmpty)
        ? report.rankedCauses
        : arabicFallbackCauses;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(context.backIcon,
              color: const Color(0xFF242424), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.reportTitle,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF242424),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: Color(0xFF242424), size: 22),
            onPressed: () {
              final buffer = StringBuffer('${l10n.reportTitle} - ${l10n.causesTab}\n');
              for (final c in causes) {
                buffer.writeln(
                  '• ${c.cause} (${(c.probability * 100).round()}%): ${c.description}',
                );
              }
              buffer.writeln('\n${l10n.srsDisclaimer}');
              AppActions.copyText(
                context,
                buffer.toString(),
                feedback: l10n.reportCopiedMsg,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // 1. Segmented Control: [Summary] | [Causes] (Figma Node 253:986)
                    Container(
                      height: 42,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4AAFF).withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.reportSummary,
                                  arguments:
                                      widget.reportArg ?? widget.historyLog,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  l10n.summaryTab,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8855FF),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                l10n.causesTab,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2. Subheader: AI Estimate Pill & Ranked text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFA2C2FF).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 14,
                                color: Color(0xFF003FB8),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.aiEstimateTitle,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          l10n.rankedByLikelihood,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF5B6780),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 3. Cause Cards List (Dynamic AI Causes or Fallback)
                    for (var i = 0; i < causes.length; i++) ...[
                      _buildCauseCard(
                        title: causes[i].cause,
                        subtitle: causes[i].description,
                        percentage:
                            (causes[i].probability * 100).round().clamp(5, 99),
                        hasTrend: i == 0,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Epistemic Disclaimer (RULES.md)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        report?.safetyDisclaimer ?? l10n.srsDisclaimer,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          height: 1.4,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom CTAs: Find service center & Done
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                          arguments: 1,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003FB8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.findServiceCenter,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF003FB8),
                        side: const BorderSide(color: Color(0xFFD2D2D2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.doneButton,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCauseCard({
    required String title,
    required String subtitle,
    required int percentage,
    required bool hasTrend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textDirection: detectTextDirection(title),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF19213D),
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        textDirection: detectTextDirection(subtitle),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF6D758F),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasTrend)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE9FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF7C3AED),
                    size: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final filledWidth = totalWidth * (percentage / 100);

              return Container(
                height: 24,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFFE1E4ED)),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: filledWidth,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFC4AAFF),
                            Color(0xFF8855FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      padding: const EdgeInsetsDirectional.only(end: 10),
                      child: Text(
                        '$percentage%',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
