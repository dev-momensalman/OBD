import 'package:flutter/material.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../diagnostics/presentation/pages/diagnosis_page.dart';
import '../../../history/presentation/pages/activity_history_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../workshops/presentation/pages/service_centers_page.dart';
import '../widgets/active_workshop_card.dart';
import '../widgets/curved_bottom_nav_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/live_telemetry_section.dart';
import '../widgets/system_health_card.dart';

/// Authentic Root Home & Navigation Shell matching Figma Node 274:983 & Component 2
/// Hosts the 5 core application tabs:
/// [0] Home Dashboard
/// [1] Service Centers & Workshops
/// [2] Diagnosis & Scan
/// [3] Activity & History
/// [4] Profile & Settings
class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentNavIndex;

  @override
  void initState() {
    super.initState();
    _currentNavIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    if (_currentNavIndex != index) {
      setState(() {
        _currentNavIndex = index;
      });
    }
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeDashboard();
      case 1:
        return ServiceCentersPage(onBack: () => _onNavTap(0));
      case 2:
        return DiagnosisPage(onBack: () => _onNavTap(0));
      case 3:
        return ActivityHistoryPage(onBack: () => _onNavTap(0));
      case 4:
        return ProfilePage(onBack: () => _onNavTap(0));
      default:
        return _buildHomeDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // 1. Smooth Animated Tab Content Transition
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentNavIndex),
                child: _buildCurrentTab(),
              ),
            ),
          ),

          // 2. Persistent Authentic Animated Figma Curved Bottom Navigation Bar
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

  Widget _buildHomeDashboard() {
    return SingleChildScrollView(
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
              Navigator.of(context).pushNamed(AppRoutes.myVehicle);
            },
            onBluetoothTap: () {
              Navigator.of(context).pushNamed(AppRoutes.myDevice);
            },
            onNotificationsTap: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
          const SizedBox(height: 16),

          // 2. System Health & Alert Card (86 Health Score)
          SystemHealthCard(
            healthScore: 86,
            warningTitle: 'Coolant temperature\ntrending high',
            warningSubtitle: 'Last scan today, 09:40 · Inspect sensor',
            onRunDiagnosis: () {
              // Smoothly transition to Diagnosis tab inside the bottom navbar shell
              _onNavTap(2);
            },
            onSeeDetails: () {
              Navigator.of(context).pushNamed(AppRoutes.reportSummary);
            },
          ),
          const SizedBox(height: 20),

          // 3. Live Telemetry Section (Engine Speed, Coolant, Alternator)
          LiveTelemetrySection(
            engineRpm: 780,
            coolantTemp: 96.0,
            alternatorVoltage: 13.8,
            onSeeAll: () {
              Navigator.of(context).pushNamed(AppRoutes.liveData);
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
              // Smoothly transition to Service tab inside the bottom navbar shell
              _onNavTap(1);
            },
          ),

          // Bottom padding so content is never obscured by the curved bottom bar
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
