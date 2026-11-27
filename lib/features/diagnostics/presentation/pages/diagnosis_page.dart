import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/history/presentation/bloc/history_cubit.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/diagnosis_step_completed.dart';
import '../widgets/diagnosis_step_precheck.dart';
import '../widgets/diagnosis_step_scanning.dart';

/// Authentic Multi-Step Diagnosis Screen matching Figma Nodes 186:1695, 189:1790, 189:1902
/// Orchestrates Clean Architecture RunDiagnosticScanUseCase and real-time ECU bus audit.
class DiagnosisPage extends StatefulWidget {
  final VoidCallback? onBack;

  const DiagnosisPage({super.key, this.onBack});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  int _currentStep = 1; // 1: Pre-check, 2: Scanning, 3: Completed
  double _scanProgress = 0.0;
  Timer? _progressTicker;

  void _startDiagnosticScan(BuildContext context) {
    setState(() {
      _currentStep = 2;
      _scanProgress = 0.15;
    });

    // Trigger Domain Use Case via DashboardCubit
    context.read<DashboardCubit>().runFullDiagnosticScan();

    // Smooth UI progress interpolation matching physical ECU scan duration
    _progressTicker?.cancel();
    _progressTicker = Timer.periodic(const Duration(milliseconds: 180), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_scanProgress < 0.95) {
          _scanProgress += 0.05;
        }
      });
    });
  }

  void _cancelScan() {
    _progressTicker?.cancel();
    setState(() {
      _currentStep = 1;
      _scanProgress = 0.0;
    });
  }

  @override
  void dispose() {
    _progressTicker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If DashboardCubit is provided higher up (e.g. by HomePage), use it, otherwise provide it.
    Widget content = BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state.scanStatus == ScanStatus.completed) {
          _progressTicker?.cancel();
          if (state.latestReport != null) {
            try {
              context.read<HistoryCubit>().recordScanReport(state.latestReport!);
            } catch (_) {}
          }
          setState(() {
            _scanProgress = 1.0;
            _currentStep = 3;
          });
        } else if (state.scanStatus == ScanStatus.error) {
          _progressTicker?.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.l10n.ecuCommunicationError),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
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
                          icon: Icon(context.backIcon,
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
                                ? context.l10n.checkBeforeYouScan
                                : _currentStep == 2
                                    ? context.l10n.scanYourVehicle
                                    : context.l10n.scanCompleted,
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

                  // Step indicator: "SCAN - X OF 3"
                  Center(
                    child: Text(
                      context.l10n.scanStepIndicator(_currentStep),
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

                  // 3. Modular Atomic Step Views
                  if (_currentStep == 1)
                    DiagnosisStepPreCheck(
                      onStartScan: () => _startDiagnosticScan(context),
                      onWatchLiveData: () =>
                          Navigator.of(context).pushNamed(AppRoutes.liveData),
                    )
                  else if (_currentStep == 2)
                    DiagnosisStepScanning(
                      progress: _scanProgress,
                      onCancel: _cancelScan,
                    )
                  else
                    DiagnosisStepCompleted(
                      report: state.latestReport,
                      onRescan: () {
                        setState(() {
                          _currentStep = 1;
                          _scanProgress = 0.0;
                        });
                      },
                    ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Ensure DashboardCubit is available even if DiagnosisPage is invoked independently
    try {
      context.read<DashboardCubit>();
      return content;
    } catch (_) {
      return BlocProvider<DashboardCubit>(
        create: (_) => di.sl<DashboardCubit>(),
        child: content,
      );
    }
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
    final isDone = _currentStep > step;
    final isActive = _currentStep == step;

    Color bg = const Color(0xFFE2E8F0);
    Color textColor = const Color(0xFF64748B);

    if (isActive) {
      bg = const Color(0xFF003FB8);
      textColor = Colors.white;
    } else if (isDone) {
      bg = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF16A34A);
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      alignment: Alignment.center,
      child: isDone
          ? const Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 16)
          : Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 38,
      height: 2,
      color: isActive ? const Color(0xFF003FB8) : const Color(0xFFE2E8F0),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
