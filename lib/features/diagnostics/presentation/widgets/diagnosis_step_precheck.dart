import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pre-Scan Checklist View (Figma Node 186:1695)
/// Step 1: Informs the driver of prerequisites before scanning OBD-II bus.
class DiagnosisStepPreCheck extends StatelessWidget {
  final VoidCallback onStartScan;
  final VoidCallback? onWatchLiveData;

  const DiagnosisStepPreCheck({
    super.key,
    required this.onStartScan,
    this.onWatchLiveData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Device Connected Status Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF003FB8),
                ),
                child: const Icon(
                  Icons.bluetooth_connected_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OBD-II Scanner Connected',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ready to communicate with ECU bus',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF5B6780),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Pre-check instructions card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Before you start:',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              _buildCheckItem('Park car in a safe, ventilated area'),
              const SizedBox(height: 12),
              _buildCheckItem('Turn ignition ON (engine running or idle)'),
              const SizedBox(height: 12),
              _buildCheckItem('Keep device within Bluetooth range (~5m)'),
              const SizedBox(height: 12),
              _buildCheckItem('Do not unplug scanner during scan'),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Start Scan Primary CTA
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: onStartScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003FB8),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Start scan',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: GestureDetector(
            onTap: onWatchLiveData,
            child: Text(
              'Watch live data only',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF003FB8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFDCFCE7),
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Color(0xFF16A34A),
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
