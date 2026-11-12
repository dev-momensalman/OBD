import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/service_center_entity.dart';

/// Center Details Page (Figma Node 434:1174)
/// Displays workshop photo carousel, compatibility badge, specialties,
/// authorized brands, address card with navigation, and book appointment CTA.
class CenterDetailsPage extends StatefulWidget {
  final ServiceCenterEntity? center;

  const CenterDetailsPage({
    super.key,
    this.center,
  });

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
          id: 'sc-1',
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
                _buildPhotoHeader(),

                // Main Content Card / Sheet
                Transform.translate(
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
                                center.name,
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
                                    'Compatible',
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
                              '(${center.reviewsCount} reviews)',
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
                              '${center.distance} away',
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
                              'Open now',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1FC16B),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '· Closes 8:00 PM',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF606060),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Divider
                        const Divider(
                          color: Color(0x99D9E2F0),
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(height: 16),

                        // Specialties Section
                        Text(
                          'SPECIALTIES',
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
                            _buildSpecialtyChip(
                                Icons.settings_rounded, 'Engine'),
                            _buildSpecialtyChip(
                                Icons.bolt_rounded, 'Electrical'),
                            _buildSpecialtyChip(
                                Icons.disc_full_rounded, 'Brakes'),
                            _buildSpecialtyChip(
                                Icons.ac_unit_rounded, 'AC'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Authorized Brands Section
                        Text(
                          'AUTHORIZED BRANDS',
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
                                      center.address ?? '12 Tahrir St, Cairo',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1F2A44),
                                      ),
                                    ),
                                    Text(
                                      'Downtown Automotive District',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFF5B6780),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.near_me_rounded,
                                    size: 14, color: Color(0xFF0159C2)),
                                label: Text(
                                  'Directions',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0159C2),
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Certified Assurance Note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 14,
                              color: Color(0xFF1FC16B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Certified OBD-II Diagnostic Partner',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF4A4A4A),
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
          ),

          // 2. Floating Top Bar (Back, Favorite, Share)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGlassCircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
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
                        onTap: () {},
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
                      onPressed: () {},
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
                          'Book appointment',
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

  Widget _buildPhotoHeader() {
    return Container(
      height: 240,
      width: double.infinity,
      color: const Color(0xFF0F172A),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Workshop image gradient carousel
          PageView.builder(
            itemCount: 4,
            onPageChanged: (index) {
              setState(() {
                _activePhotoIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF001C52 + (index * 0x00050810)),
                      const Color(0xFF0F172A),
                      const Color(0xFF1E293B),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    index % 2 == 0
                        ? Icons.precision_manufacturing_rounded
                        : Icons.car_repair_rounded,
                    size: 72,
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
              );
            },
          ),

          // Top gradient scrim
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),

          // Photo Carousel Dots
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(4, (index) {
                    final isActive = index == _activePhotoIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: isActive ? 16 : 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    );
                  }),
                ),
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
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildSpecialtyChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF0159C2)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0159C2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandChip(String brand) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD9E2F0).withValues(alpha: 0.6),
        ),
      ),
      child: Text(
        brand,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1F2A44),
        ),
      ),
    );
  }
}
