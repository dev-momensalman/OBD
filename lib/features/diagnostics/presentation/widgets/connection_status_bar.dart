import 'package:flutter/material.dart';
import 'package:obd_vision/core/constants/app_colors.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/connection_status.dart';
import 'glass_card.dart';

class ConnectionStatusBar extends StatelessWidget {
  final bool isConnected;
  final bool isSimulatedMode;
  final ConnectionStatus connectionStatus;
  final String vehicleTitle;

  const ConnectionStatusBar({
    super.key,
    required this.isConnected,
    required this.isSimulatedMode,
    required this.connectionStatus,
    this.vehicleTitle = 'Toyota Corolla 2021',
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isConnected ? AppColors.accentTeal : AppColors.criticalRed,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isSimulatedMode
                ? 'SIMULATED OBD-II (10 Hz)'
                : switch (connectionStatus) {
                    ConnectionStatus.connected => 'BLE LINK ACTIVE',
                    ConnectionStatus.connecting => 'CONNECTING...',
                    ConnectionStatus.handshaking => 'HANDSHAKING...',
                    _ => 'DISCONNECTED',
                  },
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const Spacer(),
          Text(
            vehicleTitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
