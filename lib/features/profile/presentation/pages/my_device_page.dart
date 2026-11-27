import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:obd_vision/injection_container.dart' as di;

/// My Device Page (Figma Node 325:2262)
/// Manages paired OBD-II hardware scanner, status, firmware, re-pairing, and deactivation.
class MyDevicePage extends StatefulWidget {
  const MyDevicePage({super.key});

  @override
  State<MyDevicePage> createState() => _MyDevicePageState();
}

class _MyDevicePageState extends State<MyDevicePage> {
  bool _isPaired = true;

  @override
  void initState() {
    super.initState();
    if (di.sl.isRegistered<AppPreferences>()) {
      _isPaired = di.sl<AppPreferences>().devicePaired;
    }
  }

  String _activeVehicleName(BuildContext context) {
    try {
      final v = context.read<VehicleCubit>().state.activeVehicle;
      if (v != null) return v.name;
    } catch (_) {}
    if (di.sl.isRegistered<VehicleCubit>()) {
      return di.sl<VehicleCubit>().state.activeVehicle?.name ?? 'Corolla 2018';
    }
    return 'Corolla 2018';
  }

  String _activeSerial() {
    if (di.sl.isRegistered<AppPreferences>()) {
      final s = di.sl<AppPreferences>().activatedSerial;
      if (s != null && s.isNotEmpty) return s;
    }
    return '••••-••••-A7F2';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Curved Header
          Container(
            height: 124,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 44, left: 16, right: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000C24),
                  Color(0xFF002F8A),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const RtlBackIcon(
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.myDeviceTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // 2. Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Section - Device Overview Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD9E2F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header Row (Icon + Name + Connected Tag)
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.settings_input_composite_rounded,
                                color: Color(0xFF003FB8),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'OBD-A7F2',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1F2A44),
                                    ),
                                  ),
                                  Text(
                                    'Bluetooth LE 5.2',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _isPaired
                                    ? const Color(0xFFE6F6EE)
                                    : const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _isPaired
                                          ? const Color(0xFF1FC16B)
                                          : const Color(0xFFDC2626),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isPaired
                                        ? context.l10n.deviceConnectedStatus
                                        : context.l10n.deviceDeactivatedMsg,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _isPaired
                                          ? const Color(0xFF1FC16B)
                                          : const Color(0xFFDC2626),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: Color(0xFFF1F5F9),
                            height: 1,
                          ),
                        ),

                        // Specifications List
                        _buildSpecRow(context.l10n.serialLabel, _activeSerial()),
                        const SizedBox(height: 12),
                        _buildSpecRow(context.l10n.firmwareLabel, 'v2.4.1'),
                        const SizedBox(height: 12),
                        _buildSpecRow(context.l10n.lastConnectedLabel, 'Today, 9:12 AM'),
                        const SizedBox(height: 12),
                        _buildSpecRow(
                          context.l10n.linkedVehicleLabel,
                          _activeVehicleName(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section - Action Rows
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD9E2F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildActionRow(
                          icon: Icons.bluetooth_searching_rounded,
                          title: context.l10n.rePairDevice,
                          onTap: () {
                            setState(() => _isPaired = true);
                            if (di.sl.isRegistered<AppPreferences>()) {
                              di.sl<AppPreferences>().setDevicePaired(true);
                            }
                            AppActions.showSnack(
                              context,
                              context.l10n.devicePairedMsg,
                            );
                          },
                        ),
                        const Divider(
                          color: Color(0xFFF1F5F9),
                          height: 1,
                        ),
                        _buildActionRow(
                          icon: Icons.system_update_alt_rounded,
                          title: context.l10n.checkForUpdates,
                          badge: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD00416),
                              shape: BoxShape.circle,
                            ),
                          ),
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (dlgCtx) => AlertDialog(
                                title: Text(context.l10n.firmwareUpToDateTitle),
                                content: Text(context.l10n.firmwareUpToDateBody),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(dlgCtx).pop(),
                                    child: Text(context.l10n.closeButton),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Destructive Action: Deactivate device
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() => _isPaired = false);
                        if (di.sl.isRegistered<AppPreferences>()) {
                          di.sl<AppPreferences>().setDevicePaired(false);
                        }
                        AppActions.showSnack(
                          context,
                          context.l10n.deviceDeactivatedMsg,
                          isError: true,
                        );
                      },
                      icon: const Icon(
                        Icons.link_off_rounded,
                        color: Color(0xFFC62828),
                        size: 20,
                      ),
                      label: Text(
                        context.l10n.deactivateDevice,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFC62828),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF003FB8),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2A44),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    Widget? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF003FB8), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2A44),
                ),
              ),
            ),
            if (badge != null) ...[
              badge,
              const SizedBox(width: 8),
            ],
            const RtlForwardChevron(
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
