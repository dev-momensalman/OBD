import 'package:flutter/material.dart';
import 'package:obd_vision/features/home/presentation/widgets/active_workshop_card.dart';
import 'package:obd_vision/features/home/presentation/widgets/curved_bottom_nav_bar.dart';
import 'package:obd_vision/features/home/presentation/widgets/home_header.dart';
import 'package:obd_vision/features/home/presentation/widgets/live_telemetry_section.dart';
import 'package:obd_vision/features/home/presentation/widgets/system_health_card.dart';

/// Authentic Home Page matching Figma Node 274:983
/// Features vehicle status header, health card with score ring, live telemetry gauges, active workshop tracker, and curved navigation.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    if (index == 2) {
      // Index 2 is Scan -> navigate to diagnostic scanner
      _onRunDiagnosis();
    }
  }

  void _onRunDiagnosis() {
    _showSnackBar('Diagnostic Scan flow (Pre-Check) according to Figma');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Scrollable Page Content
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Vehicle Header (Corolla 2018 + OBD-II status)
                  HomeHeader(
                    vehicleName: 'Corolla 2018',
                    connectionText: 'Connected · OBD-II v2.4',
                    isConnected: true,
                    onVehicleTap: () {
                      _showSnackBar('Selected Vehicle: Corolla 2018');
                    },
                    onBluetoothTap: () {
                      _showSnackBar('OBD-II Bluetooth: Connected');
                    },
                    onNotificationsTap: () {
                      _showSnackBar('Notifications: 1 Alert pending');
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2. System Health & Alert Card (86 Health Score)
                  SystemHealthCard(
                    healthScore: 86,
                    warningTitle: 'Coolant temperature\ntrending high',
                    warningSubtitle: 'Last scan today, 09:40 · Inspect sensor',
                    onRunDiagnosis: _onRunDiagnosis,
                    onSeeDetails: () {
                      _showSnackBar('Opening System Health details...');
                    },
                  ),
                  const SizedBox(height: 20),

                  // 3. Live Telemetry Section (Engine Speed, Coolant, Alternator)
                  LiveTelemetrySection(
                    engineRpm: 780,
                    coolantTemp: 96.0,
                    alternatorVoltage: 13.8,
                    onSeeAll: () {
                      _showSnackBar('Opening Full Telemetry stream...');
                    },
                  ),
                  const SizedBox(height: 20),

                  // 4. Active Workshop Service (Stage 4/5 - Al-Nour Service Center)
                  ActiveWorkshopCard(
                    statusText: 'Repair in progress',
                    stageText: 'Stage 4/5',
                    centerName: 'Al-Nour Service Center',
                    serviceType: 'Radiator Flush',
                    onTrack: () {
                      _showSnackBar('Tracking active workshop service...');
                    },
                  ),

                  // Bottom padding so content is never obscured by the curved bottom bar
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // 5. Authentic Figma Curved Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CurvedBottomNavBar(
              selectedIndex: _currentNavIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
