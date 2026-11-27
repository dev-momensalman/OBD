import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_assets.dart';

/// Top App Bar matching Figma Node 274:983 (Home Page)
/// Features vehicle model dropdown, green OBD-II status indicator, Bluetooth toggle, and Notification badge.
class HomeHeader extends StatelessWidget {
  final String vehicleName;
  final String connectionText;
  final bool isConnected;
  final VoidCallback? onVehicleTap;
  final VoidCallback? onBluetoothTap;
  final VoidCallback? onNotificationsTap;

  const HomeHeader({
    super.key,
    this.vehicleName = 'Corolla 2018',
    this.connectionText = 'Connected · OBD-II v2.4',
    this.isConnected = true,
    this.onVehicleTap,
    this.onBluetoothTap,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF003FB8), // Figma Core Brand Blue
            Color(0xFF002E8A), // Deep Navy
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Logo Badge + Connection info + Vehicle Title
          Row(
            children: [
              // White circular container with 4x crisp emblem
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  AppAssets.appLogoMark,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),

              // Status and Vehicle Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row: Green dot + connection text
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isConnected
                              ? const Color(0xFF34D399)
                              : const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        connectionText,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Vehicle dropdown
                  GestureDetector(
                    onTap: onVehicleTap,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Text(
                          vehicleName,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right: Action buttons (Bluetooth & Notifications)
          Row(
            children: [
              // Bluetooth action button
              GestureDetector(
                onTap: onBluetoothTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.bluetooth_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Notifications button with red unread badge
              GestureDetector(
                onTap: onNotificationsTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF1E293B),
                        size: 22,
                      ),
                      PositionedDirectional(
                        top: 8,
                        end: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE11D48), // Red unread badge
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
