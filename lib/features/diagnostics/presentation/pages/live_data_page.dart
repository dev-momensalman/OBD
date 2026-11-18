import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';

/// Authentic Live Data Telemetry Screen matching Figma Node 269:774
/// Features interactive circular gauge telemetry sensors, real-time live data simulation,
/// and responsive action controls (Pause/Resume, Run Diagnosis).
class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {
  bool _isPaused = false;
  Timer? _telemetryTimer;

  // Real-time sensor state values
  int _rpm = 780;
  double _voltage = 13.8;
  int _fuelTrim = 18;
  int _engineLoad = 24;
  int _coolantTemp = 96;
  final int _speed = 0;
  int _throttle = 14;
  int _mapPressure = 34;

  @override
  void initState() {
    super.initState();
    _startTelemetryStream();
  }

  void _startTelemetryStream() {
    _telemetryTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!_isPaused && mounted) {
        setState(() {
          // Slight realistic telemetry jitter
          _rpm = 775 + (DateTime.now().millisecond % 25);
          _voltage = 13.7 + ((DateTime.now().millisecond % 3) * 0.1);
          _fuelTrim = 17 + (DateTime.now().millisecond % 3);
          _engineLoad = 23 + (DateTime.now().millisecond % 3);
          _coolantTemp = 95 + (DateTime.now().millisecond % 3);
          _throttle = 13 + (DateTime.now().millisecond % 3);
          _mapPressure = 33 + (DateTime.now().millisecond % 3);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF242424), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Live data',
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
                      title: 'Engine speed',
                      status: 'Normal',
                      statusColor: const Color(0xFF1FC16B),
                      unit: 'RPM',
                      value: '$_rpm',
                      progress: (_rpm / 3000).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: 'Battery',
                      status: 'Normal',
                      statusColor: const Color(0xFF1FC16B),
                      unit: 'Volt',
                      value: _voltage.toStringAsFixed(1),
                      progress: (_voltage / 16.0).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: 'Short fuel trim',
                      status: 'High',
                      statusColor: const Color(0xFFD00416),
                      unit: '%',
                      value: '+$_fuelTrim',
                      progress: (_fuelTrim / 30).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFFD00416),
                    ),
                    _buildGaugeCard(
                      title: 'Engine Load',
                      status: 'Medium',
                      statusColor: const Color(0xFFDFB400),
                      unit: '%',
                      value: '$_engineLoad',
                      progress: (_engineLoad / 100).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFFDFB400),
                    ),
                    _buildGaugeCard(
                      title: 'Coolant temp',
                      status: 'Normal',
                      statusColor: const Color(0xFF1FC16B),
                      unit: '°C',
                      value: '$_coolantTemp',
                      progress: (_coolantTemp / 120).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: 'Vehicle speed',
                      status: 'Normal',
                      statusColor: const Color(0xFF1FC16B),
                      unit: 'Km / h',
                      value: '$_speed',
                      progress: (_speed / 200).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: 'Throttle pos',
                      status: 'Normal',
                      statusColor: const Color(0xFF1FC16B),
                      unit: '%',
                      value: '$_throttle',
                      progress: (_throttle / 100).clamp(0.0, 1.0),
                      gaugeColor: const Color(0xFF1FC16B),
                    ),
                    _buildGaugeCard(
                      title: 'MAP Pressure',
                      status: 'Normal',
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

            // Bottom Actions: Pause & Run Diagnosis (Figma Node 269:782 & 269:783)
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
                          _isPaused ? 'Resume' : 'Pause',
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
                          Navigator.of(context).pushNamed(AppRoutes.scan);
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
                          'Run Diagnosis',
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
          // Header: Status + Sensor Title
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

          // Circular Ring Visual
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
