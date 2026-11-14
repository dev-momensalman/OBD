import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';

/// My Vehicle Page (Figma Node 325:2047)
/// Lists connected vehicles, switches active vehicle with "Current" indicator,
/// and provides an Add Vehicle action button.
class MyVehiclePage extends StatefulWidget {
  const MyVehiclePage({super.key});

  @override
  State<MyVehiclePage> createState() => _MyVehiclePageState();
}

class _MyVehiclePageState extends State<MyVehiclePage> {
  int _currentVehicleIndex = 0;

  final List<Map<String, dynamic>> _vehicles = [
    {
      'name': 'Corolla 2018',
      'nickname': 'My daily car',
      'brand': 'Toyota',
      'fuel': 'Petrol',
      'mileage': '84,200 km',
      'plate': '4821 KSA',
      'vin': 'JTDBR32E820194821',
    },
    {
      'name': 'Elantra 2020',
      'nickname': 'Family car',
      'brand': 'Hyundai',
      'fuel': 'Petrol',
      'mileage': '41,500 km',
      'plate': '7193 EGY',
      'vin': 'KMHD35LE9LU384102',
    },
  ];

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
                    'My Vehicle',
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

          // 2. Vehicle Cards List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(_vehicles.length, (index) {
                    final isCurrent = index == _currentVehicleIndex;
                    final vehicle = _vehicles[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrent
                              ? const Color(0xFF003FB8).withValues(alpha: 0.4)
                              : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002060).withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Vehicle Icon Container
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? const Color(0xFFEFF6FF)
                                  : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.directions_car_filled_rounded,
                              color: isCurrent
                                  ? const Color(0xFF003FB8)
                                  : const Color(0xFF64748B),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Vehicle Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicle['name']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1F2A44),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  vehicle['nickname']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF1F2A44),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${vehicle['brand']} · ${vehicle['fuel']} · ${vehicle['mileage']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF5B6780),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Current Badge / Set Current Button
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF84EBB4)
                                    .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: Color(0xFF1FC16B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Current',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1FC16B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _currentVehicleIndex = index;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFF004FE7)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Set as current',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0159C2),
                                ),
                              ),
                            ),

                          const SizedBox(width: 6),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                size: 18, color: Color(0xFF94A3B8)),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.editVehicle,
                                arguments: vehicle,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Helper Notice Line
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: Color(0xFF5B6780),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Each vehicle keeps its own diagnostic history.',
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

          // 3. Add Vehicle CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.addVehicle);
                },
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(
                  'Add Vehicle',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003FB8),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
