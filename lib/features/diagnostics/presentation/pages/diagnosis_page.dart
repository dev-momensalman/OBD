import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';

/// Authentic Multi-Step Diagnosis Screen matching Figma Nodes 186:1695, 189:1790, 189:1902
class DiagnosisPage extends StatefulWidget {
  final VoidCallback? onBack;

  const DiagnosisPage({super.key, this.onBack});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  int _currentStep = 1; // 1: Pre-check, 2: Scanning, 3: Completed
  double _scanProgress = 0.78;
  Timer? _scanTimer;

  void _startScan() {
    setState(() {
      _currentStep = 2;
      _scanProgress = 0.15;
    });

    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _scanProgress += 0.05;
        if (_scanProgress >= 1.0) {
          _scanProgress = 1.0;
          _currentStep = 3;
          timer.cancel();
        }
      });
    });
  }

  void _cancelScan() {
    _scanTimer?.cancel();
    setState(() {
      _currentStep = 1;
    });
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // 1. Navigation Header
              Row(
                children: [
                  if (widget.onBack != null || _currentStep > 1)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF0F172A), size: 20),
                      onPressed: () {
                        if (_currentStep > 1) {
                          _cancelScan();
                        } else if (widget.onBack != null) {
                          widget.onBack!();
                        }
                      },
                    )
                  else
                    const SizedBox(width: 4),
                  Expanded(
                    child: Center(
                      child: Text(
                        _currentStep == 1
                            ? 'Check before you scan'
                            : _currentStep == 2
                                ? 'Scan your vehicle'
                                : 'Scan completed',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 4),

              // Subtitle step label: "SCAN - 1 OF 3"
              Center(
                child: Text(
                  'SCAN - $_currentStep OF 3',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Stepper Indicator: [1] ─── [2] ─── [3]
              _buildStepper(),
              const SizedBox(height: 24),

              // 3. Step Content Switcher
              if (_currentStep == 1)
                _buildPreCheckView()
              else if (_currentStep == 2)
                _buildScanningView()
              else
                _buildCompletedView(),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, '1'),
        _buildStepLine(_currentStep >= 2),
        _buildStepCircle(2, '2'),
        _buildStepLine(_currentStep >= 3),
        _buildStepCircle(3, '3'),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep == step;
    final isDone = _currentStep > step;

    Color bg = const Color(0xFFE2E8F0);
    Color fg = const Color(0xFF64748B);

    if (isActive || isDone) {
      bg = const Color(0xFF7C3AED); // Figma Purple
      fg = Colors.white;
    }

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: isDone
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
          : Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: fg,
              ),
            ),
    );
  }

  Widget _buildStepLine(bool isFilled) {
    return Container(
      width: 60,
      height: 3,
      color: isFilled ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0),
    );
  }

  // --- Step 1: Pre-Check View ---
  Widget _buildPreCheckView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            'This takes about a minute',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF003FB8),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Checklist Card (Figma Node 186:1695)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildCheckRow('Device connected', isChecked: true),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildCheckRow('Ignition on', isChecked: true),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildCheckRow('Vehicle supported', isChecked: true),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Primary: Start Scan
        ElevatedButton(
          onPressed: _startScan,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003FB8),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
          ),
          child: Text(
            'Start scan',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Outlined: Watch live data only
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.liveData);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Color(0xFF003FB8), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Watch live data only',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF003FB8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckRow(String text, {required bool isChecked}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDCFCE7),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.check_rounded,
                color: Color(0xFF16A34A), size: 18),
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 2: Scanning View ---
  Widget _buildScanningView() {
    final pct = (_scanProgress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Arc progress percentage
        Center(
          child: SizedBox(
            width: 160,
            height: 110,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: _scanProgress,
                    strokeWidth: 10,
                    backgroundColor: const Color(0xFFEDE9FE),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
                  ),
                ),
                Text(
                  '$pct%',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Live Scanning Checklist (Figma Node 189:1790)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildProgressRow(
                'Reading trouble codes',
                isDone: _scanProgress > 0.35,
                isLoading: _scanProgress <= 0.35,
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildProgressRow(
                'Reading sensors',
                subtitle: '${(_scanProgress * 27).toInt()} of 27 readings',
                isDone: _scanProgress > 0.70,
                isLoading: _scanProgress > 0.35 && _scanProgress <= 0.70,
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildProgressRow(
                'Analyzing data',
                isDone: _scanProgress > 0.90,
                isLoading: _scanProgress > 0.70 && _scanProgress <= 0.90,
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildProgressRow(
                'Preparing your report',
                isDone: _scanProgress >= 1.0,
                isLoading: _scanProgress > 0.90,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Center(
          child: Text(
            'Keep the engine running and the device plugged in',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: _cancelScan,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003FB8),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Cancel scan',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(String title,
      {String? subtitle, required bool isDone, required bool isLoading}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (isDone)
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDCFCE7),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF16A34A), size: 16),
            )
          else if (isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(Color(0xFF003FB8)),
              ),
            )
          else
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDone || isLoading
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF94A3B8),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
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
    );
  }

  // --- Step 3: Completed View ---
  Widget _buildCompletedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Suspected Fault Hero Card (Figma Node 189:1902)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDDD6FE)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_rounded,
                        size: 14, color: Color(0xFF7C3AED)),
                    const SizedBox(width: 4),
                    Text(
                      'Suspected fault',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Possible engine misfire',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF002264),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Based on 2 codes and 1 warning',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Metric Pills Row: [2 Codes] [1 Warning] [24/27 Checked]
        Row(
          children: [
            Expanded(child: _buildMetricCard('2', 'Codes')),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('1', 'Warning')),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('24/27', 'Checked')),
          ],
        ),
        const SizedBox(height: 20),

        Text(
          'Codes found',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        // DTC Cards
        _buildDtcCard('P0301', 'Cylinder 1 misfire', 'Engine · Active', 'High',
            const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
        const SizedBox(height: 10),
        _buildDtcCard('P0171', 'Fuel mixture too lean', 'Fuel system · Pending',
            'Medium', const Color(0xFFFEF3C7), const Color(0xFFD97706)),

        const SizedBox(height: 24),

        // Action Buttons: Done / View Report
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _currentStep = 1);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF003FB8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.reportSummary);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003FB8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'View report',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF003FB8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDtcCard(String code, String desc, String system, String severity,
      Color badgeBg, Color badgeFg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF7C3AED),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  system,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              severity,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: badgeFg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
