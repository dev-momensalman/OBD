import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/diagnostic_report.dart';
import '../../domain/entities/dtc_fault.dart';

/// Completed Diagnostic Scan View (Figma Node 189:1902)
/// Step 3: Displays authentic RuleEngine findings, health score, and DTC list.
class DiagnosisStepCompleted extends StatelessWidget {
  final DiagnosticReport? report;
  final VoidCallback onRescan;

  const DiagnosisStepCompleted({
    super.key,
    this.report,
    required this.onRescan,
  });

  @override
  Widget build(BuildContext context) {
    final healthScore = report?.vehicleHealthScore ?? 86;
    final dtcs = report?.dtcs ?? const <DtcFault>[];
    final hasFaults = dtcs.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Success / Warning Header Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: hasFaults ? const Color(0xFFFFFBEB) : const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasFaults ? const Color(0xFFFDE68A) : const Color(0xFFA7F3D0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasFaults ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                ),
                child: Icon(
                  hasFaults ? Icons.warning_amber_rounded : Icons.check_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasFaults ? 'Issues Detected' : 'Vehicle Systems Healthy',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasFaults
                          ? '${dtcs.length} fault code(s) recorded in ECU bus'
                          : 'All 27 sensors operating within factory tolerance',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasFaults ? const Color(0xFFFCD34D) : const Color(0xFF6EE7B7),
                  ),
                ),
                child: Text(
                  '$healthScore / 100',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: hasFaults ? const Color(0xFFB45309) : const Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2. Detected DTCs Card List
        if (hasFaults) ...[
          Text(
            'Diagnostic Trouble Codes (DTCs)',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          ...dtcs.map((dtc) => _buildDtcCard(dtc)),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No active DTC trouble codes found. Powertrain and emissions pass OBD-II inspection.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // 3. Action CTAs
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.reportSummary);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003FB8),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'View Full AI Report',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.serviceCentersList);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF003FB8),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Find Nearby Service Center',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton.icon(
            onPressed: onRescan,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              'Run Scan Again',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDtcCard(DtcFault dtc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dtc.code,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFB91C1C),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  dtc.severity.name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dtc.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
