import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/history/domain/entities/activity_log_entity.dart';
import '../../domain/entities/diagnostic_report.dart';
import '../../domain/entities/dtc_fault.dart';
import '../../domain/entities/measured_evidence.dart';
import '../bloc/dashboard_cubit.dart';

/// Authentic Diagnostic Report Summary Screen matching Figma Node 247:553
/// Reads live [DiagnosticReport] from [DashboardCubit] when available and enforces
/// Epistemic Safety boundaries (`RULES.md` §2.3) + BiDi text direction.
class ReportSummaryPage extends StatefulWidget {
  final DiagnosticReport? reportArg;
  final ActivityLogEntity? historyLog;

  const ReportSummaryPage({super.key, this.reportArg, this.historyLog});

  @override
  State<ReportSummaryPage> createState() => _ReportSummaryPageState();
}

class _ReportSummaryPageState extends State<ReportSummaryPage> {
  final int _selectedTab = 0; // 0: Summary, 1: Causes

  DiagnosticReport? _readReport(BuildContext context) {
    if (widget.reportArg != null) return widget.reportArg;
    final log = widget.historyLog;
    if (log != null) {
      return DiagnosticReport(
        id: log.id,
        timestamp: DateTime.now(),
        dtcs: log.detectedDtcs
            .map(
              (c) => DtcFault(
                code: c,
                description: log.title,
                system: 'Powertrain',
                severity: log.isWarning ? DtcSeverity.warning : DtcSeverity.healthy,
              ),
            )
            .toList(),
        measuredEvidence: MeasuredEvidence(
          detectedDtcs: const [],
          coolantTempC: 92,
          batteryVoltage: 13.8,
          engineRpm: 780,
          measuredAt: DateTime.now(),
        ),
        overallSeverity: log.isWarning ? DtcSeverity.warning : DtcSeverity.healthy,
        vehicleHealthScore: log.healthScore,
        plainLanguageExplanation: log.subtitle,
        rankedCauses: const [],
        recommendedNextAction: log.title,
        confidenceScore: 0.85,
        minCostUsd: 0,
        maxCostUsd: 0,
      );
    }
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

    final headline = (report != null && report.dtcs.isNotEmpty)
        ? report.dtcs.map((d) => '${d.code} · ${d.description}').join('\n')
        : l10n.possibleEngineMisfire;
    final explanation =
        report?.plainLanguageExplanation ?? l10n.fallbackExplanation;
    final nextStep = report?.recommendedNextAction ?? l10n.fallbackNextStep;
    final safetyWarning = report?.safetyWarning;
    final disclaimer = report?.safetyDisclaimer ?? l10n.srsDisclaimer;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(context.backIcon,
              color: const Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.reportTitle,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: Color(0xFF0F172A), size: 22),
            onPressed: () {
              final text =
                  '${l10n.reportTitle}\n$headline\n\n$explanation\n\n$nextStep\n\n$disclaimer';
              AppActions.copyText(
                context,
                text,
                feedback: l10n.reportCopiedMsg,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // 1. Segmented Control: [Summary] | [Causes] (Figma Node 247:553)
            Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedTab == 0
                            ? const Color(0xFF7C3AED)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.summaryTab,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 0
                              ? Colors.white
                              : const Color(0xFF6B21A8),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.reportCauses,
                          arguments: widget.reportArg ?? widget.historyLog,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.causesTab,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6B21A8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Main Diagnostic Detail Card (Figma Node 247:553)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFBFDBFE)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF003FB8).withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Inference Badge + Timestamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFC7D2FE)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome_rounded,
                                  size: 12, color: Color(0xFF4338CA)),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  l10n.aiInferenceBadge,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF3730A3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        report != null
                            ? '${report.vehicleHealthScore}/100'
                            : l10n.todayDefaultTime,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    headline,
                    textDirection: detectTextDirection(headline),
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF002264),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      report?.diagnosisSource ?? l10n.checkSoonBadge,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    l10n.whatsHappening,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF002264),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    explanation,
                    textDirection: detectTextDirection(explanation),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.5,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (safetyWarning != null && safetyWarning.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.safetyWarningTitle,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB91C1C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            safetyWarning,
                            textDirection: detectTextDirection(safetyWarning),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              height: 1.4,
                              color: const Color(0xFF991B1B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Next best step card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.nextBestStep,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF003FB8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          nextStep,
                          textDirection: detectTextDirection(nextStep),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        if (report == null)
                          Text(
                            l10n.commonCausesHint,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Mandatory SRS Legal / Epistemic Safety Disclaimer (RULES.md)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 16, color: Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      disclaimer,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        height: 1.4,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Action Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                  arguments: 1, // Service Centers tab index
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003FB8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
              child: Text(
                l10n.findServiceCenter,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l10n.doneButton,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF003FB8),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
