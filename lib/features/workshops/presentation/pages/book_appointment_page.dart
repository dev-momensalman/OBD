import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/service_center_entity.dart';

/// Book Appointment Page (Figma Node 435:2041)
/// Interactive date and time picker, note field, diagnostic report sharing toggle,
/// dynamic appointment summary pill, and Confirm Booking CTA.
class BookAppointmentPage extends StatefulWidget {
  final ServiceCenterEntity? center;

  const BookAppointmentPage({
    super.key,
    this.center,
  });

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  int _selectedDateIndex = 3; // 21 (Thu)
  String _selectedTime = '10:00 AM';
  bool _shareDiagnosticReport = true;
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _dates = [
    {'day': '18', 'weekday': 'Mo', 'full': 'Mon, Dec 18'},
    {'day': '19', 'weekday': 'Tu', 'full': 'Tue, Dec 19'},
    {'day': '20', 'weekday': 'Wed', 'full': 'Wed, Dec 20'},
    {'day': '21', 'weekday': 'Th', 'full': 'Thu, Dec 21'},
    {'day': '22', 'weekday': 'Fr', 'full': 'Fri, Dec 22'},
    {'day': '23', 'weekday': 'Sa', 'full': 'Sat, Dec 23'},
    {'day': '24', 'weekday': 'Su', 'full': 'Sun, Dec 24'},
  ];

  final List<String> _morningSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
  ];

  final List<String> _afternoonSlots = [
    '1:00 PM', // Taken
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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
          tags: ['Engine', 'Electrical'],
          address: '12 Tahrir St, Cairo',
        );

    final selectedDateStr = _dates[_selectedDateIndex]['full'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Figma Header with Curved Gradient
          Container(
            height: 114,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
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
                    'Book appointment',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Balance back button
              ],
            ),
          ),

          // 2. Main Form Content (Zero scroll budget)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Workshop Reference Line
                  Row(
                    children: [
                      const Icon(Icons.business_rounded,
                          size: 16, color: Color(0xFF003FB8)),
                      const SizedBox(width: 6),
                      Text(
                        center.name,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2A44),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Date Selection Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2A44),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 13, color: Color(0xFF5B6780)),
                          const SizedBox(width: 4),
                          Text(
                            'December 2026',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Calendar Horizontal Strip (7 Days)
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_dates.length, (index) {
                        final isSelected = index == _selectedDateIndex;
                        final dateItem = _dates[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDateIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 44,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFC4AAFF).withValues(alpha: 0.35)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(
                                      color: const Color(0xFF4D00FF)
                                          .withValues(alpha: 0.4),
                                    )
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dateItem['day']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? const Color(0xFF3C00C6)
                                        : const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dateItem['weekday']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? const Color(0xFF4D00FF)
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time Selection Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2A44),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1FC16B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '7 slots open',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1FC16B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 8 Time Chips in 2 Rows
                  Row(
                    children: _morningSlots.map((time) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: _buildTimeChip(time),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _afternoonSlots.map((time) {
                      final isTaken = time == '1:00 PM';
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: isTaken
                              ? _buildTakenSlot(time)
                              : _buildTimeChip(time),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Note Field (Optional)
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD9E2F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.edit_note_rounded,
                          size: 20,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _noteController,
                            maxLines: 3,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF1F2A44),
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Add a note (e.g. check engine light on, strange noise)...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFFA9B4C7),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Share Diagnostic Report Toggle Row
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD9E2F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
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
                          child: const Icon(
                            Icons.description_rounded,
                            color: Color(0xFF003FB8),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Share diagnostic report',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2A44),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Includes your codes, readings, and AI summary.',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF5B6780),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _shareDiagnosticReport,
                          activeThumbColor: const Color(0xFF8855FF),
                          onChanged: (val) {
                            setState(() {
                              _shareDiagnosticReport = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Sticky Bottom Confirmation Area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFD9E2F0).withValues(alpha: 0.8),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Summary Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC4AAFF).withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: const Color(0xFF4D00FF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_filled_rounded,
                        size: 14,
                        color: Color(0xFF4D00FF),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$selectedDateStr · $_selectedTime',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2A44),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Primary CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.bookingConfirm,
                        arguments: {
                          'center': center,
                          'schedule': '$selectedDateStr · $_selectedTime',
                          'note': _noteController.text,
                        },
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
                      'Confirm Booking',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    final isSelected = _selectedTime == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTime = time;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4D00FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFD2D2D2)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4D00FF).withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _buildTakenSlot(String time) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 11,
              decoration: TextDecoration.lineThrough,
              color: const Color(0xFFA9B4C7),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Taken',
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5B6780),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
