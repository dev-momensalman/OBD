import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:obd_vision/features/settings/presentation/bloc/settings_state.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';

/// Authentic Live Data Telemetry Screen matching Figma Node 269:774
/// Subscribes to [DashboardCubit] live stream when provided, respects unit settings
/// from [SettingsCubit], and preserves local Pause/Resume controls.
class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {
  bool _isPaused = false;
  Timer? _telemetryTimer;

  // Fallback telemetry values when no ancestor DashboardCubit exists (or paused snapshot)
  int _rpm = 780;
  double _voltage = 13.8;
  final int _fuelTrim = 18;
  int _engineLoad = 24;
  int _coolantTemp = 96;
  int _speed = 0;
  final int _throttle = 14;
  final int _mapPressure = 34;

  bool _hasDashboardCubit(BuildContext context) {
    try {
      context.read<DashboardCubit>();
      return true;
    } catch (_) {
      return false;
    }
  }

  SettingsState _readSettings(BuildContext context) {
    try {
      return context.watch<SettingsCubit>().state;
    } catch (_) {
      return const SettingsState();
    }
  }

  @override
  void initState() {
    super.initState();
    _telemetryTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!_isPaused && mounted && !_hasDashboardCubit(context)) {
        setState(() {
          _rpm = 775 + (DateTime.now().millisecond % 25);
          _voltage = 13.7 + ((DateTime.now().millisecond % 3) * 0.1);
          _engineLoad = 23 + (DateTime.now().millisecond % 3);
          _coolantTemp = 95 + (DateTime.now().millisecond % 3);
        });
      }
    });
  }

  @override
  void dispose() {
    _telemetryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = _readSettings(context);

    DashboardState? dashboardState;
    try {
      dashboardState = context.watch<DashboardCubit>().state;
    } catch (_) {}

    if (!_isPaused && dashboardState?.telemetry != null) {
      final t = dashboardState!.telemetry!;
      _rpm = t.engineRpm.toInt();
      _voltage = t.batteryVoltage;
      _engineLoad = t.engineLoadPercent.toInt();
      _coolantTemp = t.coolantTempC.toInt();
      _speed = t.vehicleSpeedKmH.toInt();
    }

    final displayCoolant = settings.usesFahrenheit
        ? ((_coolantTemp * 9.0 / 5.0) + 32.0).toInt()
        : _coolantTemp;
    final displaySpeed =
        settings.usesMiles ? (_speed * 0.621371).toInt() : _speed;
    final speedUnit = settings.usesMiles ? 'mph' : 'Km / h';

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
          l10n.liveDataTitle,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF242424),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Telemetry Grid (Figma Node 274:492)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.95,
                  children: [
                    _buildGaugeCard(
                      title: l10n.liveSensorEngineSpeed,
                      status: l10n.statusNormal,
                      statusColor: const Color(0xFF1FC16B),
                      unit: l10n.unitRpm,
                      value: '$_rpm',
                      progress: (_rpm / 3000).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: l10n.liveSensorBattery,
                      status: l10n.statusNormal,
                      statusColor: const Color(0xFF1FC16B),
                      unit: l10n.unitVolt,
                      value: _voltage.toStringAsFixed(1),
                      progress: (_voltage / 16.0).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: l10n.liveSensorShortFuelTrim,
                      status: l10n.statusHigh,
                      statusColor: const Color(0xFFD00416),
                      unit: '%',
                      value: '+$_fuelTrim',
                      progress: (_fuelTrim / 30).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFFD00416),
                    ),
                    _buildGaugeCard(
                      title: l10n.liveSensorEngineLoad,
                      status: l10n.statusMedium,
                      statusColor: const Color(0xFFDFB400),
                      unit: '%',
                      value: '$_engineLoad',
                      progress: (_engineLoad / 100).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFFDFB400),
                    ),
                    _buildGaugeCard(
                      title: l10n.liveSensorCoolantTemp,
                      status:
                          _coolantTemp >= 105 ? l10n.statusHigh : l10n.statusNormal,
                      statusColor: _coolantTemp >= 105
                          ? const Color(0xFFD00416)
                          : const Color(0xFF1FC16B),
                      unit: settings.tempUnit,
                      value: '$displayCoolant',
                      progress: (_coolantTemp / 120).clamp(0.0, 1.0),
                      gaugeColor: _coolantTemp >= 105
                          ? const Color(0xFFD00416)
                          : const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: l10n.liveSensorVehicleSpeed,
                      status: l10n.statusNormal,
                      statusColor: const Color(0xFF1FC16B),
                      unit: speedUnit,
                      value: '$displaySpeed',
                      progress: (_speed / 200).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: l10n.liveSensorThrottlePos,
                      status: l10n.statusNormal,
                      statusColor: const Color(0xFF1FC16B),
                      unit: '%',
                      value: '$_throttle',
                      progress: (_throttle / 100).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: l10n.liveSensorMapPressure,
                      status: l10n.statusNormal,
                      statusColor: const Color(0xFF1FC16B),
                      unit: 'kPa',
                      value: '$_mapPressure',
                      progress: (_mapPressure / 100).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions: Pause & Run Diagnosis
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _isPaused = !_isPaused);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF003FB8),
                          side: const BorderSide(color: Color(0xFFD2D2D2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _isPaused ? l10n.resumeButton : l10n.pauseButton,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.home,
                            (route) => false,
                            arguments: 2,
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
                          l10n.runDiagnosis,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildGaugeCard({
    required String title,
    required String status,
    required Color statusColor,
    required String unit,
    required String value,
    required double progress,
    required Color gaugeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF19213D).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF19213D),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 86,
            height: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 82,
                  height: 82,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFFF1F3F7),
                    valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      unit,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF6D758F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF19213D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
