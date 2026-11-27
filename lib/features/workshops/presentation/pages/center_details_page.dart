import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import '../utils/service_center_l10n.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/service_center_entity.dart';
import '../widgets/center_details_overview.dart';
import '../widgets/center_photo_header.dart';

/// Authentic Service Center Details Page matching Figma Node 434:1174
class CenterDetailsPage extends StatefulWidget {
  final ServiceCenterEntity? center;

  const CenterDetailsPage({super.key, this.center});

  @override
  State<CenterDetailsPage> createState() => _CenterDetailsPageState();
}

class _CenterDetailsPageState extends State<CenterDetailsPage> {
  int _activePhotoIndex = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final center = widget.center ??
        const ServiceCenterEntity(
          id: 'sc_01',
          name: 'Al-Nour Service Center',
          distance: '1.2 km',
          rating: 4.7,
          reviewsCount: 230,
          workingHours: 'Open now · Closes 8:00 PM',
          isOpen: true,
          tags: ['Engine', 'Electrical', 'Brakes', 'AC'],
          address: '12 Tahrir St, Cairo',
          phoneNumber: '+20 100 123 4567',
        );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Section: Photo Header (240px tall, under status bar)
                CenterPhotoHeader(
                  activePhotoIndex: _activePhotoIndex,
                  onPageChanged: (idx) => setState(() => _activePhotoIndex = idx),
                  centerName: ServiceCenterL10n.name(context, center.name),
                ),

                // Main Content Overview Card
                CenterDetailsOverview(center: center),
              ],
            ),
          ),

          // 2. Floating Top Bar (Back, Favorite, Share)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGlassCircleButton(
                    icon: context.backIcon,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Row(
                    children: [
                      _buildGlassCircleButton(
                        icon: _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: _isFavorite
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF1F2A44),
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildGlassCircleButton(
                        icon: Icons.share_rounded,
                        onTap: () {
                          final info =
                              '${ServiceCenterL10n.name(context, center.name)}\n'
                              '${ServiceCenterL10n.address(context, center.address ?? 'Cairo')}\n'
                              '${center.phoneNumber ?? '+201001234567'}';
                          AppActions.copyText(context, info);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Sticky Action Bar (Call + Book Appointment)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Call button
                  Container(
                    height: 54,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD9E2F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.phone_rounded,
                          color: Color(0xFF003FB8)),
                      onPressed: () {
                        final phone = center.phoneNumber ?? '+201001234567';
                        AppActions.copyText(
                          context,
                          phone,
                          feedback: context.l10n.callPhoneCopied(phone),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Book Appointment CTA
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.bookAppointment,
                            arguments: center,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003FB8),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          context.l10n.bookAppointmentButton,
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
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF1F2A44),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
