import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import '../utils/service_center_l10n.dart';
import '../../domain/entities/service_center_entity.dart';

/// Center Details Overview Sheet Content (Figma Node 434:1174)
class CenterDetailsOverview extends StatelessWidget {
  final ServiceCenterEntity center;

  const CenterDetailsOverview({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0F002F8A),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Compatible Badge Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    ServiceCenterL10n.name(context, center.name),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2A44),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF84EBB4).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: Color(0xFF1FC16B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.l10n.compatibleBadge,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1FC16B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Rating & Distance Row
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFDB43),
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${center.rating}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFB45309),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  context.l10n.reviewsCountText(center.reviewsCount),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF606060),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '•',
                  style: TextStyle(color: Color(0xFFD9E2F0)),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Color(0xFF606060),
                ),
                const SizedBox(width: 4),
                Text(
                  context.l10n.distanceAway(ServiceCenterL10n.distance(context, center.distance)),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF606060),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Open Status Row
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Color(0xFF1FC16B),
                ),
                const SizedBox(width: 6),
                Text(
                  ServiceCenterL10n.workingHours(context, center.workingHours),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1FC16B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Specialties Section
            Text(
              context.l10n.specialtiesTitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.55,
                color: const Color(0xFF5B6780),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSpecialtyChip(Icons.build_rounded, context.l10n.specialtyEngine),
                _buildSpecialtyChip(Icons.bolt_rounded, context.l10n.specialtyElectrical),
                _buildSpecialtyChip(Icons.disc_full_rounded, context.l10n.specialtyBrakes),
                _buildSpecialtyChip(Icons.ac_unit_rounded, context.l10n.specialtyAc),
              ],
            ),
            const SizedBox(height: 20),

            // Authorized Brands Section
            Text(
              context.l10n.authorizedBrandsTitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.55,
                color: const Color(0xFF5B6780),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBrandChip('Toyota'),
                _buildBrandChip('Hyundai'),
                _buildBrandChip('Kia'),
                _buildBrandChip('Nissan'),
              ],
            ),
            const SizedBox(height: 20),

            // Address Card
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD9E2F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.place_rounded,
                      color: Color(0xFF003FB8),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ServiceCenterL10n.address(context, center.address ?? '12 Tahrir St, Cairo'),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2A44),
                          ),
                        ),
                        Text(
                          context.l10n.downtownAutomotive,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF5B6780),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      final addr = ServiceCenterL10n.address(
                        context,
                        center.address ?? '12 Tahrir St, Cairo',
                      );
                      AppActions.copyText(
                        context,
                        addr,
                        feedback: context.l10n.addressCopied(addr),
                      );
                    },
                    icon: const Icon(Icons.near_me_rounded,
                        size: 14, color: Color(0xFF0159C2)),
                    label: Text(
                      context.l10n.directionsButton,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0159C2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Certified Diagnostic Partner Reassurance Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF003FB8),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.certifiedPartner,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF334155),
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

  Widget _buildSpecialtyChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF003FB8)),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF003FB8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandChip(String brand) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        brand,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF334155),
        ),
      ),
    );
  }
}
