import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';

/// Time Slots Selection Grid for Appointments (Figma Node 435:2041)
class TimeSlotsPicker extends StatelessWidget {
  final String selectedTime;
  final ValueChanged<String> onSelectTime;

  const TimeSlotsPicker({
    super.key,
    required this.selectedTime,
    required this.onSelectTime,
  });

  static const List<String> morningSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
  ];

  static const List<String> afternoonSlots = [
    '1:00 PM', // Taken in Figma
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Morning Subheader
        Text(
          l10n.morningSection,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.55,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),

        // Morning Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: morningSlots.map((time) {
            return GestureDetector(
              onTap: () => onSelectTime(time),
              child: _buildTimeChip(
                context,
                time,
                isSelected: selectedTime == time,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Afternoon Subheader
        Text(
          l10n.afternoonSection,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.55,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),

        // Afternoon Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: afternoonSlots.map((time) {
            final isTaken = time == '1:00 PM';
            if (isTaken) {
              return _buildTakenSlot(context, time);
            }
            return GestureDetector(
              onTap: () => onSelectTime(time),
              child: _buildTimeChip(
                context,
                time,
                isSelected: selectedTime == time,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatTimeDisplay(BuildContext context, String raw) {
    final l10n = context.l10n;
    return raw
        .replaceAll('AM', l10n.amSuffix)
        .replaceAll('PM', l10n.pmSuffix);
  }

  Widget _buildTimeChip(
    BuildContext context,
    String time, {
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF003FB8) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? const Color(0xFF003FB8) : const Color(0xFFD9E2F0),
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF003FB8).withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        _formatTimeDisplay(context, time),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected ? Colors.white : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildTakenSlot(BuildContext context, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        context.l10n.takenSlot(_formatTimeDisplay(context, time)),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
          decoration: TextDecoration.lineThrough,
        ),
      ),
    );
  }
}
