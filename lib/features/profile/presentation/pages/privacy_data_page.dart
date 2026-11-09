import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Privacy & Data Policy Screen (Figma Node 325:3324)
/// Provides links to Privacy Policy, Terms of Use, Data Export, and Account Deletion,
/// with GDPR & End-to-end encryption trust credentials.
class PrivacyDataPage extends StatelessWidget {
  const PrivacyDataPage({super.key});

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
                    'Privacy & data',
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

          // 2. Options Card
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
                        _buildRow(
                          icon: Icons.policy_rounded,
                          title: 'Privacy policy',
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildRow(
                          icon: Icons.article_rounded,
                          title: 'Terms of use',
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildRow(
                          icon: Icons.download_rounded,
                          title: 'Download my data',
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildRow(
                          icon: Icons.delete_forever_rounded,
                          title: 'Delete account',
                          isDestructive: true,
                          badge: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFB3748)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              'Permanent',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFD00416),
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reassurance & Trust Metric Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF84EBB4).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          size: 16,
                          color: Color(0xFF1FC16B),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'End-to-end encrypted · GDPR ready',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1FC16B),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildRow({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    Widget? badge,
    required VoidCallback onTap,
  }) {
    final color =
        isDestructive ? const Color(0xFFD00416) : const Color(0xFF1F2A44);

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
                color: isDestructive
                    ? const Color(0xFFFB3748).withValues(alpha: 0.1)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? const Color(0xFFD00416)
                    : const Color(0xFF003FB8),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (badge != null) ...[
              badge,
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive
                  ? const Color(0xFFD00416)
                  : const Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
