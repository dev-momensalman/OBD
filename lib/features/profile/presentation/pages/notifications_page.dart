import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notifications Preferences Page (Figma Node 325:2609)
/// Allows user to toggle granular alerts: early warnings, diagnostic reports,
/// booking updates, quote approvals, and device status.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _earlyWarnings = true;
  bool _diagnosticReports = true;
  bool _bookingUpdates = true;
  bool _quoteApprovals = true;
  bool _deviceStatus = false;

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
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Notifications',
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

          // 2. Settings Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD9E2F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSwitchRow(
                          title: 'Early warnings',
                          subtitle: 'When we notice unusual vehicle behavior',
                          value: _earlyWarnings,
                          onChanged: (val) =>
                              setState(() => _earlyWarnings = val),
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildSwitchRow(
                          title: 'Diagnostic reports',
                          subtitle: 'When your AI analysis report is ready',
                          value: _diagnosticReports,
                          onChanged: (val) =>
                              setState(() => _diagnosticReports = val),
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildSwitchRow(
                          title: 'Booking updates',
                          subtitle: 'Status changes from your service centers',
                          value: _bookingUpdates,
                          onChanged: (val) =>
                              setState(() => _bookingUpdates = val),
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildSwitchRow(
                          title: 'Quote approvals',
                          subtitle: 'When a revised quote needs your review',
                          value: _quoteApprovals,
                          onChanged: (val) =>
                              setState(() => _quoteApprovals = val),
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildSwitchRow(
                          title: 'Device status',
                          subtitle:
                              'When your scanner disconnects or connects',
                          value: _deviceStatus,
                          onChanged: (val) =>
                              setState(() => _deviceStatus = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Footnote
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 16,
                        color: Color(0xFF5B6780),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Critical safety warnings cannot be disabled.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF5B6780),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: const Color(0xFF1F2A44),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: const Color(0xFF003FB8),
            activeThumbColor: Colors.white,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
