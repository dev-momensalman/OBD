import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dynamic 7-Day Calendar Strip Picker (Figma Node 435:2041)
/// Dynamically calculates upcoming days from DateTime.now() to eliminate hardcoded stagnation.
class CalendarStripPicker extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectDate;
  final List<Map<String, dynamic>> dates;

  const CalendarStripPicker({
    super.key,
    required this.selectedIndex,
    required this.onSelectDate,
    required this.dates,
  });

  static List<Map<String, dynamic>> generateDynamicDates([DateTime? baseDate]) {
    final now = baseDate ?? DateTime.now();
    const weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    const fullWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      final weekdayIndex = date.weekday - 1;
      final monthIndex = date.month - 1;

      return {
        'day': date.day.toString().padLeft(2, '0'),
        'weekday': weekdays[weekdayIndex],
        'full': '${fullWeekdays[weekdayIndex]}, ${months[monthIndex]} ${date.day}',
        'date': date,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(dates.length, (index) {
          final isSelected = selectedIndex == index;
          final item = dates[index];

          return GestureDetector(
            onTap: () => onSelectDate(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              width: 50,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF003FB8)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF003FB8)
                      : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF003FB8).withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['weekday'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['day'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
