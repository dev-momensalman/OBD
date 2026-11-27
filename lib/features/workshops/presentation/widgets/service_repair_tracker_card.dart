import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/injection_container.dart' as di;
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/service_center_entity.dart';
import '../utils/service_center_l10n.dart';

/// Active Repair Progress Banner (Figma Node 404:3388)
class ServiceRepairTrackerCard extends StatelessWidget {
  const ServiceRepairTrackerCard({super.key});

  Map<String, dynamic>? _readActiveBooking() {
    if (!di.sl.isRegistered<AppPreferences>()) return null;
    final raw = di.sl<AppPreferences>().savedActiveBookingJson;
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = _readActiveBooking();
    final center = ServiceCenterEntity(
      id: booking?['centerId'] as String? ?? 'sc-1',
      name: booking?['centerName'] as String? ?? 'Al-Nour Service Center',
      distance: booking?['distance'] as String? ?? '1.2 km',
      rating: (booking?['rating'] as num?)?.toDouble() ?? 4.7,
      reviewsCount: booking?['reviewsCount'] as int? ?? 230,
      workingHours: booking?['workingHours'] as String? ?? 'Open until 8 PM',
      isOpen: booking?['isOpen'] as bool? ?? true,
      tags: (booking?['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Engine', 'Electrical', 'Compatible'],
      address: booking?['address'] as String? ?? 'Plot 14, Auto District, Cairo',
      phoneNumber: booking?['phoneNumber'] as String? ?? '+201001234567',
    );
    final scheduleSub = booking == null
        ? context.l10n.readyThursdaySub
        : '${ServiceCenterL10n.name(context, center.name)} · ${booking['schedule']}';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.centerDetails,
          arguments: center,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD9E2F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF002F8A).withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.handyman_rounded,
                color: Color(0xFF003FB8),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        context.l10n.repairInProgress,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF84E8B4)
                              .withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          context.l10n.activeTag,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    scheduleSub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const RtlForwardChevron(color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
